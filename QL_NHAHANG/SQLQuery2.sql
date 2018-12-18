create database QLNhaHang
go
use QuanLyNhaHang
go	

--Food
--Table
--FoodCategory
--Account
--Bill
--BillInfo
 
create table TableFood
(
	id int identity primary key,
	name nvarchar(100) not null default N'Chưa đặt tên',
	status nvarchar(100) not null default N'Trống'--trong || co nguoi

)
go

create table Account 
(
	DisplayName nvarchar(100) not null default N'User',
	UserName nvarchar(100) not null primary key,
	PassWord nvarchar(100) not null default 0,
	Type int not null default 0 --1:admin && 0:staff
)
go

create table FoodCategory
(
	id int identity primary key,
	name nvarchar(100) default N'Chưa đặt tên',
)
go

create table food
(
	id int identity primary key,
	name nvarchar(100) not null default N'Chưa đặt tên',
	idCategory int not null,
	price float not null default 0

	foreign key(idCategory) references dbo.FoodCategory(id)
)
go

create table Bill
(
	id int identity primary key,
	DateCheckIn Date not null default Getdate(),
	DateCheckOut date,
	idTable int not null,
	status int not null --1:da thanh toan  && 0: chua thanh toan

	foreign key (idTable) references dbo.TableFood(id)
)
go

create table BillInfo
(
	id int identity primary key,
	idBill int not null,
	idFood int not null,
	count int not null default 0

	foreign key (idBill) references dbo.Bill(id),
	foreign key (idFood) references dbo.Food(id)
)

insert into dbo.Account values (N'Admin',N'Admin',N'123',1)
insert into dbo.Account values (N'staff',N'staff',N'123',0)
select * from dbo.Account

create procedure  USP_GetAccountByUserName
@userName nvarchar(100)
as 
begin
	select*from dbo.Account where UserName=@userName
end
go

USP_GetAccountByUserName N'Admin'

alter procedure USP_Login
@userName nvarchar(100),@passWord nvarchar(100)
as begin
select * from dbo.Account where UserName=@userName and PassWord=@passWord
end
go

declare @I int =0
while @i<=10
begin 
insert dbo.TableFood(name) values (N'Bàn' + cast(@i as nvarchar(100)))
set @i=@i+ 1
end

select * from dbo.TableFood


go 
create proc USP_GetTableList
as select * from dbo.TableFood
go Exec dbo.USP_GetTableList

Update dbo.TableFood set status=N'Có người' where id=9
select * from TableFood
select *from  dbo.Bill
select * from dbo.BillInfo
select * from dbo.food
select * from dbo.FoodCategory

insert dbo.FoodCategory(name) values (N'Hải sản')
insert dbo.FoodCategory(name) values (N'Nông sản')
insert dbo.FoodCategory(name) values (N'Lâm sản')
insert dbo.FoodCategory(name) values (N'Nước')
go
insert dbo.food(name,idCategory,price) values (N'Bò một nắng',3,200000)
insert dbo.food(name,idCategory,price) values (N'Mực nướng sa tế',1,60000)
insert dbo.food(name,idCategory,price) values (N'Heo rừng 7 món',3,135000)
insert dbo.food(name,idCategory,price) values (N'Canh cua đồng',2,45000)
insert dbo.food(name,idCategory,price) values (N'Sò lông',1,54000)
insert dbo.food(name,idCategory,price) values (N'Nghêu hấp xả',1,43000)
insert dbo.food(name,idCategory,price) values (N'Lẩu thái chua chua hihi',1,179000)
insert dbo.food(name,idCategory,price) values (N'7 Up',4,15000)
insert dbo.food(name,idCategory,price) values (N'Bò húc',4,16000)
insert dbo.food(name,idCategory,price) values (N'Coca Cola',4,13000)
go
insert dbo.Bill(DateCheckIn,DateCheckOut,idTable,status) values(GETDATE(),Null,1,0)
insert dbo.Bill(DateCheckIn,DateCheckOut,idTable,status)  values(GETDATE(),Null,2,0)
insert dbo.Bill(DateCheckIn,DateCheckOut,idTable,status)  values(GETDATE(),GETDATE(),3,1)
go 
insert dbo.BillInfo(idBill,idFood,count) values(1,1,2)
insert dbo.BillInfo(idBill,idFood,count) values(1,3,4)
insert dbo.BillInfo(idBill,idFood,count) values(1,5,1)
insert dbo.BillInfo(idBill,idFood,count) values(2,1,2)
insert dbo.BillInfo(idBill,idFood,count) values(2,6,2)
insert dbo.BillInfo(idBill,idFood,count) values(3,4,2)
go

create proc USP_InsertBill
@idTable int
as
begin
	insert dbo.Bill(DateCheckIn,DateCheckOut,idTable,status,discount) values(GETDATE(),null,@idTable,0,0) 
end
go

alter proc USP_InsertBillInfo
@idBill int,@idFood int,@count int
as
begin
	declare @isExistBillInfo int
	declare @foodCount int =1

	select  @isExistBillInfo = id, @foodCount=b.count 
	from dbo.BillInfo as b 
	where idBill=@idBill and idFood=@idFood


	if(@isExistBillInfo >0)
	begin
		declare @newCount int = @foodCount + @count
		if(@newCount>0)
			update dbo.BillInfo set count=@foodCount+@count where idFood=@idFood
		else
			delete dbo.BillInfo where idBill=@idBill and idFood=@idFood
	end
		else
		begin
			insert BillInfo(idBill,idFood,count) values (@idBill,@idFood,@count)
		end
end
go

create trigger UIG_UpdateBillInfo
on dbo.BillInfo for insert,update
as
begin
	declare @idBill int

	select @idBill = idBill from inserted

	declare @idTable int

	select @idTable = idTable from dbo.Bill where id=@idbill and status=0

	declare @count int

	select @count=count(*) from dbo.BillInfo where idBill=@idBill

	if(@count>0)

	update dbo.TableFood set status= N'Có người' where id=@idTable

	else

	update dbo.TableFood set status= N'Trống ' where id=@idTable


end
go



create trigger UIG_UpdateBill
on dbo.Bill for update
as
begin
	declare @idBill int
	select @idBill = id from inserted
	declare @idTable int
	select @idTable = idTable from dbo.Bill where id=@idbill 
	declare @count int =0
	select @count = count(*) from dbo.Bill where idTable=@idTable and status=0
	if(@count=0)
		update dbo.TableFood set status= N'Trống ' where id=@idTable
end
go

delete dbo.BillInfo
delete dbo.Bill

alter table dbo.Bill
add discount int

create proc USP_SwitchTable
@idTable1 int,@idTable2 int
as begin

	declare @idFirstBill int
	declare @idSecondBill int

	declare @isFirstTableEmpty int =1
	declare @isSecondTableEmpty int =1

	
	select @idSecondBill= id from dbo.Bill where idTable= @idTable2 and status=0
	select @idFirstBill= id from dbo.Bill where idTable= @idTable1 and status=0

	select  id from dbo.Bill where idTable= @idTable1 and status=0

	print @idFirstBill
	print @idSecondBill
	print '-----------'

	if(@idFirstBill is null)
	begin 
	print '000001'
		insert dbo.Bill(DateCheckIn,DateCheckOut,idTable,status)
		values (GETDATE(),null,@idTable1,0)

		select @idFirstBill = max(id) from dbo.Bill where idTable=@idTable1 and status=0

		
	end
		select @isFirstTableEmpty = count(*) from dbo.BillInfo where idBill=@idFirstBill
	print @idFirstBill
	print @idSecondBill
	print '-----------'

	if(@idSecondBill is null)
	begin 
		print '000002'
		insert dbo.Bill(DateCheckIn,DateCheckOut,idTable,status)
		values (GETDATE(),null,@idTable2,0)

		select @idSecondBill = max(id) from dbo.Bill where idTable=@idTable2 and status=0

	end

	select @isSecondTableEmpty=count(*) from dbo.BillInfo where idBill=@idSecondBill

	print @idFirstBill
	print @idSecondBill
	print '-----------'
	select id into IDBillInfoTable from dbo.BillInfo where idBill=@idSecondBill

	update dbo.BillInfo set idBill=@idSecondBill where idBill=@idFirstBill

	update dbo.BillInfo set idBill=@idFirstBill where id in(select *from IDBillInfoTable)

	drop table IDBillInfoTable

	if(@isFirstTableEmpty=0)
		update dbo.TableFood set status=N'Trống ' where id = @idTable2
	if(@isSecondTableEmpty=0)
		update dbo.TableFood set status=N'Trống ' where id = @idTable1

end
go
exec dbo.USP_SwitchTable @idTable1 =4 ,@idTable2 = 10


go
alter table Bill add totalPrice float

create proc USP_GetListBillByDate
@checkIn date,@checkOut date
as begin
	select t.name as [Tên bàn],b.totalPrice as [Tổng tiền],DateCheckIn as[Ngày vào],DateCheckOut as[Ngày ra],discount as[Giảm giá] 
	from dbo.Bill as b,dbo.TableFood as t 
	where DateCheckIn>=@checkIn and DateCheckOut<=@checkOut and b.status=1
	and t.id=b.idTable 
end

go
create proc USP_UpdateAccount
@userName nvarchar(100),@displayName nvarchar(100),@passWord nvarchar(100),@newPassword nvarchar(100)
as 
begin
	declare @isRightPass int = 0
	select @isRightPass = count(*) from dbo.Account where UserName=@userName and PassWord=@passWord
	if	(@isRightPass=1)
		begin
			if(@newPassword=null or @newPassword='')
			begin
				update dbo.Account set DisplayName=@displayName where UserName=@userName
			end
			else --TH co mk va muon doi mk
				update dbo.Account set DisplayName=@displayName, PassWord=@newPassword where UserName=@userName
		end 
end
go

CREATE TRIGGER UTG_DeleteBillInfo
ON dbo.BillInfo FOR DELETE
AS 
BEGIN
	DECLARE @idBillInfo INT
	DECLARE @idBill INT
	SELECT @idBillInfo = id, @idBill = Deleted.idBill FROM Deleted
	
	DECLARE @idTable INT
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill
	
	DECLARE @count INT = 0
	
	SELECT @count = COUNT(*) FROM dbo.BillInfo AS bi, dbo.Bill AS b WHERE b.id = bi.idBill AND b.id = @idBill AND b.status = 0
	
	IF (@count = 0)
		UPDATE dbo.TableFood SET status = N'Trống ' WHERE id = @idTable
END
GO
drop TRIGGER UTG_DeleteBillInfo
CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END
