use QuanLyBanHang
go

-------------------lap3---------------------------------
-- 1. hãy  thống kê xem  mỗi hãng  sản xuất có bao nhiêu loại sản phẩm
SELECT HangSX.TenHang, COUNT(*) AS SoLuongSanPham
FROM SanPham 
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
GROUP BY HangSX.TenHang
-- 2. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2018
SELECT SanPham.MaSP, SanPham.TenSP, SUM(Nhap.SoLuongN * Nhap.DonGian) AS TongTienNhap
FROM SanPham JOIN Nhap ON SanPham.MaSP = Nhap.MaSP
WHERE YEAR(Nhap.NgayNhap) = 2018
GROUP BY SanPham.MaSP, SanPham.TenSP
--3. Hãy thống kế các sản phẩm có tổng số lượng xuất năm 2018 là lớn hơn 10.000 sản phẩm của hãng samsung.
SELECT SanPham.MaSP, SanPham.TenSP, SUM(Xuat.SoLuongX) as TongSoLuongXuat
FROM SanPham
INNER JOIN Xuat ON SanPham.MaSP = Xuat.MaSP
INNER JOIN NhanVien ON Xuat.MaNV = NhanVien.MaNV
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
WHERE YEAR(Xuat.NgayXuat) = 2018 AND HangSX.TenHang = 'Samsung' 
GROUP BY SanPham.MaSP, SanPham.TenSP
HAVING SUM(Xuat.SoLuongX) > 10000;
--4. Thống kê số lượng nhân viên Nam của mỗi phòng ban.
SELECT Phong, COUNT(*) AS SoLuongNam
FROM NhanVien
WHERE GioiTinh = 'nam'
GROUP BY Phong
--5. Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
SELECT HangSX.TenHang, SUM(Nhap.SoLuongN) as TongSoLuongNhap
FROM Nhap
INNER JOIN SanPham ON Nhap.MaSP = SanPham.MaSP
INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
WHERE YEAR(Nhap.NgayNhap) = 2018
GROUP BY HangSX.TenHang
ORDER BY TongSoLuongNhap DESC
--6. Hãy thống kê xem tổng lượng tiền xuất của mỗi nhân viên trong năm 2018 là bao nhiêu.
SELECT Xuat.MaNV, NhanVien.TenNV, SUM(Xuat.SoLuongX * SanPham.GiaBan) AS TongTienXuat
FROM Xuat
JOIN NhanVien ON Xuat.MaNV = NhanVien.MaNV
JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
WHERE YEAR(Xuat.NgayXuat) = 2018
GROUP BY Xuat.MaNV, NhanVien.TenNV
--7. Hãy đưa ra tổng tiền nhập của mỗi nhân viên trong tháng 8 - năm 2018 có tổng giá trị lớn hơn 100.000
SELECT Nhap.MaNV, SUM(Nhap.SoLuongN*Nhap.DonGian) AS TongTienNhap
FROM Nhap
WHERE MONTH(Nhap.NgayNhap) = 8 AND YEAR(Nhap.NgayNhap) = 2018
GROUP BY Nhap.MaNV
HAVING SUM(Nhap.SoLuongN*Nhap.DonGian) > 100000
--8. Hãy đưa ra danh sách các sản phẩm đã nhập nhưng chưa xuất bao giờ
SELECT SanPham.MaSP, SanPham.TenSP
FROM SanPham
WHERE SanPham.MaSP NOT IN (SELECT MaSP FROM Xuat)
--9. Hãy đưa ra danh sách các sản phẩm đã nhập năm 2018 và đã xuất năm 2018
SELECT DISTINCT SanPham.MaSP, SanPham.TenSP
FROM SanPham
JOIN Nhap ON SanPham.MaSP = Nhap.MaSP
JOIN Xuat ON Nhap.MaSP = Xuat.MaSP
WHERE YEAR(Nhap.NgayNhap) = 2018 AND YEAR(Xuat.NgayXuat) = 2018
--10. Hãy đưa ra danh sách các nhân viên vừa nhập vừa xuất
SELECT DISTINCT NhanVien.MaNV, NhanVien.TenNV
FROM Nhap INNER JOIN Xuat
ON Nhap.MaNV = Xuat.MaNV AND Nhap.MaSP = Xuat.MaSP
INNER JOIN NhanVien
ON Nhap.MaNV = NhanVien.MaNV

--11. Hãy đưa ra danh sách các nhân viên không tham gia việc nhập và xuất
SELECT *
FROM NhanVien
WHERE MaNV NOT IN (
    SELECT DISTINCT MaNV FROM Nhap
    UNION
    SELECT DISTINCT MaNV FROM Xuat
)
