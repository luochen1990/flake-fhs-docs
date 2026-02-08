# Nix 打包与部署调研报告

## 项目概述

**项目名称**: flake-fhs-docs
**项目类型**: 静态文档网站 (基于 Astro Starlight)
**项目描述**: Flake FHS 框架的官方文档站点，提供全面、易用、可搜索的文档体验。

## 技术栈

### 核心框架
- **Astro**: v4.14.0 - 现代 Web 框架
- **Starlight**: v0.26.0 - Astro 的文档主题
- **React**: v19.2.4 - 用于交互组件
- **TypeScript**: v5.5.0 - 类型安全

### 样式与构建
- **Tailwind CSS**: v3.4.19 - 样式框架
- **Sharp**: v0.34.5 - 图片处理库

### 开发工具
- **包管理器**: pnpm
- **类型检查**: tsc (TypeScript 编译器)
- **链接检查**: Lychee
- **代码检查**: astro check

## 包信息

### 主要包

| 包名 | 类型 | 描述 | 输出路径 |
|------|------|------|----------|
| flake-fhs-docs | 静态网站 | 构建后的文档站点 | dist/ |

**包说明**:
- 该包为静态网站，使用 Astro 构建生成
- 构建产物为纯静态文件（HTML、CSS、JS、图片等）
- 可直接部署到任何静态文件服务器或 CDN

## 服务信息

### 提供的服务

| 服务名 | 命令 | 描述 | 端口 |
|--------|------|------|------|
| dev-server | `pnpm dev` | 开发服务器，支持热重载 | 4321 |
| preview-server | `pnpm preview` | 预览构建后的站点 | 4321 |

**服务说明**:
- 开发服务器提供热重载功能，用于本地开发
- 预览服务器用于验证生产构建结果

## 构建与部署

### 开发流程

```bash
# 安装依赖
pnpm install

# 启动开发服务器
pnpm dev          # 访问 http://localhost:4321

# 构建生产版本
pnpm build        # 执行 astro check + astro build

# 预览生产版本
pnpm preview      # 访问 http://localhost:4321

# 代码检查
pnpm check        # 执行 astro check + tsc --noEmit + 链接检查

# 链接检查
pnpm check:links           # 全面检查所有链接（内部 + 外部）
pnpm check:links:external  # 快速检查外部链接
```

### 构建配置

- **配置文件**: `astro.config.mjs`
- **TypeScript 配置**: `tsconfig.json` (使用 `astro/tsconfigs/strict` 基础配置)
- **Tailwind 配置**: `tailwind.config.mjs`

### 构建产物

- **输出目录**: `dist/`
- **内容类型**: 静态 HTML、CSS、JS 文件
- **多语言支持**: 简体中文 (zh-cn) 为主要语言，英文 (en) 为翻译
- **路由**: 基于文件系统的自动路由生成

## 目录结构

```
flake-fhs-docs/
├── src/
│   ├── assets/           # 静态资源（图片、Logo 等）
│   ├── components/       # 自定义 React/Astro 组件
│   ├── content/
│   │   ├── docs/         # 文档内容（SSOT）
│   │   │   ├── zh-cn/    # 简体中文源内容
│   │   │   └── en/       # 英文翻译
│   │   └── config.ts     # Content collections 配置
│   ├── layouts/          # 自定义布局
│   ├── pages/            # 页面路由
│   └── styles/           # 全局样式
├── public/               # 公共静态文件
├── dist/                 # 构建产物（Git 忽略）
├── package.json          # 项目依赖
├── astro.config.mjs      # Astro 配置
├── tsconfig.json         # TypeScript 配置
└── tailwind.config.mjs   # Tailwind 配置
```

## 关键特性

1. **SSOT (Single Source of Truth)**: `src/content/docs/zh-cn/` 是文档内容的单一事实来源
2. **多语言支持**: 基于路由的 i18n，主要语言为简体中文
3. **类型安全**: 严格的 TypeScript 配置
4. **链接验证**: 集成 Lychee 进行自动链接检查
5. **热重载**: 开发环境支持文件监听和自动重新加载

## 依赖版本约束

- Node.js: >= 18.x (Astro 4.x 要求)
- pnpm: 建议使用最新稳定版
- 仅构建依赖需要预构建: esbuild, sharp

## 部署建议

1. **静态托管**: 由于是纯静态网站，可部署到任何静态托管服务
   - Netlify
   - Vercel
   - GitHub Pages
   - Cloudflare Pages
   - Nginx/Apache 等

2. **预渲染**: 内容在构建时预渲染，无需服务器端渲染

3. **CDN 友好**: 构建产物可缓存到 CDN，提升访问速度

## Nix 打包注意事项

1. **Node.js 版本**: 使用 nixpkgs 中最新的 Node.js LTS 版本（如 nodejs_20）
2. **pnpm 依赖**: 需要包含 `nodePackages.pnpm`
3. **Sharp 原生模块**: sharp 需要编译原生模块，确保构建环境包含必要的构建工具
4. **构建输出**: 静态文件应正确放置到 `$out/share/www` 或类似位置
5. **开发服务**: 可通过 `pkgs.writeShellApplication` 提供 dev 服务封装
