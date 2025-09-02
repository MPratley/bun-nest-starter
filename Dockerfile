# Use the official Bun image as base
FROM oven/bun:1.2-alpine AS base

# Set the working directory
WORKDIR /app

# Copy package.json and bun.lock for dependency installation
COPY package.json bun.lock* ./

# Install dependencies
RUN bun install --frozen-lockfile --production

# Build stage
FROM base AS build

# Install all dependencies (including dev dependencies for building)
RUN bun install --frozen-lockfile

# Copy source code
COPY . .

# Build the application
RUN bun run build

# Production stage
FROM oven/bun:1.2-alpine AS production

# Set working directory
WORKDIR /app

# Copy package.json for reference
COPY package.json ./

# Copy production dependencies from base stage
COPY --from=base /app/node_modules ./node_modules

# Copy built application from build stage
COPY --from=build /app/dist ./dist

# Create a non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nestjs -u 1001

# Change ownership of the app directory to the nestjs user
RUN chown -R nestjs:nodejs /app

# Switch to non-root user
USER nestjs

# Expose the port the app runs on
EXPOSE 3000

# Set environment to production
ENV NODE_ENV=production

# Start the application
CMD ["bun", "run", "start:prod"]
