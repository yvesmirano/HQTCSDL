USE master  
CREATE DATABASE QuanLyDeAn2 
ON   
( NAME = QuaLyDeAn_Data,  
    FILENAME ='D:\DoPhuThanhDat\QuanLyDeAn2Data.mdf',  
    SIZE = 20,  
    MAXSIZE = 500,  
    FILEGROWTH = 1 )  
LOG ON  
( NAME = QuanLyDeAn_Log,  
    FILENAME = 'D:\DoPhuThanhDat\QuanLyDeAn2Log.ldf',  
    SIZE = 2MB,  
    MAXSIZE = 48MB,  
    FILEGROWTH = 10MB )

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
  DDiemDA varchar(20) NULL)
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
   CONSTRAINT pk_NHANVIEN PRIMARY KEY (MaNV))
CREATE TABLE dbo.THANNHAN
(
  MaNV varchar(9) NOT NULL,
  TenTN varchar(20) NOT NULL,
  NgaySinh smalldatetime  NULL,
  Phai nvarchar (3) NULL,
  QuanHe varchar(15) NULL,
  CONSTRAINT pk_THANNHAN PRIMARY KEY (MaNV, TenTN)
)
CREATE TABLE dbo.PHONGBAN
(
  MaPhg varchar(2) PRIMARY KEY,
  TenPhg nvarchar(20) NULL
)
ALTER TABLE dbo.PHANCONG
ADD
   CONSTRAINT fk_1 FOREIGN KEY (MaDA) REFERENCES dbo.DEAN (MaDA),
   CONSTRAINT fk_2 FOREIGN KEY (MaNV) REFERENCES dbo.NHANVIEN (MaNV)
   ON DELETE CASCADE
   ON UPDATE CASCADE
ALTER TABLE dbo.THANNHAN
ADD
   CONSTRAINT fk_5 FOREIGN KEY (MaNV) REFERENCES dbo.NHANVIEN (MaNV)
ALTER TABLE dbo.NHANVIEN
ADD
   CONSTRAINT fk_4 FOREIGN KEY (Phong) REFERENCES dbo.PHONGBAN (MaPhg)
   ON DELETE CASCADE
   ON UPDATE CASCADE
ALTER TABLE dbo.PHONGBAN
ALTER COLUMN TenPhg nvarchar(30);
ALTER TABLE dbo.DEAN
ALTER COLUMN DDiemDA nvarchar(20);
ALTER TABLE dbo.THANNHAN
ALTER COLUMN TenTN nvarchar(20);
ALTER TABLE dbo.NHANVIEN
DROP CONSTRAINT ck_NHANVIEN_Phai
ALTER TABLE dbo.THANNHAN
ALTER COLUMN Phai nvarchar(3);
ALTER TABLE dbo.THANNHAN
ALTER COLUMN QuanHe nvarchar(15);
ALTER TABLE dbo.NHANVIEN
ADD SoDienThoai varchar(15);
ALTER TABLE dbo.NHANVIEN
DROP Column SoDienThoai;
INSERT INTO dbo.NHANVIEN
VALUES ('123',N'Đinh',N'Bá',N'Tiến','02-27-1972',N'Mộ Đức','Nam',NULL,'4'),
       ('234',N'Nguyễn',N'Thanh',N'Tùng','08-12-1956',N'Sơn Tịnh','Nam',NULL,'5'),
	   ('345',N'Bùi',N'Thúy',N'Vũ',NULL,N'Tư Nghĩa',N'Nữ',NULL,'4'),
	   ('456',N'Lê',N'Thị',N'Nhàn','07-12-1962',N'Mộ Đức',N'Nữ',NULL,'4'),
	   ('567',N'Nguyễn',N'Mạnh',N'Hùng','03-25-1985',N'Sơn Tịnh',N'Nam',NULL,'5'),
	   ('678',N'Trần',N'Hồng',N'Quang',NULL,N'Bình Sơn',N'Nam',NULL,'5'),
	   ('789',N'Trần',N'Thanh',N'Tâm','06-17-1972',N'Tp Quảng Ngãi',N'Nam',NULL,'5'),
	   ('890',N'Cao',N'Thanh',N'Huyền',NULL,N'Tư Nghĩa',N'Nữ',NULL,'1'),
	   ('901',N'Vương',N'Ngọc',N'Quyền','12-12-1988',N'Mộ Đức',N'Nam',NULL,'1')
INSERT INTO dbo.DEAN
VALUES ('1',N'Nâng cao chất lượng muối',N'Sa Huỳnh'),
       ('10',N'Xây dựng nhà máy chế biến thuỷ sản',N'Dung Quốc'),
	   ('2',N'Phát triển hạ tầng mạng',N'Tp Quãng Ngãi'),
	   ('20',N'Truyền tảu cáp quang',N'Tp Quảng Ngãi'),
	   ('3',N'Tin học hoá trường học',N'Ba Tơ'),
	   ('30',N'Đào tạo nhân lực',N'Tịnh Phong')
INSERT INTO dbo.PHONGBAN
VALUES ('1',N'Quản Lý'),
       ('4',N'Điều Hành'),
	   ('5',N'Nghiên Cứu')
INSERT INTO dbo.PHANCONG
VALUES ('123','1','33'),
	('123','2','8'),
	   ('345','10','10'),
	   ('345','20','10'),
	   ('345','3','10'),
	   ('456','1','20'),
	   ('456','2','20'),
	   ('678','3','40'),
	   ('789','10','35'),
	   ('789','20','30'),
	   ('789','30','5')
INSERT INTO dbo.THANNHAN
VALUES ('123',N'Châu','10-30-2005',N'Nữ',N'Con gái'),
		('123',N'Duy','10-25-2001',N'Nam',N'Con trai'),
		('123',N'Phương','10-30-1985',N'Nữ',N'Vợ chồng'),
		('234',N'Thanh','04-05-1980',N'Nữ',N'Con gái'),
		('345',N'Khang','10-25-1982',N'Nam',N'Con trai'),
		('456',N'Hùng','01-01-1987',N'Nam',N'Con trai'),
		('901',N'Thương','04-05-1989',N'Nữ',N'Vợ chồng')