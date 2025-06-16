# 📝 代码提交规范指南

## 🚀 快速开始

### 1. 使用 Commitizen（推荐）

```bash
# 添加文件到暂存区
git add .

# 使用 Commitizen 进行交互式提交
bun run commit
```

### 2. 使用 Gitmoji CLI

```bash
# 添加文件到暂存区
git add .

# 使用 Gitmoji CLI 进行交互式提交
bun run commit:gitmoji
```

## 📋 提交类型说明

### 常用类型

| Emoji | 代码 | 类型 | 描述 | 使用场景 |
|-------|------|------|------|----------|
| ✨ | `:sparkles:` | feat | 引入新功能 | 添加新的功能特性 |
| 🐛 | `:bug:` | fix | 修复 bug | 修复代码中的错误 |
| 📝 | `:memo:` | docs | 添加或更新文档 | 更新 README、API 文档等 |
| 💄 | `:lipstick:` | style | 更新 UI 和样式文件 | 修改 CSS、SwiftUI 样式等 |
| ♻️ | `:recycle:` | refactor | 重构代码 | 代码重构，不改变功能 |
| ⚡️ | `:zap:` | perf | 提升性能 | 性能优化 |
| ✅ | `:white_check_mark:` | test | 添加、更新或通过测试 | 单元测试、集成测试 |
| 🔧 | `:wrench:` | chore | 添加或更新配置文件 | 构建配置、依赖更新 |

### iOS 开发专用

| Emoji | 代码 | 类型 | 描述 |
|-------|------|------|------|
| 🍎 | `:apple:` | osx | 修复 macOS 上的某些功能 |
| 📱 | `:iphone:` | responsive | 响应式设计 |
| 🎨 | `:art:` | format | 改进代码结构/代码格式 |
| 🚀 | `:rocket:` | deploy | 部署功能 |

## 💡 提交示例

### 功能开发
```bash
# 添加新的登录功能
git add .
bun run commit
# 选择: ✨ feat: 引入新功能
# 输入: 添加用户登录功能
```

### Bug 修复
```bash
# 修复登录页面崩溃
git add .
bun run commit
# 选择: 🐛 fix: 修复 bug
# 输入: 修复登录页面在 iOS 26 上的崩溃问题
```

### UI 更新
```bash
# 更新按钮样式
git add .
bun run commit
# 选择: 💄 style: 更新 UI 和样式文件
# 输入: 更新主页按钮的玻璃效果样式
```

### 文档更新
```bash
# 更新 README
git add .
bun run commit
# 选择: 📝 docs: 添加或更新文档
# 输入: 更新项目安装和使用说明
```

## 🔧 配置说明

### package.json 脚本
- `bun run commit`: 使用 Commitizen 进行提交
- `bun run commit:gitmoji`: 使用 Gitmoji CLI 进行提交

### 配置文件
- `.czrc`: Commitizen 配置，包含中文描述的 gitmoji 类型
- `package.json`: 项目依赖和脚本配置

## 📚 最佳实践

1. **提交频率**: 小而频繁的提交比大而稀少的提交更好
2. **描述清晰**: 提交信息要清楚描述做了什么改变
3. **单一职责**: 每个提交只做一件事
4. **测试通过**: 提交前确保代码能够正常运行
5. **使用中文**: 提交描述使用中文，便于团队理解

## 🛠️ 故障排除

### 如果 Commitizen 不工作
```bash
# 重新安装依赖
bun install

# 检查配置
cat .czrc
cat package.json
```

### 如果 Gitmoji 不工作
```bash
# 检查 gitmoji-cli 是否安装
bunx gitmoji --version

# 重新安装
bun add -D gitmoji-cli
```
