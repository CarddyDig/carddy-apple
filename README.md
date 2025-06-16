# Carddy

一个使用 SwiftUI 开发的 iOS 应用，支持规范化的 Git 提交。

## 🚀 开发环境

- iOS 26.0+
- Xcode 16.0+
- Swift 6.0+

## 📝 代码提交规范

本项目使用 [Commitizen](https://github.com/commitizen/cz-cli) 和 [Gitmoji](https://gitmoji.dev/) 来规范化 Git 提交信息。

### 安装依赖

```bash
bun install
```

### 提交代码

#### 方式一：使用 Commitizen（推荐）

```bash
# 使用 Commitizen 进行交互式提交
bun run commit

# 或者直接使用
bunx cz
```

#### 方式二：使用 Gitmoji CLI

```bash
# 使用 Gitmoji CLI 进行交互式提交
bun run commit:gitmoji

# 或者直接使用
bunx gitmoji -c
```

### 提交类型说明

| Emoji | 代码 | 类型 | 描述 |
|-------|------|------|------|
| ✨ | `:sparkles:` | feat | 引入新功能 |
| 🐛 | `:bug:` | fix | 修复 bug |
| 📝 | `:memo:` | docs | 添加或更新文档 |
| 💄 | `:lipstick:` | style | 更新 UI 和样式文件 |
| ♻️ | `:recycle:` | refactor | 重构代码 |
| ⚡️ | `:zap:` | perf | 提升性能 |
| ✅ | `:white_check_mark:` | test | 添加、更新或通过测试 |
| 🔧 | `:wrench:` | chore | 添加或更新配置文件 |
| 🚀 | `:rocket:` | deploy | 部署功能 |
| 🎨 | `:art:` | format | 改进代码结构/代码格式 |

### 提交示例

```bash
# 添加新功能
git add .
bun run commit
# 选择 ✨ feat: 引入新功能
# 输入: 添加用户登录功能

# 修复 bug
git add .
bun run commit
# 选择 🐛 fix: 修复 bug
# 输入: 修复登录页面崩溃问题

# 更新文档
git add .
bun run commit
# 选择 📝 docs: 添加或更新文档
# 输入: 更新 API 文档
```

## 🏗️ 项目结构

```
carddy/
├── carddy/
│   ├── App/                 # 应用程序入口
│   ├── Views/              # SwiftUI 视图
│   │   ├── Data/           # 数据相关视图
│   │   └── ...
│   ├── Models/             # 数据模型
│   ├── Services/           # 服务层
│   └── Assets.xcassets     # 资源文件
├── package.json            # Node.js 依赖配置
├── .czrc                   # Commitizen 配置
└── README.md              # 项目说明
```

## 🛠️ 开发指南

1. **克隆项目**
   ```bash
   git clone <repository-url>
   cd carddy
   ```

2. **安装依赖**
   ```bash
   bun install
   ```

3. **打开 Xcode 项目**
   ```bash
   open carddy.xcodeproj
   ```

4. **开始开发**
   - 使用 Xcode 进行 iOS 开发
   - 使用 `bun run commit` 进行规范化提交

## 📄 许可证

MIT License
