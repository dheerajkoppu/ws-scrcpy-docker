# === Builder stage ===
FROM node:20-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git python3 make g++

# Clone the ws-scrcpy repository
RUN git clone https://github.com/dheerajkoppu/ws-scrcpy.git /ws-scrcpy

# Set working directory and install dependencies
WORKDIR /ws-scrcpy
RUN npm install
RUN npm run dist

# Install runtime dependencies inside the built dist folder
WORKDIR /ws-scrcpy/dist
RUN npm install

# === Runtime stage ===
FROM alpine:edge AS runner
LABEL maintainer="Haroun EL ALAMI <haroun.dev@gmail.com>"

# Install required runtime dependencies
RUN apk add --no-cache android-tools nodejs npm

# Copy built app from builder stage
COPY --from=builder /ws-scrcpy/dist /root/ws-scrcpy

# Set working directory and start the app
WORKDIR /root/ws-scrcpy
CMD ["npm", "start"]
