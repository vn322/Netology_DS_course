============= теория =============

create table table_one (
	name_one varchar(255) not null
);

create table table_two (
	name_two varchar(255) not null
);

insert into table_one (name_one)
values ('one'), ('two'), ('three'), ('four'), ('five');

insert into table_two (name_two)
values ('four'), ('five'), ('six'), ('seven'), ('eight');

select * from table_one;

select * from table_two;

--left, right, inner, full outer, cross

select t1.name_one, t2.name_two
from table_one t1 
join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1 
inner join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1 
left join table_two t2 on t1.name_one = t2.name_two

select count(1)
from customer c 
join address a on a.address_id = c.address_id

select count(1)
from customer c 
left join address a on a.address_id = c.address_id

select t1.name_one, t2.name_two
from table_one t1 
right join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1 
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select t1.name_one, t2.name_two
from table_one t1 
cross join table_two t2 

select c1.first_name, c2.first_name
from customer c1, customer c2
where c1.first_name != c2.first_name

select c1.first_name, c2.first_name
from customer c1, customer c2
where c1.first_name > c2.first_name

select t1.name_one, t2.name_two
from table_one t1, table_two t2 
where t1.name_one = t2.name_two

cross join - inner join - left / right- full

delete from table_one;
delete from table_two;

insert into table_one (name_one)
select unnest(array[1,1,2])

insert into table_two (name_two)
select unnest(array[1,1,3])

select * from table_one

select * from table_two

select t1.name_one, t2.name_two
from table_one t1 
join table_two t2 on t1.name_one = t2.name_two

1A	1B
1a	1b
2c	3d

1A1B
1A1b
1a1B
1a1b

select count(1)
from customer c
join rental r on r.customer_id = c.customer_id
join payment p on p.customer_id = c.customer_id and p.rental_id = r.rental_id

select count(1)
from customer c
join rental r on r.customer_id = c.customer_id
join payment p on p.rental_id = r.rental_id

select count(1)
from payment p    --r 16044 p 16049 

select t1.name_one, t2.name_two
from table_one t1 
left join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1 
right join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1 
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select t1.name_one, t2.name_two
from table_one t1 
cross join table_two t2 

--union / except

select 1 as x, 1 as y
union 
select 2 as x, 3 as y

select 1 as x, 1 as y
union --distinct
select 1 as x, 1 as y

select 1 as x, 1 as y
union all
select 1 as x, 1 as y

select 1 as x, 1 as y
union 
select 2 as x, 3 as y
union
select 1 as x, 1 as y
union --distinct
select 1 as x, 1 as y
union all
select 1 as x, 1 as y
union all
select 1 as x, 1 as y

select 1 as x, 1 as y
except
select 2 as x, 3 as y

select * from (
select 1 as x, 1 as y
union all
select 1 as x, 3 as y
union all
select 1 as x, 3 as y
union all
select 1 as x, 1 as y) t
except
select * from (
select 1 as x, 1 as y
union all
select 1 as x, 3 as y
union all
select 1 as x, 1 as y) t2

select * from (
select 1 as x, 1 as y
union all
select 1 as x, 3 as y
union all
select 1 as x, 3 as y
union all
select 1 as x, 1 as y) t
except all
select * from (
select 1 as x, 1 as y
union all
select 1 as x, 3 as y
union all
select 1 as x, 1 as y) t2

-- case
select t1.name_one, t2.name_two
from table_one t1 
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null



select 
	case 
		when t1.name_one is null then t2.name_two
		when t2.name_two is null then t1.name_one
		else 'Что-то пошло не так'
	end 
from table_one t1 
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null


============= соединения =============

1. Выведите список названий всех фильмов и их языков (таблица language)
* Используйте таблицу film
* Соедините с language
* Выведите информацию о фильмах:
title, language."name"

select f.title, l."name"
from film f
join "language" l on l.language_id = f.language_id

select f.title, l."name", c.last_name, c.first_name
from film f
join "language" l on l.language_id = f.language_id
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
join customer c on c.customer_id = r.customer_id

explain analyze 
select f.title, l."name", c.last_name, c.first_name
from film f
left join "language" l on l.language_id = f.language_id
left join inventory i on i.film_id = f.film_id
left join rental r on r.inventory_id = i.inventory_id
left join customer c on c.customer_id = r.customer_id

film - language 
	 - inventory - rental - customer	
	 
(((inventory - rental) - film) - language) - customer		

1.1 Выведите все фильмы и их категории:
* Используйте таблицу film
* Соедините с таблицей film_category
* Соедините с таблицей category
* Соедините используя оператор using

select f.title, c."name"
from film f
join film_category fc on f.film_id = fc.film_id
join category c on c.category_id = fc.category_id

2. Выведите список всех актеров, снимавшихся в фильме Lambs Cincinatti (film_id = 508). 
* Используйте таблицу film
* Соедините с film_actor
* Соедините с actor
* Отфильтруйте, используя where и "title like" (для названия) или "film_id =" (для id)

explain analyze
select f.title, a.last_name, a.first_name
from film f
join film_actor fa on f.film_id = fa.film_id
join actor a on a.actor_id = fa.actor_id
where f.film_id = 508

explain analyze
select f.title, a.last_name, a.first_name
from film f
join film_actor fa on f.film_id = fa.film_id and f.film_id = 508
join actor a on a.actor_id = fa.actor_id


2. Выведите уникальный список фильмов, которые брали в аренду '24-05-2005'. 
* Используйте таблицу film
* Соедините с inventory
* Соедините с rental
* Отфильтруйте, используя where 

select distinct title
from film f
join inventory i on i.film_id = f.film_id
join rental r on r.inventory_id = i.inventory_id
where r.rental_date::date = '24-05-2005'

2.1 Выведите все магазины из города Woodridge (city_id = 576)
* Используйте таблицу store
* Соедините таблицу с address 
* Соедините таблицу с city 
* Соедините таблицу с country 
* отфильтруйте по "city_id"
* Выведите полный адрес искомых магазинов и их id:
store_id, postal_code, country, city, district, address, address2, phone

select store_id, postal_code, country, city, district, address, address2, phone
from store s
join address a using(address_id)
join city c using(city_id)
join country c2 using(country_id)
where city_id = 576

============= агрегатные функции =============

FROM
ON
JOIN
WHERE
GROUP by --знает, но не в каждой СУБД это реализовано
WITH CUBE или WITH ROLLUP
HAVING
select --алиасы 
DISTINCT
ORDER by

3. Подсчитайте количество актеров в фильме Grosse Wonderful (id - 384)
* Используйте таблицу film
* Соедините с film_actor
* Отфильтруйте, используя where и "film_id" 
* Для подсчета используйте функцию count, используйте actor_id в качестве выражения внутри функции
* Примените функцильные зависимости

select count(1)
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
where f.film_id = 384

select count(*)
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
where f.film_id = 384

select count('Считаем что-то странное')
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
where f.film_id = 384

select count(a.actor_id)
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
where f.film_id = 384

select count(address_id)
from customer 

select count(distinct customer_id)
from customer 

--select count(paiment_id) as Количество фильмов

select count(distinct a.actor_id)
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id

select f.title, count(a.actor_id), f.rental_rate, f.release_year, f.language_id
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
group by f.title, f.rental_rate, f.release_year, f.language_id

select f.title, count(a.actor_id), f.rental_rate, f.release_year, f.language_id
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
group by f.film_id

select c.last_name, c.first_name
from customer c
group by c.customer_id

select f.title, count(a.actor_id), f.rental_rate, f.release_year
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
group by f.film_id, f.release_year, f.rental_rate

select f.title, count(a.actor_id), f.rental_rate, f.release_year, fa.film_id
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
group by f.film_id, fa.film_id

select f.title, count(a.actor_id), string_agg(concat(a.last_name, ' ', a.first_name), ', ')
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
group by f.film_id

array_agg()

select f.title, a.last_name, count(a.actor_id)
from film f
join film_actor fa on fa.film_id = f.film_id
join actor a on a.actor_id = fa.actor_id
group by f.film_id, a.last_name

select sum(amount) filter (where date_trunc('month', payment_date) = '01/05/2005'),
	sum(amount) filter (where amount < 1)
from payment 


select sum(amount)
from payment 
where amount < 1 and date_trunc('month', payment_date) = '01/05/2005'


select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 4
group by customer_id, staff_id, date_trunc('month', payment_date)
order by 1,2,3

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 4
group by grouping sets (customer_id, staff_id, date_trunc('month', payment_date))
order by 1,2,3

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 4
group by cube(customer_id, staff_id, date_trunc('month', payment_date))
order by 1,2,3

select customer_id, staff_id, date_trunc('month', payment_date), sum(amount)
from payment 
where customer_id < 4
group by rollup(customer_id, staff_id, date_trunc('month', payment_date))
order by 1,2,3

3.1 Посчитайте среднюю стоимость аренды за день по всем фильмам
* Используйте таблицу film
* Стоимость аренды за день rental_rate/rental_duration
* avg - функция, вычисляющая среднее значение
--4 агрегации

select avg(rental_rate/rental_duration),
	min(rental_rate/rental_duration),
	max(rental_rate/rental_duration),
	sum(rental_rate/rental_duration),
	count(rental_rate/rental_duration)
from film 

============= группировки =============

4. Выведите месяцы, в которые было сдано в аренду более чем на 10 000 у.е.

* Используйте таблицу payment
* Сгруппируйте данные по месяцу используя date_trunc
* Для каждой группы посчитайте сумму платежей
* Воспользуйтесь фильтрацией групп, для выбора месяцев с суммой продаж более чем на 10 000 у.е.

select date_trunc('month', payment_date), sum(amount)
from payment 
group by date_trunc('month', payment_date)
having sum(amount) > 10000

select date_trunc('month', payment_date), sum(amount)
from payment 
group by 1
having sum(amount) > 10000

4.1 Выведите список категорий фильмов, средняя продолжительность аренды которых более 5 дней
* Используйте таблицу film
* Соедините с таблицей film_category
* Соедините с таблицей category
* Сгруппируйте полученную таблицу по category.name
* Для каждой группы посчитайте средню продолжительность аренды фильмов
* Воспользуйтесь фильтрацией групп, для выбора категории со средней продолжительностью > 5 дней

select c."name"
from film f
join film_category fc on f.film_id = fc.film_id
join category c on c.category_id = fc.category_id
group by c.category_id
having avg(f.rental_duration) > 5

============= подзапросы =============

5. Выведите количество фильмов, со стоимостью аренды за день больше, 
чем среднее значение по всем фильмам
* Напишите подзапрос, который будет вычислять среднее значение стоимости 
аренды за день (задание 3.1)
* Используйте таблицу film
* Отфильтруйте строки в результирующей таблице, используя опретаор > (подзапрос)
* count - агрегатная функция подсчета значений

select title, rental_rate/rental_duration
from film 
where rental_rate/rental_duration > (select avg(rental_rate/rental_duration)from film)

select sum(amount) *100 / (select sum(amount) from payment)
from payment p
group by customer_id

6. Выведите фильмы, с категорией начинающейся с буквы "C"
* Напишите подзапрос:
 - Используйте таблицу category
 - Отфильтруйте строки с помощью оператора like 
* Соедините с таблицей film_category
* Соедините с таблицей film
* Выведите информацию о фильмах:
title, category."name"
* Используйте подзапрос во from, join, where

select category_id, "name"
from category 
where "name" like 'C%'

explain analyse
select f.title, t.name
from (
	select category_id, "name"
	from category 
	where "name" like 'C%') t 
join film_category fc on fc.category_id = t.category_id
join film f on f.film_id = fc.film_id --175 / 53.54 / 0.47

explain analyse
select f.title, t.name
from (
	select category_id, "name"
	from category 
	where "name" like 'C%') t 
left join film_category fc on fc.category_id = t.category_id
left join film f on f.film_id = fc.film_id --175 / 53.54 / 0.47

explain analyse
select f.title, t.name
from film f
join film_category fc on fc.film_id = f.film_id
join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.54 / 0.47

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id and 
	fc.category_id in --(3, 4, 5)
		(select category_id
		from category 
		where "name" like 'C%')
join category c on c.category_id = fc.category_id --175 / 47.36 / 0.45

explain analyse
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id
where c.category_id in (
	select category_id
	from category 
	where "name" like 'C%') --175 / 47.21 / 0.43

explain analyze
select f.title, t.name
from film f
right join film_category fc on fc.film_id = f.film_id
right join (
	select category_id, "name"
	from category 
	where "name" like 'C%') t on t.category_id = fc.category_id --175 / 53.54 / 0.43

explain analyze --175 / 53.54
select f.title, c.name
from film f
join film_category fc on fc.film_id = f.film_id 
join category c on c.category_id = fc.category_id
where c."name" like 'C%'


explain analyze --529.21
select customer_id, count(1), sum(amount), min(amount), max(amount), avg(amount)
from payment p
group by customer_id

/*ТАК ДЕЛАТЬ НЕЛЬЗЯ 
explain analyze --738210
select distinct p1.customer_id, 
	(select count(1) 
	from payment p
	where p1.customer_id = p.customer_id
	group by p.customer_id),
	(select sum(amount) 
	from payment p
	where p1.customer_id = p.customer_id
	group by p.customer_id),
	(select min(amount) 
	from payment p
	where p1.customer_id = p.customer_id
	group by p.customer_id),
	(select max(amount) 
	from payment p
	where p1.customer_id = p.customer_id
	group by p.customer_id),
	(select avg(amount) 
	from payment p
	where p1.customer_id = p.customer_id
	group by p.customer_id)
from payment p1*/

explain analyze --779
select c.last_name, count(r.rental_id), c2.city
from customer c
join address a on a.address_id = c.address_id
join city c2 on c2.city_id = a.city_id
join rental r on r.customer_id = c.customer_id
group by c.customer_id, c2.city_id

explain analyze --467
select c.last_name, count, c2.city
from customer c
join address a on a.address_id = c.address_id
join city c2 on c2.city_id = a.city_id
join (
	select customer_id, count(rental_id) 
	from rental 
	group by customer_id) r on r.customer_id = c.customer_id

