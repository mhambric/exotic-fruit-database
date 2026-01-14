DELIMITER $$

CREATE PROCEDURE create_order (
    IN p_user_id INT,
    IN p_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_order_id INT;
    DECLARE v_unit_price DECIMAL(10,2);

    -- Validate quantity
    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    START TRANSACTION;

    -- Get product price (also validates product existence)
    SELECT price
    INTO v_unit_price
    FROM Products
    WHERE product_id = p_product_id
    FOR UPDATE;

    IF v_unit_price IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Product not found';
    END IF;

    -- Insert order
    INSERT INTO Orders (user_id, order_date)
    VALUES (p_user_id, NOW());

    SET v_order_id = LAST_INSERT_ID();

    -- Insert order item
    INSERT INTO Order_Products (
        order_id,
        product_id,
        quantity,
        unit_price
    )
    VALUES (
        v_order_id,
        p_product_id,
        p_quantity,
        v_unit_price
    );

    COMMIT;
END $$

DELIMITER ;


-- delete an order procedure
--------------------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE delete_order (
    IN p_order_id INT
)
BEGIN
    START TRANSACTION;

    -- 1. Delete order items
    DELETE FROM Order_Products
    WHERE order_id = p_order_id;

    -- 2. Delete order
    DELETE FROM Orders
    WHERE order_id = p_order_id;

    COMMIT;
END $$

DELIMITER ;

-- Update order item procedure
-- In Order_products intersection table, it remove the old row then insert a new row.
--------------------------------------------------------------------------------

DELIMITER $$

CREATE PROCEDURE update_order_item (
    IN p_order_id INT,
    IN p_old_product_id INT,
    IN p_new_product_id INT,
    IN p_quantity INT
)
BEGIN
    DECLARE v_old_price DECIMAL(10,2);
    DECLARE v_new_price DECIMAL(10,2);
    DECLARE v_exists INT;

    -- Validate quantity
    IF p_quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than zero';
    END IF;

    START TRANSACTION;

    -- Ensure existing order item exists
    SELECT COUNT(*)
    INTO v_exists
    FROM Order_Products
    WHERE order_id = p_order_id
      AND product_id = p_old_product_id;

    IF v_exists = 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Order item not found';
    END IF;

    -- Get price for new product
    SELECT price
    INTO v_new_price
    FROM Products
    WHERE product_id = p_new_product_id;

    IF v_new_price IS NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'New product not found';
    END IF;

    -- Delete old row
    DELETE FROM Order_Products
    WHERE order_id = p_order_id
      AND product_id = p_old_product_id;

    -- Insert updated row
    INSERT INTO Order_Products (
        order_id,
        product_id,
        quantity,
        unit_price
    )
    VALUES (
        p_order_id,
        p_new_product_id,
        p_quantity,
        v_new_price
    );

    COMMIT;
END $$

DELIMITER ;



-- reset database procedure
--------------------------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE CreateCompleteDatabase()
BEGIN
    -- Declare variables for error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Start transaction
    START TRANSACTION;

    -- Drop tables in correct order to handle foreign key constraints
    DROP TABLE IF EXISTS `Order_Products`;
    DROP TABLE IF EXISTS `Orders`;
    DROP TABLE IF EXISTS `Products`;
    DROP TABLE IF EXISTS `Users`;
    DROP TABLE IF EXISTS `Categories`;

    -- Create Categories table
    CREATE TABLE `Categories` (
      `category_id` int(11) NOT NULL,
      `category_name` varchar(100) NOT NULL,
      `description` text NOT NULL,
      `created_at` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- Create Users table
    CREATE TABLE `Users` (
      `user_id` int(11) NOT NULL,
      `name` varchar(100) NOT NULL,
      `email` varchar(255) NOT NULL,
      `address` varchar(255) NOT NULL,
      `phone` varchar(15) DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- Create Products table
    CREATE TABLE `Products` (
      `product_id` int(11) NOT NULL,
      `name` varchar(100) NOT NULL,
      `description` text NOT NULL,
      `price` decimal(10,2) NOT NULL,
      `category_id` int(11) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- Create Orders table
    CREATE TABLE `Orders` (
      `order_id` int(11) NOT NULL,
      `user_id` int(11) NOT NULL,
      `order_date` datetime NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- Create Order_Products table
    CREATE TABLE `Order_Products` (
      `order_id` int(11) NOT NULL,
      `product_id` int(11) NOT NULL,
      `quantity` int(11) NOT NULL,
      `unit_price` decimal(10,2) NOT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

    -- Insert Categories data
    INSERT INTO `Categories` (`category_id`, `category_name`, `description`, `created_at`) VALUES
    (1, 'Citrus Fruits', 'Fresh organic oranges, lemons, and grapefruits.', '2024-01-10 09:00:00'),
    (2, 'Berries', 'Seasonal organic strawberries, blueberries, and raspberries.', '2024-02-20 11:00:00'),
    (3, 'Tropical Fruits', 'Sweet organic mangoes, pineapples, and papayas.', '2024-03-15 10:30:00'),
    (4, 'Stone Fruits', 'Juicy organic peaches, apricots, and cherries.', '2024-04-05 13:45:00'),
    (5, 'Apples & Pears', 'Crisp organic apples and pears.', '2024-05-01 08:15:00');

    -- Insert Users data
    INSERT INTO `Users` (`user_id`, `name`, `email`, `address`, `phone`) VALUES
    (1, 'Emma Green', 'emma.green@organicfruitco.com', '123 Orchard Lane, Fresno, CA', '5595551234'),
    (2, 'Liam Rivera', 'liam.rivera@organicfruitco.com', '56 Harvest Rd, Portland, OR', '5035556789'),
    (3, 'Sophia Nguyen', 'sophia.nguyen@organicfruitco.com', '77 Grove St, Seattle, WA', '2065553344'),
    (4, 'Noah Patel', 'noah.patel@organicfruitco.com', '89 Citrus Blvd, Austin, TX', '5125559087'),
    (5, 'Olivia Kim', 'olivia.kim@organicfruitco.com', '45 Apple Ave, Miami, FL', '3055554455');

    -- Insert Products data
    INSERT INTO `Products` (`product_id`, `name`, `description`, `price`, `category_id`) VALUES
    (1, 'Organic Navel Oranges', 'Sweet seedless oranges from California groves.', 1.25, 1),
    (2, 'Organic Strawberries', 'Handpicked ripe strawberries, 1 lb pack.', 4.50, 2),
    (3, 'Organic Mangoes', 'Tropical mangoes with rich, sweet flavor.', 2.75, 3),
    (4, 'Organic Peaches', 'Locally grown juicy peaches, 1 lb pack.', 3.20, 4),
    (5, 'Organic Honeycrisp Apples', 'Crisp and refreshing Honeycrisp apples.', 1.80, 5);

    -- Insert Orders data
    INSERT INTO `Orders` (`order_id`, `user_id`, `order_date`) VALUES
    (1, 1, '2025-10-01 09:00:00'),
    (2, 2, '2025-10-03 11:30:00'),
    (3, 3, '2025-10-05 10:15:00'),
    (4, 4, '2025-10-07 13:00:00'),
    (5, 5, '2025-10-10 16:20:00');

    -- Insert Order_Products data
    INSERT INTO `Order_Products` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
    (1, 1, 10, 12.50),
    (1, 2, 2, 9.00),
    (2, 3, 5, 13.75),
    (3, 4, 3, 9.60),
    (4, 5, 8, 14.40);

    -- Add primary keys and indexes
    ALTER TABLE `Categories` ADD PRIMARY KEY (`category_id`);
    ALTER TABLE `Orders` ADD PRIMARY KEY (`order_id`), ADD KEY `user_id` (`user_id`);
    ALTER TABLE `Order_Products` ADD PRIMARY KEY (`order_id`,`product_id`), ADD KEY `product_id` (`product_id`);
    ALTER TABLE `Products` ADD PRIMARY KEY (`product_id`), ADD KEY `category_id` (`category_id`);
    ALTER TABLE `Users` ADD PRIMARY KEY (`user_id`), ADD UNIQUE KEY `email` (`email`);

    -- Set auto increment values
    ALTER TABLE `Categories` MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
    ALTER TABLE `Orders` MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
    ALTER TABLE `Products` MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
    ALTER TABLE `Users` MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

    -- Add foreign key constraints
    ALTER TABLE `Orders`
      ADD CONSTRAINT `Orders_ibfk_1`
      FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
      ON DELETE CASCADE ON UPDATE CASCADE;

    ALTER TABLE `Order_Products`
      ADD CONSTRAINT `Order_Products_ibfk_1`
      FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`)
      ON DELETE CASCADE ON UPDATE CASCADE,
      ADD CONSTRAINT `Order_Products_ibfk_2`
      FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`)
      ON DELETE CASCADE ON UPDATE CASCADE;

    ALTER TABLE `Products`
      ADD CONSTRAINT `Products_ibfk_1`
      FOREIGN KEY (`category_id`) REFERENCES `Categories` (`category_id`)
      ON DELETE CASCADE ON UPDATE CASCADE;

    -- Commit transaction
    COMMIT;

    SELECT 'Database schema created successfully with all tables, data, and constraints.' AS result;
END //

DELIMITER ;
