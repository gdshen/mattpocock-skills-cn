# 深模块（Deep Modules）

来自《A Philosophy of Software Design》：

**Deep module** = small interface + lots of implementation

```
┌─────────────────────┐
│   Small Interface   │  ← 方法少，参数简单
├─────────────────────┤
│                     │
│                     │
│  Deep Implementation│  ← 复杂 logic 被隐藏
│                     │
│                     │
└─────────────────────┘
```

**Shallow module** = large interface + little implementation（避免）

```
┌─────────────────────────────────┐
│       Large Interface           │  ← 方法多，参数复杂
├─────────────────────────────────┤
│  Thin Implementation            │  ← 只是传递
└─────────────────────────────────┘
```

设计 interfaces 时，问：

- 能减少 methods 数量吗？
- 能简化参数吗？
- 能把更多复杂度藏在内部吗？
