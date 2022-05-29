select table_name, constraint_name
from information_schema.table_constraints 
where constraint_schema = 'public' and constraint_type = 'PRIMARY KEY'

Задание 1. Выведите одним запросом информацию о фильмах, у которых рейтинг “R” 
и стоимость аренды указана от 0.00 до 3.00 включительно, а также фильмы c рейтингом 
“PG-13” и стоимостью аренды больше или равной 4.00.
Ожидаемый результат запроса: https://ibb.co/Dk4PjJn

explain analyze --77.5
select title, rating, rental_rate
from film 
where (rating = 'R' and rental_rate between 0. and 3.) or 
	(rating = 'PG-13' and rental_rate >= 4.)

explain analyze --148.11
select title, rating, rental_rate
from film 
where rating = 'R' and rental_rate between 0. and 3. 
union 
select title, rating, rental_rate
from film 
where rating = 'PG-13' and rental_rate >= 4.

Задание 2. Получите информацию о трёх фильмах с самым длинным описанием фильма.
Ожидаемый результат запроса: https://ibb.co/pfMHBs0


select title, description 
from film 
order by character_length(description) desc
limit 3

select title, character_length(description) 
from film 
order by 2 desc
limit 3

Задание 3. Выведите Email каждого покупателя, разделив значение Email на 2 отдельных 
колонки: в первой колонке должно быть значение, указанное до @, во второй колонке должно 
быть значение, указанное после @.
Ожидаемый результат запроса: https://ibb.co/SJng6qd

select concat(last_name, ' ', first_name), email, 
	split_part(email, '@', 1), split_part(email, '@', 2)
from customer 

select concat('Hello', ' ', 'world')

select 'Hello' || ' ' || null

select concat_ws(' ', 'Hello', 'world', 'Max', 'moon')

select split_part('Hello world Max moon', ' ', 1), 
	split_part('Hello world Max moon', ' ', 2), 
	split_part('Hello world Max moon', ' ', 3), 
	split_part('Hello world Max moon', ' ', 4)

Задание 4. Доработайте запрос из предыдущего задания, скорректируйте значения в новых 
колонках: первая буква должна быть заглавной, остальные строчными.
Ожидаемый результат запроса: https://ibb.co/vv0k9b6

select concat(last_name, ' ', first_name), email, 
	initcap(split_part(email, '@', 1)), initcap(split_part(email, '@', 2))
from customer 

explain analyze --37.45
select concat(last_name, ' ', first_name), email, 
	concat(upper(left(split_part(email, '@', 1), 1)), lower(substring(split_part(email, '@', 1), 2))),
	concat(upper(left(split_part(email, '@', 2), 1)), lower(substring(split_part(email, '@', 2), 2)))
from customer 

explain analyze --34.46
select concat(last_name, ' ', first_name), email, 
	overlay(lower(split_part(email, '@', 1)) 
		placing upper(left(split_part(email, '@', 1), 1)) from 1 for 1),
	overlay(lower(split_part(email, '@', 2)) 
		placing upper(left(split_part(email, '@', 2), 1)) from 1 for 1)
from customer 

explain analyze --35.96
select split_part(concat(upper(left(email, 1)), lower(right(email, -1))), '@', 1) "Customer name", 
concat(upper(left(split_part(email, '@', 2), 1)), right(email, (length(split_part(email, '@', 2)) - 1))) "Domain"
from customer c

select title, array_length(regexp_split_to_array(description, '\s+'), 1)
from film 

select upper(description), lower('HELLO')
from film

3 дня 12 часов сделать 3.5

select '3 days 12:00:00'::interval

select date_part('days', '3 days 12:25:00'::interval) +
	date_part('hours', '3 days 12:25:00'::interval)/24 + 
	date_part('minutes', '3 days 12:25:00'::interval)/1440
	
select date_part('epoch', '3 days 12:25:00'::interval)

select 60*24

select '21/11/2021 20:00:00'::timestamp - '18/11/2021 16:00:00'::timestamp

select '21/11/2021'::date - '18/11/2021'::date


select ….
from a
left join b on a.1=b.1
inner join c on c1=b.1

select title, character_length(description), description
from film 
order by character_length(description)
