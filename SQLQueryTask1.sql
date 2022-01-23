--Database Yaradin Adi Ne Olursa Olsun
create database NeOlursaOlsun
use NeOlursaOlsun

--Brands Adinda Table Yaradin 2 dene colum Id ve Name
drop table Brands
create table Brands
(
	Id int primary key identity,
	Name nvarchar(25)
)

--Notebooks Adinda Table Yaradin Id,Name, Price Columlari Olsun.
drop table Notebooks
create table Notebooks
(
	 Id int,
	 Name nvarchar(25),
	 Price money,
	 --1) Notebook ve Brand Arasinda Mentiqe Uygun Relation Qurun.
	 BrandId int references Brands(Id)
)

--Phones Adinda Table Yaradin Id, Name, Price Columlari Olsun.
drop table Phones
create table Phones
(
	 Id int,
	 Name nvarchar(25) not null,
	 Price money,
	 --2) Phones ve Brand Arasinda Mentiqe Uygun Relation Qurun.
	 BrandId int references Brands(Id)
)

--3) Notebooks Adini, Brandin Adini BrandName kimi ve Qiymetini Cixardan Query.
Select (Brands.Name+ ' ' +Notebooks.Name) 'BrandName', Price from Notebooks
Inner Join Brands on Notebooks.BrandId=Brands.Id

--4) Phones Adini, Brandin Adini BrandName kimi ve Qiymetini Cixardan Query.
Select (Brands.Name+ ' ' + Phones.Name) 'BrandName', Price from Phones
Inner Join Brands on Phones.BrandId=Brands.Id

--5) Brand Adinin Terkibinde s Olan Butun Notebooklari Cixardan Query.
Select * from Brands where Name like '%s%'

--6) Qiymeti 2000 ve 5000 arasi ve ya 5000 den yuksek Notebooklari Cixardan Query.
Select * from Notebooks where Price between 2000 and 5000 or Price>5000

--7) Qiymeti 1000 ve 1500 arasi ve ya 1500 den yuksek Phonelari Cixardan Query.
Select * from Phones where Price between 1000 and 1500 or Price>1500

--8) Her Branda Aid Nece dene Notebook Varsa Brandin Adini Ve Yaninda Sayini Cixardan Query.
Select b.Name, count(b.Name) from Brands b
Inner Join Notebooks on Notebooks.BrandId=b.Id
Group By b.Name

--9) Her Branda Aid Nece dene Phone Varsa Brandin Adini Ve Yaninda Sayini Cixardan Query.
Select b.Name, count(b.Name) from Brands b
inner Join Phones on Phones.BrandId=b.Id
Group By b.Name

--10) Hem Phone Hem de Notebookda Ortaq Olan Name ve BrandId Datalarni Bir Cedvelde Cixardan Query.
Select n.Name, n.BrandId from Notebooks n
intersect
Select p.Name, p.BrandId from Phones p

--11) Phone ve Notebook da Id, Name, Price, ve BrandId Olan Butun Datalari Cixardan Query.
Select * from Phones
union all
Select* from Notebooks

--12) Phone ve Notebook da Id, Name, Price, ve Brandin Adini BrandName kimi Olan Butun Datalari Cixardan Query.
Select p.Id, p.Name, p.Price, p.BrandId, Brands.Name 'BrandName' from Phones p
inner join Brands
on p.BrandId=Brands.Id
union all
Select n.Id, n.Name, n.Price, n.BrandId, Brands.Name 'BrandName' from Notebooks n
inner join Brands
on n.BrandId=Brands.Id

--13) Phone ve Notebook da Id, Name, Price, ve Brandin Adini BrandName kimi Olan Butun Datalarin Icinden Price 1000-den Boyuk Olan Datalari Cixardan Query.
Select p.Id, p.Name, p.Price, p.BrandId, Brands.Name 'BrandName' from Phones p
inner join Brands
on p.BrandId=Brands.Id
where p.Price>1000
union all
Select n.Id, n.Name, n.Price, n.BrandId, Brands.Name 'BrandName' from Notebooks n
inner join Brands
on n.BrandId=Brands.Id
where n.Price>1000

--14) Phones Tabelenden Data Cixardacaqsiniz Amma Nece Olacaq Brandin Adi (BrandName kimi), Hemin Brandda Olan Telefonlarin Pricenin Cemi (TotalPrice Kimi) ve Hemin Branda Nece dene Telefon Varsa Sayini (ProductCount Kimi) Olan Datalari Cixardan Query.
Create view usv_GetPhones
As
Select b.Name 'BrandName:', SUM(Phones.Price) 'TotalPrice:', COUNT(b.Name) 'ProductCount:' from Brands b
Inner Join Phones
on Phones.BrandId=b.Id
Group By b.Name
Select * from usv_GetPhones

--15) Notebooks Tabelenden Data Cixardacaqsiniz Amma Nece Olacaq Brandin Adi (BrandName kimi), Hemin Brandda Olan Telefonlarin Pricenin Cemi (TotalPrice Kimi) , Hemin Branda Nece dene Telefon Varsa Sayini (ProductCount Kimi) Olacaq ve Sayi 3-ve 3-den Cox Olan Datalari Cixardan Query.
Create view usv_GetNotebooks
As
Select b.Name 'BrandName:', SUM(Notebooks.Price) 'TotalPrice:', COUNT(b.Name) 'ProductCount:' from Brands b
Inner Join Notebooks
on Notebooks.BrandId=b.Id
Group By b.Name
Select * from usv_GetNotebooks