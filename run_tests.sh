#!/bin/bash

# 检查 .env 文件是否存在
if [ ! -f .env ]; then
    echo "请创建 .env 文件，包含以下内容："
    echo "FS_PROJ_BASE_URL=https://open.feishu.cn"
    echo "FS_PROJ_PROJECT_KEY=YOUR_PROJECT_KEY"
    echo "FS_PROJ_USER_KEY=YOUR_USER_KEY"
    echo "FS_PROJ_PLUGIN_ID=YOUR_PLUGIN_ID"
    echo "FS_PROJ_PLUGIN_SECRET=YOUR_PLUGIN_SECRET"
    exit 1
fi

# 加载 .env 文件中的环境变量
source .env

echo "正在运行单元测试..."
echo "环境变量已加载："
echo "FS_PROJ_BASE_URL: $FS_PROJ_BASE_URL"
echo "FS_PROJ_PROJECT_KEY: $FS_PROJ_PROJECT_KEY"
echo "FS_PROJ_USER_KEY: $FS_PROJ_USER_KEY"
echo "FS_PROJ_PLUGIN_ID: $FS_PROJ_PLUGIN_ID"
echo "FS_PROJ_PLUGIN_SECRET: $FS_PROJ_PLUGIN_SECRET"

# 检查虚拟环境是否存在，如果不存在则创建
if [ ! -d ".venv" ]; then
    echo "创建虚拟环境..."
    # 检查是否安装了 uv
    if ! command -v uv &> /dev/null; then
        echo "安装 uv..."
        pip install uv
    fi
    uv venv
    source .venv/bin/activate
    echo "安装依赖..."
    uv pip install -e .
else
    echo "激活虚拟环境..."
    source .venv/bin/activate
fi

# 执行单元测试
# 使用 -m 标志从项目根目录运行 unittest discover，以正确处理相对导入
# 这样可以自动发现所有测试文件
python -m unittest discover -s src/mcp_server -p "test_*.py"

# 检查测试结果
if [ $? -eq 0 ]; then
    echo "✅ 所有测试通过！"
    exit 0
else
    echo "❌ 测试失败！"
    exit 1
fi
