# OpenClaw Docker

开箱即用的 [OpenClaw](https://docs.openclaw.ai) 容器化部署，支持挂载本地代码目录，让 AI Agent 直接操作你的项目文件。

## 快速使用

```bash
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -v openclaw-data:/root/.openclaw \
  wuheng0319/openclaw:2026.3.28
```

启动后获取 Dashboard 链接：

```bash
docker exec -it openclaw openclaw dashboard
```

在浏览器中打开输出的 URL 即可。

## 挂载代码目录

将本地项目挂载到容器的 workspace，Agent 即可读写你的代码：

```bash
docker run -d \
  --name openclaw \
  -p 18789:18789 \
  -v openclaw-data:/root/.openclaw \
  -v /path/to/your/project:/root/.openclaw/workspace/project \
  wuheng0319/openclaw:2026.3.28
```

支持同时挂载多个项目：

```bash
-v ~/projects/frontend:/root/.openclaw/workspace/frontend \
-v ~/projects/backend:/root/.openclaw/workspace/backend
```

## 使用 Docker Compose

```yaml
networks:
  openclaw-net:
    driver: bridge
    ipam:
      config:
        - subnet: 172.30.0.0/24

services:
  openclaw:
    image: wuheng0319/openclaw:2026.3.28
    container_name: openclaw
    ports:
      - "18789:18789"
    networks:
      openclaw-net:
        ipv4_address: 172.30.0.2
    volumes:
      - ./openclaw-data:/root/.openclaw
      - /path/to/your/project:/root/.openclaw/workspace/project
    environment:
      - OPENCLAW_HOME=/root
```

## 首次使用

1. **启动容器** — 自动生成默认配置
2. **获取链接** — `docker exec -it openclaw openclaw dashboard`
3. **打开浏览器** — 访问输出的 Dashboard URL
4. **设备配对** — 首次连接需在容器内批准：

```bash
docker exec -it openclaw openclaw devices list
docker exec -it openclaw openclaw devices approve <request-id>
```

## 自定义模型

编辑 `openclaw-data/openclaw.json`（容器启动后自动生成），配置你的模型提供商：

```json
{
  "models": {
    "providers": {
      "my-provider": {
        "baseUrl": "https://api.example.com/v1",
        "apiKey": "<your-api-key>",
        "models": [
          { "id": "my-model", "name": "My Model", "contextWindow": 65536 }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": { "primary": "my-provider/my-model" }
    }
  }
}
```

## 端口

| 端口 | 说明 |
|------|------|
| 18789 | Gateway / Dashboard |

## 数据卷

| 路径 | 说明 |
|------|------|
| `/root/.openclaw` | 配置、会话、设备数据 |
| `/root/.openclaw/workspace/` | Agent 工作空间，挂载代码目录到此处 |

## 常用命令

```bash
docker exec -it openclaw openclaw status        # 查看状态
docker exec -it openclaw openclaw dashboard      # 获取 Dashboard URL
docker exec -it openclaw openclaw devices list   # 查看设备
docker exec -it openclaw openclaw logs --follow  # 实时日志
```

## 源码

GitHub: [https://github.com/80boys/openclaw](https://github.com/80boys/openclaw)
