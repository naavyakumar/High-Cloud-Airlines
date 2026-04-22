create database project;
use project;

select * from airlinesql;
select count(month) from airlinesql;
describe airlinesql;

describe `distance groups`;

-- load factor by year
select year,
concat(round(load_factor/sum(load_factor) over() *100,2),'%') as load_factor
from(
select year,
ifnull(sum(transported_passengers/available_seats),0) as load_factor 
from airlinesql group by year) as t;

-- load factor by month
select month_name,
concat(round(load_factor/sum(load_factor) over() *100,2),'%') as load_factor
from(
select month,MONTHNAME(STR_TO_DATE(`date`, '%d/%m/%Y')) AS month_name,
ifnull(sum(transported_passengers/available_seats),0) as load_factor 
from airlinesql group by month,MONTHNAME(STR_TO_DATE(`date`, '%d/%m/%Y'))) as t order by month;

-- load factor by quater
alter table airlinesql add quater varchar(20);

update airlinesql set quater=concat('Q',CEILING(month/3));

SET SQL_SAFE_UPDATES = 0;

select quater,
concat(round(load_factor/sum(load_factor) over() *100,2),'%') as load_factor
from(
select quater,
ifnull(sum(transported_passengers/available_seats),0) as load_factor 
from airlinesql group by quater) as t;

-- loadfactor by weekname
select weekname,
concat(round(load_factor/sum(load_factor) over() *100,2),'%') as load_factor
from(
select weekname,
ifnull(sum(transported_passengers/available_seats),0) as load_factor 
from airlinesql group by weekname) as t;

-- loadfactor by carrier name
select carrier_name,
concat(round(load_factor/sum(load_factor) over() *100,2),'%') as load_factor
from(
select carrier_name,
ifnull(sum(transported_passengers/available_seats),0) as load_factor 
from airlinesql group by carrier_name order by load_factor desc limit 5) as t ;

-- carrier wise passenger preference
select carrier_name ,concat(round(sum(transported_passengers)/1000000,2),'M') as total_passengers from airlinesql
group by carrier_name with rollup order by sum(transported_passengers) desc limit 10;

-- distance group
select `Distance Interval` ,concat(round(sum(departure_performed)/1000000,2),'M') as number_of_flights  from airlinesql as a   
join `distance groups` as d on d.`ï»¿%Distance Group ID`=a.`ï»¿distance_id` group by `Distance Interval` 
order by count(`ï»¿distance_id`) desc;

-- top 10 routes
select `from _to_city` , concat(round(sum(departure_performed)/1000,2),'k') as total_flights from airlinesql
group by `from _to_city` order by sum(departure_performed) desc limit 10;
