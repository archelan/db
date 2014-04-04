CREATE TABLE IF NOT EXISTS main (PersonID int, ChiefID int, FullName VARCHAR(60))
LOAD DATA INFILE 'homework1-data.csv' INTO TABLE main COLUMNS TERMINATED BY ','
Alter table main add PRIMARY KEY(PersonID)
#DROP TABLE main
SET max_sp_recursion_depth=100;