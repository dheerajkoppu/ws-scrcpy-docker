# === Builder stage ===
FROM node:20-alpine AS builder

RUN apk add --no-cache git python3 make g++

RUN git clone https://github.com/dheerajkoppu/ws-scrcpy.git /ws-scrcpy

WORKDIR /ws-scrcpy
RUN npm install
RUN npm run dist

WORKDIR /ws-scrcpy/dist
RUN npm install

# === Runtime stage ===
FROM alpine:edge AS runner
LABEL maintainer="Haroun EL ALAMI <haroun.dev@gmail.com>"

RUN apk add --no-cache android-tools

COPY --from=builder /ws-scrcpy/dist /root/ws-scrcpy

WORKDIR /root/ws-scrcpy
CMD ["npm", "start"]
