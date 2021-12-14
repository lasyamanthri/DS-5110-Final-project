-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 14, 2021 at 01:54 AM
-- Server version: 10.4.20-MariaDB
-- PHP Version: 7.3.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restaurant`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `birthday` (IN `date` DATE)  BEGIN
select c.Name, c.DOB from customer c where c.DOB=date;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Check1` (IN `date` DATE)  BEGIN
select b.date, sum(b.Total) from bill b where b.date=date GROUP by b.date;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Chef` (IN `id` INT(10), IN `date` DATE)  BEGIN
select  o.Menuid, o.Status from chef c, order1 o where c.id=o.Chefid and o.Chefid=id and o.Date=date ;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_chef` (IN `id` INT(10), IN `username` VARCHAR(15), IN `password` VARCHAR(15))  BEGIN
INSERT into login_chef VALUES(id, username, password);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_man` (IN `id` INT(10), IN `username` VARCHAR(15), IN `password` VARCHAR(15))  BEGIN
INSERT into login_manager VALUES(id, username, password);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_update` (IN `id` INT(10), IN `username` VARCHAR(15), IN `password` VARCHAR(15))  BEGIN
INSERT into login_cust values(id, username, password);
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `manager` (IN `date` DATE, IN `time` INT(10))  BEGIN
select c.name from customer c, reservation_table r where c.id=r.Customerid and r.ReservationDate=date and r.time=time;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reservation` (IN `id` INT(10))  BEGIN
select c.name, r.ReservationDate from customer c, reservation_table r where c.id=r.Customerid and r.Customerid=id;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `chef` () RETURNS INT(11) BEGIN
  DECLARE c int;
  select count(id) into c from chef;
  RETURN c;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `customer` (`c` INT) RETURNS INT(11) BEGIN
  DECLARE c int;
  select count(id) into c from customer;
  RETURN c;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `employees` (`c` INT) RETURNS INT(11) BEGIN
  DECLARE c int;
  select count(id) into c from employes;
  RETURN c;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `manager` (`c` INT) RETURNS INT(11) BEGIN
  DECLARE c int;
  select count(id) into c from manager;
  RETURN c;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `id` int(10) NOT NULL,
  `Total` int(50) DEFAULT NULL,
  `Customerid` int(10) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`id`, `Total`, `Customerid`, `date`) VALUES
(21, 10, 1, '2021-11-18'),
(22, 5, 1, '2021-11-18'),
(23, 10, 1, '2021-11-18'),
(24, 10, 2, '2021-11-18'),
(25, 5, 2, '2021-11-18'),
(26, 10, 2, '2021-11-18'),
(28, 5, 1, '2021-11-19'),
(29, 22, 1, '2021-11-19'),
(123, 60, 4, '2021-11-19'),
(124, 24, 1, '2021-12-03'),
(126, 27, 1, '2021-12-03'),
(127, 30, 1, '2021-12-03'),
(128, 5, 1, '2021-12-03'),
(129, 12, 1, '2021-12-03'),
(132, 17, 1, '2021-12-03'),
(133, 50, 1, '2021-12-06'),
(134, 5, 2, '2021-12-06'),
(135, 20, 1, '2021-12-06'),
(136, 15, 1, '2021-12-07'),
(137, 55, 1, '2021-12-07'),
(138, 65, 12, '2021-12-07'),
(139, 25, 1242, '2021-12-07'),
(140, 40, 1243, '2021-12-07'),
(141, 15, 1243, '2021-12-07'),
(142, 45, 1244, '2021-12-07'),
(1423, 60, 2, '2021-12-18');

-- --------------------------------------------------------

--
-- Table structure for table `chef`
--

CREATE TABLE `chef` (
  `id` int(10) NOT NULL,
  `Name` varchar(20) DEFAULT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(15) NOT NULL,
  `email` varchar(20) DEFAULT NULL,
  `address` varchar(30) DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `chef`
--

INSERT INTO `chef` (`id`, `Name`, `username`, `password`, `email`, `address`, `Phone`) VALUES
(123, 'Lasya Manthripragada', 'headchef', '12345', 'las@gmail.com', 'C 103 siddamshetty towers, Nea', '2147483647'),
(130, 'M YOGITHA', 'yogita', '123456', 'lasyamanthri@gmail.c', 'Jawahar Nagar, Rtc X Roads', '2147483647'),
(131, 'gordan ramsay', 'ramsay', '1234', 'lassu@gmail.com', 'earth, 20210', '123453782');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id` int(10) NOT NULL,
  `Name` varchar(30) DEFAULT NULL,
  `email` varchar(15) DEFAULT NULL,
  `Address` varchar(30) DEFAULT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(15) NOT NULL,
  `DOB` date DEFAULT NULL,
  `phone no` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id`, `Name`, `email`, `Address`, `username`, `password`, `DOB`, `phone no`) VALUES
(1, 'lasya', 'aa@gmail.com', '24 lawn st', 'lasyamanthri', '123456', '2000-03-11', '1234568888'),
(2, 'lasyamanthri', 'a@gmail.com', '24 lawn st', 'lasya', '123', '2000-03-11', '1234567899'),
(4, 'venkat', 'la@gmail.com', '24 lawn st', 'lassi', '1234', '1998-06-13', '1234567897'),
(12, 'Paul', 'las@gmail.com', '24 lawn st', 'venkat', '123', '1988-11-09', '1234567890'),
(1242, 'andrew garfield', 'andrew@gmail.co', '9003 tremont ridge CT', 'andrew', '12345', '2005-07-20', '4565645678'),
(1243, 'M YOGITHA', 'lasyamanthri@gm', 'Jawahar Nagar, Rtc X Roads', 'rachel', '12345', '2004-10-13', '1231231234'),
(1244, 'monica', 'monica@gmail.co', '1123, tremont st', 'Monica', '123', '2000-06-07', '1234123412');

-- --------------------------------------------------------

--
-- Table structure for table `employes`
--

CREATE TABLE `employes` (
  `id` int(11) NOT NULL,
  `Name` varchar(20) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employes`
--

INSERT INTO `employes` (`id`, `Name`, `address`, `Phone`) VALUES
(3, 'Ram', 'lawn st', '8578672869'),
(12, 'RAHUL', 'Jawahar Nagar, Rtc X Roads, C-103 Siddamshetty Towers', '07680887111');

-- --------------------------------------------------------

--
-- Table structure for table `food`
--

CREATE TABLE `food` (
  `id` int(11) NOT NULL,
  `Menuid` int(10) NOT NULL,
  `Customerid` int(10) NOT NULL,
  `date` date DEFAULT NULL,
  `chef_id` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(10) NOT NULL,
  `Name` varchar(20) DEFAULT NULL,
  `Quanity` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `Name`, `Quanity`) VALUES
(2, 'tomato', '70'),
(3, 'lettuce', '400'),
(4, 'carrot', '100'),
(5, 'onions', '10');

-- --------------------------------------------------------

--
-- Stand-in structure for view `login_chef`
-- (See below for the actual view)
--
CREATE TABLE `login_chef` (
`username` varchar(15)
,`password` varchar(15)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `login_cust`
-- (See below for the actual view)
--
CREATE TABLE `login_cust` (
`id` int(10)
,`username` varchar(15)
,`password` varchar(15)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `login_manager`
-- (See below for the actual view)
--
CREATE TABLE `login_manager` (
`username` varchar(15)
,`password` varchar(15)
);

-- --------------------------------------------------------

--
-- Table structure for table `manager`
--

CREATE TABLE `manager` (
  `id` int(10) NOT NULL,
  `Name` varchar(15) DEFAULT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(15) NOT NULL,
  `email` varchar(15) DEFAULT NULL,
  `address` varchar(30) DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `manager`
--

INSERT INTO `manager` (`id`, `Name`, `username`, `password`, `email`, `address`, `Phone`) VALUES
(1, 'lasya', 'admin', '123456', 'las@gmail.com', '123 tremont st, boston', NULL);

-- --------------------------------------------------------

--
-- Stand-in structure for view `max1`
-- (See below for the actual view)
--
CREATE TABLE `max1` (
`Customerid` int(10)
,`count1` bigint(21)
);

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` int(10) NOT NULL,
  `Name` varchar(15) NOT NULL,
  `Descrpition` varchar(100) DEFAULT NULL,
  `Price` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `Name`, `Descrpition`, `Price`) VALUES
(1, 'Potato fry', 'Indian fritters', 15),
(3, 'pav bhaaji', 'potato', 5),
(14, 'Pasta', 'Italian', 40),
(17, 'mac n cheese', 'Cheddar cheese', 600);

-- --------------------------------------------------------

--
-- Table structure for table `order`
--

CREATE TABLE `order` (
  `id` int(10) NOT NULL,
  `Customerid` int(10) NOT NULL,
  `Chefid` int(10) NOT NULL,
  `Menuid` int(10) NOT NULL,
  `Date` date DEFAULT NULL,
  `Priority` int(10) NOT NULL,
  `Status` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order`
--

INSERT INTO `order` (`id`, `Customerid`, `Chefid`, `Menuid`, `Date`, `Priority`, `Status`) VALUES
(123, 1, 123, 1, '2021-11-13', 2, 'not done');

-- --------------------------------------------------------

--
-- Table structure for table `order1`
--

CREATE TABLE `order1` (
  `id` int(10) NOT NULL,
  `Customerid` int(10) NOT NULL,
  `Chefid` int(10) NOT NULL,
  `Menuid` int(10) NOT NULL,
  `Date` date DEFAULT NULL,
  `Status` enum('done','not done','','') DEFAULT 'not done'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `order1`
--

INSERT INTO `order1` (`id`, `Customerid`, `Chefid`, `Menuid`, `Date`, `Status`) VALUES
(7, 1, 123, 1, '2021-11-18', 'not done'),
(8, 2, 123, 1, '2021-11-18', 'not done'),
(9, 12, 123, 1, '2021-11-18', 'done'),
(10, 12, 123, 3, '2021-11-18', 'not done'),
(12, 12, 123, 1, '2021-11-18', 'not done'),
(13, 1, 123, 1, '2021-11-18', 'done'),
(14, 1, 123, 1, '2021-11-18', NULL),
(15, 1, 123, 1, '2021-11-18', NULL),
(16, 1, 123, 3, '2021-11-18', NULL),
(18, 1, 123, 1, '2021-11-18', NULL),
(19, 1, 123, 3, '2021-11-18', NULL),
(21, 1, 123, 1, '2021-11-18', NULL),
(22, 1, 123, 3, '2021-11-18', NULL),
(24, 1, 123, 1, '2021-11-18', NULL),
(25, 1, 123, 3, '2021-11-18', NULL),
(27, 1, 123, 1, '2021-11-18', NULL),
(28, 1, 123, 3, '2021-11-18', NULL),
(29, 1, 123, 1, '2021-11-18', 'done'),
(30, 2, 123, 1, '2021-11-18', NULL),
(31, 2, 123, 3, '2021-11-18', 'not done'),
(32, 2, 123, 1, '2021-11-18', NULL),
(33, 1240, 123, 3, '2021-11-18', 'not done'),
(34, 1, 123, 3, '2021-11-19', NULL),
(35, 1, 130, 1, '2021-11-19', 'done'),
(36, 1, 123, 1, '2021-12-11', 'done'),
(37, 1, 131, 13, '2021-12-03', NULL),
(38, 1, 130, 13, '2021-12-03', NULL),
(39, 1, 123, 13, '2021-12-03', 'not done'),
(40, 1, 130, 1, '2021-12-03', NULL),
(43, 1, 131, 1, '2021-12-03', 'done'),
(44, 1, 123, 1, '2021-12-03', NULL),
(46, 1, 131, 3, '2021-12-03', 'not done'),
(47, 1, 131, 13, '2021-12-03', NULL),
(48, 1, 130, 3, '2021-12-03', NULL),
(49, 1, 131, 13, '2021-12-03', NULL),
(50, 1, 130, 1, '2021-12-06', NULL),
(51, 1, 130, 14, '2021-12-06', NULL),
(53, 2, 123, 3, '2021-12-06', NULL),
(54, 1, 131, 1, '2021-12-06', 'not done'),
(55, 1, 130, 3, '2021-12-06', NULL),
(56, 1, 130, 1, '2021-12-07', NULL),
(57, 1, 130, 1, '2021-12-07', NULL),
(58, 1, 130, 14, '2021-12-07', NULL),
(60, 12, 131, 3, '2021-12-07', 'done'),
(61, 12, 123, 14, '2021-12-07', 'not done'),
(62, 12, 123, 3, '2021-12-07', 'not done'),
(63, 12, 131, 1, '2021-12-07', 'done'),
(64, 1242, 130, 3, '2021-12-07', 'not done'),
(65, 1242, 123, 1, '2021-12-07', 'not done'),
(66, 1242, 123, 3, '2021-12-07', 'done'),
(67, 1243, 130, 14, '2021-12-07', 'not done'),
(68, 1243, 130, 1, '2021-12-07', 'not done'),
(69, 1244, 123, 3, '2021-12-07', 'not done'),
(70, 1244, 131, 14, '2021-12-07', 'not done');

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `Date` date NOT NULL,
  `No` int(10) NOT NULL,
  `time` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`Date`, `No`, `time`) VALUES
('2021-11-19', 18, 4),
('2021-12-04', 24, 6),
('2021-12-07', 13, 9),
('2021-12-17', 10, 9),
('2021-12-18', 19, 6),
('2021-12-25', 10, 9),
('2021-12-27', 9, 9),
('2021-12-28', 0, 6),
('2022-01-01', 18, 8);

--
-- Triggers `reservation`
--
DELIMITER $$
CREATE TRIGGER `dec` BEFORE INSERT ON `reservation` FOR EACH ROW BEGIN
update reservation set No=No-1 where reservation.Date=new.Date and reservation.time=new.time;
end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `reservation_table`
--

CREATE TABLE `reservation_table` (
  `Customerid` int(10) NOT NULL,
  `ReservationDate` date DEFAULT NULL,
  `time` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `reservation_table`
--

INSERT INTO `reservation_table` (`Customerid`, `ReservationDate`, `time`) VALUES
(1, '2021-11-19', 4),
(1, '2022-01-01', 8),
(1, '2021-12-07', 9),
(12, '2021-12-17', 9),
(12, '2021-12-07', 9),
(1, '2021-12-28', 6),
(1, '2021-12-28', 6),
(1242, '2021-12-07', 9),
(1243, '2021-12-07', 9),
(1244, '2021-12-07', 9),
(1, '2022-01-01', 8),
(1, '2022-01-01', 8);

-- --------------------------------------------------------

--
-- Table structure for table `reservaton_wait`
--

CREATE TABLE `reservaton_wait` (
  `Customerid` int(10) NOT NULL,
  `Date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Structure for view `login_chef`
--
DROP TABLE IF EXISTS `login_chef`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `login_chef`  AS SELECT `chef`.`username` AS `username`, `chef`.`password` AS `password` FROM `chef` ;

-- --------------------------------------------------------

--
-- Structure for view `login_cust`
--
DROP TABLE IF EXISTS `login_cust`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `login_cust`  AS SELECT `customer`.`id` AS `id`, `customer`.`username` AS `username`, `customer`.`password` AS `password` FROM `customer` ;

-- --------------------------------------------------------

--
-- Structure for view `login_manager`
--
DROP TABLE IF EXISTS `login_manager`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `login_manager`  AS SELECT `manager`.`username` AS `username`, `manager`.`password` AS `password` FROM `manager` ;

-- --------------------------------------------------------

--
-- Structure for view `max1`
--
DROP TABLE IF EXISTS `max1`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `max1`  AS SELECT `bill`.`Customerid` AS `Customerid`, count(`bill`.`Customerid`) AS `count1` FROM `bill` GROUP BY `bill`.`Customerid` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`);

--
-- Indexes for table `chef`
--
ALTER TABLE `chef`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `Name` (`Name`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `phone no` (`phone no`),
  ADD KEY `Name` (`Name`),
  ADD KEY `DOB` (`DOB`);

--
-- Indexes for table `employes`
--
ALTER TABLE `employes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Phone` (`Phone`),
  ADD KEY `Name` (`Name`),
  ADD KEY `address` (`address`);

--
-- Indexes for table `food`
--
ALTER TABLE `food`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKfood309490` (`Menuid`),
  ADD KEY `FKfood253902` (`Customerid`),
  ADD KEY `chef_id` (`chef_id`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Name` (`Name`);

--
-- Indexes for table `manager`
--
ALTER TABLE `manager`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `Name` (`Name`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Name` (`Name`);

--
-- Indexes for table `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Date` (`Date`),
  ADD KEY `FKOrder558759` (`Customerid`),
  ADD KEY `FKOrder867871` (`Chefid`),
  ADD KEY `FKOrder4633` (`Menuid`);

--
-- Indexes for table `order1`
--
ALTER TABLE `order1`
  ADD PRIMARY KEY (`id`),
  ADD KEY `Date` (`Date`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`Date`),
  ADD UNIQUE KEY `Date` (`Date`),
  ADD KEY `No` (`No`);

--
-- Indexes for table `reservation_table`
--
ALTER TABLE `reservation_table`
  ADD KEY `FKReservatio145134` (`ReservationDate`);

--
-- Indexes for table `reservaton_wait`
--
ALTER TABLE `reservaton_wait`
  ADD KEY `Date` (`Date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bill`
--
ALTER TABLE `bill`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1424;

--
-- AUTO_INCREMENT for table `chef`
--
ALTER TABLE `chef`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=134;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1245;

--
-- AUTO_INCREMENT for table `employes`
--
ALTER TABLE `employes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `food`
--
ALTER TABLE `food`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `manager`
--
ALTER TABLE `manager`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `order`
--
ALTER TABLE `order`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `order1`
--
ALTER TABLE `order1`
  MODIFY `id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=71;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`Customerid`) REFERENCES `customer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `food`
--
ALTER TABLE `food`
  ADD CONSTRAINT `FKfood253902` FOREIGN KEY (`Customerid`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `FKfood309490` FOREIGN KEY (`Menuid`) REFERENCES `menu` (`id`);

--
-- Constraints for table `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `FKOrder4633` FOREIGN KEY (`Menuid`) REFERENCES `menu` (`id`),
  ADD CONSTRAINT `FKOrder558759` FOREIGN KEY (`Customerid`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `FKOrder867871` FOREIGN KEY (`Chefid`) REFERENCES `chef` (`id`);

--
-- Constraints for table `reservation_table`
--
ALTER TABLE `reservation_table`
  ADD CONSTRAINT `FKReservatio145134` FOREIGN KEY (`ReservationDate`) REFERENCES `reservation` (`Date`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
