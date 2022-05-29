--=============== МОДУЛЬ 6. POSTGRESQL =======================================
select * from film f 
--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Напишите SQL-запрос, который выводит всю информацию о фильмах 
--со специальным атрибутом "Behind the Scenes".


select film_id, title, special_features 
from film 
where special_features = '{Behind the Scenes}'

--ЗАДАНИЕ №2
--Напишите еще 2 варианта поиска фильмов с атрибутом "Behind the Scenes",
--используя другие функции или операторы языка SQL для поиска значения в массиве.

select film_id, title, special_features
from film 
where special_features && array['Behind the Scenes']


select film_id, title, special_features
from film 
where special_features::text like '%Behind the Scenes%' 


select title, array_agg(unnest)
from (
	select title, unnest(special_features), film_id
	from film) t
where unnest = 'Behind the Scenes'
group by film_id, title


select * from film 
where "special_features" @> '{Behind The Scenes}'

--ЗАДАНИЕ №3
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов 
--со специальным атрибутом "Behind the Scenes.




--Обязательное условие для выполнения задания: используйте запрос из задания 1, 
--помещенный в CTE. CTE необходимо использовать для решения задания.

explain analyze
with cte as (
	select film_id, title, special_features
	from film 
	where special_features && array['Behind the Scenes']
)
select c.customer_id, count(cte.film_id) as film_count
from customer c
left join rental r on c.customer_id = r.customer_id
left join inventory i on r.inventory_id = i.inventory_id
left join cte on cte.film_id = i.film_id 
group by c.customer_id
order by c.customer_id 



--ЗАДАНИЕ №4
--Для каждого покупателя посчитайте сколько он брал в аренду фильмов
-- со специальным атрибутом "Behind the Scenes".

--Обязательное условие для выполнения задания: используйте запрос из задания 1,
--помещенный в подзапрос, который необходимо использовать для решения задания.

explain analyze
select r.customer_id, count(f.film_id) as film_count
from (select film_id, title, special_features
	from film 
	where special_features && array['Behind the Scenes']) f
left join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
group by r.customer_id
order by r.customer_id 




--ЗАДАНИЕ №5
--Создайте материализованное представление с запросом из предыдущего задания
--и напишите запрос для обновления материализованного представления

explain analyze
create materialized view task_5 as
	select r.customer_id, count(f.film_id) as film_count
	from (select film_id, title, special_features
		from film 
		where special_features && array['Behind the Scenes']) f
	left join inventory i on f.film_id = i.film_id
	left join rental r on i.inventory_id = r.inventory_id
	group by r.customer_id
	order by r.customer_id

refresh materialized view task_5
	
select * from task_5



--ЗАДАНИЕ №6
--С помощью explain analyze проведите анализ скорости выполнения запросов
-- из предыдущих заданий и ответьте на вопросы:

--1. Каким оператором или функцией языка SQL, используемых при выполнении домашнего задания, 
--   поиск значения в массиве происходит быстрее
--2. какой вариант вычислений работает быстрее: 
--   с использованием CTE или с использованием подзапроса




Здравствуйте, Алексей!

Спасибо за выполненную работу. Вы отлично освоили принцип использования CTE, подзапросов и работу с массивами данных. Все варианты поиска значения в массиве написаны верно.

Когда используете EXPLAIN ANALYZE, то запускайте запрос несколько раз и смотрите на среднее время, так как на скорость выполнения запроса влияет загрузка системы, нагрузка на жесткий диск, и другие параметры, поэтому время исполнения каждый раз будет немного отличаться.

Поздравляю Вас с успешным выполнением последнего домашнего задания на курсе! Уверена, что Вы успешно сможете применить все полученные знания на курсе и выполните итоговую работу на высокую оценку.

Желаю успехов! :)

С уважением, Екатерина