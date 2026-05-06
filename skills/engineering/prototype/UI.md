# UI 原型（UI Prototype）

在单一路由上生成**多个差异很大的 UI 变体**，通过 floating bottom bar 切换。用户在浏览器里切换变体，选择一个（或从每个里面拿一点），然后丢掉其余部分。

如果问题关于 logic/state，而不是某个东西长什么样，那就是错误分支。使用 [LOGIC.md](LOGIC.md)。

## 何时这是正确形状

- “这个页面应该长什么样？”
- “我想在定下来之前看看这个 dashboard 的几个选项。”
- “给 settings screen 试一个不同布局。”
- 任何用户原本会花一天在脑子里比较三个模糊 mockups 的时候。

## 两种子形状 — 强烈优先子形状 A

当 UI prototype **贴着应用其余部分**时更容易判断：真实 header、真实 sidebar、真实 data、真实 density。一个孤立的一次性路由是真空环境：每个变体单独看都不错。只要存在一个合理的已有页面可以承载变体，就默认用子形状 A。只有 prototype 真的没有附近归宿时才用子形状 B。

### 子形状 A — 调整已有页面（优先）

路由已经存在。变体在**同一路由**上渲染，由 `?variant=` URL search param 控制。既有 data fetching、params 和 auth 都保留；只有渲染子树替换。这是默认选择；除非有明确理由，否则选它。

如果 prototype 对象还没有页面，但*自然会存在于某个页面中*（dashboard 的新 section、settings screen 上的新 card、既有 flow 的新 step），那仍然是子形状 A。把变体挂载到宿主页面内。

### 子形状 B — 新页面（最后手段）

只有当被 prototype 的东西真的没有已有页面可容纳时才用这个，例如全新的顶层 surface，或无法合理嵌入任何地方的 flow。

按项目已有 routing convention 创建一个**一次性路由**；不要发明新的顶层结构。命名要明显表明它是 prototype（例如在 path 或 filename 中包含 `prototype`）。同样使用 `?variant=` 模式。

采用子形状 B 前先 sanity-check：真的没有任何已有页面可以嵌入吗？空路由会隐藏一个有内容页面能暴露的设计问题。

两种子形状里的 floating bottom bar 完全相同。

## 流程

### 1. 说明问题并选择 N

默认 **3 个变体**。超过 5 个后就不再是根本不同，而会变成噪音；最多 5 个。

在 prototype 位置或文件顶部注释里，用一行写下计划：

> “在既有 `/settings` 路由上做 settings page 的三个变体，通过 `?variant=` 切换。”

无论用户是否在线提出反馈，这都有效。

### 2. 生成差异很大的变体

起草每个变体。每个都必须受以下内容约束：

- 页面的目的，以及它能访问的数据。
- 项目的 component library / styling system（TailwindCSS、shadcn、MUI、plain CSS 等）。
- 清晰的 exported component name，例如 `VariantA`、`VariantB`、`VariantC`。

变体必须**结构不同**：不同 layout、不同 information hierarchy、不同 primary affordance，而不只是颜色不同。三个轻微调整的 card grids 不是 UI prototype，只是壁纸。如果两个草稿太像，就用明确的“不要使用 card grid”约束重做其中一个。

### 3. 把它们接起来

在路由上创建一个单一 switcher component：

```tsx
// 伪代码：按项目 framework 调整
const variant = searchParams.get('variant') ?? 'A';
return (
  <>
    {variant === 'A' && <VariantA {...data} />}
    {variant === 'B' && <VariantB {...data} />}
    {variant === 'C' && <VariantC {...data} />}
    <PrototypeSwitcher variants={['A','B','C']} current={variant} />
  </>
);
```

对子形状 A（已有页面）：把所有既有 data fetching 保持在 switcher 之上；每个变体只改变渲染子树。

对子形状 B（新页面）：`/prototype/<name>` 下的一次性路由挂载同一个 switcher。

### 4. 构建 floating switcher

屏幕底部居中的一个小 fixed-position bar，包含三部分：

- **左箭头**：切到上一个 variant（循环）。
- **Variant label**：显示当前 variant key；如果 variant 导出名称，也显示名称。例如 `B — Sidebar layout`。
- **右箭头**：向前切换（循环）。

行为：

- 点击箭头会更新 URL search param（使用 framework router：Next 用 `router.replace`，React Router 用 `navigate` 等），这样 variant 可分享且 reload-stable。
- Keyboard：`←` 和 `→` arrow keys 也能切换。当焦点在 `<input>`、`<textarea>` 或 `[contenteditable]` 上时，不要拦截 arrow keys。
- 视觉上要和页面区分开（例如 high-contrast pill、subtle shadow），让它明显不是被评估设计的一部分。
- 在 production builds 中隐藏：用 `process.env.NODE_ENV !== 'production'` 或等价检查 gate 住，避免意外 merge prototype 后把 bar 发给用户。

把 switcher 放在单个 shared component 中，这样两种子形状都能复用。位置放在项目 shared UI 所在的地方。

### 5. 交给用户

给出 URL（以及 `?variant=` keys）。用户会在方便时自己切换。有价值的反馈通常是**“我想要 B 的 header 加 C 的 sidebar”**；这才是他们真正想要的设计。

### 6. 捕获答案并清理

一旦某个 variant 胜出，写下是哪一个以及为什么（commit message、ADR、issue；如果 AFK 运行且用户还没回应，就写在 prototype 旁边的 `NOTES.md`）。然后：

- **子形状 A**：删除失败 variants 和 switcher；把胜出者折进已有页面。
- **子形状 B**：把胜出 variant 提升为真实路由，删除一次性路由和 switcher。

不要留下 variant components 或 switcher。它们很快会腐烂，并迷惑下一个读者。

## 反模式

- **只在颜色或文案上不同的 variants。** 那是 tweak，不是 prototype。真正的 variants 应该在结构上有分歧。
- **Variants 之间共享太多代码。** 共享 `<Header>` 可以；共享 `<Layout>` 会破坏目的。每个 variant 都应该能自由丢掉 layout。
- **把 variants 接到真实 mutations。** Read-only prototype 没问题。如果某个 variant 需要 mutate，就指向 stub；问题是“它应该长什么样”，不是“backend 是否工作”。
- **直接把 prototype 提升到 production。** Variant code 是在 prototype 约束下写的（无测试、最小错误处理）。折进去时要正式重写。
