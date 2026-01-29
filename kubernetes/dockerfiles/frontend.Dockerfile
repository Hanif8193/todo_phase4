# -----------------------------
# Frontend Dockerfile for Todo Chatbot
# -----------------------------

# Stage 1: Builder
FROM node:20-slim AS builder

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm install --legacy-peer-deps

# Copy all frontend source code
COPY . .

# Set API URL for build time
ENV NEXT_PUBLIC_API_URL=http://localhost:9091

# Build the Next.js application
RUN npm run build

# Stage 2: Production image
FROM node:20-slim

# Set working directory
WORKDIR /app

# Copy build artifacts from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Copy the public folder if it exists, optional
# This avoids errors if public folder is missing
COPY --from=builder /app/public ./public

# Expose the port Next.js runs on
EXPOSE 3000

# Run the production server
CMD ["npm", "start"]

