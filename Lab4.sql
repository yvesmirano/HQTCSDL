USE QuanLyBanHang
SELECT * FROM SanPham
SELECT * FROM Nhap
SELECT * FROM Xuat
SELECT * FROM Nhanvien
SELECT * FROM Hangsx
---Câu 1---
CREATE VIEW view1 
AS
SELECT Hangsx.Tenhang, COUNT(*) AS SoLuongSanPham 
FROM SanPham inner join Hangsx on SanPham.Mahangsx = Hangsx.Mahangsx 
GROUP BY Hangsx.Tenhang
---Câu 2---
CREATE VIEW view2 
AS
SELECT Nhap.Masp, Sanpham.tensp, SUM(Nhap.soluongN * Nhap.dongiaN) as TongTienNhap
FROM Nhap inner join Sanpham on Nhap.Masp = Sanpham.masp
WHERE  YEAR(Nhap.Ngaynhap)='2018'
GROUP BY Nhap.Masp, Sanpham.tensp
---Câu 3(*)---
CREATE VIEW view3 
AS
SELECT SanPham.tensp, SUM(Xuat.soluongX) as TongSoLuongXuat
FROM SanPham inner join Xuat on SanPham.masp = Xuat.masp
WHERE YEAR(Xuat.ngayxuat) = '2018' and SanPham.mahangsx = 'H01'
GROUP BY SanPham.tensp
HAVING SUM(Xuat.soluongX) > 10000;
---Câu 4---
CREATE VIEW view4
AS
SELECT Nhanvien.Phong, COUNT(*) as SoLuongNamMoiPhong
FROM Nhanvien
WHERE Nhanvien.Gioitinh=N'Nam'
GROUP BY Nhanvien.Phong
---Câu 5---
CREATE VIEW view5 
AS
SELECT SanPham.mahangsx, Hangsx.Tenhang, SUM(Nhap.soluongN) as TongSoLuongNhap
FROM Nhap inner join SanPham on Nhap.Masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.Mahangsx
WHERE YEAR(Nhap.Ngaynhap)='2018'
GROUP BY SanPham.mahangsx, Hangsx.Tenhang
---Câu 6---
CREATE VIEW view6 
AS
SELECT SUM(Xuat.soLuongX*SanPham.giaban) AS TongLuongTienXuat, Nhanvien.Manv, Nhanvien.Tennv
FROM Nhanvien inner join Xuat on Nhanvien.Manv=Xuat.Manv inner join SanPham on Xuat.Masp=SanPham.masp
WHERE YEAR(Xuat.Ngayxuat)='2018'
GROUP BY Nhanvien.Manv, Nhanvien.Tennv
---Câu 7---
CREATE VIEW view7 
AS
SELECT SUM(Nhap.soluongN * Nhap.dongiaN) as TongTienNhap, Nhanvien.Manv, Nhanvien.Tennv
FROM Nhap inner join Nhanvien on Nhap.Manv=Nhanvien.Manv
WHERE CONVERT(DATE, Nhap.Ngaynhap, 105) between  '2018-08-01' and'2018-08-31'---dùng convert để chuyển đổi định dạng, 105 xác định định dạng ban đầu dd-mm-yyyy của ngày tháng năm
GROUP BY Nhanvien.Manv, Nhanvien.Tennv
HAVING SUM(Nhap.soluongN * Nhap.dongiaN) > 100000;
---Câu 8---
CREATE VIEW view8 
AS
SELECT SanPham.masp, SanPham.tensp
FROM SanPham
WHERE SanPham.masp NOT IN (SELECT masp FROM Xuat)
---Câu 9---
CREATE VIEW view9 
AS
SELECT DISTINCT SanPham.masp, SanPham.tensp
FROM Nhap inner join SanPham on Nhap.Masp=SanPham.masp inner join Xuat on SanPham.masp=Xuat.Masp
WHERE YEAR(Nhap.NgayNhap) = '2018' and YEAR(Xuat.NgayXuat) = '2018'
---Câu 10---
CREATE VIEW view10 
AS
SELECT DISTINCT NhanVien.Manv, NhanVien.Tennv
FROM Nhap inner join Nhanvien on Nhap.Manv=Nhanvien.Manv inner join Xuat on Nhanvien.Manv=Xuat.Manv
---Câu 11---
CREATE VIEW view11 
AS
SELECT Nhanvien.Manv, Nhanvien.Tennv, Nhanvien.Sodt, Nhanvien.Diachi, Nhanvien.email, Nhanvien.Gioitinh, Nhanvien.Phong
FROM Nhap inner join Nhanvien on Nhap.Manv=Nhanvien.Manv inner join Xuat on Nhanvien.Manv=Xuat.Manv
WHERE Nhap.Manv is null and Xuat.Manv is null---is null là hàm toán tử so sánh, kiểm tra các nhân viên không xuất không nhập
USE QuanLyBanHang
---Câu 12---
SELECT * FROM information_schema.tables
SELECT * FROM SanPham
SELECT * FROM Nhap
SELECT * FROM Xuat
SELECT * FROM Nhanvien
SELECT * FROM Hangsx
---Câu 13---
CREATE VIEW view13 AS
WITH tam AS (
    SELECT TOP 100 PERCENT SanPham.masp, SanPham.tensp, SanPham.soluong, SanPham.mausac, SanPham.giaban, SanPham.donvitinh, SanPham.mota---tham khảo link 'http://hoidapsql.blogspot.com/2015/11/mot-vai-luu-y-khi-su-dung-top-va-order.html'---
    FROM SanPham 
    ORDER BY giaban DESC)
SELECT * FROM tam;
---Câu 14---
CREATE VIEW view14 AS
SELECT Hangsx.tenhang, SanPham.tensp 
FROM Hangsx inner join SanPham on Hangsx.mahangsx=SanPham.mahangsx
WHERE tenhang='Samsung' 
---Câu 15---
CREATE VIEW view15 AS
SELECT Manv, Tennv, Gioitinh, Diachi, Sodt, email, Phong
FROM Nhanvien
WHERE Gioitinh=N'Nữ' and Phong=N'Kế toán')
---Câu 16---
CREATE VIEW view16 AS
WITH tam_1 AS(
SELECT TOP 100 PERCENT Nhap.Sohdn, Nhap.Masp, SanPham.tensp, Hangsx.tenhang, Nhap.soluongN*Nhap.dongiaN as tiennhap, SanPham.mausac, SanPham.donvitinh, Nhap.Ngaynhap, Nhanvien.Tennv, Nhanvien.Phong
FROM Nhanvien inner join Nhap on Nhanvien.manv=Nhap.manv inner join SanPham on Nhap.masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.mahangsx
ORDER BY Nhap.Sohdn ASC)
SELECT * FROM tam_1;
---Câu 17---
CREATE VIEW view17 AS
WITH tam_2 AS(
SELECT TOP 100 PERCENT Xuat.Sohdx, Xuat.Masp, SanPham.tensp, Hangsx.tenhang, Xuat.soluongX*SanPham.giaban as tienxuat,SanPham.mausac,SanPham.donvitinh, Xuat.Ngayxuat,Nhanvien.Tennv,Nhanvien.Phong
FROM Nhanvien inner join Xuat on Nhanvien.manv=Xuat.manv inner join SanPham on Xuat.masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.mahangsx
WHERE YEAR(Xuat.Ngayxuat)='2018'
ORDER BY Xuat.Sohdx ASC)
SELECT * FROM tam_2;
---Câu 18---
CREATE VIEW view18 AS
SELECT Nhap.Sohdn, Nhap.Masp, SanPham.tensp, Nhap.soluongN, Nhap.dongiaN, Nhap.Ngaynhap, Nhanvien.Tennv,Nhanvien.Phong, Hangsx.tenhang
FROM Nhanvien inner join Nhap on Nhanvien.manv=Nhap.manv inner join SanPham on Nhap.masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.mahangsx
WHERE tenhang='Samsung' and YEAR(Nhap.Ngaynhap)='2017'
---Câu 19---
CREATE VIEW view19 AS
WITH tam_3 AS(
SELECT TOP 10 Xuat.Sohdx, Xuat.masp, SanPham.tensp, HangSX.tenhang, Xuat.soluongX, SanPham.giaban, Xuat.soLuongX*SanPham.giaban AS TienXuat, SanPham.mauSac, SanPham.donvitinh, Xuat.ngayxuat, NhanVien.Tennv, NhanVien.Phong
FROM Nhanvien inner join Xuat on Nhanvien.manv=Xuat.manv inner join SanPham on Xuat.masp=SanPham.masp inner join Hangsx on SanPham.mahangsx=Hangsx.mahangsx
WHERE YEAR(Xuat.ngayxuat) = '2008'
ORDER BY Xuat.soluongX DESC)
SELECT * FROM tam_3;
---Câu 20---
CREATE VIEW view20 AS
WITH tam_4 AS(
SELECT TOP 10 *
FROM SanPham
ORDER BY giaban DESC)
SELECT * FROM tam_4;
---Câu 21---
CREATE VIEW view21 AS
SELECT Hangsx.tenhang, SanPham.tensp, SanPham.giaban
FROM Hangsx inner join SanPham on Hangsx.mahangsx=SanPham.mahangsx
WHERE Hangsx.tenhang='Samsung' and SanPham.giaban between 100000 and 500000
---Câu 22---
CREATE VIEW view22 AS
SELECT SUM(Nhap.dongiaN * Nhap.soluongN) as tongtiennhap
FROM Hangsx inner join SanPham on Hangsx.mahangsx=SanPham.mahangsx inner join Nhap on SanPham.masp=Nhap.Masp
WHERE Hangsx.tenhang='Samsung' and YEAR(Nhap.Ngaynhap)='2018'
---Câu 23---
CREATE VIEW view23 AS
SELECT SUM(Xuat.soluongX * SanPham.giaban) as tongtienxuat
FROM Xuat inner join SanPham on Xuat.masp=SanPham.masp
WHERE  CONVERT(DATE, Xuat.Ngayxuat,105)='02-09-2018'
---Câu 24-----------
CREATE VIEW view24 AS
WITH tam_5 AS(
SELECT  TOP 100 PERCENT Nhap.dongiaN* Nhap.soluongN as tiennhap, Nhap.Sohdn, Nhap.Ngaynhap
FROM Nhap
WHERE YEAR(Nhap.Ngaynhap)='2018'
ORDER BY tiennhap DESC)
SELECT * FROM tam_5;
---Câu 25---
CREATE VIEW view25 AS
WITH tam_6 AS(
SELECT TOP 10 Nhap.soluongN, Nhap.masp, SanPham.tensp, Nhap.Ngaynhap
FROM Nhap inner join SanPham on Nhap.masp=SanPham.masp
WHERE YEAR(Nhap.Ngaynhap)='2019' 
ORDER BY Nhap.soluongN DESC)
SELECT * FROM tam_6; 
---Câu 26---
CREATE VIEW view26 AS
SELECT Hangsx.tenhang, SanPham.tensp, Nhap.manv
FROM Hangsx inner join SanPham on Hangsx.mahangsx=SanPham.mahangsx inner join Nhap on SanPham.masp=Nhap.masp
WHERE tenhang='Samsung' and Nhap.manv='NV01'
---Câu 27---
CREATE VIEW view27 AS
SELECT Nhap.Manv, Nhap.Masp, Nhap.soluongN, Nhap.Ngaynhap
FROM Nhap
WHERE Nhap.Masp='SP02' and Nhap.Manv='NV02'
---Câu 28---
CREATE VIEW view28 AS
SELECT Xuat.Manv, Nhanvien.Tennv
FROM Xuat inner join Nhanvien on Xuat.Manv=Nhanvien.Manv
WHERE Xuat.Masp='SP02' and CONVERT(DATE, Xuat.Ngayxuat,105)='03-02-2020'
