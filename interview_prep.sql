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