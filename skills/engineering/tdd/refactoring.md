# 重构候选项（Refactor Candidates）

TDD cycle 后，寻找：

- **Duplication** → 提取 function/class
- **Long methods** → 拆成 private helpers（测试保持在 public interface 上）
- **Shallow modules** → 合并或 deepen
- **Feature envy** → 把 logic 移到 data 所在位置
- **Primitive obsession** → 引入 value objects
- 新代码暴露出问题的**既有代码**
