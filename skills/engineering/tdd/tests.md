# 好测试与坏测试

## 好测试

**Integration-style**：通过真实 interfaces 测试，而不是 mock 内部 parts。

```typescript
// 好：测试可观察 behavior
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

特征：

- 测试 users/callers 关心的 behavior
- 只使用 public API
- 能扛住 internal refactors
- 描述 WHAT，而不是 HOW
- 每个测试只有一个逻辑断言

## 坏测试

**Implementation-detail tests**：和 internal structure 耦合。

```typescript
// 坏：测试 implementation details
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

危险信号：

- Mock internal collaborators
- 测试 private methods
- 断言 call counts/order
- behavior 未变时 refactoring 导致测试失败
- test name 描述 HOW 而不是 WHAT
- 通过 interface 以外的外部手段验证

```typescript
// 坏：绕过 interface 验证
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// 好：通过 interface 验证
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```
