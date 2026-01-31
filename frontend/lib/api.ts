import axios from 'axios';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

export interface TodoItem {
  task: string;
}

export interface TodoResponse {
  todos: string[];
}

export interface AddTodoResponse {
  message: string;
  todos: string[];
}

export interface RunTaskResponse {
  task: string;
  result: any;
}

const api = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const todoApi = {
  // Get all todos
  getTodos: async (): Promise<TodoResponse> => {
    const response = await api.get<TodoResponse>('/todos');
    return response.data;
  },

  // Add a new todo
  addTodo: async (task: string): Promise<AddTodoResponse> => {
    const response = await api.post<AddTodoResponse>('/todos', { task });
    return response.data;
  },

  // Delete a todo
  deleteTodo: async (index: number): Promise<AddTodoResponse> => {
    const response = await api.delete<AddTodoResponse>(`/todos/${index}`);
    return response.data;
  },

  // Run AI agent on a task
  runTask: async (task: string): Promise<RunTaskResponse> => {
    const response = await api.post<RunTaskResponse>('/todos/run', { task });
    return response.data;
  },

  // Health check
  healthCheck: async (): Promise<{ status: string }> => {
    const response = await api.get('/health');
    return response.data;
  },
};
