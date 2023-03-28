use QuanLyBanHang
go

CREATE TABLE SanPham
(
	MaSP varchar(4) not null primary key,
	MaHangSX varchar(4) not null ,
	TenSP varchar(20) ,
	SoLuong int , 
	MauSac nvarchar(20) ,
	GiaBan bigint , 
	DonViTinh varchar(20) , 
	Mota varchar(50)
)
CREATE TABLE HangSX
(
	MaHangSX varchar(4) not null primary key , 
	TenHang varchar(20) not null ,
	DiaChi varchar(20) , 
	SDT varchar(20) , 
	Email varchar(20) 
)
CREATE TABLE Nhanvien
(
	MaNV varchar(4) not null primary key,
	TenNV varchar(50) ,
	GioiTinh varchar(5) , 
	DiaChi varchar(20) , 
	SDT varchar(20) , 
	Email varchar(20) , 
	Phong varchar(20)
)
CREATE TABLE Nhap
(
	SoHDN varchar(4) not null primary key, 
	MaSP varchar(4) not null , 
	MaNV varchar(4) not null ,
	NgayNhap date ,
	SoluongN int, 
	DonGiaN bigint
)
CREATE TABLE Xuat
(
	SoHDX varchar(4) not null primary key,
	MaSP varchar(4) not null , 
	MaNV varchar(4) not null , 
	NgayXuat date , 
	SoluongX bigint 
)
ALTER TABLE SanPham 
ADD 
	CONSTRAINT fk_1 FOREIGN KEY (MaHangSX) REFERENCES HangSX (MaHangSX)
   ON DELETE CASCADE
   ON UPDATE CASCADE

ALTER TABLE Nhap
ADD
   CONSTRAINT fk_2 FOREIGN KEY (MaSp) REFERENCES SanPham (MaSP),
   CONSTRAINT fk_3 FOREIGN KEY (MaNV) REFERENCES NhanVien (MaNV)
   ON DELETE CASCADE
   ON UPDATE CASCADE

ALTER TABLE Xuat
ADD
   CONSTRAINT fk_4 FOREIGN KEY (MaSp) REFERENCES SanPham (MaSP),
   CONSTRAINT fk_5 FOREIGN KEY (MaNV) REFERENCES NhanVien (MaNV)
   ON DELETE CASCADE
   ON UPDATE CASCADE

INSERT INTO HangSX 
values
('H01','Samsung',N'Korea','011-08271717','ss@gmail.com.kr'),
('H02','OPPO',N'China','081-08626262','oppo@gmail.com.cn'),
('H03','Vinfone',N'Việt Nam','084-098262626','vf@gmail.com.vn')

INSERT INTO NhanVien 
values
('NV01',N'Nguyễn Thị Thu',N'Nữ',N'Hà Nội','0982626521','thu@gmail.com',N'Kế toán'),
('NV02',N'Lê Văn Nam',N'Nam',N'Bắc Ninh','0972525252','nam@gmail.com',N'Vật tư'),
('NV03',N'Trần Hòa Bình',N'Nữ',N'Hà Nội','0328388388','hb@gmail.com',N'Kế toán')

INSERT INTO SanPham
values
('SP01','H02','F1 Plus','100',N'Xám','7000000',N'Chiếc',N'Hàng cận cao cấp'),
('SP02','H01','Galaxy Note 11','50',N'Đỏ','19000000',N'Chiếc',N'Hàng cao cấp'),
('SP03','H02','F3 lite','200',N'Nâu','3000000',N'Chiếc',N'Hàng phổ thông'),
('SP04','H03','Vjoy3','200',N'Xám','1500000',N'Chiếc',N'Hàng phổ thông'),
('SP05','H01','Galaxy V21','500',N'Nâu','8000000',N'Chiếc','Hàng cận cao cấp')

INSERT INTO Nhap
values
('N01','SP02','NV01','02-05-2019','10','17000000'),
('N02','SP01','NV02','04-07-2020','30','6000000'),
('N03','SP04','NV02','05-17-2020','20','1200000'),
('N04','SP01','NV03','03-22-2020','10','6200000'),
('N05','SP05','NV01','07-07-2020','20','7000000')

INSERT INTO Xuat 
values
('X01','SP03','NV02','06-14-2020','5'),
('X02','SP01','NV03','03-05-2019','3'),
('X03','SP02','NV01','12-12-2020','1'),
('X04','SP03','NV02','06-02-2020','2'),
('X05','SP05','NV01','05-18-2020','1')

BACKUP DATABASE QuanLyBanHang TO DISK='D:\SQL\SQLQuery6'

RESTORE DATABASE QuanLyBanHang FROM DISK='D:\SQL\SQLQuery6'