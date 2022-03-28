CREATE TABLE Customer(
  clientId INTEGER PRIMARY KEY NOT NULL,
  balance INTEGER,
  creditLimit INTEGER UNSIGNED,
  discount INTEGER CHECK(discount >= 0 AND discount<=100),
  shippingAddrID INTEGER,
  CONSTRAINT FK_ShippingAddress FOREIGN KEY (shippingAddrID) REFERENCES ShippingAddresses(addressID)
  );
CREATE TABLE ShippingAddresses (
  street CHAR(50) NOT NULL
  district CHAR(50),
  house INTEGER UNSIGNED,
  city CHAR(50),
  addressID INTEGER PRIMARY KEY NOT NULL
  );
  CREATE TABLE Orders
(
  order_id INTEGER PRIMARY KEY NOT NULL,
  date CHAR(50) NOT NULL,
  shippingAddrID INTEGER,
  CONSTRAINT FK_ShippingAddress FOREIGN KEY (shippingAddrID) REFERENCES ShippingAddresses(addressID)
);


CREATE TABLE Item
(
item_id INTEGER PRIMARY KEY NOT NULL,
description CHAR(1000) NOT NULL,
);


CREATE TABLE Manufacturer
(
manufacture_id INTEGER PRIMARY KEY NOT NULL,
phoneNumber CHAR(50) NOT NULL,
);


CREATE TABLE Includes(
  item_id INTEGER NOT NULL,
  order_id INTEGER NOT NULL,
  CONSTRAINT FK_Item FOREIGN KEY (item_id) REFERENCES Item(item_id)
  CONSTRAINT FK_Order FOREIGN KEY (order_id) REFERENCES Orders(order_id)
  quantity INTEGER
  );
 
CREATE TABLE Producers(
  
  item_id INTEGER NOT NULL,
  manufacture_id INTEGER NOT NULL,
  CONSTRAINT FK_Item KEY (item_id) REFERENCES Item(item_id)
  CONSTRAINT FK_Manufacturer FOREIGN KEY (manufacturer_id) REFERENCES Manufacturer(manufacturer_id)
  quantity INTEGER


);