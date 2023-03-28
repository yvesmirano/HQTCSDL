use QuanLyBanHang
go

create table SanPham
(
	MaSP varchar(4) not null primary key,
	MaHangSX varchar(3) not null ,
	TenSP varchar(50) ,
	SoLuong int ,
	MauSac nvarchar(50) ,
	GiaBan bigint ,
	DonViTinh varchar(20) ,
	Mota nvarchar(50)
)
create table HangSX
(
	MaHangSX varchar(3) not null primary key ,
	TenHang varchar(50) not null , 
	DiaChi varchar(50) ,
	SDT varchar(20) ,
	Email varchar(20)
)
create table NhanVien
(
	MaNV varchar(4) not null primary key,
	TenNV varchar(50) ,
	GioiTinh varchar(3) ,
	DiaChi varchar(50) ,
	SDT varchar(20) ,
	Email varchar(30),
	Phong varchar(20)
)
create table Nhap
(
	SoHDN varchar(3) not null primary key,
	MaSP varchar(4) not null,
	MaNV varchar(4) not null,
	NgayNhap date ,
	SoLuongN int, 
	DonGian bigint
)
create table Xuat
(
	SoHDX varchar(3) not null primary key,
	MaSP varchar(4) not null,
	MaNV varchar(4) not null,
	NgayXuat date ,
	SoLuongX int
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

insert into HangSX
values('H01','Samsung',N'Korea',N'011-08271717',N'ss@gmail.com.kr'),
('H02','OPPO',N'china',N'081-08626262',N'oppo@gmail.com.cn'),
('H03','Vinfone',N'Việt Nam',N'084-098262626',N'vf@gmail.com.vn')

insert into NhanVien
values 
('NV01',N'Nguyễn Thị Thu',N'nữ',N'Hà Nội','0982626521','thu@gmail.com',N'Kế toán'),
('NV02',N'Lê văn Nam',N'nam',N'Bắc Ninh','0972525252','nam@gmail.com',N'Vật Tư'),
('NV03',N'Trần Hòa Bình',N'nữ',N'Hà Nội','0328388388','hb@gmail.com',N'Kế toán')

insert into SanPham
values 
('SP01','H02','F1 Plus','100',N'xám','7000000',N'chiếc',N'hàng cận cap cấp'),
('SP02','H01','Galaxy Note 11','50',N'đỏ','19000000',N'chiếc',N'hàng cap cấp'),
('SP03','H02','F3 lite','200',N'nâu','3000000',N'chiếc',N'hàng phổ thông'),
('SP04','H03','Vjoy3','200',N'xám','1500000',N'chiếc',N'hàng phổ thông'),
('SP05','H01','Galaxy v21','500',N'nâu','8000000',N'chiếc',N'hàng cận cap cấp')

insert into Nhap
values 
('N01','SP02','NV01','02-05-2019',10,17000000),
('N02','SP01','NV02','04-07	-2020',30,6000000),
('N03','SP04','NV02','05-17-2020',20,1200000),
('N04','SP01','NV03','03-22-2020',10,6200000),
('N05','SP05','NV01','07-07-2020',20,7000000)

insert into Xuat
values 
('X01','SP03','NV02','06-14-2020',5),
('X02','SP01','NV03','03-05-2019',3),
('X03','SP02','NV01','12-12-2020',1),
('X04','SP03','NV02','06-02-2020',2),
('X05','SP05','NV01','05-18-2020',1)

BACKUP DATABASE QuanLyBanHang TO DISK='D:\TranHongNhat\lab2'

RESTORE DATABASE QuanLyBanHang FROM DISK='D:\TranHongNhat\lab2'
--lab2:
-- 1 Hiển thị thông tin các bảng dữ liệu trên:
select *
from HangSX
select *
from SanPham
select *
from NhanVien
select *
from Nhap
select *
from Xuat

-- 2 Đưa ra thông tin masp, tensp, tenhang, soluong, mausac, giaban, donvitinh, mota cua các sản phẩm sắp xếp theo chiều giảm dần giá bán:

SELECT *
FROM SanPham sp
JOIN HangSX hs ON sp.MaHangSX = hs.MaHangSX
ORDER BY sp.giaban DESC

--3 Đưa ra thông tin các sản phẩm có trong cửa hàng do công ty có tên hãng là samsung sản xuất
SELECT *
FROM SanPham sp
JOIN HangSX hs ON sp.MaHangSX = hs.MaHangSX
WHERE hs.TenHang = 'Samsung'

--4 đưa ra các thông tin nhân viên nữ ở phòng kế toán
SELECT *
FROM Nhanvien
WHERE GioiTinh = N'nữ' AND Phong = N'Kế toán'

-- 5 Để đưa ra thông tin phiếu nhập bao gồm các trường SoHDN, MaSp, Tensp, TenHang, SoluongN, DonGiaN, Tiennhap=SoluongN*DonGiaN, MauSac, DonViTinh, NgayNhap, TenNV, Phong, sắp xếp theo chiều tăng dần của hóa đơn nhập
SELECT Nhap.SoHDN, Nhap.MaSP, SanPham.TenSP, HangSX.TenHang, Nhap.SoLuongN, Nhap.DonGian, Nhap.SoLuongN*Nhap.DonGian AS TienNhap, Sanpham.MauSac, Sanpham.DonViTinh, Nhap.NgayNhap, Nhanvien.TenNV, NhanVien.Phong
FROM Nhap
INNER JOIN SanPham ON Nhap.MaSP = SanPham. MaSP
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
INNER JOIN NhanVien ON Nhap.MaNV = NhanVien.MaNV
ORDER BY Nhap.SoHDN ASC

--6  Đưa ra thông tin phiếu xuất gồm: sohdx, masp, tensp, tenhang, soluongX, giaban,tienxuat=, soluongX*giaban, mausac, donvitinh, ngayxuat, tennv, phong trong tháng 10 năm 2018, sắp xếp theo chiều tăng dần của sohdx
SELECT Xuat.SoHDX, Xuat.MaSP, SanPham.TenSP, HangSX.TenHang, Xuat.SoLuongX,SanPham.GiaBan,Xuat.SoLuongX*SanPham.GiaBan AS TienXuat, SanPham.MauSac, SanPham.DonViTinh, Xuat.NgayXuat, NhanVien.TenNV, NhanVien.Phong
FROM Xuat
INNER JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
INNER JOIN NhanVien ON Xuat.MaNV = NhanVien.MaNV
ORDER BY Xuat.SoHDX ASC

--7 Đưa ra các thông tin về các hóa đơn mà hãng samsung đã nhập trong năm 2017, gồm: sohdn, masp, tensp, soluongN, dongiaN, ngaynhap, tennv, phong
SELECT Nhap.SoHDN, Nhap.MaSP, SanPham.TenSP, Nhap.SoLuongN, Nhap.DonGian, Nhap.NgayNhap, NhanVien.TenNV, NhanVien.Phong
FROM Nhap
INNER JOIN SanPham ON Nhap.MaSP = SanPham.MaSP
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
INNER JOIN NhanVien ON Nhap.MaNV = NhanVien.MaNV
WHERE YEAR(Nhap.NgayNhap) = 2017 AND HangSX.TenHang = 'Samsung'

--8Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2018, sắp xếp theo chiều giảm dần của soluongX.
SELECT TOP 10 Xuat.SoHDX, Xuat.MaSP, SanPham.TenSP, HangSX.TenHang, Xuat.SoLuongX, SanPham.GiaBan, Xuat.SoLuongX*SanPham.GiaBan AS TienXuat, SanPham.MauSac, SanPham.DonViTinh, Xuat.NgayXuat, NhanVien.TenNV, NhanVien.Phong
FROM Xuat
INNER JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
INNER JOIN NhanVien ON Xuat.MaNV = NhanVien.MaNV
WHERE YEAR(Xuat.NgayXuat) = 2018
ORDER BY Xuat.SoLuongX DESC
-- 9Đưa ra thông tin 10 sản phẩm có giá bán cao nhất trong cửa hàng, theo chiều giảm dần giá bán.
 SELECT TOP 10 MaSP, TenSP, GiaBan
FROM SanPham
ORDER BY GiaBan DESC

-- 10  Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng samsung
select *
from SanPham sp
inner join HangSX sx on sp.MaHangSX= sx.MaHangSX
where sx.TenHang = 'Samsung' and sp.GiaBan between 100000 and 500000

--11Tính tổng tiền đã nhập trong năm 2018 của hãng samsung
select SUM(SoLuongN*DonGian) as TongTienNhap
from Nhap
INNER JOIN SanPham ON Nhap.MaSP = SanPham.MaSP
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
where HangSX.TenHang = 'Samsung' and YEAR(NgayNhap) = 2018

--12 Thống kê tổng tiền đã xuất trong ngày 2/9/2018
select sum(Xuat.SoLuongX*SanPham.GiaBan) as tongtienxuat
from Xuat
INNER JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
where NgayXuat = '2-9-2018'

--13  Đưa ra sohdn, ngaynhap, số tiền nhập phải trả cao nhất trong năm 2018
select SoHDN, NgayNhap, Nhap.SoLuongN*Nhap.DonGian AS TienNhap
from Nhap
where YEAR(NgayNhap) = 2018

--14 Đưa ra 10 mặt hàng có soluongN nhiều nhất trong năm 2019
select top  10  sum(Nhap.SoLuongN), SanPham.MaSP,SanPham.TenSP
from Nhap
INNER JOIN SanPham ON SanPham.MaSP=Nhap.MaSP 
where YEAR(NgayNhap)=2019
GROUP BY SanPham.MaSP, SanPham.TenSP
ORDER BY sum(Nhap.SoLuongN) DESC

--15 Đưa ra masp, tensp của các sản phẩm do công ty 'samsung' sản xuất do nhân viên có mã 'NV01' nhập.
SELECT sp.MaSP, sp.TenSP
FROM SanPham sp
INNER JOIN HangSX hsx ON sp.MaHangSX = hsx.MaHangSX
INNER JOIN Nhap n ON sp.MaSP = n.MaSP
INNER JOIN NhanVien nv ON n.MaNV = nv.MaNV
WHERE hsx.TenHang = 'samsung' AND nv.MaNV = 'NV01';


