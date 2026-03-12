# Deno runtime for CallAttribution backend
FROM denoland/deno:alpine-1.40.0

WORKDIR /app

# Copy configuration files
COPY deno.json .

# Copy source code
COPY . .

# Cache dependencies
RUN deno cache server.ts

# Expose the API port
EXPOSE 8080

# Run the server
CMD ["deno", "run", "--allow-net", "--allow-read", "--allow-env", "--allow-sys", "server.ts"]
