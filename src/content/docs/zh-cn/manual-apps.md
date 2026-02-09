---
title: 应用程序 (Apps)
description: 学习如何定义可通过 nix run 直接运行的应用程序。
---

import { FileTree, Aside, Badge } from '@astrojs/starlight/components';

Flake FHS 将 `apps/` 目录下的定义映射为 `apps.<system>.<name>`，让你可以通过 `nix run` 快速运行它们。

## 快速开始

在 `apps/` 目录下创建一个 `.nix` 文件，返回一个可执行的 Derivation 即可。

**示例：定义一个简单的静态文件服务器**

`apps/serve.nix`:

```nix
{ writeShellScriptBin, python3 }:

# 返回一个包含可执行文件的 Derivation
writeShellScriptBin "serve" ''
  ${python3}/bin/python -m http.server 8080
''
```

**运行命令**：

```bash
nix run .#serve
```

## 自动推断机制

你可能注意到上面的例子中返回的是一个 Package，而不是 Flake 标准要求的 App 结构 (`{ type = "app"; program = "..."; }`)。

这是因为 Flake FHS 提供了**自动适配**功能：

1.  **自动包装**: 框架会自动将你的 Package 包装成 App 结构。
2.  **入口推断**: 框架会自动推断 `program` (可执行文件路径)。推断优先级如下：
    1.  `meta.mainProgram` (显式指定)
    2.  `pname` (包名)
    3.  `name` (去除版本号后缀)

<Aside type="tip">
只要你的包名（如 "serve"）与生成的二进制文件名一致，通常不需要额外配置。
</Aside>

## 目录结构

`apps/` 目录完全复用 **Scoped Package Tree** 模型，这意味着你可以使用目录模式来组织复杂的应用，或者使用 `scope.nix` 来管理依赖。

<FileTree>
- apps/
  - serve.nix            <Badge text="简单应用" variant="default" size="small" />
  - sync-docs/           <Badge text="复杂应用" variant="default" size="small" />
    - package.nix        <Badge text="定义文件" variant="default" size="small" />
    - scope.nix          <Badge text="依赖注入" variant="default" size="small" />
</FileTree>

关于目录模式和 Scope 的详细用法，请参考：
*   [软件包 (Packages)](/zh-cn/manual-pkgs)
*   [为 callPackage 指定 Scope 和额外参数](/zh-cn/manual-pkgs-scope)
