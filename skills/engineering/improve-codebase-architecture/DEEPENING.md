# 深化

在给定依赖的前提下，如何安全深化一组 shallow modules。假设使用 [LANGUAGE.md](LANGUAGE.md) 中的词汇：**module**、**interface**、**seam**、**adapter**。

## 依赖类别

评估 deepening 候选项时，先给它的依赖分类。类别决定 deepened module 如何跨 seam 测试。

### 1. 进程内

纯计算、内存状态、无 I/O。总是可以深化：合并 modules，直接通过新 interface 测试。不需要 adapter。

### 2. 本地可替代

有本地测试替身的依赖（例如给 Postgres 用 PGLite、内存文件系统）。如果替身存在，就可以深化。deepened module 在测试套件中用这个替身运行测试。seam 是内部的；module 的外部 interface 不需要 port。

### 3. 远程但自有（Ports & Adapters）

跨网络的自有服务（微服务、内部 APIs）。在 seam 处定义 **port**（interface）。deep module 拥有逻辑；transport 作为 **adapter** 注入。测试使用 in-memory adapter。生产使用 HTTP/gRPC/queue adapter。

建议句式：*"在 seam 处定义一个 port，为生产实现 HTTP adapter，为测试实现 in-memory adapter。这样即使部署跨网络，逻辑仍然位于一个 deep module 中。"*

### 4. 真外部（Mock）

你不控制的第三方服务（Stripe、Twilio 等）。deepened module 把外部依赖作为注入的 port；测试提供 mock adapter。

## Seam 纪律

- **一个 adapter 表示假设中的 seam。两个 adapter 表示真实 seam。** 除非至少两个 adapters 有正当理由（通常是生产 + 测试），否则不要引入 port。单 adapter seam 只是间接层。
- **Internal seams vs external seams。** Deep module 可以有 internal seams（implementation 私有，供自身测试使用），也可以在 interface 处有 external seam。不要因为测试使用 internal seams，就把它们暴露到 interface 上。

## 测试策略：替换，不叠加

- 一旦 deepened module 的 interface 上有测试，旧 shallow modules 的 unit tests 就变成浪费；删掉它们。
- 在 deepened module 的 interface 上写新测试。**Interface 就是测试面**。
- 测试通过 interface 断言可观察结果，不断言内部状态。
- 测试应该能扛住内部重构；它们描述行为，不描述 implementation。如果 implementation 一变测试就必须变，说明测试越过了 interface。
