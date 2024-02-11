1)
/* user activity */ 
select table1.date, case when table2.date is null then 0 else table2.count end as unique_user_count from (
select distinct date from user_activity)table1 
left join (
with interm_table as (
    select *,  ROW_NUMBER() OVER(PARTITION BY user_id order by date) AS row_num  
    from user_activity order by date )
select count(user_id), date from interm_table
where row_num =1 
group by date 
)table2 
on (table1.date = table2.date)
order by date ; 

2) 
/* lookup questions we should solve using exists operator not with join .
as sometime with join operation it will have one to many rows which will not suffice and moreover it is not optimized  
in this question we need to check whtether customer harshit has placed an order or not 
*/

/*
1 approch with join 
*/

select customers_iq.* from customers_iq
left join orders_iq 
on(customers_iq.customer_id = orders_iq.customer_id)
where customers_iq.customer_name = 'harshit' 
 /*
 	
customer_id | customer_name |customer_email
1	        | harshit       |	abc@gmail.com
1	        | harshit	    |   abc@gmail.com
Now if see there are 2 rows with id 1 
but in actual harshit has placed one order which is delivered 
and one is cancelled 
so therfore it is hard to decide  | 

*/

/*
2 approach with exists 
*/

select customers_iq.* from 
customers_iq where exists (select customer_id from orders_iq where customers_iq.customer_id = orders_iq.customer_id and customers_iq.customer_name ='harshit')

/*
output 
customer_id | customer_name |customer_email
1	        | harshit       |	abc@gmail.com

so that is why exists is better than join when dealing with lookup like questions 

*/


3)
/*
Warehouse Manager 
Table: Warehouse

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| name         | varchar |
| product_id   | int     |
| units        | int     |
+--------------+---------+
(name, product_id) is the primary key for this table.
Each row of this table contains the information of the products in each warehouse.

Table: Products

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
| Width         | int     |
| Length        | int     |
| Height        | int     |
+---------------+---------+
product_id is the primary key for this table.
Each row of this table contains the information about the product dimensions (Width, Lenght and Height) in feets of each product.


Write an SQL query to report, How much cubic feet of volume does the inventory occupy in each warehouse.
warehouse_name
volume
Return the result table in any order.

The query result format is in the following example.

Warehouse table:
+------------+--------------+-------------+
| name       | product_id   | units       |
+------------+--------------+-------------+
| LCHouse1   | 1            | 1           |
| LCHouse1   | 2            | 10          |
| LCHouse1   | 3            | 5           |
| LCHouse2   | 1            | 2           |
| LCHouse2   | 2            | 2           |
| LCHouse3   | 4            | 1           |
+------------+--------------+-------------+

Products table:
+------------+--------------+------------+----------+-----------+
| product_id | product_name | Width      | Length   | Height    |
+------------+--------------+------------+----------+-----------+
| 1          | LC-TV        | 5          | 50       | 40        |
| 2          | LC-KeyChain  | 5          | 5        | 5         |
| 3          | LC-Phone     | 2          | 10       | 10        |
| 4          | LC-T-Shirt   | 4          | 10       | 20        |
+------------+--------------+------------+----------+-----------+

Result table:
+----------------+------------+
| warehouse_name | volume     | 
+----------------+------------+
| LCHouse1       | 12250      | 
| LCHouse2       | 20250      |
| LCHouse3       | 800        |
+----------------+------------+
Volume of product_id = 1 (LC-TV), 5x50x40 = 10000
Volume of product_id = 2 (LC-KeyChain), 5x5x5 = 125 
Volume of product_id = 3 (LC-Phone), 2x10x10 = 200
Volume of product_id = 4 (LC-T-Shirt), 4x10x20 = 800
LCHouse1: 1 unit of LC-TV + 10 units of LC-KeyChain + 5 units of LC-Phone.
        Total volume: 1*10000 + 10*125  + 5*200 = 12250 cubic feet
LCHouse2: 2 units of LC-TV + 2 units of LC-KeyChain.
        Total volume: 2*10000 + 2*125 = 20250 cubic feet
LCHouse3: 1 unit of LC-T-Shirt.
        Total volume: 1*800 = 800 cubic feet.

*/

select name as warehouse_name , 
sum(units * volume) as volume
from (
select a.name, a.product_id ,a.units ,b.volume
from warehouse_table a 
inner join 
(
select *, width*length*height as volume from product_table
)b 
on (a.product_id = b.product_id)
)c 
group by name 

select * from product_table

update product_table  set 
product_id = 4 
where product_name = 'LC-T-Shirt'

4)
/*
 Customer Placing the Largest Number Orders

Table: Orders

+-----------------+----------+
| Column Name     | Type     |
+-----------------+----------+
| order_number    | int      |
| customer_number | int      |
+-----------------+----------+
order_number is the primary key for this table.
This table contains information about the order ID and the customer ID.

Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.

It is guaranteed that exactly one customer will have placed more orders than any other customer.

The query result format is in the following example:

 Orders table:
+--------------+-----------------+
| order_number | customer_number |
+--------------+-----------------+
| 1            | 1               |
| 2            | 2               |
| 3            | 3               |
| 4            | 3               |
+--------------+-----------------+

Result table:
+-----------------+
| customer_number |
+-----------------+
| 3               |
+-----------------+

The customer with number 3 has two orders, which is greater than either customer 1 or 2 because each of them only has one order. 
So the result is customer_number 3.

*/
select customer_number from (
select customer_number ,count(order_number) 
as cnt
from orders_table 
group by customer_number
order by cnt desc 
)tbl  limit 1 ;

5)
/*
Write a SQL query to get the second highest salary from the 
Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
For example, given the above Employee table, the query should return 200 as the second highest salary. If there is no second highest salary, then the query should return null.
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |

*/

select max(salary) from employee_table
where salary not  in ( select max(salary) from employee_table )

/*
using limit and offset 
SELECT salary
FROM employee_table
WHERE salary >= (
 SELECT DISTINCT salary
 FROM employee_table
 ORDER BY salary DESC
 LIMIT 2, 1
)
ORDER BY salary DESC;

SELECT salary
FROM employee_table e1
WHERE (
 SELECT COUNT(*)
 FROM employee_table e2
 WHERE e2.salary > e1.salary
) = (n-1);
where n is the highest salary 

*/

6)
/*
Table: Patients

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| patient_id   | int     |
| patient_name | varchar |
| conditions   | varchar |
+--------------+---------+
patient_id is the primary key for this table.
'conditions' contains 0 or more code separated by spaces
This table contains information of the patients in the hospital.

Write an SQL query to report the patient_id, patient_name all conditions of patients who have Type I Diabetes. Type I Diabetes always starts with DIAB1 prefix

Return the result table in any order.

The query result format is in the following example.

Patients
+------------+--------------+--------------+
| patient_id | patient_name | conditions   |
+------------+--------------+--------------+
| 1          | Daniel       | YFEV COUGH   |
| 2          | Alice        |              |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |
| 5          | Alain        | DIAB201      |
+------------+--------------+--------------+

Result table:
+------------+--------------+--------------+
| patient_id | patient_name | conditions   |
+------------+--------------+--------------+
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 | 
+------------+--------------+--------------+
Bob and George both have a condition that starts with DIAB1

*/

select patient_id, patient_name, conditions from patient_table
where conditions like '%DIAB1%'

6)
/*
Customers Who Bought All Products
Problem statement
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
product_key is a foreign key to Product table.


Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key column for this table.


Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

The query result format is in the following example:

Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+

Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+

Result table:
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
The customers who bought all the products (5 and 6) are customers with id 1 and 3.

*/
select customer_id from customer_table
group by customer_id
having count(distinct product_key) = (select count(*) from products_table)
order by customer_id 

7)
/*
Running Total for Different Genders
Table: Scores

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| player_name   | varchar |
| gender        | varchar |
| day           | date    |
| score_points  | int     |
+---------------+---------+
(gender, day) is the primary key for this table.
A competition is held between females team and males team.
Each row of this table indicates that a player_name and with gender has scored score_point in someday.
Gender is 'F' if the player is in females team and 'M' if the player is in males team.


Write an SQL query to find the total score for each gender at each day.

Order the result table by gender and day

The query result format is in the following example:

Scores table:
+-------------+--------+------------+--------------+
| player_name | gender | day        | score_points |
+-------------+--------+------------+--------------+
| Aron        | F      | 2020-01-01 | 17           |
| Alice       | F      | 2020-01-07 | 23           |
| Bajrang     | M      | 2020-01-07 | 7            |
| Khali       | M      | 2019-12-25 | 11           |
| Slaman      | M      | 2019-12-30 | 13           |
| Joe         | M      | 2019-12-31 | 3            |
| Jose        | M      | 2019-12-18 | 2            |
| Priya       | F      | 2019-12-31 | 23           |
| Priyanka    | F      | 2019-12-30 | 17           |
+-------------+--------+------------+--------------+
Result table:
+--------+------------+-------+
| gender | day        | total |
+--------+------------+-------+
| F      | 2019-12-30 | 17    |
| F      | 2019-12-31 | 40    |
| F      | 2020-01-01 | 57    |
| F      | 2020-01-07 | 80    |
| M      | 2019-12-18 | 2     |
| M      | 2019-12-25 | 13    |
| M      | 2019-12-30 | 26    |
| M      | 2019-12-31 | 29    |
| M      | 2020-01-07 | 36    |
+--------+------------+-------+
For females team:
First day is 2019-12-30, Priyanka scored 17 points and the total score for the team is 17.
Second day is 2019-12-31, Priya scored 23 points and the total score for the team is 40.
Third day is 2020-01-01, Aron scored 17 points and the total score for the team is 57.
Fourth day is 2020-01-07, Alice scored 23 points and the total score for the team is 80.
For males team:
First day is 2019-12-18, Jose scored 2 points and the total score for the team is 2.
Second day is 2019-12-25, Khali scored 11 points and the total score for the team is 13.
Third day is 2019-12-30, Slaman scored 13 points and the total score for the team is 26.
Fourth day is 2019-12-31, Joe scored 3 points and the total score for the team is 29.
Fifth day is 2020-01-07, Bajrang scored 7 points and the total score for the team is 36.

*/

select gender, day , sum(score_points) over (partition by gender order by day) 
as total_sum 
from scores_table 
order by gender, day  

8)
/*
 Biggest Single Number
  Table my_numbers contains many numbers in column num including duplicated ones.
 Can you write a SQL query to find the biggest number, which only appears once.

 +---+
|num|
+---+
| 8 |
| 8 |
| 3 |
| 3 |
| 1 |
| 4 |
| 5 |
| 6 | 

For the sample data above, your query should return the following result:
+---+
|num|
+---+
| 6 |
Note: If there is no such number, just output null. 

*/
select max(num) from my_numbers 
where num not in (
select distinct num from (
select num, ROW_NUMBER() over (partition by num order by num) as rnk
from my_numbers
)a where rnk  > 1)

/*
other way 

select num from my_numbers 
group by num 
having count(*) =1 
order by num desc limit 1 

*/

9)
/*
Delete Duplicate emails

 Write a SQL query to delete all duplicate email entries in a table named Person, keeping only unique emails based on its smallest Id.

 +----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
+----+------------------+
Id is the primary key column for this table.
For example, after running your query, the above Person table should have the following rows:

+----+------------------+
| Id | Email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
+----+------------------+
Note:

  Your output is the whole Person table after executing your sql. Use delete statement.

*/

delete from person_table 
where id = (
select max(id) as id from (
select id, ROW_NUMBER() over (partition by email order by id )
as rnk , email  
from person_table
)a where rnk > 1
)


select * from person_table

/*
other way 
delete from person_table 
where id not in 
(
    select min(id) from person_table
    group by email 
)
*/

10)
/*
Apples & Oranges
Table: Sales

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_date     | date    |
| fruit         | enum    | 
| sold_num      | int     | 
+---------------+---------+
(sale_date,fruit) is the primary key for this table.
This table contains the sales of "apples" and "oranges" sold each day.


Write an SQL query to report the difference between number of apples and oranges sold each day.

Return the result table ordered by sale_date in format ('YYYY-MM-DD').

The query result format is in the following example:



Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+

Result table:
+------------+--------------+
| sale_date  | diff         |
+------------+--------------+
| 2020-05-01 | 2            |
| 2020-05-02 | 0            |
| 2020-05-03 | 20           |
| 2020-05-04 | -1           |
+------------+--------------+

Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).