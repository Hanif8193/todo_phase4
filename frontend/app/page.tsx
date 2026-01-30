'use client';

import ChatInterface from '@/components/ChatInterface';
import TodoList from '@/components/TodoList';

export default function Home() {
  return (
    <main className="min-h-screen p-8">
      <div className="max-w-7xl mx-auto">
        <header className="mb-8 text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            AI Todo Chatbot
          </h1>
          <p className="text-gray-600">
            Manage your tasks with the help of AI
          </p>
        </header>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <div>
            <TodoList />
          </div>
          <div>
            <ChatInterface />
          </div>
        </div>

        <footer className="mt-8 text-center text-sm text-gray-500">
          <p>Powered by FastAPI & Next.js 14</p>
        </footer>
      </div>
    </main>
  );
}
