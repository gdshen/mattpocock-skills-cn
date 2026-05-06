# 何时 Mock

只在 **system boundaries** mock：

- External APIs（payment、email 等）
- Databases（有时；优先 test DB）
- Time/randomness
- File system（有时）

不要 mock：

- 你自己的 classes/modules
- Internal collaborators
- 任何你控制的东西

## 为 Mockability 设计

在 system boundaries，设计易于 mock 的 interfaces：

**1. 使用 dependency injection**

传入 external dependencies，而不是在内部创建：

```typescript
// 容易 mock
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// 难 mock
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. 优先使用 SDK-style interfaces，而不是 generic fetchers**

为每个 external operation 创建 specific functions，而不是一个带 conditional logic 的 generic function：

```typescript
// 好：每个 function 都能独立 mock
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// 坏：mocking 需要在 mock 内部写 conditional logic
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

SDK 方式意味着：
- 每个 mock 返回一个 specific shape
- test setup 中没有 conditional logic
- 更容易看出某个测试覆盖哪些 endpoints
- 每个 endpoint 都有 type safety
