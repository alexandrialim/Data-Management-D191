INSERT INTO sys.COFFEE_SHOP
VALUES(1, 'starbucks', 'seattle', 'wa'),
(2, 'latteCo', 'honolulu', 'hi'),
(3, 'coffee+T', 'alexandria', 'va');

INSERT INTO sys.EMPLOYEE
VALUES(10, 'katy', 'li', '20210101', 'barista', 1),
(11, 'sara', 'bailey', '20210222', 'cashier', 2),
(12, 'samuel', 'xu', '20210406', 'barista', 3);

INSERT INTO sys.SUPPLIER
VALUES(101, 'foodsCo', 'canada', 'amanda', 'amanda@foodsco.com'),
(102, 'shipFood', 'united states of america', 'cole', 'cole@shipfood.com'),
(103, 'gardenersCo', 'egypt', 'maize', 'maize@gardenersco.com');

INSERT INTO sys.COFFEE
VALUES(201, 1, 101, 'arabica', 10.20),
(202, 2, 102, 'liberica', 11.00),
(203, 3, 103, 'Sumatra', 12.35);