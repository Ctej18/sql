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