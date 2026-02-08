---
title: 应用程序 (Apps)
description: 了解如何定义可通过 nix run 直接运行的目标，包括自动推断机制和程序入口点的设置
---

定义可通过 `nix run` 直接运行的目标。映射为 `apps.<system>.<name>`。

## 核心机制

`apps/` 目录完全复用 **Scoped Package Tree** 的结构与逻辑：
*   支持 `package.nix` 目录模式
*   支持 `<name>.nix` 文件模式
*   支持 `scope.nix` 依赖注入

详情请参考 [软件包与作用域文档 (manual-pkgs)](/zh-cn/manual-pkgs)。

区别在于：Flake FHS 会自动将构建出的软件包包装为 App 结构 `{ type = "app"; program = "..."; }`。

## 自动推断机制

框架会尝试自动推断程序的入口点。当然，你也可以通过设置 `meta.mainProgram` 来手动指定。推断优先级如下：
1.  `meta.mainProgram` (显式指定)
2.  `pname`
3.  `name` (去除版本号后缀)

## 代码示例

**1. 文件模式 (`apps/serve.nix`)**

快速启动一个静态文件服务器（典型的 "One-Liner" 应用）：

```nix
{ writeShellScriptBin, python3 }:
writeShellScriptBin "serve" ''
  ${python3}/bin/python -m http.server 8080
''
```

**2. 目录模式 (`apps/sync-docs/package.nix`)**

创建一个文档同步脚本（利用目录模式管理复杂依赖）：

```nix
{ writeShellScriptBin, rsync, openssh }:
writeShellScriptBin "sync-docs" ''
  export PATH="${rsync}/bin:${openssh}/bin:$PATH"
  
  SRC="./dist/"
  DEST="user@server:/var/www/docs"
  
  echo "Syncing $SRC to $DEST..."
  rsync -avz --delete "$SRC" "$DEST"
  echo "Done!"
''
```

## 运行命令

```bash
nix run .#serve
nix run .#sync-docs
```
