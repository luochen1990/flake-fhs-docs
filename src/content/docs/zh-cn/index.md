---
title: Flake FHS
description: Flake FHS 框架的官方文档站点 - 通过标准化目录结构自动生成 flake outputs
template: splash
hero:
  tagline: 通过标准化的目录结构自动生成 Nix Flake outputs，简化 Nix 项目配置
  actions:
    - text: 快速开始
      link: /zh-cn/manual-best-practices/
      icon: right-arrow
      variant: primary
    - text: 查看 GitHub
      link: https://github.com/luochen1990/flake-fhs
      icon: external
---

## 什么是 Flake FHS？

**Flake FHS** (Flake Filesystem Hierarchy Standard) 是一个 Nix Flake 框架，通过标准化的目录结构自动生成 flake outputs，旨在解决 Nix 项目配置中的常见痛点。

### 为什么选择 Flake FHS？

在维护多个 Nix Flake 项目时，我们经常面临以下问题：

1.  **样板代码重复**：每个项目都需要编写大量雷同的 `flake.nix` 代码来处理 inputs、systems 遍历和模块导入。
2.  **结构差异巨大**：缺乏统一的目录规范，导致接手不同项目时需要花费额外精力理解其文件组织方式。
3.  **工具链集成难**：由于缺乏标准化的目录语义，难以开发通用的自动化工具来辅助开发。

Flake FHS 通过引入一套**固定且可预测**的目录规范来解决这些问题。你只需将文件放入约定的目录，框架会自动处理剩余的工作。

---

## 核心特性

### 📁 约定优于配置

Flake FHS 将文件系统的目录结构直接映射为 Flake Outputs：

| 目录 | 对应 Output | 用途 |
| :--- | :--- | :--- |
| [`hosts/`](/zh-cn/manual-hosts/) | `nixosConfigurations` | 系统配置 |
| [`modules/`](/zh-cn/manual-modules/) | `nixosModules` | NixOS 模块 |
| [`pkgs/`](/zh-cn/manual-pkgs/) | `packages` | 软件包 |
| [`apps/`](/zh-cn/manual-apps/) | `apps` | 应用程序 |
| [`checks/`](/zh-cn/manual-checks/) | `checks` | 测试与检查 |
| [`shells/`](/zh-cn/manual-shells/) | `devShells` | 开发环境 |
| [`lib/`](/zh-cn/manual-lib/) | `lib` | 函数库 |
| [`templates/`](/zh-cn/manual-templates/) | `templates` | 项目模板 |

### 🔄 统一构建范式

无论是软件包 (`pkgs`)、应用程序 (`apps`) 还是测试用例 (`checks`)，均采用统一的 `package.nix` + `callPackage` 机制构建，共享相同的依赖注入机制。

### 🧩 智能模块加载

自动递归发现 `modules/` 下的 NixOS 模块。对于包含 `options.nix` 的目录，系统会自动生成 `enable` 选项，实现了模块的"声明即注册，启用即加载"。

### 🚀 渐进式采用

支持混合模式。你可以仅让 Flake FHS 接管一部分输出（如只管理 `packages`），而将其他部分留给传统方式定义，从而实现平滑迁移现有项目。

---

## 快速开始

### 1. 初始化项目

使用 Flake FHS 提供的模板：

```bash
# 标准模板 (完整目录树，标准命名)
nix flake init --template github:luochen1990/flake-fhs#std

# 简短模板 (完整目录树，简短命名如 pkgs, modules)
nix flake init --template github:luochen1990/flake-fhs#short

# 最小模板 (仅 flake.nix，适合从零开始)
nix flake init --template github:luochen1990/flake-fhs#zero
```

### 2. 配置 flake.nix

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-fhs.url = "github:luochen1990/flake-fhs";
  };

  outputs = inputs@{ flake-fhs, ... }:
    flake-fhs.lib.mkFlake { inherit inputs; } {
      # 可选配置
      systems = [ "x86_64-linux" ];
      nixpkgs.config = {
        allowUnfree = true;
      };
    };
}
```

### 3. 开始使用

创建一个软件包 `pkgs/hello/package.nix`：

```nix
{ stdenv, fetchurl }:
stdenv.mkDerivation {
  name = "hello-2.10";
  src = fetchurl { /* ... */ };
}
```

构建：`nix build .#hello`

就这么简单！无需修改 `flake.nix`，Flake FHS 会自动发现并构建这个包。

---

## 下一步

*   📖 [阅读最佳实践指南](/zh-cn/manual-best-practices/) - 了解如何高效使用 Flake FHS
*   🗂️ [查看核心指南](/zh-cn/manual-hosts/) - 深入学习各个功能模块
*   ⚙️ [配置参考](/zh-cn/manual-config/) - 查看 mkFlake 选项详解
