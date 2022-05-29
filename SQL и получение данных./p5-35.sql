select concat_ws(':', date_part('days', ('29/11/2021 19:05:00'::timestamp - '29/11/2020 9:25:00'::timestamp))*24,
date_part('minutes', ('29/11/2021 19:05:00'::timestamp - '29/11/2020 9:25:00'::timestamp)),
date_part('seconds', ('29/11/2021 19:05:00'::timestamp - '29/11/2020 9:25:00'::timestamp)))

group by
order by

FROM
ON
JOIN
WHERE
GROUP BY
WITH CUBE или WITH ROLLUP
HAVING
SELEC   OVER  T
DISTINCT
ORDER by


============= оконные функции =============

1. Вывести ФИО пользователя и название третьего фильма, который он брал в аренду.
* В подзапросе получите порядковые номера для каждого пользователя по дате аренды
* Задайте окно с использованием предложений over, partition by и order by
* Соедините с customer
* Соедините с inventory
* Соедините с film
* В условии укажите 3 фильм по порядку

explain analyse --2129
select r.customer_id, f.title
from (
	select customer_id, array_agg(rental_id)
	from (
		select *
		from rental
		order by customer_id, rental_date) t
	group by customer_id) t
join rental r on t.customer_id = r.customer_id and r.rental_id = t.array_agg[3]
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id

explain analyse --2108
select t.customer_id, f.title
from (
	select *, row_number() over (partition by customer_id order by rental_date)
	from rental) t
join inventory i on i.inventory_id = t.inventory_id
join film f on f.film_id = i.film_id
where t.row_number = 3

1.1. Выведите таблицу, содержащую имена покупателей, арендованные ими фильмы и средний платеж 
каждого покупателя
* используйте таблицу customer
* соедините с paymen
* соедините с rental
* соедините с inventory
* соедините с film
* avg - функция, вычисляющая среднее значение
* Задайте окно с использованием предложений over и partition by

select c.last_name, f.title, 
	avg(p.amount) over (partition by c.customer_id), 
	sum(p.amount) over (partition by c.customer_id), 
	max(p.amount) over (partition by c.customer_id), 
	min(p.amount) over (partition by c.customer_id), 
	count(p.amount) over (partition by c.customer_id)
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id

select c.last_name, f.title, avg(p.amount) 
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id
group by c.customer_id, f.film_id

select c.customer_id, f.film_id, p.amount
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id

select c.last_name, f.title, date_trunc('month', p.payment_date),
	sum(p.amount) over (partition by c.customer_id), 
	count(r.rental_id) over (partition by c.customer_id),
	sum(p.amount) over (), 
	count(r.rental_id) over (),
	sum(p.amount) over (partition by c.customer_id, date_trunc('month', p.payment_date)), 
	count(r.rental_id) over (partition by c.customer_id, date_trunc('month', r.rental_date))
from customer c
join payment p on p.customer_id = c.customer_id
join rental r on r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
join film f on f.film_id = i.film_id

-- демонстрация агрегатных функций

-- работа функций lead и lag
select customer_id, payment_date,
	lag(amount) over (partition by customer_id order by payment_date),
	amount,
	lead(amount) over (partition by customer_id order by payment_date)
from payment 

select customer_id, payment_date,
	lag(amount, 3) over (partition by customer_id order by payment_date),
	amount,
	lead(amount, 3) over (partition by customer_id order by payment_date)
from payment 

select customer_id, payment_date,
	lag(amount, 3, 0.) over (partition by customer_id order by payment_date),
	amount,
	lead(amount, 3, 0.) over (partition by customer_id order by payment_date)
from payment 

1. дата вылета | дата прилета 
2. дата вылета | дата прилета 

lead(дата вылета 2) - дата прилета 1

select date_trunc('month', payment_date), sum(amount),
sum(amount) - lag(sum(amount), 1, 0.) over (order by date_trunc('month', payment_date))
from payment 
group by date_trunc('month', payment_date)

-- формирование накопительного итога
select customer_id, payment_date, amount,
	sum(amount) over (partition by customer_id order by payment_date)
from payment 

select customer_id, payment_date, amount,
	avg(amount) over (partition by customer_id order by payment_date)
from payment 

select customer_id, payment_date::date, amount,
	sum(amount) over (partition by customer_id order by payment_date::date)
from payment 

select customer_id, payment_date::date, amount,
	sum(amount) over (partition by customer_id order by payment_date::date rows current row)
from payment 

select customer_id, payment_date::date, amount,
	sum(amount) over (partition by customer_id, date_trunc('month', payment_date) order by payment_date)
from payment 

select distinct staff_id, payment_date::date, 
	sum(amount) over (partition by staff_id order by payment_date::date)
from payment 

select customer_id, payment_date::date, amount,
	sum(amount) filter (where customer_id < 100) over (partition by customer_id order by payment_date),
	sum(amount) filter (where customer_id > 100) over (partition by customer_id order by payment_date)
from payment 

-- работа с рангами и порядковыми номерами
select customer_id, payment_date,
	row_number() over (partition by customer_id order by date_trunc('month', payment_date)),
	rank() over (partition by customer_id order by date_trunc('month', payment_date)),
	dense_rank() over (partition by customer_id order by date_trunc('month', payment_date))
from payment 

-- last_value / first_value

select customer_id, max(rental_date)
from rental 
group by customer_id

select r.*
from (
	select rental_id, customer_id, max(rental_date) over (partition by customer_id)
	from rental) t
join rental r on r.rental_id = t.rental_id and r.rental_date = t.max

select *
from (
	select *, 
		row_number() over (partition by customer_id order by rental_date desc)
	from rental) t
where row_number = 1

select *
from (
	select *, 
		first_value(rental_date) over (partition by customer_id order by rental_date desc)
	from rental) t
where rental_date = first_value 

select *
from (
	select customer_id, rental_date, 
		last_value(rental_date) over (partition by customer_id order by rental_date)
	from rental) t

select customer_id, rental_date, 
	last_value(rental_date) over (partition by customer_id)
from (
	select * 
	from rental
	order by customer_id, rental_date) t

select *
from (
	select customer_id, rental_date, 
		last_value(rental_date) over (partition by customer_id order by rental_date
		rows between unbounded preceding and unbounded following)
	from rental) t

============= общие табличные выражения =============

2.  При помощи CTE выведите таблицу со следующим содержанием:
Название фильма продолжительностью более 3 часов и к какой категории относится фильм
* Создайте CTE:
 - Используйте таблицу film
 - отфильтруйте данные по длительности
 * напишите запрос к полученной CTE:
 - соедините с film_category
 - соедините с category

with c1 as (
	select film_id, title
	from film 
	where length > 180
), c2 as (
	select fc.film_id, c1.title, fc.category_id
	from film_category fc
	join c1 on c1.film_id = fc.film_id
), c3 as (
	select c2.title, c.name
	from category c
	join c2 on c2.category_id = c.category_id
)
select *
from c3

2.1. Выведите фильмы, с категорией начинающейся с буквы "C"
* Создайте CTE:
 - Используйте таблицу category
 - Отфильтруйте строки с помощью оператора like 
* Соедините полученное табличное выражение с таблицей film_category
* Соедините с таблицей film
* Выведите информацию о фильмах:
title, category."name"

select version()

explain analyze --93.03 / 90.33
with c1 as (
	with c2 as (
		select c.category_id, c."name"
		from category c
		where left(name, 1) = 'C'
	)
	select c2."name", fc.film_id
	from c2 
	join film_category fc on fc.category_id = c2.category_id
)
select f.title, c1.name
from c1 
join film f on f.film_id = c1.film_id

 ============= общие табличные выражения (рекурсивные) =============
 
 3.Вычислите факториал
 + Создайте CTE
 * стартовая часть рекурсии (т.н. "anchor") должна позволять вычислять начальное значение
 *  рекурсивная часть опираться на данные с предыдущей итерации и иметь условие останова
 + Напишите запрос к CTE

with recursive r as (
	--стартовая часть 
	select 1 as i, 1 as factorial
	union 
	--рекурсивная часть
	select i + 1 as i, factorial * (1 + i) as factorial
	from r 
	where i < 10
)
select *
from r

create table geo ( 
	id int primary key, 
	parent_id int references geo(id), 
	name varchar(1000) );

insert into geo (id, parent_id, name)
values 
	(1, null, 'Планета Земля'),
	(2, 1, 'Континент Евразия'),
	(3, 1, 'Континент Северная Америка'),
	(4, 2, 'Европа'),
	(5, 4, 'Россия'),
	(6, 4, 'Германия'),
	(7, 5, 'Москва'),
	(8, 5, 'Санкт-Петербург'),
	(9, 6, 'Берлин');

select * from geo
order by id

with recursive r as (
	--стартовая часть 
	select id, parent_id, name, 1 as level
	from geo
	where id = 5
	union 
	--рекурсивная часть
	select geo.id, geo.parent_id, geo.name, level + 1 as level
	from r 
	join geo on geo.id = r.parent_id
)
select *
from r
where level < 3

with recursive r as (
	--стартовая часть 
	select id, parent_id, name, 1 as level
	from geo
	where id = 5
	union 
	--рекурсивная часть
	select geo.id, geo.parent_id, geo.name, level + 1 as level
	from r 
	join geo on geo.parent_id = r.id
)
select *
from r

with recursive r as (
	--стартовая часть 
	select unit_id, parent_id, unit_type, unit_title, 1 as level
	from structure
	where unit_id = 59
	union 
	--рекурсивная часть
	select s.unit_id, s.parent_id, s.unit_type, s.unit_title, level + 1 as level
	from r 
	--join structure s on s.parent_id = r.unit_id
	join structure s on r.parent_id = s.unit_id
)
select *
from r

select * from "structure" s

3.2 Работа с рядами.

explain analyze --3.57
with recursive r as (
	--стартовая часть 
	select '01.01.2021'::date as x
	union 
	--рекурсивная часть
	select x + 1
	from r 
	where x < '31.01.2021'::date
)
select *
from r

explain analyze --25.02
select (generate_series('01.01.2021'::date, '31.01.2021'::date, interval '1 day'))::date

select generate_series(1, 1000, 19)

Есть исходные данные:
create table test (
	date_event timestamp,
	field varchar(50),
	old_value varchar(50),
	new_value varchar(50)
)

insert into test (date_event, field, old_value, new_value)
values
('2017-08-05', 'val', 'ABC', '800'),
('2017-07-26', 'pin', '', '10-AA'),
('2017-07-21', 'pin', '300-L', ''),
('2017-07-26', 'con', 'CC800', 'null'),
('2017-08-11', 'pin', 'EKH', 'ABC-500'),
('2017-08-16', 'val', '990055', '100')

select * from test order by date(date_event)

В данной таблице хранят информацию по изменению "статуса" для каждого типа поля (field ). 
То есть, есть поле pin, на 21.07.2017 было изменено значение, соответственно новое (new_value ) стало '' (пустая строка) и старое  (old_value), записалось как '300-L'.
Далее 26.07.2017 изменили значение с '' (пустая строка) на '10-AA'. И так по разным полям в разные даты были какие-то изменения значений.

Задача: составить запрос таким образом, что бы в новой результирующей таблице был календарь изменения значений для каждого поля. 
Всего три столбца: дата, поле, текущий статус.
То есть для каждого поля будет отображение каждого дня с отображением текущего статуса. К примеру, для поля pin на 21.07.2017 статус будет  '' (пустая строка), на 22.07.2017 -  '' (пустая строка). и т.д. до 26.07.2017, где статус станет '10-AA'

Решение должно быть универсальным для любого SQL, не только под PostgreSQL ;)

explain analyze --8 146 723 / 10 229
select
	gs::date as change_date,
	fields.field as field_name,
	case 
		when (
			select new_value 
			from test t 
			where t.field = fields.field and t.date_event = gs::date) is not null 
			then (
				select new_value 
				from test t 
				where t.field = fields.field and t.date_event = gs::date)
		else (
			select new_value 
			from test t 
			where t.field = fields.field and t.date_event < gs::date 
			order by date_event desc 
			limit 1) 
	end as field_value
from 
	generate_series((select min(date(date_event)) from test), (select max(date(date_event)) from test), interval '1 day') as gs, 
	(select distinct field from test) as fields
order by 
	field_name, change_date
	
explain analyze --93 000 / 1 735
select
	distinct field, gs, first_value(new_value) over (partition by value_partition)
from
	(select
		t2.*,
		t3.new_value,
		sum(case when t3.new_value is null then 0 else 1 end) over (order by t2.field, t2.gs) as value_partition
	from
		(select
			field,
			generate_series((select min(date_event)::date from test), (select max(date_event)::date from test), interval '1 day')::date as gs
		from test) as t2
	left join test t3 on t2.field = t3.field and t2.gs = t3.date_event::date) t4
order by 
	field, gs

explain analyze --2 616 / 42
with recursive r(a, b, c) as (
    select temp_t.i, temp_t.field, t.new_value
    from 
	    (select min(date(t.date_event)) as i, f.field
	    from test t, (select distinct field from test) as f
	    group by f.field) as temp_t
    left join test t on temp_t.i = t.date_event and temp_t.field = t.field
    union all
    select a + 1, b, 
    	case 
    		when t.new_value is null then c
    		else t.new_value
		end
    from r  
    left join test t on t.date_event = a + 1 and b = t.field
    where a < (select max(date(date_event)) from test)
)    
SELECT *
FROM r
order by b, a

select 93000/385

explain analyze -- 385 / 17.32
with recursive r as (
 	--стартовая часть рекурсии
 	 	select
 	     	min(t.date_event) as c_date
		   ,max(t.date_event) as max_date
	from test t
	union
	-- рекурсивная часть
	select
	     r.c_date+ INTERVAL '1 day' as c_date
	    ,r.max_date
	from r
	where r.c_date < r.max_date
 ),
t as (select t.field
		, t.new_value
		, t.date_event
		, case when lead(t.date_event) over (partition by t.field order by t.date_event) is null
			   then max(t.date_event) over ()
			   else lead(t.date_event) over (partition by t.field order by t.date_event)- INTERVAL '1 day'
		  end	  
			   as next_date
		, min (t.date_event) over () as min_date
		, max(t.date_event) over () as max_date	  
from (
select t1.date_event ,t1.field ,t1.new_value ,t1.old_value
from test t1
union all
select distinct min (t2.date_event) over () as date_event --первые стартовые даты
		,t2.field ,null as new_value ,null as old_value
from test t2) t
)
select r.c_date, t.field , t.new_value
from r
join t on r.c_date between t.date_event and t.next_date
order by t.field,r.c_date