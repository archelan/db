SET SQL_SAFE_UPDATES = 0;

DROP PROCEDURE IF exists p;
DELIMITER \\
CREATE PROCEDURE p (IN param int, OUT result int)   
BEGIN
     DECLARE t int;
     INSERT into temp1 values(param);
     SELECT ChiefID FROM main WHERE PersonID = param INTO t;
     IF t != -1 THEN        
          CALL p(t, @result);
     END IF;   
END\\
DELIMITER ;

DROP PROCEDURE IF exists p2;
DELIMITER \\
CREATE PROCEDURE p2()   
BEGIN
     DECLARE s varchar(100);
     DECLARE res varchar(1000) DEFAULT '';
     DECLARE cnt int;
     DECLARE num int;

     SELECT COUNT(*) FROM firstpart into cnt;
     WHILE cnt > 0 DO
          SELECT * FROM firstpart LIMIT 1 INTO num;
          SELECT FullName FROM main WHERE PersonID = num INTO s;
          DELETE FROM firstpart LIMIT 1;
          SET cnt = cnt - 1;
          SET res = CONCAT(res, s, ' (id:', num, ') -> ');
     END WHILE;

     SELECT COUNT(*) FROM middle into cnt;
     WHILE cnt > 0 DO
          SELECT * FROM middle LIMIT 1 INTO num;
          SELECT FullName FROM main WHERE PersonID = num INTO s;
          DELETE FROM middle LIMIT 1;
          SET cnt = cnt - 1;
          SET res = CONCAT(res, s, ' (id:', num, ')');
     END WHILE;

     SELECT COUNT(*) FROM lastpart into cnt;
     WHILE cnt > 0 DO
          SELECT * FROM lastpart LIMIT 1 INTO num;
          SELECT FullName FROM main WHERE PersonID = num INTO s;
          DELETE FROM lastpart LIMIT 1;
          SET cnt = cnt - 1;
          SET res = CONCAT(res, ' <- ', s, ' (id:', num, ')');
     END WHILE;

    INSERT into tableres values(res);   
END\\
DELIMITER ;


DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 (id int);
CALL p(98, @answer);
DROP TABLE IF EXISTS first_table;
CREATE TABLE first_table LIKE temp1;
INSERT first_table  SELECT * FROM temp1;

DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 (id int);
CALL p(92, @answer);
DROP TABLE IF EXISTS second_table;
CREATE TABLE second_table LIKE temp1;
INSERT second_table SELECT * FROM temp1;

DROP TABLE IF EXISTS firstpart;
CREATE TABLE firstpart (id int);

DROP TABLE IF EXISTS middle;
CREATE TABLE middle (id int);

DROP TABLE IF EXISTS lastpart;
CREATE TABLE lastpart (id int);

insert firstpart (SELECT id FROM second_table
WHERE second_table.id NOT IN
(SELECT id FROM first_table));

insert middle (SELECT id FROM first_table
WHERE first_table.id IN
(SELECT id FROM second_table)
ORDER BY ID DESC
LIMIT 1);

insert lastpart (SELECT id FROM first_table
WHERE first_table.id NOT IN
(SELECT id FROM second_table)
ORDER BY ID ASC);

DROP TABLE IF EXISTS tableres;
CREATE TABLE tableres (str varchar(1000));

CALL p2();

select * from tableres;