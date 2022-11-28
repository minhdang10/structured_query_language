-- Query 1. For all customers in the customers table, construct a dataset with one 
-- line per customer and the following customer stats: 
-- + Customer ID
-- + Customer registration state
-- + Total bets placed
-- + Total bet stakes
-- + Total bet revenue
-- + Total casino stakes

SELECT 	c.customer_id, c.registration_state, 
	COUNT(s.bet_id) AS Total_Bets_Placed, 
	SUM(s.bet_stake) AS Total_Bet_Stakes, 
        	SUM(s.bet_revenue) AS Total_Bet_Revenue, 
        	c1.casino_stakes AS Total_Casino_Stakes
FROM 	(customers c INNER JOIN sportsbook_bets s 
		ON c.customer_id=s.customer_id)
	LEFT JOIN casino c1 
		ON c.customer_id=c1.customer_id
GROUP BY c.customer_id, c.registration_state, c1.casino_stakes;


-- Query 2. Create a list of all customer IDs where the customer has greater than 
-- 10% of their total bet stakes placed on in play football.

SELECT c.customer_id
FROM customers c 
INNER JOIN sportsbook_bets s ON c.customer_id=s.customer_id
GROUP BY c.customer_id
HAVING COUNT(CASE WHEN s.sport_name = 'football' AND s.in_play_yn='Y' 
	THEN 1 END)/COUNT(*) >= 0.10;


-- Query 3. Find the percentage of customers who have placed bets outside of the 
-- state they registered in.

SELECT CONCAT(ROUND((SUM(Out_of_State_Bet)/COUNT(*))*100,2),'%') AS Out_of_State_Bet_Percentage
FROM (	SELECT 	c.customer_id,ROUND(COUNT(DISTINCT CASE WHEN s.bet_state <> c.registration_state 
		THEN c.registration_state END)/COUNT(DISTINCT c.customer_id),0) 
            	AS Out_of_State_Bet
	FROM customers c INNER JOIN sportsbook_bets s
	ON c.customer_id=s.customer_id
	GROUP BY s.customer_id) AS out_of_state_yn;




-- Query 4. For all customers in the customers table, construct a dataset with one 
-- line per customer and the following customer stats:
-- + Customer ID
-- + A list of all states where the customer has placed a bet

SELECT c.customer_id, GROUP_CONCAT(DISTINCT s.bet_state) AS "List_of_States"
FROM customers c LEFT JOIN sportsbook_bets s 
ON c.customer_id=s.customer_id
GROUP BY c.customer_id;