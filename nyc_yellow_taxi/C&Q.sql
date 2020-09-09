--1. External Table

CREATE EXTERNAL TABLE yellow_taxi
        (VendorID INT,
         tpep_pickup_datetime TIMESTAMP,
         tpep_dropoff_datetime TIMESTAMP,
         Passenger_count INT,
         Trip_distance DOUBLE,
         RateCodeID INT,
         Store_and_fwd_flag CHAR(1),
         PULocationID INT,
         DOLocationID INT,
         Payment_type INT,
         Fare_amount DOUBLE,
         Extra DOUBLE,
         MTA_tax DOUBLE,
         Tip_amount DOUBLE,
         Tolls_amount DOUBLE,
         Improvement_surcharge DOUBLE,
         Total_amount DOUBLE )
     ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
     LOCATION 's3://yellow-taxi-bucket/data/';

-- 2. Q1
SELECT FORMAT_NUMBER(SUM(Fare_amount),2) AS Total_Fare_Amount, 
MONTH(tpep_pickup_datetime) AS Month_of_2018
FROM   yellow_taxi
WHERE  RateCodeID = 1
  AND  Passenger_count >= 2
  AND  Payment_type IN (1, 2)
  AND  Trip_distance <= 50
  AND (unix_timestamp(tpep_dropoff_datetime) - unix_timestamp(tpep_pickup_datetime))/3600 <= 2

  AND  VendorID IN (1,2)
  AND  YEAR(tpep_dropoff_datetime) = 2018
  AND  YEAR(tpep_pickup_datetime) = 2018
  AND  Passenger_count <= 6
  AND  Trip_distance > 0
  AND  Store_and_fwd_flag IN ('Y','N')
  AND  Fare_amount > 0
  AND  Extra IN (0,0.5,1)
  AND  MTA_tax IN (0,0.5)
  AND  Tip_amount >= 0
  AND  Tolls_amount >= 0
  AND  Improvement_surcharge IN (0,0.3)
  AND  Total_amount > 0
GROUP BY Month(tpep_pickup_datetime)
ORDER BY Month(tpep_pickup_datetime);

-- 1	26,698,121.12
-- 2	25,780,643.47
-- 3	29,570,741.41
-- 4	29,955,538.13
-- 5	30,225,146.45
-- 6	28,535,262.05
-- 7	25,559,459.15
-- 8	25,459,718.99
-- 9	26,400,844.77
-- 10	28,475,398.60
-- 11	26,445,826.93
-- 12	27,275,036.86
-- Time taken: 181.524 seconds, Fetched 12 row(s)


-- 3. Q2
SELECT ROUND(AVG(Fare_amount/Trip_distance),3) AS Average_Cost_Per_Mile
FROM   yellow_taxi
WHERE  RateCodeID = 1
  AND  Trip_distance > 10
  AND  Trip_distance < 25
  AND  DOLocationID NOT IN (1,132,138)
  AND (unix_timestamp(tpep_dropoff_datetime) - unix_timestamp(tpep_pickup_datetime))/3600 <= 2
  
  AND  VendorID IN (1,2)
  AND  YEAR(tpep_dropoff_datetime) = 2018
  AND  YEAR(tpep_pickup_datetime) = 2018
  AND  Passenger_count BETWEEN 1 AND 6
  AND  Store_and_fwd_flag IN ('Y','N')
  AND  Payment_Type IN (1,2,3,4,5,6)
  AND  Fare_amount > 0
  AND  Extra IN (0,0.5,1)
  AND  MTA_tax IN (0,0.5)
  AND  Tip_amount >= 0
  AND  Tolls_amount >= 0
  AND  Improvement_surcharge IN (0,0.3)
  AND  Total_amount > 0;

-- 3.122
-- Time taken: 180.349 seconds, Fetched 1 row(s)


4. Q3
SELECT DATE_FORMAT(tpep_pickup_datetime,'EEEE') AS Day_of_Week, 
(SUM(CASE when passenger_count = 1 THEN 1 ELSE 0 END)/COUNT(DISTINCT TO_DATE(tpep_pickup_datetime))) AS Average_Single_Rider_Trips,
-- COUNT (DISTINCT TO_DATE(tpep_pickup_datetime)) AS Date_Count

FROM   yellow_taxi
WHERE  RateCodeID = 1
  AND  Trip_distance <= 50
  AND (unix_timestamp(tpep_dropoff_datetime) - unix_timestamp(tpep_pickup_datetime))/3600 <= 2

  AND  VendorID IN (1,2)
  AND  YEAR(tpep_pickup_datetime) = 2018
  AND  YEAR(tpep_dropoff_datetime) = 2018
  AND  Passenger_count BETWEEN 1 AND 6
  AND  Trip_distance > 0
  AND  Store_and_fwd_flag IN ('Y','N')
  AND  Payment_Type in (1,2,3,4,5,6)
  AND  Fare_amount > 0
  AND  Extra IN (0,0.5,1)
  AND  MTA_tax IN (0,0.5)
  AND  Tip_amount >= 0
  AND  Tolls_amount >= 0
  AND  Improvement_surcharge IN (0,0.3)
  AND  Total_amount > 0

GROUP BY DATE_FORMAT(tpep_pickup_datetime,'EEEE')
ORDER BY Average_Single_Rider_Trips ASC
LIMIT 1;

-- Sunday	162293.904
-- Time taken: 320.847 seconds, Fetched 1 row(s)

-- *total every single rider, take the average of each days and return the lowest
-- eg: (5+7+3+12)/4 for Jan
