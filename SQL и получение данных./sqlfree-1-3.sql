create database ....

create schema ....

create table delivery (
	delivery_id serial primary key,
	address_id int not null references address(address_id),
	delivery_date date not null,
	time_range text[] not null,
	staff_id int not null references staff(staff_id),
	status del_status not null default 'в обработке',
	last_update timestamp,
	created_date timestamp not null default now(),
	deleted int2 not null default 0 check(deleted in (0, 1))
)

select *
from delivery 
where deleted = 1

alter table orders add constraint delivery_orders_fkey foreign key
	(delivery_id) references delivery(delivery_id)
	
alter table orders add column название_столбца int

alter table orders drop constraint delivery_orders_fkey

insert into delivery(address_id, delivery_date, time_range, staff_id)
values (107, '23/10/2021', array['10:00:00', '20:00:00'], 330), 
	(208, '24/10/2021', array['20:00:00', '21:00:00'], 330), 
	(178, '22/10/2021', array['22:00:00', '23:00:00'], 330) 

select time_range[1], time_range[2]
from delivery

select *
from delivery

update delivery 
set status = 'в обработке'
where delivery_id = 1

delete from delivery 

drop database postgres 

delete from staff
where staff_id = 3

begin 
	select * from delivery 
	savepoint 
commit;


create table table_one (
	name_one varchar(255) not null
);

create table table_two (
	name_two varchar(255) not null
);

insert into table_one (name_one)
values ('one'), ('two'), ('three'), ('four'), ('five')

insert into table_two (name_two)
values ('four'), ('five'), ('six'), ('seven'), ('eight')

select * from table_one

select * from table_two

select t1.name_one, t2.name_two
from table_one t1
inner join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
left join table_two t2 on t1.name_one = t2.name_two

select t1.name_one, t2.name_two
from table_one t1
right join table_two t2 on t1.name_one = t2.name_two

select concat(t1.name_one, t2.name_two)
from table_one t1
full join table_two t2 on t1.name_one = t2.name_two
where t1.name_one is null or t2.name_two is null

select t1.name_one, t2.name_two
from table_one t1
cross join table_two t2

select o.order_id, d.delivery_id, c.city
from orders o
join delivery d on d.delivery_id = o.delivery_id
join address a on a.address_id = d.address_id
join city c on c.city_id = a.city_id

select * from delivery d

select * from address a where address_id in (107,208,178)

select * from city

select * from orders o

update orders
set delivery_id = 6
where order_id = 3

select o.order_id, d.delivery_id
from orders o
left join delivery d on d.delivery_id = o.delivery_id
where d.delivery_id is null

select d.delivery_id, p.product
from delivery d
join orders o on o.delivery_id = d.delivery_id
join order_product_list opl on opl.order_id = o.order_id
join product p on p.product_id = opl.product_id

/*
ТАК НЕЛЬЗЯ ДЕЛАТЬ
select o.order_id, c.city_id
from orders o
join city c on c.city_id = o.order_id
*/

select s1.first_name, s2.first_name
from staff s1
cross join staff s2
where s1.first_name != s2.first_name

select sum(amount)
from orders o

select *
from orders o

select customer_id, sum(amount), avg(amount), 
	count(order_id), min(amount), max(amount)
from orders
group by customer_id
order by 1

select customer_id, sum(amount), avg(amount), 
	count(order_id), min(amount), max(amount)
from orders
--where customer_id = 1
group by customer_id
having sum(amount) > 10000
order by customer_id

select c.last_name, c.first_name, sum(amount), avg(amount), 
	count(order_id), min(amount), max(amount)
from orders o
join customer c on c.customer_id = o.customer_id
group by c.last_name, c.first_name, o.customer_id
having sum(amount) > 10000
order by o.customer_id

select c.last_name, c.first_name, c2.category, sum(o.amount), count(o.order_id)
from orders o
join order_product_list opl on opl.order_id = o.order_id
join product p on p.product_id = opl.product_id
join category c2 on c2.category_id = p.category_id
join customer c on c.customer_id = o.customer_id
group by c.last_name, c.first_name, o.customer_id, p.category_id, c2.category
order by o.customer_id


Задание
Вопросы по заданию
В этом разделе можно задать вопросы и получить ответ.
Предлагаем вам повторить запросы на создание таблицы delivery и нужных ограничений с занятия.

Напоминаем, что
Таблицу нужно создать в собственной схеме.
При правильном результате, диаграмма Вашей схемы должна быть идентична диаграмме схемы public.

** Описание задания:**

Написать запросы, по следующим задачам:
Какое количество заказы было совершено
Какое количество товаров находится в категории “Игрушки”
В какой категории находится больше всего товаров
Сколько “Черепах” купила Williams Linda?
С кем живет Williams Linda?
По результату запросов необходимо пройти тест и проверить себя.