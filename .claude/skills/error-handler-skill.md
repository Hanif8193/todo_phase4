# ErrorHandlerSkill (Optional / integrated in previous skill)

## Purpose
Handle invalid task ids, missing info, or unsupported commands.

## Actions
1. Check if task_id exists before calling MCP tool
2. Return friendly error messages

## Example

**User:** "Delete task 99"

**TodoAgent** → **ErrorHandlerSkill** → Task 99 not found

**Response:** "❌ Task 99 not found. Please check your tasks."
