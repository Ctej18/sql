--1) derive points table
with icc_world_cup as (
Select 'India' as Team1,'SL' as Team2,'India' as Winner
union all Select 'SL' as Team1,'Aus' as Team2,'Aus' as Winner
union all Select 'SA' as Team1,'Eng' as Team2,'Eng' as Winner
union all Select 'Eng' as Team1,'NZ' as Team2,'NZ' as Winner
union all Select 'Aus' as Team1,'India' as Team2,'India' as Winner
union all Select 'Eng' as Team1,'NZ' as Team2,'NZ' as Winner
)
Select  team_name,count(team_name) as matches_played,
		Sum(win_flag) as no_of_matches_won,
		Count(team_name) - Sum(win_flag) as no_of_matches_loss
from
(select team1 as team_name,
       case when team1 = winner then 1 else 0 end as win_flag
from icc_world_cup
union all
Select team2 as team_name,
       case when team2 = winner then 1 else 0 end as win_flag
from icc_world_cup)
group by team_name
order by no_of_matches_won desc

--find number of new and returning customers each day
with customer_orders as (
Select 1 as order_id,100 as customer_id, '2022-01-01' as order_date, 2000 as order_amount
union all Select 2 as order_id,200 as customer_id, '2022-01-01' as order_date, 2500 as order_amount
union all Select 3 as order_id,300 as customer_id, '2022-01-01' as order_date, 2100 as order_amount
union all Select 4 as order_id,100 as customer_id, '2022-01-02' as order_date, 2000 as order_amount
union all Select 5 as order_id,400 as customer_id, '2022-01-02' as order_date, 2200 as order_amount
union all Select 6 as order_id,500 as customer_id, '2022-01-02' as order_date, 2700 as order_amount
union all Select 7 as order_id,100 as customer_id, '2022-01-03' as order_date, 3000 as order_amount
union all Select 8 as order_id,400 as customer_id, '2022-01-03' as order_date, 1000 as order_amount
union all Select 9 as order_id,600 as customer_id, '2022-01-03' as order_date, 3000 as order_amount
),
first_date as (
select customer_id,min(order_date) as first_order_date from customer_orders
group by customer_id)
select co.order_date,
       Sum(case when order_date = first_order_date then 1 else 0 end) as new_customer_flag,
	   Sum(case when order_date != first_order_date then 1 else 0 end) as repeated_customer_flag
from customer_orders co
inner join first_date fd
on fd.customer_id = co.customer_id
group by co.order_date