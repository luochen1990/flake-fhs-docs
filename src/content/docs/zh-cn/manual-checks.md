---
title: 测试与检查 (Checks)
description: 学习如何编写测试与检查用例，用于 nix flake check，包括规范的编写方式和代码示例
---

用于 `nix flake check`。映射为 `checks.<system>.<name>`。

## 核心机制

`checks/` 目录完全复用 **Scoped Package Tree** 的结构与逻辑：
*   支持 `package.nix` 目录模式
*   支持 `<name>.nix` 文件模式
*   支持 `scope.nix` 包域 (Scope)

详情请参考 [软件包 (Packages)](/zh-cn/manual-pkgs) 与 [包域 (Scope)](/zh-cn/manual-pkgs-scope) 文档。

## 编写规范

Checks 采用标准的 `callPackage` 机制构建，因此应编写为标准的包定义函数 `{ pkgs, ... }`。

如果需要访问 `system`、`self` 或其他 inputs，请通过 `scope.nix` 显式注入它们（参见 [包域 (Scope)](/zh-cn/manual-pkgs-scope)）。

## 代码示例

假设你已在 `checks/scope.nix` 中注入了 `self`。

### 1. 格式化检查 (`checks/fmt.nix`)

检查代码格式是否符合规范（典型的 CI 检查任务）：

```nix
{ runCommand, alejandra, self }: # 需在 scope.nix 中注入 self 以访问源码
runCommand "check-fmt" {
  buildInputs = [ alejandra ];
} ''
  echo "Checking Nix formatting..."
  # 对整个 source tree 进行检查
  alejandra --check ${self}
  touch $out
''
```

### 2. 集成测试 (`checks/integration/package.nix`)

对核心功能进行冒烟测试（Smoke Test）：

```nix
{ runCommand, hello, ... }:
runCommand "smoke-test-hello" {
  buildInputs = [ hello ];
} ''
  # 验证 hello 命令能否正常执行并输出预期结果
  hello | grep "Hello, world!"
  touch $out
''
```

## 运行命令

```bash
# 运行所有检查
nix flake check

# 构建特定检查
nix build .#checks.x86_64-linux.fmt
```
