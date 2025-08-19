#!/bin/bash

# n8n 备份脚本

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 配置
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PREFIX="n8n_backup_${TIMESTAMP}"

# 函数：打印带颜色的消息
print_message() {
    echo -e "${2}${1}${NC}"
}

# 创建备份目录
mkdir -p ${BACKUP_DIR}

print_message "=====================================" "$BLUE"
print_message "   n8n 备份脚本" "$BLUE"
print_message "=====================================" "$BLUE"
echo

# 备份数据库
print_message "📦 备份 PostgreSQL 数据库..." "$YELLOW"
docker-compose exec -T postgres pg_dump -U n8n n8n > "${BACKUP_DIR}/${BACKUP_PREFIX}_database.sql"
if [ $? -eq 0 ]; then
    print_message "✅ 数据库备份完成: ${BACKUP_PREFIX}_database.sql" "$GREEN"
else
    print_message "❌ 数据库备份失败" "$RED"
    exit 1
fi

# 备份 n8n 数据目录
print_message "📦 备份 n8n 数据目录..." "$YELLOW"
docker run --rm \
    -v n8n-deployment_n8n_data:/data \
    -v $(pwd)/${BACKUP_DIR}:/backup \
    alpine tar czf "/backup/${BACKUP_PREFIX}_data.tar.gz" -C /data .
if [ $? -eq 0 ]; then
    print_message "✅ 数据目录备份完成: ${BACKUP_PREFIX}_data.tar.gz" "$GREEN"
else
    print_message "❌ 数据目录备份失败" "$RED"
    exit 1
fi

# 备份环境配置
print_message "📦 备份环境配置..." "$YELLOW"
if [ -f .env ]; then
    cp .env "${BACKUP_DIR}/${BACKUP_PREFIX}.env"
    print_message "✅ 环境配置备份完成: ${BACKUP_PREFIX}.env" "$GREEN"
fi

# 计算备份大小
BACKUP_SIZE=$(du -sh ${BACKUP_DIR}/${BACKUP_PREFIX}* | awk '{print $1}' | paste -sd+ | bc 2>/dev/null || echo "未知")

# 清理旧备份（保留最近7天）
print_message "🧹 清理旧备份（保留7天）..." "$YELLOW"
find ${BACKUP_DIR} -name "n8n_backup_*" -mtime +7 -delete
print_message "✅ 旧备份清理完成" "$GREEN"

echo
print_message "=====================================" "$GREEN"
print_message "✅ 备份完成！" "$GREEN"
print_message "=====================================" "$GREEN"
echo
print_message "备份位置: ${BACKUP_DIR}/" "$BLUE"
print_message "备份文件:" "$BLUE"
print_message "  - ${BACKUP_PREFIX}_database.sql" "$NC"
print_message "  - ${BACKUP_PREFIX}_data.tar.gz" "$NC"
print_message "  - ${BACKUP_PREFIX}.env" "$NC"
echo

# 显示恢复命令
print_message "恢复命令示例：" "$YELLOW"
print_message "  数据库: docker-compose exec -T postgres psql -U n8n n8n < ${BACKUP_DIR}/${BACKUP_PREFIX}_database.sql" "$NC"
print_message "  数据目录: docker run --rm -v n8n-deployment_n8n_data:/data -v \$(pwd)/${BACKUP_DIR}:/backup alpine tar xzf /backup/${BACKUP_PREFIX}_data.tar.gz -C /data" "$NC"