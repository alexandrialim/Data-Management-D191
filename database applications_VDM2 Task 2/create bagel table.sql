CREATE TABLE sys.BagelOrder(
BagelOrderID INT NOT NULL,
BagelID INT NOT NULL,
OrderDate TIMESTAMP,
FirstName VARCHAR(255),
LastName VARCHAR(255),
Address1 VARCHAR(255),
Address2 VARCHAR(255),
City VARCHAR(255),
State VARCHAR(255),
Zip VARCHAR(255),
MobilePhone VARCHAR(255),
DeliveryFee INT,
BagelName VARCHAR(255),
BagelDescription VARCHAR(255),
BagelPrice FLOAT,
BagelQuantity INT,
SpecialNotes VARCHAR(255),
PRIMARY KEY (BagelOrderID, BagelID)
);