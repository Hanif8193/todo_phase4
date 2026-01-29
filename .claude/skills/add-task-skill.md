# AddTaskSkill

## Purpose
Add / remember / create a todo task.

## Triggers
User says: "Add", "Remember", "Create", "I need to"

## Actions
1. Call MCP add_task(user_id, title, description?)
2. Confirm action to user

## Example

**User:** "I need to pay electricity bill"

**TodoAgent** → **AddTaskSkill** → `add_task(user_id, title="Pay electricity bill")`

**Response:** "✅ Task added: Pay electricity bill"
