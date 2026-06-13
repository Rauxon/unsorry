#!/usr/bin/env python3
"""OpenAI CLI wrapper for Unsorry swarm.

Usage similar to claude/codex/gemini CLIs:
  openai -p "prompt" --model gpt-4o --output-format text
  openai -p "prompt" --prove --workdir /path/to/repo
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from llm_providers.openai_provider import OpenAIProvider, OpenAIError


def run_tool(tool_name: str, arguments: str, workdir: str) -> str:
    """Execute a tool and return the result."""
    try:
        args = json.loads(arguments) if arguments else {}
    except json.JSONDecodeError:
        return f"Error: Invalid JSON arguments: {arguments}"
    
    if tool_name == "Read":
        file_path = args.get("file_path", "")
        full_path = os.path.join(workdir, file_path) if workdir else file_path
        try:
            with open(full_path, "r") as f:
                return f.read()
        except Exception as e:
            return f"Error reading {file_path}: {e}"
    
    elif tool_name == "Write":
        file_path = args.get("file_path", "")
        content = args.get("content", "")
        full_path = os.path.join(workdir, file_path) if workdir else file_path
        try:
            os.makedirs(os.path.dirname(full_path), exist_ok=True)
            with open(full_path, "w") as f:
                f.write(content)
            return f"Successfully wrote {file_path}"
        except Exception as e:
            return f"Error writing {file_path}: {e}"
    
    elif tool_name == "Edit":
        file_path = args.get("file_path", "")
        old_string = args.get("old_string", "")
        new_string = args.get("new_string", "")
        full_path = os.path.join(workdir, file_path) if workdir else file_path
        try:
            with open(full_path, "r") as f:
                content = f.read()
            if old_string not in content:
                return f"Error: old_string not found in {file_path}"
            content = content.replace(old_string, new_string, 1)
            with open(full_path, "w") as f:
                f.write(content)
            return f"Successfully edited {file_path}"
        except Exception as e:
            return f"Error editing {file_path}: {e}"
    
    elif tool_name == "Bash":
        command = args.get("command", "")
        try:
            result = subprocess.run(
                command,
                shell=True,
                cwd=workdir,
                capture_output=True,
                text=True,
                timeout=300,  # 5 minute timeout for commands
            )
            output = result.stdout
            if result.stderr:
                output += f"\nstderr: {result.stderr}"
            if result.returncode != 0:
                output += f"\nExit code: {result.returncode}"
            return output
        except subprocess.TimeoutExpired:
            return f"Error: Command timed out after 300s"
        except Exception as e:
            return f"Error running command: {e}"
    
    return f"Unknown tool: {tool_name}"


def process_conversation(provider: OpenAIProvider, prompt: str, model: str, workdir: str, max_turns: int = 10) -> str:
    """Process a conversation with tool use."""
    messages = [
        {
            "role": "system",
            "content": """You are an expert in Lean 4 theorem proving. 
Your task is to write complete, correct Lean 4 proofs.
You have access to tools for reading files, editing code, and running commands.
Use these tools to explore the codebase, write proofs, and verify your work with lake build.
Always produce valid Lean 4 syntax."""
        },
        {"role": "user", "content": prompt}
    ]
    
    tools = [
        {
            "type": "function",
            "function": {
                "name": "Read",
                "description": "Read a file",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "file_path": {"type": "string"},
                    },
                    "required": ["file_path"],
                },
            },
        },
        {
            "type": "function",
            "function": {
                "name": "Edit",
                "description": "Edit a file by replacing old_string with new_string",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "file_path": {"type": "string"},
                        "old_string": {"type": "string"},
                        "new_string": {"type": "string"},
                    },
                    "required": ["file_path", "old_string", "new_string"],
                },
            },
        },
        {
            "type": "function",
            "function": {
                "name": "Write",
                "description": "Write content to a file",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "file_path": {"type": "string"},
                        "content": {"type": "string"},
                    },
                    "required": ["file_path", "content"],
                },
            },
        },
        {
            "type": "function",
            "function": {
                "name": "Bash",
                "description": "Run a bash command (e.g., lake build, lake env, git diff)",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "command": {"type": "string"},
                    },
                    "required": ["command"],
                },
            },
        },
    ]
    
    import requests
    
    headers = {
        "Authorization": f"Bearer {provider.api_key}",
        "Content-Type": "application/json",
    }
    
    for turn in range(max_turns):
        request_data = {
            "model": model,
            "messages": messages,
            "tools": tools,
            "tool_choice": "auto",
            "temperature": 0.1,
        }
        
        try:
            response = requests.post(
                f"{provider.base_url}/chat/completions",
                headers=headers,
                json=request_data,
                timeout=provider.timeout,
            )
            response.raise_for_status()
            data = response.json()
        except Exception as e:
            return f"Error: API request failed: {e}"
        
        message = data["choices"][0]["message"]
        tool_calls = message.get("tool_calls", [])
        
        if not tool_calls:
            # No tool calls, return the content
            return message.get("content", "")
        
        # Add assistant message
        messages.append(message)
        
        # Execute tool calls
        for tool_call in tool_calls:
            if tool_call.get("type") == "function":
                func = tool_call["function"]
                tool_name = func["name"]
                arguments = func["arguments"]
                
                result = run_tool(tool_name, arguments, workdir)
                
                # Add tool result to messages
                messages.append({
                    "role": "tool",
                    "tool_call_id": tool_call["id"],
                    "content": result,
                })
    
    return "Error: Maximum turns exceeded"


def main():
    parser = argparse.ArgumentParser(description="OpenAI CLI for Unsorry")
    parser.add_argument("-p", "--prompt", required=True, help="The prompt")
    parser.add_argument("--model", default="gpt-4o", help="Model to use")
    parser.add_argument("--output-format", default="text", choices=["text", "json"])
    parser.add_argument("--prove", action="store_true", help="Use prove mode with tool access")
    parser.add_argument("--workdir", help="Working directory for file operations")
    parser.add_argument("--tools", help="Comma-separated list of allowed tools")
    parser.add_argument("--allowedTools", dest="allowed_tools", help="Allowed tools (alias)")
    
    args = parser.parse_args()
    
    try:
        provider = OpenAIProvider()
        workdir = args.workdir or os.getcwd()
        
        if args.prove:
            result = process_conversation(provider, args.prompt, args.model, workdir)
        else:
            result = provider.complete(
                prompt=args.prompt,
                model=args.model,
            )
        
        print(result)
        
    except OpenAIError as e:
        print(f"Error: {e.message}", file=sys.stderr)
        sys.exit(1)
    except KeyboardInterrupt:
        sys.exit(130)


if __name__ == "__main__":
    main()
