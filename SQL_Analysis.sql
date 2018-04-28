USE test;
DROP TABLE IF EXISTS `toyArrivals`;
CREATE TABLE `toyArrivals` (
		`ToyId` INT(10) UNSIGNED NOT NULL,
                `arrivalDate` DATETIME NOT NULL,
                `tentativeEndDate` DATETIME NOT NULL,
                `duration` INT(100) NOT NULL,
                PRIMARY KEY  (`ToyId`)
                ) ENGINE=MYISAM;

ALTER TABLE toyArrivals CHANGE startDate  arrivalDate DATETIME NOT NULL;


DROP TABLE IF EXISTS `toySchedule`;
CREATE TABLE `toySchedule` (
				`ToyId` INT(10) UNSIGNED NOT NULL,
                `ElfId` INT(10) NOT NULL,
                `StartTime` DATETIME NOT NULL,
                `Duration` DOUBLE NOT NULL,	
				`ElfPreProductivity` DOUBLE NOT NULL,
				`ElfPostProductivity` DOUBLE NOT NULL,
				`ElfFreeFrom` DATETIME NOT NULL,
                PRIMARY KEY  (`ToyId`)
                ) ENGINE=MYISAM;

select COUNT(*) from toySchedule;
select COUNT(*) from toyArrivals;
delete from toyArrivals where ToyId > 0;
delete from toySchedule where ToyId > 0;


select * from toySchedule where ToyId = 24774;
select * from toyArrivals where ToyId = 24774;
select * from toySchedule
inner join toyArrivals ON toySchedule.ToyId
order by StartTime limit 100;
select * from toyArrivals where toyid=4;

select ta.ToyId,ts.elfid,ta.arrivalDate,ta.duration,ts.duration,
ts.StartTime,ts.ElfPreProductivity,ts.ElfPostProductivity,ts.elffreeFrom, 
TIMESTAMPADD(MINUTE,ts.Duration,StartTime) as finalEndDate
from toyArrivals ta
INNER JOIN toySchedule ts ON ta.ToyId = ts.ToyId
WHERE ta.arrivalDate <= ts.StartTime
-- AND ElfId = 137
AND ta.ToyId = 24774
-- AND ta.duration > 540
ORDER BY StartTime DESC
LIMIT 100;

SELECT MAX(StartTime) FROM toySchedule;
SELECT * FROM toySchedule 
WHERE duration > 540
ORDER BY StartTime DESC;
select MIN(duration), MAX(duration) from toyArrivals;
select @totalCount := COUNT(*) from toyArrivals;  
select SUM(duration) from toyArrivals;

select COUNT(*) 
from toyArrivals
where duration between 40000 and 50000;
-- 1

select COUNT(*) 
from toyArrivals
where duration between 30000 and 40000;
-- 7

select COUNT(*) 
from toyArrivals
where duration between 20000 and 30000;
-- 240535

select COUNT(*) 
from toyArrivals
where duration between 10000 and 20000;
-- 1004126

select COUNT(*) 
from toyArrivals
where duration between 1 and 10000;
-- 8755549


select * , (duration/(60 * 24))
from toyArrivals
where duration > 25000;
