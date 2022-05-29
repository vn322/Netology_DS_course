--нужно найти количество аренд между датами

create function foo1 (x date, y date, out z int) as $$
begin
	select count(*)
	from rental 
	where rental_date::date between x and y into z;
end;
$$ language plpgsql

select * from rental r

select foo1('2005-05-25', '2005-05-27')

select foo1('2005-05-27', '2005-05-29')

select avg(rental_rate) * foo1('2005-05-27', '2005-05-29') from film

select foo1('2005-05-25', null)

--нужно найти количество аренд между датами по конкретному пользователю

create or replace function foo1 (x date, y date, out z int) as $$
begin
	if x is null or y is null 
		then raise exception 'Одна из дат отсутствует';
	else
		select count(*)
		from rental 
		where rental_date::date between x and y into z;
	end if;
end;
$$ language plpgsql

create or replace function foo1 (x date, y date, c int, out z int) as $$
declare a date;
begin
	a = '2005-05-27';
	if x is null
		then x = a;
	end if;
	if x is null or y is null 
		then raise exception 'Одна из дат отсутствует';
	else
		select count(*)
		from rental 
		where rental_date::date between x and y and customer_id = c into z;
	end if;
end;
$$ language plpgsql

select foo1('2005-05-27', '2005-05-29')

select foo1(null, '2005-05-29', 2)

--получить список пользователей, их фио, которые арендовали между датами

create or replace function foo2 (x date, y date, out z text) returns setof text as $$
declare i record;
begin
	if x is null or y is null 
		then raise exception 'Одна из дат отсутствует';
	else
		for i in 
			select distinct customer_id
			from rental 
			where rental_date::date between x and y
		loop
			execute 'select concat(last_name, '' '', first_name)
			from customer 
			where customer_id = ' || i.customer_id into z;
			return next;
		end loop;
	end if;
end;
$$ language plpgsql

explain analyze select * from foo2('2005-05-27', '2005-05-29')

create or replace function foo3 (x date, y date, out z text) returns setof text as $$
declare i record;
begin
	if x is null or y is null 
		then raise exception 'Одна из дат отсутствует';
	else
		for i in 
			select distinct customer_id
			from rental 
			where rental_date::date between x and y
		loop
			select concat(last_name, ' ', first_name)
			from customer 
			where customer_id = i.customer_id into z;
			return next;
		end loop;
	end if;
end;
$$ language plpgsql

explain analyze select * from foo3('2005-05-27', '2005-05-29')

https://www.postgresql.org/docs/current/auto-explain.html

auto_explain.log_nested_statements должен быть включен

create table a (
	id serial primary key,
	name varchar(100) not null,
	last_update timestamp
)

insert into a (name)
values ('a'),('b'),('c'),('d'),('e')

select * from a

create function foo1() returns trigger as $$
begin
	if TG_OP = 'UPDATE'
	then ........
	new.last_update = now();
	return new;
end;
$$ language plpgsql

create function foo2() returns trigger as $$
begin
	new.last_update = now() - interval '1 year';
	return new;
end;
$$ language plpgsql

create trigger a_l_u 
before update on a 
for each row execute procedure foo1()

create trigger aal_u 
before update on a 
for each row execute procedure foo2()

drop trigger b_l_u on a

update a 
set name = 'iiiii'
where id = 3

trigger_audit_1
trigger_audit_2
trigger_audit_3
trigger_audit_4

select public.get_customer_balance(1, '2005-06-21 06:24:45')


select * from payment p

create function foo5() as $$
declare x;
	z;
begin
	select ....
	from .... 
	where .... into x; 
	
	select ....
	from .... 
	where id = x into z;

	create table ... 
	(
		id serial 
		name varchar
	)

	insert into ... 
	values (x,z)
	
	delete from ...
	where id = z;
end;
$$

create table p (like payment including none)

alter table p inherits payment 

select * into p from payment 

select *
from information_schema."tables" t

create table test5 (a int)


CREATE or replace PROCEDURE transaction_test5()
LANGUAGE plpgsql
AS $$
BEGIN
    FOR i IN 0..10000000 LOOP
        INSERT INTO test5 (a) VALUES (i);
    END LOOP;
END;
$$;

call transaction_test5()

select * from test5

select 65535*65535

new
id price number

old
id price number

number effect_from effect_till

fact
id price effect_from number