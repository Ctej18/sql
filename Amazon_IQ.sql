--find out employees who have higher rating than manager
create table amazon_employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR,
    rating INT,
    manager_id INT  -- References emp_id of the manager
)

INSERT INTO amazon_employees (emp_id, emp_name, rating, manager_id) VALUES
(1, 'Alice', 90, NULL),       -- Alice is the top-level manager (No manager)
(2, 'Bob', 85, 1),            -- Bob reports to Alice
(3, 'Charlie', 95, 1),        -- Charlie reports to Alice
(4, 'Dave', 88, 2),           -- Dave reports to Bob
(5, 'Eve', 92, 2);            -- Eve reports to Bob

Select e.emp_name as employee_name, e.rating as employee_rating,
	   m.emp_name as manager_name, m.rating as manager_rating
from amazon_employees e
join amazon_employees m
on e.manager_id = m.emp_id
where e.rating > m.rating

select * from amazon_employees

--find out employees who have highest and lowest rating employee for each manager
select * from amazon_employees
where rating = (select max(rating) from amazon_employees)
union
select * from amazon_employees
where rating = (select min(rating) from amazon_employees)

select emp_id,emp_name,e.rating,mgr.manager_id from amazon_employees e
join (
select manager_id, max(rating) as max_rating, min(rating) as min_rating
from amazon_employees
group by manager_id
) mgr
on e.manager_id = mgr.manager_id 
where e.rating = mgr.max_rating or e.rating = mgr.min_rating

with rating as (
Select emp_id,emp_name,rating,manager_id,
       Rank() over(Partition by e.manager_id order by e.rating DESC) as highest_rating,
	   Rank() over (Partition by e.manager_id order by e.rating asc) as lowest_rating
from amazon_employees e
)
Select emp_id,emp_name,rating,manager_id from rating
where highest_rating = 1 or lowest_rating = 1

