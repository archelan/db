SELECT PersonID FROM main
WHERE main.PersonID NOT IN
(SELECT ChiefID FROM main WHERE PersonID < 100
          GROUP BY ChiefID);