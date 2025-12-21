#!/usr/bin/env python3
"""
StickLLM - Portable AI Assistant
Terminal interface for local LLM running from USB
"""

import os
import sys
import json
import sqlite3
import argparse
import requests
import readline
from datetime import datetime
from pathlib import Path
from typing import List, Dict, Optional
import yaml

# ANSI color codes for terminal
class Colors:
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    CYAN = '\033[96m'

class StickLLM:
    def __init__(self, base_path: str):
        self.base_path = Path(base_path)
        self.config_path = self.base_path / "cli" / "config.yaml"
        self.db_path = self.base_path / "chats" / "sessions.db"
        self.context_path = self.base_path / "context"
        self.server_url = "http://localhost:8080"
        
        # Load configuration
        self.config = self.load_config()
        self.current_session_id = None
        self.context_files = []
        
        # Initialize database
        self.init_database()
    
    def load_config(self) -> Dict:
        """Load configuration from YAML file"""
        if self.config_path.exists():
            with open(self.config_path, 'r') as f:
                return yaml.safe_load(f)
        return {
            'server': {
                'url': 'http://localhost:8080',
                'timeout': 120
            },
            'models': {
                'default': 'deepseek-coder-6.7b'
            },
            'contexts': {},
            'personas': {
                'default': 'You are a helpful coding assistant with deep expertise in software architecture and implementation.'
            }
        }
    
    def init_database(self):
        """Initialize SQLite database for chat history"""
        self.db_path.parent.mkdir(parents=True, exist_ok=True)
        
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS sessions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                context TEXT
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS messages (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                session_id INTEGER,
                role TEXT,
                content TEXT,
                timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (session_id) REFERENCES sessions (id)
            )
        ''')
        
        conn.commit()
        conn.close()
    
    def create_session(self, name: Optional[str] = None) -> int:
        """Create a new chat session"""
        if not name:
            name = f"Session {datetime.now().strftime('%Y-%m-%d %H:%M')}"
        
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute(
            'INSERT INTO sessions (name, context) VALUES (?, ?)',
            (name, json.dumps({'files': self.context_files}))
        )
        
        session_id = cursor.lastrowid
        conn.commit()
        conn.close()
        
        return session_id
    
    def load_session(self, session_id: int) -> List[Dict]:
        """Load chat history from a session"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute(
            'SELECT role, content FROM messages WHERE session_id = ? ORDER BY timestamp',
            (session_id,)
        )
        
        messages = [{'role': row[0], 'content': row[1]} for row in cursor.fetchall()]
        conn.close()
        
        return messages
    
    def save_message(self, session_id: int, role: str, content: str):
        """Save a message to the database"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute(
            'INSERT INTO messages (session_id, role, content) VALUES (?, ?, ?)',
            (session_id, role, content)
        )
        
        cursor.execute(
            'UPDATE sessions SET updated_at = CURRENT_TIMESTAMP WHERE id = ?',
            (session_id,)
        )
        
        conn.commit()
        conn.close()
    
    def rename_session(self, session_id: int, new_name: str):
        """Rename an existing session"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute(
            'UPDATE sessions SET name = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?',
            (new_name, session_id)
        )
        
        conn.commit()
        conn.close()
    
    def list_sessions(self) -> List[Dict]:
        """List all chat sessions"""
        conn = sqlite3.connect(self.db_path)
        cursor = conn.cursor()
        
        cursor.execute(
            'SELECT id, name, created_at, updated_at FROM sessions ORDER BY updated_at DESC'
        )
        
        sessions = []
        for row in cursor.fetchall():
            sessions.append({
                'id': row[0],
                'name': row[1],
                'created_at': row[2],
                'updated_at': row[3]
            })
        
        conn.close()
        return sessions
    
    def check_server(self, retries=10, wait=1) -> bool:
        """Check if llama.cpp server is running"""
        import time
        for attempt in range(retries):
            try:
                response = requests.get(f"{self.server_url}/health", timeout=5)
                if response.status_code == 200:
                    return True
            except requests.exceptions.ConnectionError:
                if attempt < retries - 1:
                    time.sleep(wait)
            except Exception as e:
                if attempt < retries - 1:
                    time.sleep(wait)
        return False
    
    def send_message(self, messages: List[Dict], stream: bool = True):
        """Send message to llama.cpp server and get response"""
        # Build prompt from messages
        prompt = self.build_prompt(messages)
        
        payload = {
            "prompt": prompt,
            "temperature": 0.7,
            "top_p": 0.9,
            "n_predict": 2048,
            "stop": ["User:", "Assistant:", "\n\nUser:", "\n\nAssistant:"],
            "stream": stream
        }
        
        try:
            if stream:
                response = requests.post(
                    f"{self.server_url}/completion",
                    json=payload,
                    stream=True,
                    timeout=self.config['server']['timeout']
                )
                
                full_response = ""
                for line in response.iter_lines():
                    if line:
                        data = json.loads(line.decode('utf-8').replace('data: ', ''))
                        if 'content' in data:
                            content = data['content']
                            print(content, end='', flush=True)
                            full_response += content
                
                print()  # New line after response
                return full_response
            else:
                response = requests.post(
                    f"{self.server_url}/completion",
                    json=payload,
                    timeout=self.config['server']['timeout']
                )
                return response.json()['content']
        
        except Exception as e:
            print(f"{Colors.RED}Error communicating with server: {e}{Colors.ENDC}")
            return None
    
    def build_prompt(self, messages: List[Dict]) -> str:
        """Build prompt from message history"""
        # Add system message if configured
        system_prompt = self.config['personas'].get('default', '')
        
        prompt = f"System: {system_prompt}\n\n"
        
        # Add context files if any
        if self.context_files:
            prompt += "Context Files:\n"
            for file_path in self.context_files:
                if Path(file_path).exists():
                    with open(file_path, 'r') as f:
                        content = f.read()
                        prompt += f"\n--- {file_path} ---\n{content}\n"
        
        # Add message history
        for msg in messages:
            role = "User" if msg['role'] == 'user' else "Assistant"
            prompt += f"{role}: {msg['content']}\n\n"
        
        prompt += "Assistant: "
        return prompt
    
    def add_context(self, file_path: str):
        """Add a file to the context"""
        path = Path(file_path)
        if path.exists():
            self.context_files.append(str(path.absolute()))
            print(f"{Colors.GREEN}Added to context: {file_path}{Colors.ENDC}")
        else:
            print(f"{Colors.RED}File not found: {file_path}{Colors.ENDC}")
    
    def show_context(self):
        """Show current context files"""
        if not self.context_files:
            print(f"{Colors.YELLOW}No context files loaded{Colors.ENDC}")
        else:
            print(f"{Colors.CYAN}Context files:{Colors.ENDC}")
            for i, file_path in enumerate(self.context_files, 1):
                print(f"  {i}. {file_path}")
    
    def clear_context(self):
        """Clear all context files"""
        self.context_files = []
        print(f"{Colors.GREEN}Context cleared{Colors.ENDC}")
    
    def interactive_chat(self, session_id: Optional[int] = None, session_name: Optional[str] = None):
        """Start interactive chat session"""
        if not self.check_server():
            print(f"{Colors.RED}Error: llama.cpp server is not running!{Colors.ENDC}")
            print(f"Please start the server first using: {Colors.CYAN}./launch.sh{Colors.ENDC}")
            return
        
        # Create or load session
        if session_id is None:
            session_id = self.create_session(name=session_name)
            messages = []
            print(f"{Colors.GREEN}Started new session (ID: {session_id}){Colors.ENDC}")
            if session_name:
                print(f"{Colors.GREEN}Name: {session_name}{Colors.ENDC}")
        else:
            messages = self.load_session(session_id)
            print(f"{Colors.GREEN}Loaded session (ID: {session_id}){Colors.ENDC}")
            print(f"{Colors.YELLOW}Previous messages: {len(messages)}{Colors.ENDC}")
        
        self.current_session_id = session_id
        
        print(f"\n{Colors.BOLD}StickLLM Interactive Chat{Colors.ENDC}")
        print(f"Type {Colors.CYAN}/help{Colors.ENDC} for commands, {Colors.CYAN}/exit{Colors.ENDC} to quit\n")
        
        while True:
            try:
                # Get user input
                user_input = input(f"{Colors.BLUE}You:{Colors.ENDC} ").strip()
                
                if not user_input:
                    continue
                
                # Handle commands
                if user_input.startswith('/'):
                    if user_input == '/exit':
                        print(f"{Colors.YELLOW}Goodbye!{Colors.ENDC}")
                        break
                    elif user_input == '/help':
                        self.show_help()
                        continue
                    elif user_input == '/context':
                        self.show_context()
                        continue
                    elif user_input.startswith('/context add '):
                        file_path = user_input.replace('/context add ', '').strip()
                        self.add_context(file_path)
                        continue
                    elif user_input == '/context clear':
                        self.clear_context()
                        continue
                    elif user_input == '/new':
                        session_id = self.create_session()
                        messages = []
                        self.current_session_id = session_id
                        print(f"{Colors.GREEN}Started new session (ID: {session_id}){Colors.ENDC}")
                        continue
                    elif user_input.startswith('/rename '):
                        new_name = user_input.replace('/rename ', '').strip()
                        if new_name:
                            self.rename_session(session_id, new_name)
                            print(f"{Colors.GREEN}Session renamed to: {new_name}{Colors.ENDC}")
                        else:
                            print(f"{Colors.RED}Usage: /rename <new session name>{Colors.ENDC}")
                        continue
                    elif user_input == '/session':
                        conn = sqlite3.connect(self.db_path)
                        cursor = conn.cursor()
                        cursor.execute('SELECT name, created_at FROM sessions WHERE id = ?', (session_id,))
                        row = cursor.fetchone()
                        conn.close()
                        if row:
                            print(f"{Colors.CYAN}Current Session:{Colors.ENDC}")
                            print(f"  ID: {session_id}")
                            print(f"  Name: {row[0]}")
                            print(f"  Created: {row[1]}")
                        continue
                    else:
                        print(f"{Colors.RED}Unknown command. Type /help for available commands{Colors.ENDC}")
                        continue
                
                # Add user message
                messages.append({'role': 'user', 'content': user_input})
                self.save_message(session_id, 'user', user_input)
                
                # Get AI response
                print(f"{Colors.GREEN}Assistant:{Colors.ENDC} ", end='', flush=True)
                response = self.send_message(messages, stream=True)
                
                if response:
                    messages.append({'role': 'assistant', 'content': response})
                    self.save_message(session_id, 'assistant', response)
                print()  # Extra newline for readability
                
            except KeyboardInterrupt:
                print(f"\n{Colors.YELLOW}Use /exit to quit properly{Colors.ENDC}")
            except EOFError:
                break
    
    def show_help(self):
        """Show help message"""
        help_text = f"""
{Colors.BOLD}StickLLM Commands:{Colors.ENDC}

{Colors.CYAN}/help{Colors.ENDC}                    - Show this help message
{Colors.CYAN}/exit{Colors.ENDC}                    - Exit the chat
{Colors.CYAN}/new{Colors.ENDC}                     - Start a new chat session
{Colors.CYAN}/rename <name>{Colors.ENDC}           - Rename current session
{Colors.CYAN}/session{Colors.ENDC}                 - Show current session info
{Colors.CYAN}/context{Colors.ENDC}                 - Show current context files
{Colors.CYAN}/context add <file>{Colors.ENDC}      - Add file to context
{Colors.CYAN}/context clear{Colors.ENDC}          - Clear all context files

Just type your message and press Enter to chat with the AI.
        """
        print(help_text)
    
    def one_shot(self, prompt: str):
        """Single question mode"""
        if not self.check_server():
            print(f"{Colors.RED}Error: llama.cpp server is not running!{Colors.ENDC}")
            return
        
        messages = [{'role': 'user', 'content': prompt}]
        print(f"{Colors.GREEN}Assistant:{Colors.ENDC} ", end='', flush=True)
        self.send_message(messages, stream=True)
        print()


def main():
    parser = argparse.ArgumentParser(
        description='StickLLM - Portable AI Assistant',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    
    parser.add_argument(
        'command',
        nargs='?',
        default='chat',
        choices=['chat', 'ask', 'sessions', 'context'],
        help='Command to run'
    )
    
    parser.add_argument(
        'args',
        nargs='*',
        help='Additional arguments for the command'
    )
    
    parser.add_argument(
        '--session',
        type=int,
        help='Session ID to resume'
    )
    
    parser.add_argument(
        '--name',
        type=str,
        help='Name for new session'
    )
    
    parser.add_argument(
        '--base-path',
        default=os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
        help='Base path for StickLLM installation'
    )
    
    args = parser.parse_args()
    
    # Initialize StickLLM
    llm = StickLLM(args.base_path)
    
    # Handle commands
    if args.command == 'chat':
        llm.interactive_chat(args.session, args.name)
    
    elif args.command == 'ask':
        if not args.args:
            print(f"{Colors.RED}Error: Please provide a question{Colors.ENDC}")
            print(f"Usage: stickllm ask \"your question here\"")
            sys.exit(1)
        
        prompt = ' '.join(args.args)
        llm.one_shot(prompt)
    
    elif args.command == 'sessions':
        sessions = llm.list_sessions()
        if not sessions:
            print(f"{Colors.YELLOW}No sessions found{Colors.ENDC}")
        else:
            print(f"\n{Colors.BOLD}Chat Sessions:{Colors.ENDC}\n")
            for session in sessions:
                print(f"  ID: {Colors.CYAN}{session['id']}{Colors.ENDC}")
                print(f"  Name: {session['name']}")
                print(f"  Updated: {session['updated_at']}")
                print()
    
    elif args.command == 'context':
        if args.args and args.args[0] == 'add':
            llm.add_context(' '.join(args.args[1:]))
        elif args.args and args.args[0] == 'clear':
            llm.clear_context()
        else:
            llm.show_context()


if __name__ == '__main__':
    main()
