DROP PROCEDURE IF exists p;

DROP TABLE IF EXISTS temp1;
CREATE TABLE temp1 (id int);
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

CALL p(98, @answer);
SELECT COUNT(*) as rank FROM temp1;