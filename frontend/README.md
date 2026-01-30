# AI Todo Chatbot - Frontend

A Next.js 14 frontend application for the AI-powered todo chatbot.

## Features

- Modern chat interface for interacting with AI agent
- Real-time todo list display
- Built with Next.js 14 App Router
- Styled with Tailwind CSS
- TypeScript for type safety

## Prerequisites

- Node.js 18+ and npm
- Backend API running (FastAPI)

## Local Development

1. Install dependencies:
```bash
npm install
```

2. Create environment file:
```bash
cp .env.local.example .env.local
```

3. Update `.env.local` with your backend URL:
```
NEXT_PUBLIC_API_URL=http://localhost:8000
```

4. Run development server:
```bash
npm run dev
```

5. Open [http://localhost:3000](http://localhost:3000)

## Deployment to Vercel

### Option 1: Using Vercel CLI (Recommended)

1. Install Vercel CLI:
```bash
npm install -g vercel
```

2. Login to Vercel:
```bash
vercel login
```

3. Deploy from the frontend directory:
```bash
cd frontend
vercel
```

4. Follow the prompts:
   - Set up and deploy? **Y**
   - Which scope? Select your account
   - Link to existing project? **N**
   - What's your project's name? `todo-chatbot-frontend`
   - In which directory is your code located? `./`
   - Want to override the settings? **N**

5. Set environment variables:
```bash
vercel env add NEXT_PUBLIC_API_URL
```
Enter your production backend URL (e.g., `https://your-backend.onrender.com`)

6. Deploy to production:
```bash
vercel --prod
```

### Option 2: Using Vercel Dashboard

1. Go to [vercel.com](https://vercel.com)

2. Click "New Project"

3. Import your Git repository

4. Configure:
   - **Framework Preset**: Next.js
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build`
   - **Output Directory**: `.next`

5. Add Environment Variables:
   - Key: `NEXT_PUBLIC_API_URL`
   - Value: Your backend URL (e.g., `https://your-backend.onrender.com`)

6. Click "Deploy"

## Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NEXT_PUBLIC_API_URL` | Backend API URL | `https://api.example.com` |

## Project Structure

```
frontend/
├── app/
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Home page
│   └── globals.css         # Global styles
├── components/
│   ├── TodoList.tsx        # Todo list component
│   └── ChatInterface.tsx   # Chat UI component
├── lib/
│   └── api.ts              # API client
├── public/                 # Static assets
├── package.json
├── tsconfig.json
├── tailwind.config.js
└── next.config.js
```

## API Integration

The frontend connects to the FastAPI backend using these endpoints:

- `GET /health` - Health check
- `GET /todos` - Fetch all todos
- `POST /todos` - Add a new todo
- `POST /todos/run` - Run AI agent on a task

## Building for Production

```bash
npm run build
npm start
```

## Troubleshooting

### CORS Errors

If you see CORS errors in the browser console, make sure your backend has CORS properly configured to allow your Vercel domain.

Update your backend `main.py`:
```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://your-vercel-app.vercel.app"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

### API Connection Issues

1. Check that `NEXT_PUBLIC_API_URL` is set correctly
2. Verify the backend is running and accessible
3. Check browser console for error messages

## License

Part of the AI-Powered Todo Chatbot project.
