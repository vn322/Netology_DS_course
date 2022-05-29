create database название_базы_данных

create schema lecture_4

set search_path to lecture_4

======================== Создание таблиц ========================
1. Создайте таблицу "автор" с полями:
- id 
- имя
- псевдоним (может не быть)
- дата рождения
- город рождения
- родной язык
* Используйте 
    CREATE TABLE table_name (
        column_name TYPE column_constraint,
    );
* для id подойдет serial, ограничение primary key
* Имя и дата рождения - not null
* город и язык - внешние ключи

create table author (
	--author_id varchar(24) primary key
	author_id serial primary key,
	author_name varchar(150) not null,
	nick_name varchar(50),
	born_date date not null check(date_part('year', born_date) >= 1700),
	born_city int2 not null references city(city_id),
	--language_id int2 not null references language(language_id),
	create_date timestamp not null default now(),
	last_update timestamp,
	--deleted int2 not null default 0 check(deleted in (0, 1)),
	deleted boolean not null default false
)

id | название_таблицы | сгенерированный идентификатор | тип_шифрования | соль 

1*  Создайте таблицы "Язык", "Город", "Страна".
* для id подойдет serial, ограничение primary key
* названия - not null и проверка на уникальность
/*
create table language (
	language_id serial primary key,
	language_name varchar(100) not null unique
)
*/

create table language (
	language_id int primary key generated always as identity,
	language_name varchar(100) not null unique
)

create table city (
	city_id serial primary key,
	city_name varchar(100) not null,
	country_id int2 not null references country(country_id)
)

create table country (
	country_id serial primary key,
	country_name varchar(100) not null unique
)

drop table language

======================== Заполнение таблицы ========================

2. Вставьте данные в таблицу с языками:
'Русский', 'Французский', 'Японский'
* Можно вставлять несколько строк одновременно:
    INSERT INTO table (column1, column2, …)
    VALUES
     (value1, value2, …),
     (value1, value2, …) ,...;

insert into language(language_name)
values('Русский'), ('Французский'), ('Японский')

select * from language

insert into language(language_id, language_name)
values(4, 'Немецкий')


insert into language(language_name)
values('Голландский')

insert into language(language_name)
values('Китайский')

-- демонстрация работы счетчика и сброс счетчика
alter sequence language_language_id_seq restart with 1000
	
2.1 Вставьте данные в таблицу со странами из таблиц country базы dvd-rental:

insert into country(country_name)
select country from public.country order by country_id

alter sequence country_country_id_seq restart with 1

delete from country

select * from country

2.2 Вставьте данные в таблицу с городами соблюдая связи из таблиц city базы dvd-rental:

insert into city (city_name, country_id)
select city, country_id from public.city order by country_id

select * from city c2
join country c on c2.country_id = c.country_id

2.3 Вставьте данные в таблицу с авторами, идентификаторы языков и городов оставьте пустыми.
Жюль Верн, 08.02.1828
Михаил Лермонтов, 03.10.1814
Харуки Мураками, 12.01.1949

insert into author (author_name, nick_name, born_date, born_city) 
values ('Жюль Верн', null, '08.02.1828', 56),
	('Михаил Лермонтов', 'Диарбекир', '03.10.1814', 7),
	('Харуки Мураками', null, '12.01.1949', 25)

select * from author a


create table a (
	c_id int, 
	s_amount numeric
)

select * from a

insert into a (c_id, s_amount)
select p.customer_id, sum(p.amount)
from public.payment p
group by p.customer_id

======================== Модификация таблицы ========================

3. Добавьте поле "идентификатор языка" в таблицу с авторами
* ALTER TABLE table_name 
  ADD COLUMN new_column_name TYPE;

-- добавление нового столбца
alter table author add column language_id int2

select * from author a

-- удаление столбца
alter table author drop column language_id

-- добавление ограничения not null
alter table author alter column language_id set not null

-- удаление ограничения not null
alter table author alter column language_id drop not null

-- добавление ограничения unique
alter table author add constraint lang_unique unique (language_id)

-- удаление ограничения unique
alter table author drop constraint lang_unique


-- изменение типа данных столбца
alter table author alter column language_id type text using (language_id::text)

alter table author alter column language_id type varchar(10) using (language_id::varchar(10))

alter table author alter column language_id type int using (language_id::int)

update pg_attribute set atttypmod = 100+4
where attrelid = 'author'::regclass and attname = 'language_id';
 
 3* В таблице с авторами измените колонку language_id - внешний ключ - ссылка на языки
 * ALTER TABLE table_name ADD CONSTRAINT constraint_name constraint_definition
 
alter table author add constraint author_language_fkey foreign key (language_id)
	references language(language_id)


 ======================== Модификация данных ========================

4. Обновите данные, проставив корректное языки писателям:
Жюль Габриэль Верн - Французский
Михаил Юрьевич Лермонтов - Российский
Харуки Мураками - Японский
* UPDATE table
  SET column1 = value1,
   column2 = value2 ,...
  WHERE
   condition;
  
update author
set language_id = 1
where author_id = 2

update author
set language_id = 2

update author
set language_id = 3
where author_id = (select author_id from author where author_name = 'Харуки Мураками')
  
select * from author a

select * from "language" l


4*. Дополните оставшие связи по городам:




 ======================== Удаление данных ========================
 
5. Удалите Лермонтова

delete from author 
where author_id = 2

delete from author 



5.1 Удалите все города

delete from city 

select * from city

select * from country

delete from country
where country_id = 1

drop table country cascade

alter table city add constraint city_country_fkey foreign key (country_id)
	references country(country_id) on delete cascade
	
----------------------------------------------------------------------------

explain analyze --325.89
select distinct customer_id
from (
	select customer_id 
	from public.payment
	where amount > 10
	order by amount desc) t
	
create table payment_new (like public.payment) partition by range (amount)

select * from payment_new

create table payment_low partition of payment_new for values from (minvalue) to (10)

create table payment_hi partition of payment_new for values from (10) to (maxvalue)

select * from payment_new

insert into payment_new
select * from public.payment

explain analyze 
select * from payment_new

select * from only payment_new

explain analyze --9.1
select distinct customer_id
from (
	select customer_id 
	from payment_hi
	where amount > 10
	order by amount desc) t
	
create index aaa_idx on payment_hi (payment_id, amount)


explain analyze --3.5
select distinct customer_id
from payment_hi

explain analyze --133.6
select distinct customer_id
from (
	select customer_id 
	from public.payment
	where amount > 10
	order by amount desc) t
	
create index aaa_idx on public.payment (amount)


select * from payment_new pn

update payment_new
set amount = 12 
where payment_id = 1

delete from payment_new
where payment_id = 1

create table payment_1 (like public.payment including all)

alter table payment_1 inherit public.payment

create rule / create trigger 