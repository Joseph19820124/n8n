#!/bin/bash

# n8n Docker 部署脚本
# 包含 SuperCode 节点的自动化部署

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函数：打印带颜色的消息
print_message() {
    echo -e "${2}${1}${NC}"
}

# 函数：检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        print_message "❌ $1 未安装，请先安装 $1" "$RED"
        exit 1
    fi
}

# 函数：生成随机密钥
generate_key() {
    openssl rand -hex 32
}

# 标题
clear
print_message "=====================================" "$BLUE"
print_message "   n8n Docker 部署脚本" "$BLUE"
print_message "   包含 SuperCode 自定义节点" "$BLUE"
print_message "=====================================" "$BLUE"
echo

# 步骤 1: 检查依赖
print_message "步骤 1: 检查系统依赖..." "$YELLOW"
check_command docker
check_command docker-compose
check_command openssl
print_message "✅ 所有依赖已安装" "$GREEN"
echo

# 步骤 2: 检查 Docker 服务
print_message "步骤 2: 检查 Docker 服务..." "$YELLOW"
if ! docker info > /dev/null 2>&1; then
    print_message "❌ Docker 服务未运行，请启动 Docker" "$RED"
    exit 1
fi
print_message "✅ Docker 服务正在运行" "$GREEN"
echo

# 步骤 3: 创建环境配置
print_message "步骤 3: 配置环境变量..." "$YELLOW"
if [ ! -f .env ]; then
    cp .env.example .env
    
    # 生成安全密钥
    ENCRYPTION_KEY=$(generate_key)
    JWT_SECRET=$(generate_key)
    DB_PASSWORD=$(generate_key | cut -c1-16)
    
    # 更新 .env 文件
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/your_secure_password_here/$DB_PASSWORD/g" .env
        sed -i '' "s/change_me_to_32_character_string_here_12345678/$ENCRYPTION_KEY/g" .env
        sed -i '' "s/change_me_to_32_character_jwt_secret_here_1234/$JWT_SECRET/g" .env
    else
        # Linux
        sed -i "s/your_secure_password_here/$DB_PASSWORD/g" .env
        sed -i "s/change_me_to_32_character_string_here_12345678/$ENCRYPTION_KEY/g" .env
        sed -i "s/change_me_to_32_character_jwt_secret_here_1234/$JWT_SECRET/g" .env
    fi
    
    print_message "✅ 环境变量已配置（已生成安全密钥）" "$GREEN"
else
    print_message "⚠️  .env 文件已存在，跳过配置" "$YELLOW"
fi
echo

# 步骤 4: 创建必要的目录
print_message "步骤 4: 创建必要的目录..." "$YELLOW"
mkdir -p custom-nodes backups ssl
print_message "✅ 目录已创建" "$GREEN"
echo

# 步骤 5: 构建镜像
print_message "步骤 5: 构建自定义 n8n 镜像（包含 SuperCode 节点）..." "$YELLOW"
docker-compose build --no-cache
print_message "✅ 镜像构建完成" "$GREEN"
echo

# 步骤 6: 启动服务
print_message "步骤 6: 启动服务..." "$YELLOW"
docker-compose up -d
print_message "✅ 服务启动中..." "$GREEN"
echo

# 步骤 7: 等待服务就绪
print_message "步骤 7: 等待服务就绪..." "$YELLOW"
MAX_ATTEMPTS=30
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
    if curl -s http://localhost:5678/healthz > /dev/null 2>&1; then
        print_message "✅ n8n 服务已就绪！" "$GREEN"
        break
    fi
    
    ATTEMPT=$((ATTEMPT + 1))
    echo -n "."
    sleep 2
done

if [ $ATTEMPT -eq $MAX_ATTEMPTS ]; then
    print_message "⚠️  服务启动超时，请检查日志" "$YELLOW"
    docker-compose logs n8n
fi
echo

# 步骤 8: 显示服务状态
print_message "步骤 8: 服务状态..." "$YELLOW"
docker-compose ps
echo

# 显示访问信息
print_message "=====================================" "$GREEN"
print_message "🎉 部署完成！" "$GREEN"
print_message "=====================================" "$GREEN"
echo
print_message "访问地址: http://localhost:5678" "$BLUE"
print_message "首次访问需要创建管理员账户" "$BLUE"
echo
print_message "有用的命令：" "$YELLOW"
print_message "  查看日志: docker-compose logs -f n8n" "$NC"
print_message "  停止服务: docker-compose down" "$NC"
print_message "  重启服务: docker-compose restart" "$NC"
print_message "  备份数据: ./backup.sh" "$NC"
echo
print_message "SuperCode 节点已安装，可在节点列表中找到" "$GREEN"
echo

# 询问是否打开浏览器
read -p "是否立即在浏览器中打开 n8n？(y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open http://localhost:5678
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open http://localhost:5678
    fi
fi