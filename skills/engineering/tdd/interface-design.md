# 为可测试性设计 Interface

好的 interfaces 会让测试自然发生：

1. **接受 dependencies，不要创建它们**

   ```typescript
   // 可测试
   function processOrder(order, paymentGateway) {}

   // 难测试
   function processOrder(order) {
     const gateway = new StripeGateway();
   }
   ```

2. **返回结果，不要制造 side effects**

   ```typescript
   // 可测试
   function calculateDiscount(cart): Discount {}

   // 难测试
   function applyDiscount(cart): void {
     cart.total -= discount;
   }
   ```

3. **小 surface area**
   - 更少 methods = 需要更少测试
   - 更少 params = 更简单的 test setup
