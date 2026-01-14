SELECT p.product_id, p.name, p.description, p.price, c.category_name
FROM Products p
INNER JOIN Categories c ON c.category_id = p.category_id
ORDER BY p.product_id;

-- add a product
INSERT INTO Products (name, description, price, category_id)
VALUES (:nameInput, :descriptionInput, :priceInput, 
        (SELECT category_id FROM Categories WHERE category_name = :categoryInput));

-- update a product
UPDATE Products 
SET 
    name = :nameInput,
    description = :descriptionInput,
    price = :priceInput,
    category_id = (SELECT category_id FROM Categories WHERE category_name = :categoryInput)
WHERE product_id = :productidInput;

-- delete product
DELETE FROM Products WHERE product_id = :productidInput;



---------------- Manage Customers ----------Page-------

-- get all current Users
SELECT user_id, name, email, address, phone FROM Users ORDER BY user_id;

-- add a new user
INSERT INTO Users (name, email, address, phone)
VALUES (:nameInput, :emailInput, :addressInput, :phoneInput);



---------------- Orders ----------Page-------
-- get all orders
SELECT op.order_id, op.unit_price, op.quantity, p.name AS product_name, o.order_date, u.name AS customer_name
            FROM Order_Products op\n
            INNER JOIN Products p ON op.product_id = p.product_id
            INNER JOIN Orders o ON op.order_id = o.order_id
            INNER JOIN Users u ON o.user_id = u.user_id
            ORDER BY o.order_date

---------------- Manage Categories ----------Page-------

-- view all categories
SELECT category_id, category_name, description, created_at
FROM Categories
ORDER BY category_id;

-- add a new category
INSERT INTO Categories (category_name, description, created_at)
VALUES (:category_name, :description, NOW());

-- update category details
UPDATE Categories
SET 
    category_name = :category_name,
    description = :description,
    created_at = :created_at
WHERE category_id = :category_id;

-- delete a category
------- Cascading delete removes related products automatically
DELETE FROM Categories WHERE category_id = :category_id;










