---
title: 开发环境 (Shells)
description: 学习如何定义可复用的开发环境，包括默认环境和指定环境的配置。
---

import { FileTree, Aside, Badge } from '@astrojs/starlight/components';

Flake FHS 将 `shells/` 目录下的定义映射为 `devShells.<system>.<name>`，提供可复用的开发环境。

## 快速开始

在 `shells/` 目录下创建一个 `.nix` 文件，返回一个 `mkShell` 环境即可。

**示例：定义一个 Rust 开发环境**

`shells/rust.nix`:

```nix
{ pkgs }:

# 返回一个 devShell
pkgs.mkShell {
  name = "rust-dev";
  
  # 添加 cargo 和 rustc 到 shell 环境
  packages = with pkgs; [ cargo rustc ];
}
```

**运行命令**：

```bash
nix develop .#rust
```

## 默认环境 (default.nix)

`shells/default.nix` 是特殊的，它会被映射为 `devShells.<system>.default`。这意味着你可以直接运行 `nix develop` 而不需要指定名称。

**示例：定义项目的主开发环境**

`shells/default.nix`:

```nix
{ pkgs }:

pkgs.mkShell {
  # 添加常用开发工具
  packages = with pkgs; [ 
    just             # 任务运行器
    nixfmt-rfc-style # Nix 格式化工具
    nixd             # Nix 语言服务器 (LSP)
  ];
}
```

**运行命令**：

```bash
nix develop
```

## 进阶：复用包依赖 (inputsFrom)

通常你的开发环境需要包含应用构建所需的依赖。为了避免重复定义，你可以使用 `inputsFrom` 直接从 `pkgs/` 中提取依赖。

`shells/default.nix`:

```nix
{ pkgs }:

pkgs.mkShell {
  # 从现有包中提取构建输入 (buildInputs)
  # 这样你就能获得 my-app 编译所需的库和工具
  inputsFrom = [ (pkgs.callPackage ../pkgs/my-app/package.nix {}) ];
  
  packages = with pkgs; [ just ];
}
```

关于目录模式和依赖注入的详细用法，请参考：
*   [软件包 (Packages)](/zh-cn/manual-pkgs)
*   [Scope 与依赖注入](/zh-cn/manual-pkgs-scope)
