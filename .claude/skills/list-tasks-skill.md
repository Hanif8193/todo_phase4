# ListTasksSkill

## Purpose
Show tasks (all / pending / completed).

## Triggers
User says: "Show", "List", "Pending", "Completed"

## Actions
1. Call MCP list_tasks(user_id, status?)
2. Return formatted list to user

## Example

**User:** "What tasks are pending?"

**TodoAgent** → **ListTasksSkill** → `list_tasks(user_id, status="pending")`

**Response:** "📋 You have 2 pending tasks: 1. Buy groceries 2. Call mom"
