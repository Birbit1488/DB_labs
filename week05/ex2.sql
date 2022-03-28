CREATE TABLE Group (
  groupId INTEGER NOT NULL,
  companyId INTEGER,
  PRIMARY KEY (groupId),
  CONSTRAINT FK_Has FOREIGN KEY (companyId) REFERENCES Company(companyId)
);
CREATE TABLE Company (
  companyId INTEGER NOT NULL,
  structureCompanyId INTEGER,
  plantId INTEGER,
  groupId INTEGER NOT NULL,
  PRIMARY KEY (companyId),
  CONSTRAINT FK_Owned_by FOREIGN KEY (groupId) REFERENCES Group(groupId),
  CONSTRAINT FK_Structures FOREIGN KEY (structureCompanyId) REFERENCES Company(companyId)
  CONSTRAINT FK_Has FOREIGN KEY (plantId) REFERENCES Plant(plantID);
);
CREATE TABLE Plant (
  plantId INTEGER NOT NULL,
  companyId INTEGER NOT NULL,
  itemId INTEGER,
  PRIMARY KEY (plantId),
  CONSTRAINT FK_Produces FOREIGN KEY (itemId) REFERENCES Item(itemId),
  CONSTRAINT FK_Owned_by FOREIGN KEY (companyId) REFERENCES Company(companyId)
);
CREATE TABLE Item (
  itemId INTEGER NOT NULL,
  plantId INTEGER NOT NULL,
  PRIMARY KEY (itemId),
  CONSTRAINT FK_Produced_by FOREIGN KEY (plantId) REFERENCES Plant(plantId)
  )