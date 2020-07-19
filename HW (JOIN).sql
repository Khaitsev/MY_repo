--I.Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
--II.Выведите список товаров products и разделов catalogs, который соответствует товару.
--III.(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
--Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.

select 
	*
from users 
where id in (
	select 
		user_id
	from orders
	)
	
---------------------------------------------------------
	
	
SELECT
  *
FROM
   products AS p JOIN catalogs AS c
ON
  p.catalog_id = c.id;
 
  
---------------------------------------------------------- 
 
 
 
create database if not exists HW_flights;

drop table if exists flights;

create table flights(
	id int unsigned auto_increment not null primary key,
	`from` varchar(50) not null,
	`to` varchar(50) not null
);

drop table if exists cities;

create table cities(
	label varchar(50) not null,
	name varchar(50) not null,
	constraint pr_key_label primary key (label)
);
 
insert into flights (`from`,`to`)
	values 
		('moscow','omsk'),
		('novgorod','kazan'),
		('irkutsk','moscow'),
		('omsk','irkutsk'),
		('moscow','kazan')
;

insert into cities (label,name)
	values 
		('moscow','Москва'),
		('irkutsk','Иркутск'),
		('novgorod','Новгород'),
		('kazan','Казань'),
		('omsk','Омск')
;

select *
from cities;

select *
from flights


--вариант решения с вложенными запросами 

select 
	id,
	(select name from cities where label = flights.`from`),
	(select name from cities where label = flights.`to`)
from flights




--вариант решения с join

select
	f.id, c_from.name as 'from', c_to.name as 'to'
from flights as f
left join 
cities as c_to
on f.`to` = c_to.label
left join 
cities as c_from
on f.`from` = c_from.label

