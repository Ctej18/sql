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