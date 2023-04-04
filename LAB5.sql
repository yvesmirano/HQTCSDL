use QuanLyBanHang
go
----------------lab5---------------
--1. Hãy xây dựng hàm đưa ra tên HangSX khi nhập vào MaSP từ bàn phím
CREATE FUNCTION TenHangSX (@MaSP varchar(4))
RETURNS varchar(50)
AS
BEGIN
    DECLARE @TenHangSX varchar(50)
    SELECT @TenHangSX = HangSX.TenHang
    FROM SanPham 
    INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX 
    WHERE SanPham.MaSP = @MaSP
    RETURN @TenHangSX
END

select dbo.TenHangSX('SP01')

--2. Hãy xây dựng hàm đưa ra tổng giá trị nhập từ năm nhập x đến nay nhập y, với x, y được nhập vào từ bàn phím.
CREATE FUNCTION fn_TongGiaTriNhap(@x INT, @y INT)
RETURNS BIGINT
AS
BEGIN
	DECLARE @tongGiaTriNhap BIGINT
	SELECT @tongGiaTriNhap = SUM(n.SoLuongN * n.DonGian)
	FROM Nhap n
	WHERE YEAR(n.NgayNhap) >= @x AND YEAR(n.NgayNhap) <= @y
	RETURN @tongGiaTriNhap
END

SELECT dbo.fn_TongGiaTriNhap(2018, 2020) AS 'TongGiaTriNhap'

--3. Hãy viết hàm thống kê tổng số lượng thay đổi nhập xuất của tên sản phẩm x trong năm y, với x,y nhập từ bàn phím.
CREATE FUNCTION tongsoluong_thaydoi_nhapxuat(@ten_sp VARCHAR(50), @nam INT)
RETURNS INT
AS
BEGIN
    DECLARE @tong_nhap INT;
    DECLARE @tong_xuat INT;
    DECLARE @ketqua INT;

    SET @tong_nhap = (SELECT SUM(soluongN) FROM Nhap n JOIN Sanpham s ON n.masp = s.masp WHERE s.tensp = @ten_sp AND YEAR(n.ngaynhap) = @nam);
    SET @tong_xuat = (SELECT SUM(soluongX) FROM Xuat x JOIN Sanpham s ON x.masp = s.masp WHERE s.tensp = @ten_sp AND YEAR(x.ngayxuat) = @nam);

    SET @ketqua = @tong_xuat - @tong_nhap;

    RETURN @ketqua;
END

SELECT dbo.tongsoluong_thaydoi_nhapxuat('Galaxy Note 11', 2020) AS ketqua;

--4. . Hãy xây dựng hàm đưa ra tổng giá trị nhập từ ngày nhập x đến ngày nhập y, với x,y được nhập vào từ bàn phím.
CREATE FUNCTION fn_TongGiaTriNhap(@x DATE, @y DATE)
RETURNS MONEY
AS
BEGIN
  DECLARE @tong MONEY;
  SELECT @tong = SUM(DonGian * SoLuongN)
  FROM Nhap
  WHERE ngaynhap BETWEEN @x AND @y;

  IF @tong IS NULL
    SET @tong = 0;

  RETURN @tong;
END;

SELECT dbo.fn_TongGiaTriNhap('2022-01-01', '2022-02-28')

--5.  Hãy xây dựng hàm đưa ra tổng giá trị xuất của hãng tên hãng là A, trong năm tài khóa x, với A, x được nhập từ bàn phím.
CREATE FUNCTION fn_TongGiaTriXuatHangA(@A NVARCHAR(50),@x INT)
RETURNS INT
AS
BEGIN
    DECLARE @TongGiaTriXuat INT
    SELECT @TongGiaTriXuat = SUM(Xuat.SoLuongX * SanPham.GiaBan) 
        FROM Xuat 
        JOIN SanPham ON Xuat.MaSP = SanPham.MaSP
        JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSX
        WHERE HangSX.TenHang = @A
            AND YEAR(Xuat.ngayxuat) = @x
    
    RETURN @TongGiaTriXuat
END

select fn_TongGiaTriXuatHangA('SamSung', 2020)

--6.  Hãy xây dựng hàm thông kê số lượng nhân viên mỗi phòng với tên phòng nhập từ bàn phím.
CREATE FUNCTION dem_soluong_NV(@tenphong VARCHAR(50))
RETURNS INT
BEGIN
    DECLARE @dem int ;
    SELECT COUNT(*) into @dem FROM NhanVien WHERE Phong = @tenphong
    RETURN @dem;
END

select dem_soluong_NV('kế toán')

--7. . Hãy viết hàm thống kê tên sản phẩm x đã xuất được bao nhiêu sản phẩm trong ngày y, với x,y nhập từ bàn phím.
CREATE FUNCTION thongkexuat(@tensp VARCHAR(50), @ngayxuat DATE)
RETURNS INT
AS
BEGIN
    DECLARE @sldaxuat INT;
    SELECT @sldaxuat = SUM(soluongX) FROM Xuat WHERE masp = (SELECT masp FROM Sanpham WHERE tensp = @tensp) AND ngayxuat = @ngayxuat;
    RETURN @sldaxuat;
END;

select thongkexuat('Galaxy Note 11','2020-02-02')

-- 8. Hãy viết hàm trả về số điện thoại của nhân viên đã xuất số hóa đơn x, với x nhập từ bàn phím.
CREATE FUNCTION getSDT_nhanvienXuat (@sohdx int)
RETURNS nvarchar(20)
AS
BEGIN
    DECLARE @manv int
    DECLARE @sodt nvarchar(20)
    
    SELECT @manv = manv FROM Xuat WHERE SoHDX = @sohdx
    
    SELECT @sodt = sdt FROM NhanVien WHERE manv = @manv
    
    RETURN @sodt
END

select getSDT_nhanvienXuat('x01')

-- 9. Hãy viết hàm thống kê số lượng thay đổi nhập xuất của tên sản phẩm x trong năm y, với x,y nhập từ bàn phím.
CREATE FUNCTION sp_qty_change_in_year(@x VARCHAR(255), @y INT)
RETURNS INT
BEGIN
    DECLARE qty_change INT;
    SELECT SUM(IFNULL(n.soluongN, 0) - IFNULL(x.soluongX, 0))
    INTO qty_change
    FROM (SELECT masp, SUM(soluongX) AS soluongX
          FROM Xuat
          WHERE YEAR(ngayxuat) = @y
          GROUP BY masp) AS x
    RIGHT JOIN (SELECT masp, SUM(soluongN) AS soluongN
                FROM Nhap
                WHERE YEAR(ngaynhap) = @y
                GROUP BY masp) AS n
    ON x.masp = n.masp
    JOIN Sanpham AS sp ON n.masp = sp.masp
    WHERE sp.tensp = @x;
    RETURN qty_change;
END;
