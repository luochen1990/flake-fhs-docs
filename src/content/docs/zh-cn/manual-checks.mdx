---
title: 测试与检查 (Checks)
description: 学习如何编写 CI 检查任务和集成测试。
---

import { FileTree, Aside, Badge } from '@astrojs/starlight/components';

Flake FHS 将 `checks/` 目录下的定义映射为 `checks.<system>.<name>`，用于 `nix flake check`。

## 快速开始

在 `checks/` 目录下创建一个 `.nix` 文件，返回一个成功的 Derivation 即可。

**示例：定义一个简单的冒烟测试**

`checks/smoke-test-hello.nix`:

```nix
{ runCommand, hello, ... }:

# 返回一个 Derivation，运行成功即视为检查通过
runCommand "smoke-test-hello" {
  buildInputs = [ hello ];
} ''
  echo "Testing hello command..."
  
  # 验证 hello 命令能否正常执行并输出预期结果
  hello | grep "Hello, world!"
  
  # 必须创建输出文件，否则视为构建失败
  touch $out
''
```

**运行检查**：

```bash
nix flake check
```

## 常见用例：格式化检查

一个典型的 CI 任务是检查代码格式。

`checks/fmt.nix`:

```nix
{ runCommand, alejandra, self }: # 需要访问 inputs.self

runCommand "check-fmt" {
  buildInputs = [ alejandra ];
} ''
  echo "Checking Nix formatting..."
  
  # 对整个 source tree 进行检查
  alejandra --check ${self}
  
  touch $out
''
```

<Aside type="note" title="为 callPackage 指定 Scope 和额外参数">
上面的例子中使用了 `self` 参数。默认情况下 `callPackage` 不会包含 `self`，你需要通过 `checks/scope.nix` 注入它。
</Aside>

### 如何注入依赖

在 `checks/scope.nix` 中：

```nix
{ inputs, self, ... }:
{
  # 注入 self 和 inputs 到 checks
  args = { inherit inputs self; };
}
```

关于依赖注入的详细用法，请参考：
*   [为 callPackage 指定 Scope 和额外参数](/zh-cn/manual-pkgs-scope)
