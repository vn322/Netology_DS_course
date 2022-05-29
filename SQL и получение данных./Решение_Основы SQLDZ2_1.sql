select  film_id as id, release_year as FILM_YEAR, title, rental_rate/replacement_cost as RNOI
from film
where film_id > 100;

select  round(69.53/13,3);

select p.payment_date as PD1, p.payment_date::date as PD2
from payment;

select payment_date as PD1 from payment
WHERE payment_date between '2007-02-15' and '2007-02-16';

select *
from payment;



select distinct district
from address
where
 district like 'K%a' and district not like '%_ _%';
 

select payment_id, payment_date, amount from payment p 
WHERE payment_date BETWEEN '17-03-2007' AND '20-03-2007' and amount <= 1.00
order by payment_date desc;

select payment_id, payment_date, amount from payment p 
ORDER BY payment_date DESC LIMIT 10;


select ("last_name" || ' ' || "first_name") as "Фамилия и имя", 
email as "Электронная почта",  
CHARACTER_LENGTH(email) as "Длину значения поля email",
  last_update::DATE  as "Дату последнего обновления "    
from customer c; 



select upper(last_name), upper(first_name) from customer
where first_name LIKE 'Kelly' or first_name LIKE 'Willie'



-- Задание 1. Выведите для каждого покупателя его адрес, город и страну проживания.
select ("last_name" || ' ' || "first_name") as Customer_name, a.address, c2.city, c3.country 
from customer c 
left join address a on c.address_id = a.address_id 
left join city c2 on a.city_id = c2.city_id 
left join country c3 on c2.country_id = c3.country_id 


--Задание 2. С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.
select count(customer_id) as "количество покупателей" from customer c
group by store_id

--Доработайте запрос и выведите только те магазины, у которых количество покупателей больше 300. Для решения используйте фильтрацию по сгруппированным строкам с функцией агрегации. Ожидаемый результат запроса: letsdocode.ru.../3-2-2.png
select store_id, count(customer_id) as "количество покупателей" from customer c
group by store_id
having count(store_id) > 300


--Доработайте запрос, добавив в него информацию о городе магазина, фамилии и имени продавца, который работает в нём. Ожидаемый результат запроса: letsdocode.ru.../3-2-3.png
select c.store_id, count(customer_id) as "количество покупателей",c2.city as "город", concat(s.last_name, ' ', s.first_name)  as "Name" from customer c 
join staff s on s.store_id = c.store_id
join store s2 on s2.store_id = c.store_id 
join city c2 on c2.city_id = s2.address_id 
group by s.store_id, c.store_id, s.last_name, s.first_name,  c2.city
having count(c.store_id) > 300


--Задание 3. Выведите топ-5 покупателей, которые взяли в аренду за всё время наибольшее количество фильмов.
select ("last_name" || ' ' || "first_name") as "Фамилия и имя", count(p.customer_id) as "количество фильмов"
from  rental r 
join customer c on c.customer_id = r.customer_id 
join payment p on p.customer_id = r.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
--left join payment p on c.customer_id = p.customer_id
--left join inventory i on c.store_id = i.store_id 
group by c.first_name, c.last_name
order by count(p.customer_id) desc limit  5

---Задание 4. Посчитайте для каждого покупателя 4 аналитических показателя:

--количество взятых в аренду фильмов;
--общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа);
--минимальное значение платежа за аренду фильма;
--максимальное значение платежа за аренду фильма
select ("last_name" || ' ' || "first_name") as "Фамилия и имя", 
count(p.customer_id) as "количество фильмов",
round(sum(p.amount)) as "стоимость платежей за аренду всех фильмов",
min(p.amount) as "минимальное значение платежа",
max(p.amount) as "максимальное значение платежа"
from rental r 
join customer c on c.customer_id = r.customer_id 
join payment p on p.customer_id = r.customer_id 
join inventory i on i.inventory_id = r.inventory_id 
--left join payment p on c.customer_id = p.customer_id
--left join inventory i on c.store_id = i.store_id 
group by c.first_name, c.last_name
order by count(p.customer_id) desc

--Задание 5. Используя данные из таблицы городов, составьте одним запросом всевозможные пары городов так, чтобы в результате не было пар с одинаковыми названиями городов. Для решения необходимо использовать декартово произведение.
select t1.city as "город1", t2.city as "город2"
from city  t1 cross join city t2 where t1.city < t2.city;

--Задание 6. Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date) и дате возврата (поле return_date), вычислите для каждого покупателя среднее количество дней, за которые он возвращает фильмы.

select customer_id, round(avg(return_date::date - rental_date::date))  as "среднее количество дней"
from rental r 
group by customer_id 
order by customer_id 





Здравствуйте, Алексей!

Спасибо за выполненную работу. Хотела бы особенно положительно отметить из Ваших ответов:

корректное выполнение соединений таблиц через JOIN!
верное использование функций агрегации и группировки в SQL-запросах, а также оператора HAVING.
Почти все задания выполнены верно, по некоторым требуется выполнить доработку:

В задании 2 есть ответ только для первого пункта. Далее нужно было дважды доработать запрос, дополняя его другими таблицами, полями и вычислениями. Всего в задании 2 должно получиться 3 запроса.
В заданиях 3 и 4 нужно скорректировать количество фильмов, взятых в аренду. Фильмы, взятые в аренду, хранятся в таблице inventory. В задании 4 таблицу платежей корректнее соединять не только с таблицей покупателей, но и с таблицей аренд, так как каждый платеж относится к конкретной аренде фильма.
Доработайте ответы на задания согласно рекомендациям и отправляйте повторно на проверку.

Здравствуйте, Алексей!

В задании 2 в последнем запросе нужно было вывести город магазина. Используйте JOIN, чтобы соединить все таблицы между собой. Начните с таблицы customer и постепенно дополняйте запрос другими таблицами.

В заданиях 3 и 4 таблица inventory должна быть связана таблицей аренд (rental). Таблицу платежей (payment) корректнее тоже соединить с таблицей аренд по id аренды, так как каждый платеж относится к определенной аренде.

Если остаются вопросы по теме соединения таблиц с помощью JOIN можете задать их в личные сообщения в Slack! Разберем те моменты, которые вызывают вопросы.

Доработайте ответы на задания согласно рекомендациям и отправляйте повторно на проверку.

С уважением, Екатерина

дравствуйте, Алексей!

Запросы для заданий 3 и 4 доработаны верно, только таблицу платежей правильнее было бы связать не только с покупателями, но и с арендами.

select (“last_name” || ’ ’ || “first_name”) as “Фамилия и имя”, count(p.customer_id) as "количество фильмов"
from rental r
join customer c on c.customer_id = r.customer_id
join payment p on p.customer_id = r.customer_id and r.rental_id = p.rental_id
join inventory i on i.inventory_id = r.inventory_id
group by c.first_name, c.last_name
order by count(p.customer_id) desc limit 5

Последний запрос для задания 2 не доработан. Нужно вывести также города магазинов. Присоедините таблицу store к запросу, например, её можно соединить с таблицей customer по customer_id. Затем присоедините таблицу адресов и соедините её с таблицей магазинов по полю address_id. Затем присоедините таблицу городов и соедините её с таблицей адресов. Тогда сможете добавить в SELECT город магазина.

Вносите правки и отправляйте ДЗ повторно на проверку.

Здравствуйте, Алексей!

Без таблицы адресов вы не сможете получить город магазина, так как таблицы store и city не связаны между собой напрямую



Поэтому сперва нужно соединить таблицу store с address и затем address соединить с city, чтобы получить город магазина. Таблица адресов является общей таблицей-справочником, в таблицах customer, store, staff есть поле address_id - это адрес проживания или адрес магазина, который связан с таблицей address. Поэтому в задании 1 получали город проживания покупателя, а здесь город магазина. Корректное соединение таблиц будет таким:

select c.store_id, count(customer_id) as “количество покупателей”,c2.city as “город”, concat(s.last_name, ’ ', s.first_name) as “Name” from customer c
join staff s on s.store_id = c.store_id
join store s2 on s2.store_id = c.store_id
join address a on s2.address_id=a.address_id
join city c2 on c2.city_id = a.city_id
group by s.store_id, c.store_id, s.last_name, s.first_name, c2.city
having count(c.store_id) > 300

Желаю успехов в изучении следующих тем курса!

С уважением, Екатерина

