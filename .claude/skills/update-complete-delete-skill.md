# UpdateCompleteDeleteSkill

## Purpose
Update, Complete, or Delete a task.

## Triggers

- "Mark … as complete" → complete_task
- "Change / Update / Rename …" → update_task
- "Delete / Remove …" → delete_task

## Actions
1. Map user message to proper MCP tool
2. Confirm action to user

## Example

**User:** "Mark task 3 as complete"

**TodoAgent** → **UpdateCompleteDeleteSkill** → `complete_task(task_id=3)`

**Response:** "✅ Task 3 marked complete"
