USE master  
CREATE DATABASE QuanLyDeAn  
ON   
( NAME = QuaLyDeAn_data,  
    FILENAME ='D:\DoPhuThanhDat\buoi1\QuanLyDeAn_data.mdf',  
    SIZE = 20,  
    MAXSIZE = 1000,  
    FILEGROWTH = 1 )  
LOG ON  
( NAME = QuanLyDeAn_Log,  
    FILENAME = 'D:\DoPhuThanhDat\buoi1\QuanLyDeAn_Log.ldf',  
    SIZE = 6MB,  
    MAXSIZE = 20MB,  
    FILEGROWTH = 5MB )


use QuanLyDeAn
go

CREATE TABLE dbo.PHANCONG
(
  MaNV varchar(9) NOT NULL,
  MaDA varchar(2) NOT NULL,
  ThoiGian numeric (18, 0)  NULL,
  CONSTRAINT pk_PHANCONG PRIMARY KEY (MaNV, MaDA)
)
CREATE TABLE dbo.DEAN
(
  MaDA varchar (2) PRIMARY KEY,
  TenDA nvarchar (50) NULL,
  DDiemDA nvarchar(20) NULL)
CREATE TABLE dbo.NHANVIEN
(
   MaNV varchar (9) NOT NULL,
   HoNV nvarchar (15)  NULL,
   TenLot nvarchar (30)  NULL,
   TenNV nvarchar (30)  NULL,
   NgaySinh smalldatetime  NULL,
   DiaChi nvarchar (150) NULL,
   Phai nvarchar (3) NULL,
   Luong numeric(18, 0) NULL,
   Phong varchar(2)  NULL,
   CONSTRAINT pk_NHANVIEN PRIMARY KEY (MaNV),
   CONSTRAINT ck_NHANVIEN_Phai check (Phai='Nam' or PHAI='Nữ')
)
CREATE TABLE dbo.THANNHAN
(
  MaNV varchar(9) NOT NULL,
  TenTN nvarchar(20) NOT NULL,
  NgaySinh smalldatetime  NULL,
  Phai nvarchar (3) NULL,
  QuanHe nvarchar(15) NULL,
  CONSTRAINT pk_THANNHAN PRIMARY KEY (MaNV, TenTN)
)
CREATE TABLE dbo.PHONGBAN
(
  MaPhg varchar(2) PRIMARY KEY,
  TenPhg nvarchar(30) NULL
)
ALTER TABLE dbo.PHANCONG
ADD
   CONSTRAINT fk_1 FOREIGN KEY (MaDA) REFERENCES dbo.DEAN (MaDA),
   CONSTRAINT fk_2 FOREIGN KEY (MaNV) REFERENCES dbo.NHANVIEN (MaNV)
   ON DELETE CASCADE
   ON UPDATE CASCADE
ALTER TABLE dbo.THANNHAN
ADD
   CONSTRAINT fk_3 FOREIGN KEY (MaNV) REFERENCES dbo.NHANVIEN (MaNV)
ALTER TABLE dbo.NHANVIEN
ADD
   CONSTRAINT fk_4 FOREIGN KEY (Phong) REFERENCES dbo.PHONGBAN (MaPhg)
   ON DELETE CASCADE
   ON UPDATE CASCADE

INSERT INTO dbo.NHANVIEN
VALUES ('123',N'Đinh',N'Bá',N'Tiến','1982-2-27',N'Mộ Đức','Nam',null,'4'),
       ('234',N'Nguyễn',N'Thanh',N'Tùng','1956-8-12',N'Sơn Tịnh','Nam',null,'5'),
	   ('345',N'Bùi',N'Thúy',N'Vũ',NULL,N'Tư Nghĩa',N'Nữ',NULL,'4'),
	   ('456',N'Lê',N'Thị',N'Nhàn','1962-7-12',N'Mộ Đức',N'Nữ',NULL,'4'),
	   ('567',N'Nguyễn',N'Mạnh',N'Hùng','1985-3-25',N'Sơn Tịnh',N'Nam',NULL,'5'),
	   ('678',N'Trần',N'Hồng',N'Quang',NULL,N'Bình Sơn',N'Nam',NULL,'5'),
	   ('789',N'Trần',N'Thanh',N'Tâm','1972-6-17',N'Tp Quảng Ngãi',N'Nam',NULL,'5'),
	   ('890',N'Cao',N'Thanh',N'Huyền',NULL,N'Tư Nghĩa',N'Nữ',NULL,'1'),
	   ('901',N'Vương',N'Ngọc',N'Quyền','1988-12-12',N'Mộ Đức',N'Nam',NULL,'1')
INSERT INTO dbo.DEAN
VALUES ('01',N'Nâng cao chất lượng muối',N'Sa Huỳnh'),
       ('10',N'Xây dựng nhà máy chế biến thuỷ sản',N'Dung Quốc'),
	   ('02',N'Phát triển hạ tầng mạng',N'Tp Quãng Ngãi'),
	   ('20',N'Truyền tảu cáp quang',N'Tp Quảng Ngãi'),
	   ('03',N'Tin học hoá trường học',N'Ba Tơ'),
	   ('30',N'Đào tạo nhân lực',N'Tịnh Phong')
INSERT INTO dbo.PHONGBAN
VALUES ('1',N'Quản Lý'),
       ('4',N'Điều Hành'),
	   ('5',N'Nghiên Cứu')
INSERT INTO dbo.PHANCONG
VALUES ('123','01','33'),
	('123','02','8'),
	   ('345','10','10'),
	   ('345','20','10'),
	   ('345','03','10'),
	   ('456','01','20'),
	   ('456','02','20'),
	   ('678','03','40'),
	   ('789','10','35'),
	   ('789','20','30'),
	   ('789','30','5')
INSERT INTO dbo.THANNHAN
VALUES ('123',N'Châu','2005-10-30',N'Nữ',N'Con gái'),
		('123',N'Duy','2001-10-25',N'Nam',N'Con trai'),
		('123',N'Phương','1985-10-30',N'Nữ',N'Vợ chồng'),
		('234',N'Thanh','1980-4-5',N'Nữ',N'Con gái'),
		('345',N'Khang','1982-10-25',N'Nam',N'Con trai'),
		('456',N'Hùng','1987-1-1',N'Nam',N'Con trai'),
		('901',N'Thương','1989-4-5',N'Nữ',N'Vợ chồng')

