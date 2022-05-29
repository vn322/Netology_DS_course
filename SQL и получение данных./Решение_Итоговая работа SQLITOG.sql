-- 1)В каких городах больше одного аэропорта?


select city
from airports
group by city
having count(*) > 1




--2)В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?



select distinct departure_airport
from (select a.aircraft_code 
	from aircrafts a
	order by a."range" desc
	limit 1
) a
join flights f on f.aircraft_code = a.aircraft_code




--3) Вывести 10 рейсов с максимальным временем задержки вылета


select actual_departure - scheduled_departure as departure_delay, flight_no, departure_airport
	, f.arrival_airport
	from flights f
	where actual_departure - scheduled_departure is not null
	order by departure_delay desc
	limit 10




--4) Были ли брони, по которым не были получены посадочные талоны?


select b.book_ref, bp.boarding_no
from bookings b
left join tickets t on t.book_ref = b.book_ref
left join boarding_passes bp on t.ticket_no = bp.ticket_no
where bp.boarding_no is null


--5) Найдите количество свободных мест для каждого рейса, их % отношение к общему количеству мест в самолете.
--Добавьте столбец с накопительным итогом - суммарное накопление количества вывезенных пассажиров из каждого аэропорта на каждый день. Т.е. в этом столбце должна отражаться --накопительная сумма - сколько человек уже вылетело из данного аэропорта на этом или более ранних рейсах в течении дня.



with cte as (
	select s.aircraft_code, count(s.seat_no) as num, a.model
	from seats s
	join aircrafts a on a.aircraft_code = s.aircraft_code 
	group by s.aircraft_code, a.model
)
select departure_airport, actual_departure , cte.num - count(bp.seat_no)  as "Свободные места",
(((cte.num - count(bp.seat_no))::numeric / cte.num)::numeric(32,2)) * 100 as "% свободных мест",
sum(count(bp.seat_no)) over (partition by f.actual_departure::date, f.departure_airport order by f.actual_departure)
from boarding_passes bp
join flights f on f.flight_id = bp.flight_id
join cte on cte.aircraft_code = f.aircraft_code 
group by f.flight_id, cte.num


--6) Найдите процентное соотношение перелетов по типам самолетов от общего количества.


select model, (round(num::numeric / (sum(num) over ()), 2) * 100) as "% от общего кол-ва перелётов"
from(
	select count(flight_id) as num, model
	from flights f 
	join aircrafts a on a.aircraft_code = f.aircraft_code
	group by model
) l


--7 Были ли города, в которые можно  добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?


with cte as (
	select distinct tf.flight_id, max(amount) as price_econom, fare_conditions 
	from ticket_flights tf
	where tf.fare_conditions = 'Economy'
	group by flight_id, fare_conditions 
	order by flight_id
) ,
 cte1 as (
	select distinct tf.flight_id, min(amount) as price_business , fare_conditions 
	from ticket_flights tf
	where tf.fare_conditions = 'Business'
	group by flight_id, fare_conditions 
	order by flight_id
)
select a.city as "Город прибытия"
from cte
join cte1 on cte1.flight_id = cte.flight_id
join flights f on f.flight_id = cte.flight_id
join airports a on a.airport_code = f.arrival_airport
where price_business < price_econom






--8 Между какими городами нет прямых рейсов?


create view cities_v as
select v.departure_city, v.arrival_city
from flights_v v

select distinct a.city, a1.city
from airports a
cross join airports a1
where a.city != a1.city
	except
select c.departure_city, c.arrival_city
from cities_v c



--9 Вычислите расстояние между аэропортами, связанными прямыми рейсами, сравните с допустимой максимальной дальностью перелетов  в самолетах, обслуживающих эти рейсы


with cte as (
	select f.departure_airport,--, dep.longitude, dep.latitude, f.arrival_airport, arr.longitude, arr.latitude,
	f.arrival_airport, f.aircraft_code,
	round(((acos((sind(dep.latitude)*sind(arr.latitude) + cosd(dep.latitude) * cosd(arr.latitude) * cosd((dep.longitude - arr.longitude))))) * 6371)::numeric, 2)
	as distance_airports ,
	f.flight_no,
	dep.airport_name as departure_airport_name,
	arr.airport_name as arrival_airport_name
	from 
	flights f,
	airports dep,
	airports arr
	where f.departure_airport = dep.airport_code and f.arrival_airport = arr.airport_code
)
select distinct cte.departure_airport_name, cte.arrival_airport_name, cte.distance_airports,
a.range as aircraft_flight_distance,
case
when range > distance_airports
then 'TRUE'
else 'FALSE'
end result
from aircrafts a 
join cte on cte.aircraft_code = a.aircraft_code


Добрый день, Алексей.
Спасибо за выполненную итоговую работу!

По запросам:

В каких городах больше одного аэропорта?
10

В каких аэропортах есть рейсы, выполняемые самолетом с максимальной дальностью перелета?
15

Вывести 10 рейсов с максимальным временем задержки вылета
15

Были ли брони, по которым не были получены посадочные талоны?
15

Найдите свободные места для каждого рейса, их % отношение к общему количеству мест в самолете.
Добавьте столбец с накопительным итогом - суммарное количество вывезенных пассажиров из аэропорта за день.
Т.е. в этом столбце должна отражаться сумма - сколько человек уже вылетело из данного аэропорта на этом или более ранних рейсах за сегодняшний день
35

Найдите процентное соотношение перелетов по типам самолетов от общего количества.
25

Были ли города, в которые можно добраться бизнес - классом дешевле, чем эконом-классом в рамках перелета?
25

Между какими городами нет прямых рейсов?
25

Вычислите расстояние между аэропортами, связанными прямыми рейсами, сравните с допустимой максимальной дальностью перелетов в самолетах, обслуживающих эти рейсы
35

Итого - 200

По оформлению:

Тип подключения
10

Скриншот ER-диаграммы из DBeaver’a согласно Вашего подключения.
5

Краткое описание БД - из каких таблиц и представлений состоит.
10

Развернутый анализ БД - описание таблиц, логики, связей и бизнес области (частично можно взять из описания базы данных, оформленной в виде анализа базы данных)
20

Список SQL запросов с описанием логики их выполнения
15

Итого - 60

Хорошо!

Поздравляю с хорошо выполненной работой!
Надеюсь, Вам понравился наш курс!
Буду крайне признателен, если Вы поделитесь обратной связью - что понравилось в курсе, что не понравилось и что можно улучшить.
Еще раз огромное спасибо!






