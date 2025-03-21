#!/bin/bash

# check if .env file exists
if [ ! -f .env ]; then
    echo "Please create a .env file with the following content:"
    echo "FS_PROJ_BASE_URL=https://open.feishu.cn"
    echo "FS_PROJ_PROJECT_KEY=YOUR_PROJECT_KEY"
    echo "FS_PROJ_USER_KEY=YOUR_USER_KEY"
    echo "FS_PROJ_PLUGIN_ID=YOUR_PLUGIN_ID"
    echo "FS_PROJ_PLUGIN_SECRET=YOUR_PLUGIN_SECRET"
    exit 1
fi

# add .env file into environment
source .env

echo "FS_PROJ_BASE_URL: $FS_PROJ_BASE_URL"
echo "FS_PROJ_PROJECT_KEY: $FS_PROJ_PROJECT_KEY"
echo "FS_PROJ_USER_KEY: $FS_PROJ_USER_KEY"
echo "FS_PROJ_PLUGIN_ID: $FS_PROJ_PLUGIN_ID"
echo "FS_PROJ_PLUGIN_SECRET: $FS_PROJ_PLUGIN_SECRET"

# Execute the inspector command
npx -y @modelcontextprotocol/inspector \
        -e FS_PROJ_BASE_URL="$FS_PROJ_BASE_URL" \
        -e FS_PROJ_PROJECT_KEY="$FS_PROJ_PROJECT_KEY" \
        -e FS_PROJ_USER_KEY="$FS_PROJ_USER_KEY" \
        -e FS_PROJ_PLUGIN_ID="$FS_PROJ_PLUGIN_ID" \
        -e FS_PROJ_PLUGIN_SECRET="$FS_PROJ_PLUGIN_SECRET" \
        uvx mcp-feishu-proj