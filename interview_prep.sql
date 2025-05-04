--pivoting without pivot function, using cte and union all avoids table creation in db
with emp_compensation as (
select 1 as emp_id, 'salary' as salary_component_type, 10000 as value
union all select 1 as emp_id, 'bonus' as salary_component_type, 5000 as value
union all select 1 as emp_id, 'hike_percent' as salary_component_type, 10 as value
union all select 2 as emp_id, 'salary' as salary_component_type, 15000 as value
union all select 2 as emp_id, 'bonus' as salary_component_type, 7000 as value
union all select 2 as emp_id, 'hike_percent' as salary_component_type, 8 as value
union all select 3 as emp_id, 'salary' as salary_component_type, 12000 as value
union all select 3 as emp_id, 'bonus' as salary_component_type, 6000 as value
union all select 3 as emp_id, 'hike_percent' as salary_component_type, 7 as value
)
select  emp_id,
		Sum(case when salary_component_type = 'salary' then value end) as salary,
		Sum(case when salary_component_type = 'bonus' then value end) as bonus,
		Sum(case when salary_component_type = 'hike_percent' then value end) as hike_percent
from emp_compensation
group by emp_id

--emp salary > manager salary (self join)
with emp_mgr as (
select 1 as emp_id, 'Ankit' as emp_name, 10000 as salary, 4 as mgr_id
union all select 2 as emp_id, 'Mohit' as emp_name, 15000 as salary, 5 as mgr_id
union all select 3 as emp_id, 'Vikas' as emp_name, 10000 as salary, 4 as mgr_id
union all select 4 as emp_id, 'Rohit' as emp_name, 5000 as salary, 2 as mgr_id
union all select 5 as emp_id, 'Kumar' as emp_name, 12000 as salary, 6 as mgr_id
union all select 6 as emp_id, 'Ajay' as emp_name, 12000 as salary, 2 as mgr_id
union all select 7 as emp_id, 'Vijay' as emp_name, 90000 as salary, 2 as mgr_id
union all select 8 as emp_id, 'John' as emp_name, 5000 as salary, 2 as mgr_id
)
Select e.emp_id,e.emp_name,e.salary,m.salary,m.emp_name from emp_mgr e
inner join emp_mgr m
on e.mgr_id = m.emp_id
where e.salary > m.salary
order by m.mgr_id

--calculate mode or find out most frequent value in a column
with mode_tbl as (
Select 1 as id
union all Select 2 as id
union all Select 2 as id
union all Select 3 as id
union all Select 3 as id
union all Select 3 as id
union all Select 3 as id
union all Select 4 as id
union all Select 5 as id
)
select * from (select id,count(id) as frequency from mode_tbl group by id)
where frequency = (select max(freq) from (select id,count(id) as freq from mode_tbl group by id))

--list employee_status(outer join with handling nulls)
create table emp_2020
(
emp_id int,
designation varchar(20)
);

create table emp_2021
(
emp_id int,
designation varchar(20)
)

insert into emp_2020 (emp_id,designation) values (1,'Trainee'), (2,'Developer'),(3,'Senior Developer'),(4,'Manager');
insert into emp_2021 (emp_id,designation) values (1,'Developer'), (2,'Developer'),(3,'Manager'),(5,'Trainee');

select * from emp_2020;
select * from emp_2021;

select coalesce(e20.emp_id,e21.emp_id) as id,
		case when e20.designation != e21.designation then 'Promoted'
		     when e20.emp_id is not null and e21.emp_id is null then 'Resigned'
			 else 'New Joinee' 
		end as emp_status
from emp_2020 e20
full outer join emp_2021 e21
on e20.emp_id = e21.emp_id
where coalesce(e20.designation,'xxx') != coalesce(e21.designation,'yyy')

--rank only duplicates
with list as (
select 'a' as id
union all select 'a' as id
union all select 'b' as id
union all select 'c' as id
union all select 'c' as id
union all select 'c' as id
union all select 'd' as id
union all select 'd' as id
union all select 'e' as id
),
dup_ids as (select * from list
group by id
having count(*)>1),
rank_cte as (select *,
	   rank() over (order by id) as rn
from dup_ids)
select l.id,'dup' || cast(rn as char(2)) as duprank from list l
left join rank_cte r
on l.id = r.id

--running sum
with products as (
select 'P1' as product_id, 200 as cost
union all select 'P2' as product_id, 300 as cost
union all select 'P3' as product_id, 300 as cost
union all select 'P4' as product_id, 500 as cost
union all select 'P5' as product_id, 800 as cost
)
/*select *,
	   sum(cost) over (order by product_id) as running_sum
from products*/
select *,
       sum(cost) over (order by cost asc rows between unbounded preceding and current row) as running_sum
from products

--Custom Sort Order
create table happiness_index 
("rank" int,
country varchar(55),
Happiness_2021 varchar(55),
Happiness_2020 varchar(55),
Population_2022 varchar(55)
);

insert into happiness_index ("rank",country,Happiness_2021,Happiness_2020,Population_2022) values 
(1,	'Finland',	7.842,	7.809,	5554960),
(2,	'Denmark',	7.62,	7.646,	5834950),
(3,	'Switzerland',	7.571,	7.56,	8773637),
(4,	'Iceland',	7.554,	7.504,	345393),
(5,	'Netherlands',	7.464,	7.449,	17211447),
(6,	'Norway',	7.392,	7.488,	5511370),
(7,	'Sweden',	7.363,	7.353,	10218971),
(8,	'Luxembourg',	7.324,	7.238,	642371),
(9,	'New Zealand',	7.277,	7.3,	4898203),
(10, 'Austria',	7.268,	7.294,	9066710)

select * from (select  *,
		case when country = 'Austria' then 3
		     when country = 'New Zealand' then 2
			 when country = 'Sweden' then 1
			 else 0
		end as custom_sort_order
from happiness_index)
order by custom_sort_order desc,happiness_2021 desc

--Find nth highest salary of employess
Create table nth_Employees
(
 id int primary key,
 FirstName varchar(50),
 LastName varchar(50),
 Gender varchar(50),
 Salary int
)

Insert into nth_Employees (id,FirstName,LastName,Gender,Salary) values (101,'Ben', 'Hoskins', 'Male', 70000)
Insert into nth_Employees (id,FirstName,LastName,Gender,Salary) values (102,'Mark', 'Hastings', 'Male', 60000)
Insert into nth_Employees (id,FirstName,LastName,Gender,Salary) values (103,'Steve', 'Pound', 'Male', 45000),
Insert into nth_Employees (id,FirstName,LastName,Gender,Salary) values (104,'Ben', 'Hoskins', 'Male', 70000),
Insert into nth_Employees (id,FirstName,LastName,Gender,Salary) values (105,'Philip', 'Hastings', 'Male', 45000),
Insert into nth_Employees (id,FirstName,LastName,Gender,Salary) values (106,'Mary', 'Lambeth', 'Female', 30000)
Insert into nth_Employees (id,FirstName,LastName,Gender,Salary) values (107,'Valarie', 'Vikings', 'Female', 35000)
Insert into nth_Employees (id,FirstName,LastName,Gender,Salary) values (108,'John', 'Stanmore', 'Male', 80000)

with rank_cte as
(select *,
       dense_rank() over (order by id) as dr
from nth_Employees) 
select * from rank_cte
where dr=3

--find out employess hired in last n moths
Create table lastn_Employees
(
     
     FirstName varchar(50),
     LastName varchar(50),
     Gender varchar(50),
     Salary int,
     HireDate timestamp
)


INSERT INTO lastn_Employees (ID,FirstName, LastName, Gender, Salary, HireDate) VALUES
(1, 'Steve', 'Pound', 'Male', 45000, '2014-04-20'),
(2, 'Ben', 'Hoskins', 'Male', 70000, '2014-04-05'),
(3, 'Philip', 'Hastings', 'Male', 45000, '2014-03-11'),
(4, 'Mary', 'Lambeth', 'Female', 30000, '2014-03-10'),
(5, 'Valarie', 'Vikings', 'Female', 35000, '2014-02-09'),
(6, 'John', 'Stanmore', 'Male', 80000, '2014-02-22'),
(7, 'Able', 'Edward', 'Male', 5000, '2014-01-22'),
(8, 'Emma', 'Nan', 'Female', 5000, '2014-01-14'),
(9, 'Jd', 'Nosin', 'Male', 6000, '2013-01-10'),
(10, 'Todd', 'Heir', 'Male', 7000, '2013-02-14'),
(11, 'San', 'Hughes', 'Male', 7000, '2013-03-15'),
(12, 'Nico', 'Night', 'Male', 6500, '2013-04-19'),
(13, 'Martin', 'Jany', 'Male', 5500, '2013-05-23'),
(14, 'Mathew', 'Mann', 'Male', 4500, '2013-06-23'),
(15, 'Baker', 'Barn', 'Male', 3500, '2013-07-23'),
(16, 'Mosin', 'Barn', 'Male', 8500, '2013-08-21'),
(17, 'Rachel', 'Aril', 'Female', 6500, '2013-09-14'),
(18, 'Pameela', 'Son', 'Female', 4500, '2013-10-14'),
(19, 'Thomas', 'Cook', 'Male', 3500, '2013-11-14'),
(20, 'Malik', 'Md', 'Male', 6500, '2013-12-14'),
(21, 'Josh', 'Anderson', 'Male', 4900, '2014-05-01'),
(22, 'Geek', 'Ging', 'Male', 2600, '2014-04-01'),
(23, 'Sony', 'Sony', 'Male', 2900, '2014-04-30'),
(24, 'Aziz', 'Sk', 'Male', 3800, '2014-03-01'),
(25, 'Amit', 'Naru', 'Male', 3100, '2014-03-31');

SELECT *,
    EXTRACT(DAY FROM (now() - HireDate)) AS days
FROM lastn_Employees
where EXTRACT(DAY FROM (now() - HireDate)) < 30

--Transpose rows into columns(pivoting)
Create Table Countries
(
 Country varchar(50),
 City varchar(50)
)

INSERT INTO Countries (Country, City) VALUES 
('USA', 'New York'),
('USA', 'Houston'),
('USA', 'Dallas'),
('India', 'Hyderabad'),
('India', 'Bangalore'),
('India', 'New Delhi'),
('UK', 'London'),
('UK', 'Birmingham'),
('UK', 'Manchester');

select * from countries

with city_rank as (
Select *,
	   row_number() over (partition by country order by city) as rn
from countries
)
select country,
	   Max(city) filter (where rn=1) as city1,
	   Max(city) filter (where rn=2) as city2,
	   Max(city) filter (where rn=3) as city3
from city_rank
group by country

--find department name with maximum number of employees
Create Table Departments
(
     DepartmentID int primary key,
     DepartmentName varchar(50)
)

Create Table dep_Employees
(
     EmployeeID int primary key,
     EmployeeName varchar(50),
     DepartmentID int
)

Insert into Departments (DepartmentID,DepartmentName) values (1, 'IT')
Insert into Departments (DepartmentID,DepartmentName) values (2, 'HR')
Insert into Departments (DepartmentID,DepartmentName) values (3, 'Payroll')

Insert into dep_Employees (EmployeeID,EmployeeName,DepartmentID) values (1, 'Mark', 1)
Insert into dep_Employees (EmployeeID,EmployeeName,DepartmentID)  values (2, 'John', 1)
Insert into dep_Employees (EmployeeID,EmployeeName,DepartmentID)  values (3, 'Mike', 1)
Insert into dep_Employees (EmployeeID,EmployeeName,DepartmentID) values (4, 'Mary', 2)
Insert into dep_Employees (EmployeeID,EmployeeName,DepartmentID) values (5, 'Stacy', 3)

with temp as
(Select departmentname,count(EmployeeID) as emp_count from dep_Employees e
inner join Departments dep
on dep.departmentid = e.departmentid
group by dep.departmentid) 
select departmentname from temp
where emp_count = (select max(emp_count) from temp)
('or')
Select departmentname from dep_Employees e
inner join Departments dep
on dep.departmentid = e.departmentid
group by dep.departmentid
order by count(*) desc
limit 1

select cast(now() as date) - INTERVAL '1 days'

--find most searched room type when comma seperated value is present
with airbnb_searches as (
Select 1 as user_id,'2022-01-01' as date_searched,'entire home,private room' as room_type
union all select 2 as user_id,'2022-01-02' as date_searched,'entire home,shared room' as room_type
union all select 3 as user_id,'2022-01-02' as date_searched,'private room,shared room' as room_type
union all select 4 as user_id,'2022-01-03' as date_searched,'private room' as room_type)
select 
		unnest(string_to_array(room_type,',')) as room_type,
		count(1) as no_of_searches
from airbnb_searches
group by unnest(string_to_array(room_type,','))
order by no_of_searches desc