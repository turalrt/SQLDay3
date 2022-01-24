--Kitabxana database-i qurursunu
create database Kitabxana
use Kitabxana

--Books (Id, Name, PageCount)
--Books-un Name columu minimum 2 simvol maksimum 100 simvol deyer ala bileceyi serti olsun.
--Books-un PageCount columu minimum 10 deyerini ala bileceyi serti olsun.
Create Table Books
(
 Id int,
 Name nvarchar(50) Check(LEN(Name) between 2 and 100),
 PageCount int Check(PageCount>=10),
 --Books ve Authors table-larinizin mentiqi uygun elaqesi olsun.
 AuthorID int references Authors(Id)
)

--Authors (Id, Name, Surname)
Create Table Authors
(
 Id int primary key identity,
 Name nvarchar(25),
 Surname nvarchar(25)
)

--Id, Name, PageCount ve AuthorFullName columnlarinin valuelarini qaytaran bir view yaradin
Create view usv_GetInfo
As
Select b.Id, b.Name, b.PageCount, (Authors.Name+ ' '+Authors.Surname) 'AuthorFullName' from Books b
inner join  Authors
on b.AuthorID=Authors.Id

Select * from usv_GetInfo

--Gonderilmis axtaris deyirene gore hemin axtaris deyeri name ve ya authorFullNamelerinde olan Book-lari Id, Name, PageCount, AuthorFullName columnlari seklinde gostern procedure yazin
Create procedure usp_SearchBooks
@string nvarchar(25)
As
Begin
Select b.Id, b.Name, b.PageCount, (a.Name+ ' '+a.Surname) 'AuthorFullName' from Books b
Join Authors a
on b.AuthorID=a.Id
where b.Name like '%'+@string+'%' or a.Name like '%'+@string+'%' or a.Surname like '%'+@string+'%'
End

exec usp_SearchBooks 'hello'

--Authors tableinin insert, update ve deleti ucun (her biri ucun ayrica) procedure yaradin
--Insert
Create procedure usp_InsertInfo
(@Name nvarchar(25),
@SurName nvarchar(25))
As
Begin
Insert into Authors
Values(@Name,@SurName)
Select * from Authors 
End

exec usp_InsertInfo 'Nizami', 'Gencevi'

--Update
Create procedure usp_UpdateInfo
(@Id int, 
@Name nvarchar(25),
@SurName nvarchar(25))
As
Begin
Update Authors
set Authors.Name=@Name, Authors.Surname=@SurName where Authors.Id=@Id
Select * from Authors
End

exec usp_UpdateInfo 4,'Elekber','Sabir'

--Delete
Create procedure usp_DeleteInfo
(@Id int)
As
Begin
Delete From Authors where Authors.Id=@Id
Select * from Authors
End

exec usp_DeleteInfo  4

--Authors-lari Id,FullName,BooksCount,MaxPageCount seklinde qaytaran view yaradirsiniz Id-author id-si,
--FullName - Name ve Surname birlesmesi, BooksCount - Hemin authorun elaqeli oldugu kitablarin sayi,
--MaxPageCount - hemin authorun elaqeli oldugu kitablarin icerisindeki max pagecount deyeri
Create view usv_GetAuthorInfo
As
Select a.Id 'Id', a.Name+ ' ' +a.Surname 'FullName', COUNT(b.Name) 'BooksCount', MAX(b.PageCount) 'MaxPageCount' from Authors a
inner join Books b
on b.AuthorID=a.Id
Group by a.Id, a.Name, a.Surname

Select * from usv_GetAuthorInfo


