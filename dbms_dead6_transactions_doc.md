# Conflicting and Non-Conflicting Transactions

## Conflicting Transactions

### Conflict Transactions 1

- **Transactions involved:** transaction1, transaction2
- **Description:** These transactions update the price of a product concurrently.
- **Outcome:** Potential conflict arises as both transactions attempt to update the same product's price simultaneously.

### Conflict Transactions 2

- **Transactions involved:** transaction3, transaction4
- **Description:** These transactions update the discount of an offer concurrently.
- **Outcome:** Potential conflict arises as both transactions attempt to update the same offer's discount simultaneously.

## Non-Conflicting Transactions

### Non-Conflict Transactions 1

- **Transaction:** transaction6
- **Description:** This transaction deducts an amount from a payment.
- **Outcome:** No conflict as it operates on a different payment ID.

### Non-Conflict Transactions 2

- **Transaction:** transaction8
- **Description:** This transaction adds an amount to a payment.
- **Outcome:** No conflict as it operates on a different payment ID.

### Non-Conflict Transactions 3

- **Transaction:** transaction9
- **Description:** This transaction updates the feedback text for an order.
- **Outcome:** No conflict as it operates on a different user ID.

### Non-Conflict Transactions 4

- **Transaction:** transaction11
- **Description:** This transaction updates the first name of a vendor.
- **Outcome:** No conflict as it operates on a different vendor ID.

-- Conflicting Set 1
-- Transaction 1
START TRANSACTION;
UPDATE product SET product_price = product_price - 100 WHERE productID = 2;
-- COMMIT;

-- Transaction 2
START TRANSACTION;
UPDATE product SET product_price = product_price + 200 WHERE productID = 2;
-- COMMIT;

-- Conflicting Set 2
-- Transaction 3
START TRANSACTION;
UPDATE offers SET discount = discount + 2 WHERE offerID = 2;
-- COMMIT;

-- Transaction 4
START TRANSACTION;
UPDATE offers SET discount = discount - 1 WHERE offerID = 2;
-- COMMIT;

-- Non conflicting 1
-- Transaction 6
START TRANSACTION;
UPDATE payment SET amount = amount - 100 WHERE payment_id = 1;
-- COMMIT;

-- Non conflicting 2
-- Transaction 8
START TRANSACTION;
UPDATE payment SET amount = amount + 200 WHERE payment_id = 2;
-- COMMIT;

-- Non conflicting 3
-- Transaction 9
START TRANSACTION;
UPDATE order_feedback SET feedback_text = 'Changednow' WHERE userID = 1;
-- COMMIT;

-- Non conflicting 4
-- Transaction 11
START TRANSACTION;
UPDATE vendor SET first_name = 'ChangedToGarvit' WHERE vendorID = 1;
-- COMMIT;
