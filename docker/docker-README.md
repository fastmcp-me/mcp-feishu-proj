# Docker 部署指南

本项目提供了Docker部署支持，可以通过Docker容器运行MCP飞书项目服务。

## 前提条件

- 安装 [Docker](https://docs.docker.com/get-docker/)
- 安装 [Docker Compose](https://docs.docker.com/compose/install/)

## 使用Docker Compose运行

1. 创建`.env`文件，设置必要的环境变量

```bash
cp ../.env.example ../.env
```

然后编辑`.env`文件，填入你的飞书项目相关信息：

```
FS_PROJ_BASE_URL=https://project.feishu.cn/
FS_PROJ_PROJECT_KEY=your_project_key
FS_PROJ_USER_KEY=your_user_key
FS_PROJ_PLUGIN_ID=your_plugin_id
FS_PROJ_PLUGIN_SECRET=your_plugin_secret
```

2. 使用Docker Compose启动服务

```bash
cd .. && docker-compose -f docker/docker-compose.yml up -d
```

这将使用`ghcr.io/astral-sh/uv`镜像，并挂载项目根目录到容器中，直接运行本地代码，便于开发和调试。Docker Compose会自动加载项目根目录中的`.env`文件作为环境变量。

3. 查看日志

```bash
cd .. && docker-compose -f docker/docker-compose.yml logs -f
```

4. 停止服务

```bash
cd .. && docker-compose -f docker/docker-compose.yml down
```

## 自定义配置

如果需要自定义配置，可以修改`docker/docker-compose.yml`文件：

- 如果需要暴露端口，取消ports部分的注释
- 默认配置已经挂载了项目根目录到容器的`/app`路径，并通过`uvx /app --transport sse`命令运行
- 配置使用`env_file`指定了项目根目录的`.env`文件，自动加载环境变量

## 故障排除

如果遇到问题，可以尝试以下步骤：

1. 检查环境变量是否正确设置
2. 查看容器日志：`cd .. && docker-compose -f docker/docker-compose.yml logs -f`
3. 确保`ghcr.io/astral-sh/uv`镜像已成功拉取：`docker pull ghcr.io/astral-sh/uv:latest`
4. 进入容器内部排查：`cd .. && docker-compose -f docker/docker-compose.yml exec mcp-feishu-proj /bin/sh`
