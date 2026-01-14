
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


--
-- Table structure for table `Categories`
--
DROP TABLE IF EXISTS `Categories`;

CREATE TABLE `Categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `created_at` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Categories`
--

INSERT INTO `Categories` (`category_id`, `category_name`, `description`, `created_at`) VALUES
(1, 'Citrus Fruits', 'Fresh organic oranges, lemons, and grapefruits.', '2024-01-10'),
(2, 'Berries', 'Seasonal organic strawberries, blueberries, and raspberries.', '2024-02-20'),
(3, 'Tropical Fruits', 'Sweet organic mangoes, pineapples, and papayas.', '2024-03-15'),
(4, 'Stone Fruits', 'Juicy organic peaches, apricots, and cherries.', '2024-04-05'),
(5, 'Apples & Pears', 'Crisp organic apples and pears.', '2024-05-01');

-- --------------------------------------------------------

--
-- Table structure for table `Orders`
--
DROP TABLE IF EXISTS `Orders`;

CREATE TABLE `Orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Orders`
--

INSERT INTO `Orders` (`order_id`, `user_id`, `order_date`) VALUES
(1, 1, '2025-10-01'),
(2, 2, '2025-10-03'),
(3, 3, '2025-10-05'),
(4, 4, '2025-10-07'),
(5, 5, '2025-10-10');

-- --------------------------------------------------------

--
-- Table structure for table `Order_Products`
--
DROP TABLE IF EXISTS `Order_Products`;

CREATE TABLE `Order_Products` (
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Order_Products`
--

INSERT INTO `Order_Products` (`order_id`, `product_id`, `quantity`, `unit_price`) VALUES
(1, 1, 10, 12.50),
(1, 2, 2, 9.00),
(2, 3, 5, 13.75),
(3, 4, 3, 9.60),
(4, 5, 8, 14.40);

-- --------------------------------------------------------

--
-- Table structure for table `Products`
--
DROP TABLE IF EXISTS `Products`;

CREATE TABLE `Products` (
  `product_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Products`
--

INSERT INTO `Products` (`product_id`, `name`, `description`, `price`, `category_id`) VALUES
(1, 'Organic Navel Oranges', 'Sweet seedless oranges from California groves.', 1.25, 1),
(2, 'Organic Strawberries', 'Handpicked ripe strawberries, 1 lb pack.', 4.50, 2),
(3, 'Organic Mangoes', 'Tropical mangoes with rich, sweet flavor.', 2.75, 3),
(4, 'Organic Peaches', 'Locally grown juicy peaches, 1 lb pack.', 3.20, 4),
(5, 'Organic Honeycrisp Apples', 'Crisp and refreshing Honeycrisp apples.', 1.80, 5),
(6, 'Organic Navel Oranges', 'Sweet seedless oranges from California groves.', 1.25, 1),
(7, 'Organic Strawberries', 'Handpicked ripe strawberries, 1 lb pack.', 4.50, 2),
(8, 'Organic Mangoes', 'Tropical mangoes with rich, sweet flavor.', 2.75, 3),
(9, 'Organic Peaches', 'Locally grown juicy peaches, 1 lb pack.', 3.20, 4),
(10, 'Organic Honeycrisp Apples', 'Crisp and refreshing Honeycrisp apples.', 1.80, 5);

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--
DROP TABLE IF EXISTS `Users`;

CREATE TABLE `Users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`user_id`, `name`, `email`, `address`, `phone`) VALUES
(1, 'Emma Green', 'emma.green@organicfruitco.com', '123 Orchard Lane, Fresno, CA', '5595551234'),
(2, 'Liam Rivera', 'liam.rivera@organicfruitco.com', '56 Harvest Rd, Portland, OR', '5035556789'),
(3, 'Sophia Nguyen', 'sophia.nguyen@organicfruitco.com', '77 Grove St, Seattle, WA', '2065553344'),
(4, 'Noah Patel', 'noah.patel@organicfruitco.com', '89 Citrus Blvd, Austin, TX', '5125559087'),
(5, 'Olivia Kim', 'olivia.kim@organicfruitco.com', '45 Apple Ave, Miami, FL', '3055554455');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Categories`
--
ALTER TABLE `Categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `Orders`
--
ALTER TABLE `Orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `Order_Products`
--
ALTER TABLE `Order_Products`
  ADD PRIMARY KEY (`order_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `Products`
--
ALTER TABLE `Products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Categories`
--
ALTER TABLE `Categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Orders`
--
ALTER TABLE `Orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Products`
--
ALTER TABLE `Products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `Users`
--
ALTER TABLE `Users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Orders`
--
ALTER TABLE `Orders`
  ADD CONSTRAINT `Orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`);

--
-- Constraints for table `Order_Products`
--
ALTER TABLE `Order_Products`
  ADD CONSTRAINT `Order_Products_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`),
  ADD CONSTRAINT `Order_Products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`);

--
-- Constraints for table `Products`
--
ALTER TABLE `Products`
  ADD CONSTRAINT `Products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `Categories` (`category_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
