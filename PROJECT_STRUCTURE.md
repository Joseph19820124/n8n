# n8n 项目结构分析文档

## 项目概述

n8n 是一个强大的工作流自动化平台，为技术团队提供代码的灵活性和无代码的速度。它具有 400+ 集成、原生 AI 能力，以及公平代码许可证，让你可以构建强大的自动化，同时保持对数据和部署的完全控制。

### 主要特性
- **代码与无代码结合**: 支持 JavaScript/Python 编写，可添加 npm 包，也可使用可视化界面
- **AI 原生平台**: 基于 LangChain 构建 AI 代理工作流
- **完全控制**: 可自托管或使用云服务
- **企业级功能**: 高级权限、SSO、离线部署
- **活跃社区**: 400+ 集成和 900+ 现成模板

## 技术栈

- **后端**: Node.js (>=22.16), TypeScript
- **前端**: Vue 3, Pinia, Element Plus, Vue Flow
- **数据库**: PostgreSQL, MySQL, SQLite (通过 TypeORM)
- **构建工具**: Turbo, pnpm, Vite, ESBuild
- **测试**: Jest, Playwright, Vitest
- **容器化**: Docker
- **代码质量**: ESLint, Biome, Stylelint

## 目录结构

```
n8n/
├── packages/                    # 核心包（monorepo 结构）
│   ├── @n8n/                   # 内部共享包
│   │   ├── ai-workflow-builder.ee/  # AI 工作流构建器（企业版）
│   │   ├── api-types/           # API 类型定义
│   │   ├── backend-common/      # 后端通用代码
│   │   ├── backend-test-utils/  # 后端测试工具
│   │   ├── benchmark/           # 性能基准测试
│   │   ├── client-oauth2/       # OAuth2 客户端
│   │   ├── codemirror-lang/     # CodeMirror 语言支持
│   │   ├── config/              # 配置管理
│   │   ├── constants/           # 常量定义
│   │   ├── create-node/         # 节点创建工具
│   │   ├── db/                  # 数据库抽象层
│   │   ├── decorators/          # TypeScript 装饰器
│   │   ├── di/                  # 依赖注入容器
│   │   ├── errors/              # 错误处理
│   │   ├── eslint-config/       # ESLint 配置
│   │   ├── extension-sdk/       # 扩展 SDK
│   │   ├── imap/                # IMAP 客户端
│   │   ├── json-schema-to-zod/  # JSON Schema 转换
│   │   ├── node-cli/            # 节点 CLI 工具
│   │   ├── nodes-langchain/     # LangChain 节点
│   │   ├── permissions/         # 权限管理
│   │   ├── storybook/           # Storybook 配置
│   │   ├── stylelint-config/    # Stylelint 配置
│   │   ├── task-runner/         # 任务运行器
│   │   ├── task-runner-python/  # Python 任务运行器
│   │   ├── typescript-config/   # TypeScript 配置
│   │   ├── utils/               # 工具函数
│   │   └── vitest-config/       # Vitest 配置
│   │
│   ├── cli/                     # 主 CLI 应用
│   │   ├── bin/                 # 可执行文件
│   │   ├── src/                 # 源代码
│   │   │   ├── commands/        # CLI 命令实现
│   │   │   ├── controllers/     # REST API 控制器
│   │   │   ├── databases/       # 数据库模型和仓库
│   │   │   ├── services/        # 业务服务层
│   │   │   ├── middlewares/     # Express 中间件
│   │   │   └── server.ts        # 主服务器文件
│   │   └── templates/           # HTML 模板
│   │
│   ├── core/                    # 核心工作流引擎
│   │   ├── src/                 
│   │   │   ├── binary-data/     # 二进制数据处理
│   │   │   ├── encryption/      # 加密工具
│   │   │   ├── execution-engine/# 执行引擎
│   │   │   └── node-execute-functions.ts # 节点执行函数
│   │   └── test/                # 测试文件
│   │
│   ├── workflow/                # 工作流定义引擎
│   │   ├── src/
│   │   │   ├── workflow.ts      # 核心工作流类
│   │   │   ├── expression.ts    # 表达式求值
│   │   │   ├── interfaces.ts    # TypeScript 接口
│   │   │   └── node-helpers.ts  # 节点辅助函数
│   │   └── test/                # 测试文件
│   │
│   ├── frontend/                # 前端应用
│   │   └── editor-ui/           # 编辑器 UI
│   │       ├── src/
│   │       │   ├── api/         # API 客户端
│   │       │   ├── components/  # Vue 组件
│   │       │   ├── composables/ # Vue 组合式函数
│   │       │   ├── stores/      # Pinia 状态管理
│   │       │   └── views/       # 页面视图
│   │       └── public/          # 静态资源
│   │
│   ├── nodes-base/              # 内置节点实现
│   │   ├── credentials/         # 凭证类型定义 (300+)
│   │   └── nodes/               # 节点实现 (400+)
│   │       ├── Google/          # Google 服务节点
│   │       ├── Microsoft/       # Microsoft 服务节点
│   │       ├── Slack/           # Slack 节点
│   │       └── ...              # 其他服务节点
│   │
│   ├── extensions/              # 扩展
│   │   └── insights/            # 洞察扩展
│   │
│   └── testing/                 # 测试相关
│       ├── containers/          # 容器测试
│       └── playwright/          # E2E 测试
│
├── cypress/                     # Cypress E2E 测试
│   ├── e2e/                     # 端到端测试用例
│   ├── fixtures/                # 测试数据
│   ├── pages/                   # 页面对象模型
│   └── support/                 # 测试支持文件
│
├── docker/                      # Docker 相关
│   └── images/
│       ├── n8n/                 # n8n Docker 镜像
│       └── n8n-base/            # 基础镜像
│
├── scripts/                     # 构建和工具脚本
│   ├── backend-module/          # 后端模块生成器
│   ├── build-n8n.mjs           # 构建脚本
│   ├── dockerize-n8n.mjs       # Docker 化脚本
│   └── format.mjs              # 代码格式化脚本
│
├── patches/                     # npm 包补丁
├── assets/                      # 项目资源文件
│
├── package.json                 # 根 package.json
├── pnpm-workspace.yaml         # pnpm 工作区配置
├── turbo.json                  # Turbo 构建配置
├── tsconfig.json               # TypeScript 配置
├── lefthook.yml                # Git hooks 配置
├── biome.jsonc                 # Biome 格式化配置
└── README.md                   # 项目说明文档
```

## 核心架构组件详解

### 1. CLI 包 (`packages/cli`)
**核心职责**: 主服务器应用，负责工作流执行和 API 后端

**主要功能**:
- HTTP API 端点管理
- 工作流执行编排
- 用户认证和授权
- 数据库操作
- Webhook 处理
- 后台任务处理
- 多实例扩展支持

**关键技术**:
- Express.js 作为 Web 框架
- TypeORM 进行数据库操作
- Bull 实现任务队列
- JWT 认证
- WebSocket/SSE 实时通信

### 2. 核心包 (`packages/core`)
**核心职责**: 工作流执行逻辑和节点执行框架

**主要功能**:
- 节点执行上下文管理
- 二进制数据处理（文件存储、S3）
- 凭证管理和加密
- SSH 隧道管理
- 错误处理和报告

### 3. 工作流包 (`packages/workflow`)
**核心职责**: 工作流数据结构和执行逻辑

**主要功能**:
- 工作流数据结构定义
- 表达式语言求值
- 节点连接和数据流管理
- 工作流验证
- Cron 调度功能

### 4. 前端编辑器 (`packages/frontend/editor-ui`)
**核心职责**: Vue.js 工作流编辑器界面

**主要功能**:
- 可视化工作流编辑器
- 节点参数配置
- 执行监控和调试
- 模板管理
- 实时协作

**技术栈**:
- Vue 3 + Composition API
- Pinia 状态管理
- Vue Flow 节点编辑
- Element Plus UI 组件
- CodeMirror 代码编辑

### 5. 节点实现 (`packages/nodes-base`)
**核心职责**: 400+ 内置节点和凭证实现

**结构组织**:
- 每个服务一个目录
- 节点定义文件 (`.node.ts`)
- 节点元数据 (`.node.json`)
- API 客户端函数
- 凭证定义

## 关键架构模式

### 依赖注入
- 自定义 DI 容器 (`@n8n/di`)
- 服务注册和注入机制
- 模块化服务管理

### 模块化节点系统
- 标准化节点接口 (`INodeType`)
- 版本感知的节点实现
- 向后兼容性支持

### 事件驱动架构
- 内部事件总线
- Webhook 触发器
- 实时更新推送

### 扩展架构
- Worker 进程隔离执行
- 基于队列的任务处理
- Redis 状态共享
- 水平扩展支持

### 安全模式
- 沙箱化代码执行
- 凭证加密存储
- 基于角色的访问控制
- 输入验证和清理

## 数据流程

1. **工作流定义**: 前端创建包含连接节点的工作流定义
2. **执行触发**: 手动执行、定时触发或 webhook 触发
3. **节点执行**: 核心引擎按连接顺序执行节点
4. **数据转换**: 每个节点处理输入并产生输出
5. **状态管理**: 执行状态和数据持久化到数据库
6. **结果处理**: 最终结果存储并通过 API 提供访问

## 构建和开发

### 构建系统
- **Turbo**: Monorepo 构建编排
- **pnpm**: 包管理和工作区管理
- **Vite**: 前端构建
- **ESBuild**: 快速构建和打包

### 主要命令
```bash
# 开发模式
pnpm dev          # 启动所有服务
pnpm dev:be       # 仅后端
pnpm dev:fe       # 仅前端

# 构建
pnpm build        # 构建所有包
pnpm build:n8n    # 构建 n8n 应用

# 测试
pnpm test         # 运行所有测试
pnpm test:e2e     # 运行 E2E 测试

# 代码质量
pnpm lint         # 代码检查
pnpm format       # 代码格式化
pnpm typecheck    # 类型检查
```

## 部署架构

### 单实例部署
- SQLite 数据库
- 本地文件存储
- 适合小型部署

### 生产部署
- PostgreSQL/MySQL 数据库
- S3 兼容对象存储
- Redis 缓存和队列
- 多实例负载均衡
- Worker 进程池

### 容器化部署
- Docker 镜像支持
- Kubernetes 部署支持
- 环境变量配置
- 健康检查端点

## 扩展和自定义

### 自定义节点开发
1. 使用 `@n8n/create-node` 创建节点模板
2. 实现 `INodeType` 接口
3. 定义输入/输出参数
4. 实现执行逻辑
5. 打包和部署

### 扩展点
- 自定义节点和凭证
- Webhook 触发器
- 外部钩子
- 自定义表达式函数
- UI 扩展（通过扩展 SDK）

## 性能优化

### 执行优化
- 并行节点执行
- 数据流式处理
- 内存管理优化
- 二进制数据流处理

### 扩展性
- 水平扩展支持
- Worker 池管理
- 队列优先级
- 资源限制和配额

## 安全考虑

### 数据安全
- 凭证加密存储
- TLS/SSL 通信
- 敏感数据脱敏

### 执行安全
- 代码沙箱执行
- 资源限制
- 网络隔离选项

### 访问控制
- 基于角色的权限
- API 密钥管理
- SSO/SAML 集成
- 审计日志

## 总结

n8n 采用了现代化的微服务架构设计，通过 monorepo 管理多个相互依赖的包，实现了高度模块化和可扩展的工作流自动化平台。其架构设计在保持简洁的同时，提供了企业级的功能和扩展性，适合从个人使用到大规模企业部署的各种场景。