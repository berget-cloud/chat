FROM ghcr.io/danny-avila/librechat:latest

# Create necessary directories
RUN mkdir -p /app/client/public/assets

# Add custom index.html to the client folder
COPY index.html /app/client/index.html

# Add favicon and logo files to public directory
COPY assets/berget-icon-black-16x16.png /app/client/public/assets/
COPY assets/berget-icon-black-32x32.png /app/client/public/assets/
COPY assets/berget-icon-black.svg /app/client/public/assets/
COPY assets/berget-icon-black-64x64.png /app/client/public/assets/
COPY assets/berget-icon-black-128x128.png /app/client/public/assets/
COPY assets/berget-icon-black-128x128.png /app/client/public/assets/maskable-icon.png

# Add manifest file to public directory
COPY manifest.webmanifest /app/client/public/manifest.webmanifest

# Copy all assets to public/images directory
COPY assets/* /app/client/public/images/

# Install font packages
WORKDIR /app
RUN npm install -w @librechat/frontend @fontsource/dm-sans @fontsource/ovo

# Build the client application using the workspace command
RUN npm run build:client

# Make sure we're using the correct entrypoint
ENTRYPOINT ["npm", "run", "start"]
