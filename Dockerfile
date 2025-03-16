# Base for all builds
FROM node:20-alpine AS base-min
WORKDIR /app
RUN apk --no-cache add curl
RUN npm config set fetch-retry-maxtimeout 600000 && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 15000
COPY package*.json ./
COPY packages/data-provider/package*.json ./packages/data-provider/
COPY packages/mcp/package*.json ./packages/mcp/
COPY packages/data-schemas/package*.json ./packages/data-schemas/
COPY client/package*.json ./client/
COPY api/package*.json ./api/

# Install all dependencies for every build
FROM base-min AS base
WORKDIR /app
RUN npm ci

# Build data-provider
FROM base AS data-provider-build
WORKDIR /app/packages/data-provider
COPY packages/data-provider ./
RUN npm run build

# Build mcp package
FROM base AS mcp-build
WORKDIR /app/packages/mcp
COPY packages/mcp ./
COPY --from=data-provider-build /app/packages/data-provider/dist /app/packages/data-provider/dist
RUN npm run build

# Build data-schemas
FROM base AS data-schemas-build
WORKDIR /app/packages/data-schemas
COPY packages/data-schemas ./
COPY --from=data-provider-build /app/packages/data-provider/dist /app/packages/data-provider/dist
RUN npm run build

# Client build with Berget customizations
FROM base AS client-build
WORKDIR /app/client
COPY client ./

# Create necessary directories for assets
RUN mkdir -p /app/client/public/assets /app/client/public/images

# Add custom index.html and assets
COPY index.html ./index.html
COPY assets/berget-icon-black-16x16.png ./public/assets/
COPY assets/berget-icon-black-32x32.png ./public/assets/
COPY assets/berget-icon-black.svg ./public/assets/
COPY assets/berget-icon-black-64x64.png ./public/assets/
COPY assets/berget-icon-black-128x128.png ./public/assets/
COPY assets/berget-icon-black-128x128.png ./public/assets/maskable-icon.png
COPY assets/berget-icon-white.svg ./public/assets/
COPY manifest.webmanifest ./public/manifest.webmanifest
COPY assets/* ./public/images/

# Install font packages
RUN npm install @fontsource/dm-sans @fontsource/ovo

COPY --from=data-provider-build /app/packages/data-provider/dist /app/packages/data-provider/dist
ENV NODE_OPTIONS="--max-old-space-size=2048"
RUN npm run build

# API setup (including client dist)
FROM base-min AS api-build
WORKDIR /app
# Install only production deps
RUN npm ci --omit=dev
COPY api ./api
COPY config ./config
COPY --from=data-provider-build /app/packages/data-provider/dist ./packages/data-provider/dist
COPY --from=mcp-build /app/packages/mcp/dist ./packages/mcp/dist
COPY --from=data-schemas-build /app/packages/data-schemas/dist ./packages/data-schemas/dist
COPY --from=client-build /app/client/dist ./client/dist
WORKDIR /app/api
EXPOSE 3080
ENV HOST=0.0.0.0
CMD ["node", "server/index.js"]
