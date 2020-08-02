drop database if exists project;
create database if not exists project;
use project;

create table if not exists db_cust(
	id int unsigned not null auto_increment,
	firstname varchar(50) not null,
	lastname varchar(50) not null,
	city varchar(50),
	birthday date,
	phone varchar(20) not null unique,
	email varchar(30) unique,
	created_date DATETIME DEFAULT CURRENT_TIMESTAMP null,
	
	primary key (id)	
);

insert into db_cust (firstname, lastname, city, birthday, phone, email) values
('Гоша','Куц','Москва', '1990-10-10','+74958689978','asdasd@gmail.com'),
('Гриша','Корж','Тверь', '1991-09-10','+7369586932','srg@mail.ru'),
('Людмила','Оставпова','Бишкек', '1993-02-10','+798568741253','assssd@gmail.com'),
('Юрий','Никулин','Санкт-Петербург', '1990-01-12','+78523698521','111rg@mail.ru'),
('Светлана','Рогоза','Рязань', '1990-10-10','+79858796514','aaw12@gmail.com'),
('Петр','Немцов','Москва', '1990-12-10','+7963589674','sssahg@mail.ru'),
('Александр','Добров','Тверь', '1988-11-10','+79852796514','343434d@gmail.com'),
('Кирилл','Любимов','Новгород', '1981-12-10','+79856796514','9099997777@mail.ru'),
('Наталья','Васина','Махачкала', '1980-09-01','+79858796854','rrrr12@gmail.com'),
('Вячеслав','Дронов','Денвер', '1990-06-09','+790958796514','vizh@mail.ru');


create table if not exists db_managers(
	id int unsigned not null auto_increment,
	manager varchar (50),
	
	primary key (id)
);

insert into db_managers (manager) values
('Alex'),('Max'),('Den'),('Kate'),('Jhon');



create table if not exists items(
	id int unsigned not null auto_increment,
	item varchar (30),
	
	primary key (id)
);

insert into items (item) values
('2p suit'),('3p suit'),('Jacket'),('Trousers'),('Shirt'),('Overcoat'),('Shoes'),('Jeans');


drop table if exists price_cat;
create table if not exists price_cat(
	id int unsigned not null auto_increment,
	cat int unsigned not null,
	price int,
	
	primary key (id)
);

insert into price_cat (cat, price) values
(1, 10000),(2, 20000),(3, 30000),(4, 40000),(5, 50000),(6, 60000);




drop table if exists materials;
create table if not exists materials(
	id bigint unsigned not null auto_increment,
	supplier varchar(30) not null,
	article varchar(50) not null,
	composition varchar(50),
	collection varchar (50),
	price int,
	total_price int,
		
	primary key (id)
	
);



insert into materials (supplier, article, composition, collection, price) values
	('Loro Piana','LP021569','100W','130s Four Seasons',85),
	('Ariston','P023-15','95W5S','Suits 20',51),
	('Scabal','55698SC','85WM15W','Wedding',78),
	('Drago','D259866','100W','Deep Black',62),
	('Drapers','DR889898','80W15PL5S','Summertime',86),
	('Ermenegildo Zegna','EZ165328','70W15S15Li','EZ Summer 2020',98),
	('Thomas Maison','TM589632','100C','Sea Island 20',21),
	('Drago','D252865','100S','Luxery',170)
;

/*delimiter //

create trigger add_material_total_price
after update on materials 
for each row 
begin
	if price between 0 and 25 then 
			update materials set total_price = (select price from price_cat where cat = 1);
	elseif price between 26 and 35 then 
			update materials set total_price = (select price from price_cat where cat = 2);
	elseif price between 36 and 45 then 
			update materials set total_price = (select price from price_cat where cat = 3);
	elseif price between 46 and 67 then 
			update materials set total_price = (select price from price_cat where cat = 4);
	elseif price between 68 and 90 then 
			update materials set total_price = (select price from price_cat where cat = 5);
	elseif price between 91 and 300 then 
			update materials set total_price = (select price from price_cat where cat = 6);
	end if;

end	//

delimiter ;
*/
/*delimiter //

create trigger add_material_total_price
after insert on materials 
for each row 
begin
	case 
		when price between 0 and 25 then 
			update materials set total_price = (select price from price_cat where cat = 1);
		when price between 26 and 35 then 
			update materials set total_price = (select price from price_cat where cat = 2);
		when price between 36 and 45 then 
			update materials set total_price = (select price from price_cat where cat = 3);
		when price between 46 and 67 then 
			update materials set total_price = (select price from price_cat where cat = 4);
		when price between 68 and 90 then 
			update materials set total_price = (select price from price_cat where cat = 5);
		when price between 91 and 300 then 
			update materials set total_price = (select price from price_cat where cat = 6);
	end case;
end	//

delimiter ;*/



drop table if exists db_orders;
create table if not exists db_orders(
	id bigint unsigned not null auto_increment,
	cust_id int unsigned not null,
	manager_id int unsigned not null, 
	item_id int unsigned not null,
	price_cat_id bigint unsigned,
	status enum ('on hold', 'in workshop', 'in transit', 'out for delivery', 'received', 'delivered to customer', 'cancelled', 'refused by customer'),
	created_date DATETIME DEFAULT current_timestamp null,
	delivery_date DATE,
	
	primary key (id),
	foreign key (cust_id) references db_cust(id),
	foreign key (manager_id) references db_managers(id),
	foreign key (item_id) references items(id),
	foreign key (price_cat_id) references materials(id)
		
);


insert into db_orders (cust_id, manager_id, item_id, price_cat_id, status) values 
(2,3,4,2,'on hold'),
(1,2,2,3,'on hold'),
(3,1,1,4,'on hold'),
(4,5,3,5,'on hold'),
(2,3,4,1,'on hold'),
(1,3,1,2,'on hold'),
(4,2,4,3,'on hold'),
(5,3,2,3,'on hold'),
(2,5,3,2,'on hold'),
(6,2,5,6,'on hold');

update db_orders 
set status = 'in workshop' where manager_id = 3;


create view order_by_customers as
	select concat(custs.firstname,' ', custs.lastname) as Customer, items.item as item, orders.status as 'order status', orders.created_date as 'created date', staff.manager as manager,custs.phone as 'phone number'
	from db_orders as orders
		right join db_cust as custs
		on orders.cust_id = custs.id
			join db_managers as staff
			on orders.manager_id = staff.id
				join items as items
				on orders.item_id = items.id 
;



drop table if exists cheques;
create table if not exists cheques(
	id bigint unsigned not null auto_increment,
	cust_id int unsigned not null,
	order_id bigint unsigned not null,
	qty_orders int unsigned not null,
	summ_orders int unsigned not null,
	created_date DATETIME DEFAULT current_timestamp null,
	delivery_date DATE,
		
	primary key (id),
	foreign key (cust_id) references db_cust(id),
	foreign key (order_id) references db_orders(id)
); 



create table if not exists sales_funnels(
	id int unsigned not null auto_increment,
	new_cust enum ('hello!', 'step_1', 'step_2', 'done!', 'refused'),
	old_cust enum ('hello!', 'step_1', 'step_2', 'done!', 'refused'),
	
	primary key (id)
);



create table if not exists deals(
	id bigint unsigned not null auto_increment,
	manager_id int unsigned not null,
	cust_id int unsigned,
	cust_status enum ('old', 'new'),
	funn_id int unsigned,
	created_date DATETIME DEFAULT CURRENT_TIMESTAMP null,
	
	primary key (id),
	foreign key (manager_id) references db_managers(id),
	foreign key (cust_id) references db_cust(id),
	foreign key (funn_id) references sales_funnels(id)
);


insert into deals (manager_id, cust_id) values
	(2,3),
	(3,4),
	(5,6),
	(1,5),
	(2,4),
	(3,8),
	(3,5),
	(2,5),
	(1,9),
	(2,2);


DROP FUNCTION IF EXISTS upd_cust_status;

DELIMITER $$
$$
CREATE FUNCTION upd_cust_status(cust_id_f int)
RETURNS tinytext deterministic
begin
	declare h int;
	set h = (select count(*) from db_orders where cust_id = cust_id_f);
	if h = 0 then
		return 'new';
	else 
		return 'old';
	end if;
		
END$$

create trigger upd_cust_status_in_deals
after insert on deals
for each row
begin 
	update deals set cust_status = (select upd_cust_status(cust_id));
	
END$$
delimiter ;


/* insert into deals (manager_id, cust_id) values
	(5,2);*/   -- не работает вставка при прописании триггера с функцией
	
	
select * from deals;





create table if not exists tasks(
	id bigint unsigned not null auto_increment,
	manager_id int unsigned not null,
	customer_id int unsigned,
	deal_id bigint unsigned,
	deadline datetime,
	created_date DATETIME DEFAULT CURRENT_TIMESTAMP null,

	primary key (id),
	foreign key (manager_id) references db_managers(id),
	foreign key (customer_id) references db_cust(id),
	foreign key (deal_id) references deals(id)
);







