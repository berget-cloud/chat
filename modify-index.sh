#!/bin/bash

# Replace title, description, and language
sed -i "s|<title>LibreChat</title>|<title>Berget AI</title>|g" /app/client/dist/index.html
sed -i "s|<meta name=\"description\" content=\"LibreChat - An open source chat application with support for multiple AI models\" />|<meta name=\"description\" content=\"Berget AI - Ingen data lämnar Sverige 🇪🇺 GDPR säkert\" />|g" /app/client/dist/index.html
sed -i "s|<html lang=\"en-US\">|<html lang=\"sv-SE\">|g" /app/client/dist/index.html

# Add font imports
sed -i "/<style>/a \
      @import '@fontsource/dm-sans';\n\
      @import '@fontsource/ovo';" /app/client/dist/index.html

# Update CSS variables and styling
sed -i "s|body {|body {\n        font-family: 'DM Sans', sans-serif;\n        font-feature-settings: 'ss01', 'ss02', 'cv01', 'cv02';\n        background-image: linear-gradient(to bottom, rgba(229, 221, 213, 0.02) 1px, transparent 1px), linear-gradient(to right, rgba(229, 221, 213, 0.02) 1px, transparent 1px);\n        background-size: 24px 24px;|g" /app/client/dist/index.html

# Add heading styles
sed -i "/body {/a \
\n      h1,\n      h2,\n      h3,\n      h4,\n      h5,\n      h6 {\n        font-family: 'Ovo', serif;\n      }" /app/client/dist/index.html

# Update background color in the loading script
sed -i "s|backgroundColor = \"#0d0d0d\";|backgroundColor = \"#1a1a1a\";|g" /app/client/dist/index.html
sed -i "s|backgroundColor = \"#ffffff\";|backgroundColor = \"#ffffff\";|g" /app/client/dist/index.html

# Add grid background to loading container
sed -i "s|#loading-container {|#loading-container {\n          background-image: linear-gradient(to bottom, rgba(229, 221, 213, 0.02) 1px, transparent 1px), linear-gradient(to right, rgba(229, 221, 213, 0.02) 1px, transparent 1px);\n          background-size: 24px 24px;|g" /app/client/dist/index.html

# Add custom CSS variables for Berget design system
sed -i "/<style>/a \
      :root {\n\
        --color-background: #1a1a1a;\n\
        --color-surface: #e5ddd5;\n\
        --color-text: #ffffff;\n\
        --color-text-secondary: rgba(255, 255, 255, 0.6);\n\
        --color-text-tertiary: rgba(255, 255, 255, 0.4);\n\
        --color-primary: #4361ee;\n\
        --color-secondary: #7209b7;\n\
        --color-success: #22c55e;\n\
        --color-error: #ff0033;\n\
        --color-warning: #f59e0b;\n\
        --color-info: #3b82f6;\n\
        --color-offline: #4b5563;\n\
      }" /app/client/dist/index.html

# Add custom icon links
sed -i "s|<link rel=\"shortcut icon\" href=\"#\" />|<link rel=\"shortcut icon\" href=\"#\" />\n    <link rel=\"icon\" type=\"image/svg+xml\" href=\"/assets/berget-icon-black.svg\" media=\"(prefers-color-scheme: light)\" />\n    <link rel=\"icon\" type=\"image/svg+xml\" href=\"/assets/berget-icon-white.svg\" media=\"(prefers-color-scheme: dark)\" />|g" /app/client/dist/index.html
