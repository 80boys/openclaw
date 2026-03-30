#!/bin/sh
set -e

export OPENCLAW_HOME="${OPENCLAW_HOME:-/root}"

mkdir -p "$OPENCLAW_HOME/.openclaw"

# 首次运行时生成默认配置 允许局域网链接访问
if [ ! -f "$OPENCLAW_HOME/.openclaw/openclaw.json" ]; then
    echo ">>> 首次运行，生成默认配置..."
    cat > "$OPENCLAW_HOME/.openclaw/openclaw.json" <<'CONF'
{
  "gateway": {
    "mode": "local",
    "bind": "lan",
    "trustedProxies": ["172.30.0.0/24"]
  }
}
CONF
    echo ">>> 配置文件已创建，可通过挂载卷自定义配置"
fi

# 将当前目录下的所有 .md 文件拷贝到工作区（除隐藏文件）
for file in ./*.md; do
    [ -e "$file" ] || continue
    cp "$file" "$OPENCLAW_HOME/.openclaw/workspace/"
done


echo ">>> OpenClaw $(openclaw --version 2>/dev/null || echo 'unknown') 启动中..."
echo ">>> 配置目录: $OPENCLAW_HOME"

exec "$@"
