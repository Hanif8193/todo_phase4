#!/usr/bin/env python3
"""Initialize database tables for Todo Chatbot"""

import asyncio
import os
from sqlalchemy.ext.asyncio import create_async_engine
from sqlmodel import SQLModel

# Import all models to register them with SQLModel
from src.models.task import Task
from src.models.conversation import Conversation
from src.models.message import Message


async def init_db():
    """Create all database tables"""
    database_url = os.getenv('DATABASE_URL')

    if not database_url:
        print("ERROR: DATABASE_URL environment variable not set")
        return

    print(f"Connecting to database...")
    engine = create_async_engine(database_url, echo=True)

    print("Creating tables...")
    async with engine.begin() as conn:
        await conn.run_sync(SQLModel.metadata.create_all)

    print("✓ Database tables created successfully!")
    await engine.dispose()


if __name__ == "__main__":
    asyncio.run(init_db())
