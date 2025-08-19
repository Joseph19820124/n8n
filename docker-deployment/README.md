# n8n Docker 部署指南（含 SuperCode 节点）

本指南将帮助您使用 Docker 部署 n8n 工作流自动化平台，并集成 [@kenkaiii/n8n-nodes-supercode](https://www.npmjs.com/package/@kenkaiii/n8n-nodes-supercode) 自定义节点。

## 📋 前置要求

- Docker Engine 20.10+ 
- Docker Compose 2.0+
- 至少 2GB 可用内存
- 至少 10GB 可用磁盘空间
- Linux/macOS/Windows (WSL2)

## 🚀 快速开始

### 1. 克隆或创建部署目录

```bash
# 创建部署目录
mkdir n8n-deployment
cd n8n-deployment

# 下载部署文件
# 或者直接复制本目录下的所有文件
```

### 2. 配置环境变量

```bash
# 复制环境变量模板
cp .env.example .env

# 生成安全的密钥
echo "N8N_ENCRYPTION_KEY=$(openssl rand -hex 32)" >> .env
echo "N8N_USER_MANAGEMENT_JWT_SECRET=$(openssl rand -hex 32)" >> .env

# 编辑 .env 文件，修改数据库密码等敏感信息
nano .env
```

**重要配置项：**
- `POSTGRES_PASSWORD`: PostgreSQL 数据库密码
- `N8N_ENCRYPTION_KEY`: 数据加密密钥（32字符）
- `N8N_USER_MANAGEMENT_JWT_SECRET`: JWT 密钥（32字符）
- `WEBHOOK_URL`: Webhook 访问地址

### 3. 启动服务

```bash
# 构建并启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f n8n
```

### 4. 访问 n8n

- 打开浏览器访问：http://localhost:5678
- 首次访问需要创建管理员账户
- 创建账户后即可开始使用

## 📦 SuperCode 节点说明

本部署已集成 `@kenkaiii/n8n-nodes-supercode` 节点包，该节点提供了以下功能：

- **代码执行**: 支持多种编程语言的代码执行
- **数据转换**: 高级数据处理和转换功能
- **自定义逻辑**: 实现复杂的业务逻辑

### 使用 SuperCode 节点

1. 在 n8n 编辑器中，点击 "+" 添加节点
2. 搜索 "SuperCode"
3. 拖拽节点到工作流中
4. 配置节点参数
5. 连接其他节点并执行

## 🏗️ 架构说明

本部署采用以下架构：

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Nginx     │────▶│     n8n     │────▶│  PostgreSQL │
│  (可选)     │     │   主服务     │     │   数据库    │
└─────────────┘     └─────────────┘     └─────────────┘
                            │
                            ▼
                    ┌─────────────┐
                    │    Redis    │
                    │   队列管理   │
                    └─────────────┘
                            │
                            ▼
                    ┌─────────────┐
                    │  n8n Worker │
                    │   工作进程   │
                    └─────────────┘
```

### 服务说明

- **PostgreSQL**: 数据持久化存储
- **Redis**: 队列管理和缓存
- **n8n**: 主应用服务
- **n8n-worker**: 后台任务执行
- **Nginx**: 反向代理（可选）

## 🔧 高级配置

### 启用 HTTPS (使用 Nginx)

1. 准备 SSL 证书：
```bash
# 创建 SSL 目录
mkdir ssl

# 复制证书文件
cp /path/to/cert.pem ssl/
cp /path/to/key.pem ssl/
```

2. 修改 nginx.conf 中的域名：
```nginx
server_name your-domain.com;
```

3. 启动包含 Nginx 的服务：
```bash
docker-compose --profile with-nginx up -d
```

### 配置邮件服务

编辑 `.env` 文件，取消注释并配置 SMTP 部分：

```bash
N8N_EMAIL_MODE=smtp
N8N_SMTP_HOST=smtp.gmail.com
N8N_SMTP_PORT=465
N8N_SMTP_USER=your-email@gmail.com
N8N_SMTP_PASS=your-app-password
N8N_SMTP_SENDER=your-email@gmail.com
N8N_SMTP_SSL=true
```

### 调整性能参数

修改 `.env` 中的性能相关配置：

```bash
# 增加内存限制 (MB)
NODE_MAX_OLD_SPACE_SIZE=4096

# 增加并发执行限制
N8N_CONCURRENCY_PRODUCTION_LIMIT=20

# 调整工作进程数量
# 在 docker-compose.yml 中可以增加 worker 副本
```

## 📊 监控和维护

### 查看日志

```bash
# 查看所有服务日志
docker-compose logs

# 查看特定服务日志
docker-compose logs n8n
docker-compose logs postgres

# 实时查看日志
docker-compose logs -f n8n
```

### 备份数据

```bash
# 备份数据库
docker-compose exec postgres pg_dump -U n8n n8n > backup_$(date +%Y%m%d).sql

# 备份 n8n 数据目录
docker run --rm -v n8n-deployment_n8n_data:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/n8n_data_$(date +%Y%m%d).tar.gz -C /data .
```

### 恢复数据

```bash
# 恢复数据库
docker-compose exec -T postgres psql -U n8n n8n < backup_20240101.sql

# 恢复 n8n 数据
docker run --rm -v n8n-deployment_n8n_data:/data -v $(pwd)/backups:/backup \
  alpine tar xzf /backup/n8n_data_20240101.tar.gz -C /data
```

### 更新 n8n

```bash
# 停止服务
docker-compose down

# 更新镜像
docker-compose pull

# 重新构建自定义镜像
docker-compose build --no-cache

# 启动服务
docker-compose up -d
```

## 🔐 安全建议

1. **修改默认密码**: 必须修改所有默认密码
2. **使用 HTTPS**: 生产环境务必启用 HTTPS
3. **防火墙配置**: 仅开放必要端口
4. **定期备份**: 设置自动备份计划
5. **更新维护**: 定期更新 n8n 和依赖
6. **访问控制**: 配置适当的用户权限

### 安全检查清单

- [ ] 修改 PostgreSQL 密码
- [ ] 设置强加密密钥
- [ ] 配置 JWT 密钥
- [ ] 启用 HTTPS
- [ ] 配置防火墙规则
- [ ] 设置备份策略
- [ ] 限制管理员访问
- [ ] 启用审计日志

## 🐛 故障排除

### 常见问题

#### 1. 容器无法启动
```bash
# 检查容器状态
docker-compose ps

# 查看详细错误
docker-compose logs n8n
```

#### 2. 数据库连接失败
```bash
# 检查数据库服务
docker-compose exec postgres psql -U n8n -c "SELECT 1"

# 重启数据库
docker-compose restart postgres
```

#### 3. SuperCode 节点不可见
```bash
# 进入容器检查
docker-compose exec n8n sh
cd /usr/local/lib/node_modules/n8n/node_modules
ls -la | grep supercode

# 重新构建镜像
docker-compose build --no-cache n8n
```

#### 4. 内存不足错误
```bash
# 增加 Node.js 内存限制
# 编辑 .env 文件
NODE_MAX_OLD_SPACE_SIZE=4096
```

### 性能优化建议

1. **数据库优化**
   - 定期清理执行历史
   - 添加适当的索引
   - 调整 PostgreSQL 配置

2. **Redis 优化**
   - 配置适当的内存限制
   - 设置过期策略

3. **n8n 优化**
   - 合理设置并发限制
   - 优化工作流设计
   - 使用 Worker 模式

## 📚 相关资源

- [n8n 官方文档](https://docs.n8n.io)
- [n8n GitHub](https://github.com/n8n-io/n8n)
- [SuperCode 节点文档](https://www.npmjs.com/package/@kenkaiii/n8n-nodes-supercode)
- [Docker 文档](https://docs.docker.com)
- [Docker Compose 文档](https://docs.docker.com/compose)

## 💡 提示和技巧

1. **开发环境**: 使用 SQLite 替代 PostgreSQL 以节省资源
2. **生产环境**: 使用环境变量管理敏感信息
3. **监控**: 集成 Prometheus/Grafana 进行监控
4. **日志**: 使用 ELK Stack 进行日志分析
5. **CI/CD**: 使用 GitLab CI 或 GitHub Actions 自动化部署

## 🤝 支持

如遇到问题，可以：
1. 查看 [n8n 社区论坛](https://community.n8n.io)
2. 提交 [GitHub Issue](https://github.com/n8n-io/n8n/issues)
3. 查看 [Stack Overflow](https://stackoverflow.com/questions/tagged/n8n)

## 📄 许可证

n8n 使用 [可持续使用许可证](https://github.com/n8n-io/n8n/blob/master/LICENSE.md)。