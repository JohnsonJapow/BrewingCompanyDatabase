#	Create the corresponding database using DDL
DROP DATABASE IF exists BREWING;
CREATE DATABASE BREWING;
USE BREWING;

# 	Create all the necessary tables identified above using DDL

create table BC(
BC_TID int,
BC_name		varchar(40),
BC_address  varchar(40),
primary key (BC_TID)
);

create table BR(
Bname varchar(40),
price varchar(40),
BC_TID int ,
primary key (Bname),
foreign key (BC_TID)
	references BC (BC_TID)
);

create table OD(
OID varchar(40),
Bname varchar(40),
quantity varchar(40),
total varchar(40) ,
date date,
primary key (OID),
foreign key (Bname)
	references BR(Bname)
);
create table E(
PID      varchar(40),
name		varchar(40),
address  varchar(40),
PN  varchar(40),
BC_TID int,
primary key (PID),
foreign key (BC_TID)
	references BC(BC_TID)
);

create table OS(
URL      varchar(40),
BC_TID		int,
primary key (URL),
foreign key (BC_TID)
	references BC(BC_TID)
);
create table D(
D_TID      varchar(40),
D_name		varchar(40),
D_address  varchar(40),
primary key (D_TID)
);
create table MO(
OID      varchar(40),
BC_TID		int,
D_TID varchar(40),

foreign key (OID)
	references OD(OID),
foreign key (BC_TID)
	references BC(BC_TID),
foreign key (D_TID)
	references D(D_TID)
);

#	Populate at least three of your tables with some data using DML (insert into statement)

insert into BC values ('5000','Hanne','Dulbin');
insert into E values ('sfs4df4e64a6ef64','Joe','01293 Oriole Parkway','085-123-4567','5000');
insert into OS values('http://www.google.com','5000');

# Update derived values

Update OD
OD JOIN BR ON OD.Bname=BR.Bname
SET OD.total=OD.quantity*BR.price;

#	4.	Populate your database with a large data set representing a one-year transaction (01/01/2022 - 31/12/2022) on each table. 

select * from OD;
select * from BC;
select * from D;
select * from E;
select * from MO;
select * from OS;
select * from BR;

# Show the total number of transactions your database is storing and, 
# depending on your database, the most sold/listed item or customer with the highest number of purchases.

SELECT count(*) FROM MO;
Select count(*) From OD;
Select Bname, count(Bname)
from OD group by Bname having count(Bname); 

#	Write a query statement that includes “Order by” and “Group by”

Select BC_TID, count(OID) from MO
group  by BC_TID ORDER BY BC_TID ;

#	Write a query statement that uses pattern matching

Select * from BR where Bname like '%l%' ;

#	Show information from three tables based on criteria of your choice

Select * from BC INNER JOIN BR ON BC.BC_TID=BR.BC_TID INNER JOIN MO ON BR.BC_TID=MO.BC_TID;

#	Create a view that includes information from the most frequent seven transactions

Select Bname, count(Bname) as transactionTimes
from OD group by Bname having transactionTimes >11 order by transactionTimes desc; 

#	Shows the total number of transactions with corresponding details every month

select *, month(date) as transaction_Month,count(OD.OID)AS Monthlyoder from OD 
INNER JOIN MO ON OD.OID=MO.OID group by transaction_Month,Bname order by transaction_Month desc;

#•	Shows customer purchase value per month

select  month(date) as transaction_Month,sum(total)AS MonthlyPurchase from OD 
INNER JOIN MO ON OD.OID=MO.OID group by transaction_Month order by transaction_Month desc;

#•	Shows name of product and number sold each month

select Bname, quantity, month(date) as transaction_Month, sum(quantity)AS Monthlysold from OD 
INNER JOIN MO ON OD.OID=MO.OID group by transaction_Month,Bname order by transaction_Month desc;
