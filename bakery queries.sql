show variables like 'local_infile';

set global local_infile = 1;


-- load the two tables

create table bakery_sales 
    (datetime varchar(50),
    `day of week` varchar(20),
    total int,
    place varchar(50),
    `Red Bean Butter Bread` int,
    `Plain bread` int,
    jam int,
    americano int,
    croissant int,
    `Caffe latte` int,
    `Tiramisu croissant` int,
    `Hot Chocolate` int,
    `Pain au chocolat` int,
    `Almond croissant` int,
    `Croque monsieur` int,
    `Garlic Bread` int,
    `Milk tea` int,
    `Chocolate Cake` int,
    pandoro int,
    `Cheese cake` int,
    lemonade int,
    `Orange pound` int,
    `Sausage Roll` int,
    `Vanilla Latte` int,
    `Berry ade` int,
    tiramisu int,
    `Meringue Cookies` int);

load data local infile 'C:/Users/Samuel/Downloads/Bakery Sales.csv'
into table bakery_sales
character set utf8mb4
fields terminated by ',' 
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

select *
from bakery_sales bs ;

create table bakery_price
    (name varchar(100),
    price int);

load data local infile 'C:/Users/Samuel/Downloads/Bakery price.csv'
into table bakery_price
character set utf8mb4
fields terminated by ',' 
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

-- bakery_sales table cleaning

select *
from bakery_price bp;

create table bakery_sales_staging
as
select *
from bakery_sales bs ;

select *
from bakery_sales_staging bss;

with cte_duplicates as (
    select `day of week`,row_number()over(partition by `datetime`,`day of week`,total,place,`Red Bean Butter Bread`,
    													 `Plain bread`,jam,americano,croissant,`Caffe latte`,`Tiramisu croissant`,
    													 `Hot Chocolate`,`Pain au chocolat`,`Almond croissant`,`Croque monsieur`,
    													 `Garlic Bread`,`Milk tea`,`Chocolate Cake`,pandoro,`Cheese cake`,lemonade,
    													 `Orange pound`,`Sausage Roll`,`Vanilla Latte`,`Berry ade`,tiramisu,`Meringue Cookies`
                 										  order by `datetime`)as row_num 
    													  from bakery_sales_staging)        
     select *
from cte_duplicates
where row_num > 1
order by row_num desc;   
        
create table bakery_sales_cleaned as
select *, 
       row_number() over(
           partition by `datetime`, `day of week`, total, place, `Red Bean Butter Bread`, `Plain bread`, jam,
                        americano, croissant, `Caffe latte`, `Tiramisu croissant`, `Hot Chocolate`, `Pain au chocolat`,
                        `Almond croissant`, `Croque monsieur`, `Garlic Bread`, `Milk tea`, `Chocolate Cake`, pandoro,
                        `Cheese cake`, lemonade, `Orange pound`, `Sausage Roll`, `Vanilla Latte`, `Berry ade`, tiramisu,
                        `Meringue Cookies` 
           order by `datetime`
       ) as row_num
from bakery_sales_staging;              
           
select *
from bakery_sales_cleaned bsc;

delete from bakery_sales_cleaned 
where row_num > 1;

drop table bakery_sales_staging;

rename table bakery_sales_cleaned to bakery_sales_staging;

alter table bakery_sales_staging 
drop column row_num;        
   
select *
from bakery_sales_staging bss;

select distinct `day of week`
from bakery_sales_staging bss;

update bakery_sales_staging bss 
set `day of week` =case
	when `day of week` like 'Mon%' then 'Monday'
	when `day of week` like 'Tue%' then 'Tuesday'
	when `day of week` like 'Wen%' then 'Wednesday'
	when `day of week` like 'Thur%' then 'Thursday'
	when `day of week` like 'Fri%' then 'Friday'
	when `day of week` like 'Sat%' then 'Saturday'
	when `day of week` like 'Sun%' then 'Sunday'
	else `day of week`
end;

select distinct(place)
from bakery_sales_staging bss ;

update bakery_sales_staging
set place = case 
    when place = 'new york'       then 'New York'
    when place = 'north carolina' then 'North Carolina'
    when place = 'los angeles'    then 'Los Angeles'
    when place = 'long island'    then 'Long Island'
   else concat(upper(substring(place, 1, 1)), lower(substring(place, 2)))
end
where place is not null and place != '';		                             

select 
    sum(case when datetime is null then 1 else 0 end) as datetime_nulls,
    sum(case when `day of week` is null or trim(`day of week`) = '' then 1 else 0 end) as day_of_week_nulls_or_blanks,
    sum(case when total is null then 1 else 0 end) as total_nulls,
    sum(case when place is null or trim(place) = '' then 1 else 0 end) as place_nulls_or_blanks
from bakery_sales_staging bss;

update bakery_sales_staging
set place = 'Unknown'
where place is null 
   or trim(place) = '';

select	
    sum(case when `Red Bean Butter Bread` is null then 1 else 0 end) as red_bean_butter_bread_nulls,
    sum(case when `Plain bread` is null then 1 else 0 end) as plain_bread_nulls,
    sum(case when jam is null then 1 else 0 end) as jam_nulls,
    sum(case when americano is null then 1 else 0 end) as americano_nulls,
    sum(case when croissant is null then 1 else 0 end) as croissant_nulls
from bakery_sales_staging;

select *
from bakery_sales_staging bss ;

select 
    `datetime` as raw_datetime,
    length(`datetime`) as datetime_char_length,
    `day of week` as raw_day,
    length(`day of week`) as day_char_length
from bakery_sales_staging
limit 5;

select 
    sum(case when datetime is null or trim(datetime) = '' then 1 else 0 end) as datetime_blanks_or_nulls,
    sum(case when `day of week` is null or trim(`day of week`) = '' then 1 else 0 end) as day_of_week_blanks_or_nulls
from bakery_sales_staging;

update bakery_sales_staging
set 
    datetime = case when datetime is null or trim(datetime) = '' then 'Unknown' else datetime end,
    `day of week` = case when `day of week` is null or trim(`day of week`) = '' then 'Unknown' else `day of week` end;

select *
from bakery_sales_staging bss ;


-- bakery_price dataset


select *
from bakery_price bp ;

create table bakery_price_staging
as
select *
from bakery_price bp ;

with cte_duplicates as 
	(select price,row_number() over(partition by name,price order by price)
	 as row_num 
	 from bakery_price_staging)									
 select *
 from cte_duplicates
 where row_num > 1
 order by row_num desc;

select *
from bakery_price_staging bps ;

select distinct(name)
from bakery_price_staging bps ;

select name as original_name,
       concat(upper(substring(trim(name), 1, 1)), lower(substring(trim(name), 2))) as capitalized_and_trimmed
from bakery_price_staging;

update bakery_price_staging
set name = concat(upper(substring(name, 1, 1)),lower(substring(name, 2)));


-- create a one final table from the two tables

drop table if exists final_bakery_sales;

create table final_bakery_sales as
with unpivoted as (
    select 
        s.datetime as transaction_time,
        s.`day of week` as day_of_week,
        s.place as store_location,
        p.name as product_name,
        p.price as unit_price,
        cast(
            case p.name
                when 'Red Bean Butter Bread' then s.`Red Bean Butter Bread`
                when 'Plain bread'           then s.`Plain bread`
                when 'jam'                   then s.jam
                when 'americano'             then s.americano
                when 'croissant'             then s.croissant
                when 'Caffe latte'           then s.`Caffe latte`
                when 'Tiramisu croissant'    then s.`Tiramisu croissant`
                when 'Hot Chocolate'         then s.`Hot Chocolate`
                when 'Pain au chocolat'      then s.`Pain au chocolat`
                when 'Almond croissant'      then s.`Almond croissant`
                when 'Croque monsieur'       then s.`Croque monsieur`
                when 'Garlic Bread'          then s.`Garlic Bread`
                when 'Milk tea'              then s.`Milk tea`
                when 'Chocolate Cake'        then s.`Chocolate Cake`
                when 'pandoro'               then s.pandoro
                when 'Cheese cake'           then s.`Cheese cake`
                when 'lemonade'              then s.lemonade
                when 'Orange pound'          then s.`Orange pound`
                when 'Sausage Roll'          then s.`Sausage Roll`
                when 'Vanilla Latte'         then s.`Vanilla Latte`
                when 'Berry ade'             then s.`Berry ade`
                when 'tiramisu'              then s.tiramisu
                when 'Meringue Cookies'      then s.`Meringue Cookies`
            end as signed
        ) as quantity_sold
    from bakery_sales_staging s
    cross join bakery_price_staging p
)
select 
    transaction_time,
    day_of_week,
    store_location,
    product_name,
    unit_price,
    quantity_sold
from unpivoted
where quantity_sold > 0;

select *
from final_bakery_sales fbs ;
