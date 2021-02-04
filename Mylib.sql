create database Mylib
-----------------
use Mylib
------------
create table utilisateur(
email varchar(50) primary key,
nom varchar(50),
prenom varchar(50),
pssword varchar(50),
tel varchar(50))
-------------------
create table Livre(
idlivre int primary key,
titre varchar(50),
editeur varchar(50),
datepublication date,
prix float,
poster varchar(50))
--------------------------
create table myfavorite(
idfav int primary key,
datenaissance date,
idlivre int FOREIGN KEY REFERENCES Livre(idlivre),
email varchar(50) FOREIGN KEY REFERENCES utilisateur(email))
-------------------------
create table avis(
idavis int primary key,
dateavis date,
texte varchar(50),
idlivre int FOREIGN KEY REFERENCES Livre(idlivre),
email varchar(50) FOREIGN KEY REFERENCES utilisateur(email))
---------------------------
create table likee(
idlike int primary key,
datelike date,
idlivre int  FOREIGN KEY REFERENCES Livre(idlivre),
email varchar(50) FOREIGN KEY REFERENCES utilisateur(email))
--------------------------
create table dislike(
iddislike int primary key,
datedislike date,
idlivre int FOREIGN KEY REFERENCES Livre(idlivre),
email varchar(50) FOREIGN KEY REFERENCES utilisateur(email))
--------------------------------2----ajouter les constraintes
ALTER TABLE Livre
add constraint DF_dateAjout DEFAULT getdate() for datepublication;
--------------------------------
alter table Livre
add constraint ch_idlivre_format check (idlivre like('OFPPT_[0-9][0-9][0-9]'));
---------3------ insertion
insert into utilisateur values('xxxx@gmail.com','khaled','cheb','azERTY','0666666666')
insert into utilisateur values('wwww@gmail.com','lahrache','abdelgahfour','@gmail564','0666666666')
------probleme conflit entre la constrainte donnee et le type de idlivre donc je vais drop constraint ch_idlivre_format
------alter table Livre
------drop constraint ch_idlivre_format
-----------------------------
insert into Livre values(1,'hacker tuto','moi','',10.00,'img.jpg')
insert into Livre values(2,'sql server','moi','',15.00,'img1.jpg')
insert into Livre values(3,'html5 tuto','moi','',5.00,'img2.jpg')
insert into Livre values(4,'css3 tuto','moi','',10.00,'img3.jpg')

insert into myfavorite values(1,'20010303',2,'xxxx@gmail.com')
insert into myfavorite values(2,'20010303',3,'xxxx@gmail.com')
insert into myfavorite values(3,'20010303',1,'wwww@gmail.com')
insert into myfavorite values(4,'20010303',2,'wwww@gmail.com')
insert into myfavorite values(5,'20010303',4,'wwww@gmail.com')

insert into avis values(1,'20110412','je laime bien',1,'wwww@gmail.com')
insert into avis values(2,'20110412','je laime bien',1,'wwww@gmail.com')
insert into avis values(3,'20110412','je laime bien',1,'wwww@gmail.com')
insert into avis values(4,'20110412','je laime bien',2,'xxxx@gmail.com')
insert into avis values(5,'20110412','je laime bien',1,'xxxx@gmail.com')
insert into avis values(6,'20110412','je laime bien',3,'wwww@gmail.com')

insert into likee values (1,'20110412',1,'wwww@gmail.com')
insert into likee values (2,'20110412',1,'xxxx@gmail.com')
insert into likee values (3,'20110412',2,'wwww@gmail.com')
insert into likee values (4,'20110412',4,'wwww@gmail.com')
insert into likee values (5,'20110412',1,'xxxx@gmail.com')
insert into likee values (6,'20110412',2,'wwww@gmail.com')
insert into likee values (7,'20110412',3,'wwww@gmail.com')
insert into dislike values (1,'20110412',1,'wwww@gmail.com')
insert into dislike values (2,'20110412',1,'xxxx@gmail.com')
insert into dislike values (3,'20110412',2,'wwww@gmail.com')
insert into dislike values (4,'20110412',4,'wwww@gmail.com')
insert into dislike values (5,'20110412',1,'xxxx@gmail.com')
insert into dislike values (6,'20110412',1,'wwww@gmail.com')
insert into dislike values (7,'20110412',2,'wwww@gmail.com')
insert into dislike values (8,'20110412',3,'xxxx@gmail.com')
insert into dislike values (9,'20110412',3,'xxxx@gmail.com')
--4----
---a
select count(distinct d.iddislike),count(distinct l.idlike),d.idlivre from likee l join dislike d on d.idlivre=l.idlivre group by d.idlivre
----b 
select top 1 count(idlike) as "nbre like", idlivre 
from likee 
group by idlivre
order by count(idlike) desc
-----c 
select top 1 count(idavis) as "nbre avis",email
from avis
group by email
order by count(idavis) desc
------d
select * from Livre
where idlivre not in (select likee.idlivre from likee)
------e
select * from utilisateur
where pssword not LIKE ('%[0-9-!#%&+,./:;<=>@`{|}~"()*\\\_\^\?\[\]%')
-------f
select d.idlivre,COUNT(distinct l.idlike) as "nbre likes",COUNT(distinct d.iddislike) as "nbre dislikes"
from dislike d join likee l
on l.idlivre=d.idlivre
group by d.idlivre
having COUNT(distinct l.idlike)=COUNT(distinct d.iddislike)
----5------
------a----- procedure qui affiche les livres stockés dans le favoris d'un utilisateur passe en param

create proc proc_FAVORIS @user varchar(50)
as select * from myfavorite where myfavorite.email=@user

exec proc_FAVORIS @user='xxxx@gmail.com' ----where xxx is the user email

------b------function qui retourne la valeur des prix stockés en favoris
create function [dbo].fct_calculer(@user varchar(50))
returns float as
begin
declare @somme float
select @somme= sum(l.prix)
from myfavorite m join Livre l
on m.idlivre=l.idlivre
where @user=m.email
return @somme
end

select dbo.fct_calculer('xxxx@gmail.com');




