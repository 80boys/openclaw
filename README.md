# OpenClaw Docker

开箱即用的 [OpenClaw](https://docs.openclaw.ai) Docker 部署方案，支持挂载本地代码目录，让 AI Agent 直接读写你的项目文件。

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/80boys/openclaw.git
cd openclaw
```

### 2. 配置 docker-compose.yaml

编辑 `docker-compose.yaml`，将代码目录挂载到容器的 workspace 中：

```yaml
volumes:
  - ./openclaw-data:/root/.openclaw
  - /path/to/your/project:/root/.openclaw/workspace/project
```

可以挂载多个项目目录：

```yaml
volumes:
  - ./openclaw-data:/root/.openclaw
  - ~/projects/frontend:/root/.openclaw/workspace/frontend
  - ~/projects/backend:/root/.openclaw/workspace/backend
```

### 3. 启动

```bash
docker compose up -d
```

首次启动会自动生成默认配置到 `openclaw-data/openclaw.json`。

### 4. 获取 Dashboard 链接

```bash
docker exec -it openclaw openclaw dashboard
```

输出类似：

```
Dashboard URL: http://127.0.0.1:18789/#token=<your-token>
```

在浏览器中打开该链接。

### 5. 设备配对

首次连接需要配对浏览器设备：

```bash
# 查看待配对设备
docker exec -it openclaw openclaw devices list

# 批准配对请求
docker exec -it openclaw openclaw devices approve <request-id>
```

配对完成后刷新浏览器即可使用。

## 自定义配置

启动后 OpenClaw 会自动生成 `openclaw-data/openclaw.json`，你可以在其中配置模型、Agent 参数等。

### 配置自定义模型

```json
{
  "models": {
    "providers": {
      "my-provider": {
        "baseUrl": "https://api.example.com/v1",
        "apiKey": "<your-api-key>",
        "api": "openai-completions",
        "models": [
          {
            "id": "my-model",
            "name": "My Model",
            "contextWindow": 65536,
            "maxTokens": 4096
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "my-provider/my-model"
      }
    }
  }
}
```

### 配置说明

| 配置项 | 说明 |
|--------|------|
| `gateway.mode` | 网关模式，Docker 场景固定为 `"local"` |
| `gateway.bind` | 绑定模式：`"lan"`（局域网）、`"loopback"`（仅本机）、`"auto"` |
| `gateway.trustedProxies` | 信任的代理 IP 段，需与 Docker 网络子网匹配 |
| `gateway.auth.token` | 网关访问令牌，首次启动自动生成 |
| `agents.defaults.model.primary` | 默认使用的模型 |
| `agents.defaults.workspace` | Agent 工作空间路径 |

## 项目结构

```
openclaw/
├── Dockerfile              # 镜像构建文件
├── docker-compose.yaml     # 编排配置
├── docker-entrypoint.sh    # 容器入口脚本
├── .gitignore
└── openclaw-data/          # 运行时数据（已 gitignore）
    ├── openclaw.json       # 主配置文件
    ├── devices/            # 已配对设备信息
    ├── agents/             # Agent 会话数据
    └── workspace/          # 工作空间（挂载代码目录到这里）
```

## 构建镜像

```bash
docker build -t openclaw:2026.3.28v1 .
```

指定 OpenClaw 版本：

```bash
docker build --build-arg OPENCLAW_VERSION=2026.3.28 -t openclaw:2026.3.28v1 .
```

## 常用命令

```bash
# 启动
docker compose up -d

# 查看日志
docker compose logs -f

# 查看状态
docker exec -it openclaw openclaw status

# 实时日志
docker exec -it openclaw openclaw logs --follow

# 获取 Dashboard 链接
docker exec -it openclaw openclaw dashboard

# 设备管理
docker exec -it openclaw openclaw devices list

# 进入容器
docker exec -it openclaw bash

# 停止
docker compose down
```

## 网络配置

项目使用固定子网 `172.30.0.0/24`，容器 IP 固定为 `172.30.0.2`，确保 `trustedProxies` 配置稳定可靠。如需修改子网，同步更新 `docker-compose.yaml` 中的网络配置和 `openclaw.json` 中的 `trustedProxies`。

## 注意事项

- **软链接不可用**：Docker 卷挂载不会跟随宿主机的符号链接，必须直接挂载目标目录
- **配置持久化**：`openclaw-data/` 通过卷挂载持久化，删除后首次启动会重新生成默认配置
- **安全提示**：`openclaw.json` 中包含 API Key 和访问令牌，请勿提交到公开仓库

## 相关链接

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [OpenClaw FAQ](https://docs.openclaw.ai/faq)
- [OpenClaw 故障排查](https://docs.openclaw.ai/troubleshooting)
