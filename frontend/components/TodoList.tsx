'use client';

import { useEffect, useState } from 'react';
import { todoApi } from '@/lib/api';

export default function TodoList() {
  const [todos, setTodos] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [deleting, setDeleting] = useState<number | null>(null);

  const fetchTodos = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await todoApi.getTodos();
      setTodos(data.todos);
    } catch (err) {
      setError('Failed to fetch todos. Make sure the backend is running.');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (index: number) => {
    try {
      setDeleting(index);
      await todoApi.deleteTodo(index);
      await fetchTodos(); // Refresh the list
    } catch (err) {
      console.error('Failed to delete todo:', err);
      setError('Failed to delete todo');
    } finally {
      setDeleting(null);
    }
  };

  useEffect(() => {
    fetchTodos();
  }, []);

  if (loading) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6">
        <h2 className="text-2xl font-bold mb-4 text-gray-800">Your Todos</h2>
        <p className="text-gray-600">Loading...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-white rounded-lg shadow-md p-6">
        <h2 className="text-2xl font-bold mb-4 text-gray-800">Your Todos</h2>
        <div className="bg-red-50 border border-red-200 rounded-md p-4">
          <p className="text-red-600">{error}</p>
          <button
            onClick={fetchTodos}
            className="mt-2 text-sm text-red-700 underline hover:text-red-800"
          >
            Retry
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-lg shadow-md p-6">
      <div className="flex justify-between items-center mb-4">
        <h2 className="text-2xl font-bold text-gray-800">Your Todos</h2>
        <button
          onClick={fetchTodos}
          className="text-sm text-blue-600 hover:text-blue-800 underline"
        >
          Refresh
        </button>
      </div>

      {todos.length === 0 ? (
        <p className="text-gray-500 italic">No todos yet. Add one using the chat below!</p>
      ) : (
        <ul className="space-y-2">
          {todos.map((todo, index) => (
            <li
              key={index}
              className="flex items-center justify-between p-3 bg-gray-50 rounded-md hover:bg-gray-100 transition group"
            >
              <div className="flex items-start flex-1">
                <span className="flex-shrink-0 w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-sm mr-3">
                  {index + 1}
                </span>
                <span className="text-gray-800">{todo}</span>
              </div>
              <button
                onClick={() => handleDelete(index)}
                disabled={deleting === index}
                className="ml-4 px-3 py-1 text-sm text-red-600 hover:text-red-800 hover:bg-red-50 rounded transition opacity-0 group-hover:opacity-100 disabled:opacity-50"
                title="Delete todo"
              >
                {deleting === index ? 'Deleting...' : 'Delete'}
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
