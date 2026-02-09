# AGENTS.md

本文档是 `flake-fhs-docs` 仓库的开发与维护指南，适用于 AI 助手与开发者。

## 1. 项目定位

**`flake-fhs-docs`** 是 **Flake FHS** 框架的官方文档站点。
- **技术栈**: [Astro Starlight](https://starlight.astro.build/), React, TypeScript.
- **目标**: 提供全面、易用、可搜索的文档体验。
- **SSOT**: 本仓库是 Flake FHS 文档的**单一事实来源 (Single Source of Truth)**。

## 2. 仓库架构与关系

本项目是 Flake FHS 生态系统的一部分：

| 仓库 | 角色 | 关系 |
| :--- | :--- | :--- |
| **`flake-fhs`** | **核心运行时 (RTS)** | 框架实现本身。仅包含代码和注释，不含文档站源码。 |
| **`flake-fhs-docs`** | **文档产品** | **(本仓库)** 面向用户的文档网站。独立维护内容生命周期。 |
| **`flake-fhs-dev`** | **工作区 (Workspace)** | 父级仓库，通过 submodule 聚合上述两个仓库，用于协同开发。 |

### 分离原因
- **依赖纯净**: 避免 `flake-fhs` 的下游用户下载不必要的文档构建依赖。
- **独立生命周期**: 文档可独立于框架核心进行更新、版本控制和部署。

## 3. 开发流程

我们使用 **Nix** 提供可复用的开发环境。

1.  **环境**: `nix develop` (包含 `nodejs` 和 `pnpm`)。
2.  **安装**: `pnpm install`。
3.  **运行**:
    - `pnpm dev`: 启动本地开发服务器 (默认端口 `4321`)。
    - `pnpm build`: 构建生产环境静态站点。
    - `pnpm preview`: 预览构建后的站点。
4.  **检查**: 
    - `pnpm check`: 运行 `astro check` 和 `tsc`，确保类型安全。
    - `pnpm check:links`: (基于 Lychee) 构建站点并全面检查所有链接 (内部相对路径 + 外部 URL) 是否有效。推荐在提交前运行。
    - `pnpm check:links:external`: 快速检查源文件 (`src/`) 中的外部链接有效性。

## 4. 内容策略 (i18n & SSOT)

- **主要语言**: **简体中文 (`zh-cn`)** 是文档内容的单一事实来源。
- **目录结构**:
    - `src/content/docs/zh-cn/`: SSOT 文档源内容。
    - `src/content/docs/en/`: 英文翻译。
    - `src/assets/`: 静态资源（图片、Logo 等）。
- **文件命名**: 使用 kebab-case 命名法（如 `manual-best-practices.md`）。

### 4.1 示例编写原则

文档中引入的示例 (包括但不限于示例代码、示例目录)，必须遵从 **"真实"、"典型"、"小巧"** 三原则：

- **真实 (Real)**: 存在真实场景，而不是瞎编乱造 (比如 pkgs.wget 优于 pkgs.foo)。
- **典型 (Typical)**: 具备代表性 (大部分时候真的是这么用的)，而不过分 trivial (比如 `{ stdenv }: stdenv.mkDerivation { ... }` 优于 `{ pkgs }: pkgs.hello`)。
- **小巧 (Compact)**: 体积小，不过分 complex (在能满足真实和典型的前提下,示例能做到越小越好)。

### 4.2 内容编排原则

**先易后难 (Gradual Disclosure)**:
- 在介绍功能或概念时，遵循渐进式披露原则。
- **Step 1**: 总是先陈述主要用法 (Happy Path) 和最常见的场景。
- **Step 2**: 再展开讲解高级用法、边缘情况或复杂配置。
- **避免**: 切勿在文章开头将最复杂的完整用法一次性全摆出来，以免增加认知负荷吓跑用户。

### 4.3 术语规范

文档中涉及到 Flake 模块结构时，应统一使用以下术语：

- **单文件包 (Single-file Package)**: 例如 `pkgs/hello.nix`。
- **子目录包 (Subdirectory Package)**: 例如 `pkgs/hello/package.nix`。
- **单文件模块 (Single-file Module)**: 例如 `modules/nixos.nix`。
- **子目录模块 (Subdirectory Module)**: 例如 `modules/nixos/options.nix`。
- **包域 (Scope)**: 例如 `pkgs/python/scope.nix`。

## 5. 链接维护原则

Starlight 在多语言环境下对不同位置的链接有明确的行为差异，遵循以下原则确保链接的正确性。

### 5.1 Sidebar 配置 (`astro.config.mjs`)

**原则**：内部文档链接必须使用 `slug` 属性以支持自动 Locale 路由，外部链接使用 `link`。

| 属性 | 自动添加 Locale | 使用场景 |
|------|----------------|----------|
| `slug` | ✅ 是 | 内部文档链接（推荐）。例如 `manual-pkgs` 会自动解析为 `/zh-cn/manual-pkgs` |
| `link` | ❌ 否 | 外部链接、或根路径 `/` |

**示例**：
```javascript
// 内部链接（自动添加 locale）
{ label: '软件包', slug: 'manual-pkgs' }

// 外部链接或绝对路径（不添加 locale）
{ label: 'GitHub', link: 'https://github.com/...' }
{ label: '首页', link: '/' }
```

### 5.2 Frontmatter 配置

**原则**：hero actions 中的链接必须明确指定完整路径（包含 locale）。

```yaml
---
hero:
  actions:
    - text: 快速开始
      link: /zh-cn/manual-best-practices/  # ✅ 必须包含 locale
    - text: GitHub
      link: https://github.com/...          # ✅ 外部链接
---
```

### 5.3 Markdown 内容链接

**原则**：使用相对路径，**严禁**包含 `.md` 或 `.mdx` 后缀。

**推荐格式**：
```markdown
[详情](./manual-pkgs)         # ✅ 相对路径，自动适配当前 locale
[详情](../manual-hosts)       # ✅ 跨目录相对路径
[详情](./manual-pkgs#section)  # ✅ 支持锚点
```

**禁止格式**：
```markdown
[详情](./manual-pkgs.md)  # ❌ 带后缀会导致 404 (Starlight 路由不自动剥离后缀)
[主页](/)                   # ❌ 缺少 locale，会跳回根目录
[主页](/zh-cn/)             # ✅ 显式指定 locale 根路径可用
```

### 5.4 自动化链接检查

本项目已集成 **Lychee** 进行全自动链接检测，杜绝 404 死链。

- **全面检查 (推荐)**: `pnpm check:links`
    - 执行流程: `pnpm build` -> `lychee dist/`
    - 覆盖范围: 所有内部相对链接、锚点、外部 URL。
    - 适用场景: CI/CD、Release 前检查。
- **快速检查**: `pnpm check:links:external`
    - 执行流程: 扫描 `src/` Markdown 文件。
    - 覆盖范围: 仅外部 URL (http/https)。
    - 适用场景: 开发过程中快速验证引用链接。
- **配置**: 修改根目录 `lychee.toml` 可调整超时、白名单等。

## 6. 组件与 UI 开发规范

### 6.1 内置组件优先
在编写文档时，优先使用 Starlight 提供的内置组件以保持视觉一致性：
- `<Steps>`: 用于分步指南。
- `<Aside>`: 用于警告、提示 (Note, Tip, Caution, Danger)。
- `<Tabs>`, `<TabItem>`: 用于多语言或多系统代码切换。
- `<FileTree>`: 用于展示文件结构。
- `<Badge>`: 用于状态标记或文件映射说明。

### 6.2 文件树标注规范 (FileTree Annotations)
在 `<FileTree>` 中展示文件映射关系（如 Flake Output 映射）时，**严禁**使用文本注释（如 `# -> ...`）。
应使用 `<Badge>` 组件以获得更好的视觉分离度和整洁感。

**推荐样式**:
- `size="small"`: 保持精致。
- `variant="default"`: 使用低调的灰色，避免抢占视觉焦点。

```mdx
<FileTree>
  - pkgs/
    - hello.nix <Badge text="packages.<system>.hello" variant="default" size="small" />
</FileTree>
```

### 6.3 自定义组件
- **位置**: `src/components/`
- **类型安全**: 必须定义 TypeScript 接口 (`interface Props`)。
- **样式**: 优先使用 Tailwind CSS（如果已配置）或 Scoped CSS (`<style>`).

```tsx
// src/components/MyComponent.astro
---
interface Props {
  title: string;
}
const { title } = Astro.props;
---
<div class="my-component">
  <h3>{title}</h3>
</div>
```

## 7. 维护原则

- **源码参考**: 在编写文档时, 请总是 feel free to 访问本地的 `~/ws/flake-fhs` 目录以了解真实的代码实现。
- **Skill 加载**: 维护此仓库时，**始终**应加载 `astro-coding` skill，以获取 Astro/Starlight 的最佳实践和框架特定指导。
- **MCP 工具**: 使用 `astro-docs` MCP 工具进行 Astro 文档搜索和查询，确保对框架特性的准确理解。
- **类型安全**: 保持 `tsconfig.json` 严格模式；自定义组件必须使用 TypeScript。
- **链接规范**: 严格遵循第 5 节的链接维护原则，确保多语言环境下的正确性。
- **文档保鲜**: 当架构或技术栈变更时，及时更新本 `AGENTS.md`。

**使用工具的方法**：
```bash
# 在开始维护任务前，加载 astro-coding skill
/skill astro-coding

# 需要查询 Astro 官方文档时，使用 astro-docs MCP
```
