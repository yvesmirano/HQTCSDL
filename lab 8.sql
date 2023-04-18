use QuanLyBanHang
go
------------------LAB 8---------------------
--1. Viết thủ tục thêm mới nhân viên bao gồm các tham số: manv, tennv, gioitinh, diachi, sodt, email, phong và 1 biến Flag. Nếu Flag = 0 thì nhập mới, ngược lại thì cập nhật thông tin nhân viên theo mã. Hãy kiểm tra:
-- gioitinh nhập vào có phải là Nam hoặc Nữ không nếu không trả về mã lỗi 1. 
-- Ngược lại nếu thỏa mãn thì cho phép nhập và trả về mã lỗi 0..
CREATE PROCEDURE [dbo].[spThemMoiNhanVien]
    @manv varchar(10),
    @tennv varchar(50),
    @gioitinh varchar(3),
    @diachi varchar(100),
    @sodt varchar(20),
    @email varchar(50),
    @phong varchar(10),
    @flag int
AS
BEGIN
    SET NOCOUNT ON;

    IF @flag = 0 -- Thêm mới
    BEGIN
        -- Kiểm tra giới tính
        IF @gioitinh NOT IN ('Nam', 'Nữ')
        BEGIN
            RETURN 1; -- Trả về mã lỗi 1 nếu giới tính không hợp lệ
        END

        -- Thêm mới nhân viên
        INSERT INTO NhanVien (MaNV, TenNV, GioiTinh, DiaChi, SDT, Email, Phong)
        VALUES (@manv, @tennv, @gioitinh, @diachi, @sodt, @email, @phong)

        RETURN 0; -- Trả về mã lỗi 0 nếu thêm mới thành công
    END
    ELSE -- Cập nhật thông tin nhân viên theo mã
    BEGIN
        -- Kiểm tra giới tính
        IF @gioitinh NOT IN ('Nam', 'Nữ')
        BEGIN
            RETURN 1; -- Trả về mã lỗi 1 nếu giới tính không hợp lệ
        END

        -- Cập nhật thông tin nhân viên
        UPDATE NhanVien
        SET TenNV = @tennv,
            GioiTinh = @gioitinh,
            DiaChi = @diachi,
            SDT = @sodt,
            Email = @email,
            Phong = @phong
        WHERE MaNV = @manv

        RETURN 0; -- Trả về mã lỗi 0 nếu cập nhật thành công
    END
END

exec dbo.spThemMoiNhanVien 'NV04','Tran Hong Nhat','nam','Ho Chi Minh','079202031772','nhat@gmail.com','Vat Tu','0'

--2. Viết thủ tục thêm mới sản phẩm với các tham biến masp, tenhang, tensp, soluong, mausac, giaban, donvitinh, mota và biến Flag. Nếu Flag = 0 thì thêm mới sản phẩm, ngược lại cập nhật sản phẩm. Hãy kiểm tra:
-- Nếu tenhang không có trong bảng hangsx thì trả về mã lỗi 1
-- Nếu soluong < 0 thì trả về mã lỗi 2 
-- Ngược lại trả về mã lỗi 0.

CREATE PROCEDURE [dbo].[spThemMoiSanPham]
    @masp varchar(10),
    @mahang varchar(50),
    @tensp nvarchar(100),
    @soluong int,
    @mausac nvarchar(50),
    @giaban money,
    @donvitinh nvarchar(50),
    @mota nvarchar(MAX),
    @Flag bit
AS
BEGIN
    -- Kiểm tra tên hàng có tồn tại trong bảng hangsx hay không
    IF NOT EXISTS (SELECT 1 FROM hangsx WHERE MaHangSX = @mahang)
    BEGIN
        SELECT 1 AS 'ErrorCode'
        RETURN
    END
    
    -- Kiểm tra số lượng sản phẩm
    IF @soluong < 0
    BEGIN
        SELECT 2 AS 'ErrorCode'
        RETURN
    END
    
    IF @Flag = 0 -- Thêm mới sản phẩm
    BEGIN
        INSERT INTO sanpham (masp, MaHangSX, tensp, soluong, mausac, giaban, donvitinh, mota)
        VALUES (@masp, @mahang, @tensp, @soluong, @mausac, @giaban, @donvitinh, @mota)
    END
    ELSE -- Cập nhật sản phẩm
    BEGIN
        UPDATE sanpham
        SET tensp = @tensp, soluong = @soluong, mausac = @mausac, giaban = @giaban, donvitinh = @donvitinh, mota = @mota
        WHERE masp = @masp
    END

    SELECT 0 AS 'ErrorCode'
END

exec dbo.spThemMoiSanPham 'SP06','I03','iPhone 14 Pro Max',-1,'trang',5000000,'chiec','','0'
--3. Viết thủ tục xóa dữ liệu bảng nhanvien với tham biến là manv. Nếu manv chưa có thì trả về 1, ngược lại xóa nhanvien với nhanvien bị xóa là manv và trả về 0. (Lưu ý: xóa nhanvien thì phải xóa các bảng Nhap, Xuat mà nhân viên này tham gia)
CREATE PROC [dbo].[spxoanhanvien] 
	@manv varchar(10)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNV= @manv)
	BEGIN
		SELECT 1 AS 'ERRORCODE'
		RETURN
	END
	ELSE
	BEGIN
		DELETE FROM Nhap WHERE manv = @manv
		DELETE FROM Xuat WHERE manv = @manv
		DELETE FROM nhanvien WHERE manv = @manv

		SELECT 0 AS 'ERRORCODE'
		RETURN
	END
END
EXEC dbo. spxoanhanvien 'NV02'
--4. Viết thủ tục xóa dữ liệu bảng sanpham với tham biến là masp. Nếu masp chưa có thì trả về 1, ngược lại xóa sanpham với sanpham bị xóa là masp và trả về 0. (Lưu ý: Xóa sanpham thì phải xóa các bảng Nhap, Xuat mà sanpham nay cung ứng)
CREATE PROC [dbo].[spxoasanpham]
	@masp varchar(10)
AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM SanPham WHERE MaSP = @masp)
	BEGIN
		SELECT 1 AS 'ERRORCODE'
		RETURN
	END
	ELSE 
	BEGIN 
	DELETE FROM Nhap WHERE MaSP = @masp
	DELETE FROM Xuat WHERE MaSP = @masp
	DELETE FROM SanPham WHERE MaSP = @masp

	SELECT 0 AS 'ERRORCODE'
	RETURN
	END
END
EXEC dbo.spxoasanpham 'SP04'
--Câu 5 Tạo thủ tục nhập liệu cho bảng Hangsx, với các tham biế truyền vào mahangssx
create proc [dbo].[spnhaphangsx]
	@mahangsx varchar(20),
	@tenhang varchar(20),
	@diachi varchar(20),
	@sdt varchar(20),
	@email varchar(20)
as
BEGIN
	IF EXISTS(SELECT * FROM hangSX WHERE tenhang = @Tenhang)
	BEGIN
		RETURN 1;
	END
	ELSE
	BEGIN
		INSERT INTO hangSX (mahangsx, tenhang, diachi, sdt, email)
		VALUES (@mahangsx, @tenhang, @diachi, @sdt, @email)

		RETURN 0;
	END
END

exec dbo.spnhaphangsx 'H07','svmax','can tho','0098310092','svmax@gmail.com'
----6. Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến sohdn, masp, manv, ngaynhap, soluongN, dongiaN. Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không, nếu không trả về 1? manv có tồn tại trong bảng nhanvien hay không nếu không trả về 2? ngược lại thì hãy kiểm tra: Nếu sohdn đã tồn tại thì cập nhật bảng Nhap theo sohdn, ngược lại thêm mới bảng Nhap và trả về mã lỗi 0.
create proc [dbo].[spinsertNhap]
	@sohdn varchar(5),
	@masp varchar(5),
	@manv varchar(5),
	@ngaynhap date,
	@soluongN int,
	@dongiaN int
as
BEGIN
    -- Kiểm tra masp có tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS(SELECT masp FROM Sanpham WHERE masp = @masp)
    BEGIN
        -- Trả về mã lỗi 1 nếu masp không tồn tại
        SELECT 1 AS ErrorCode
        RETURN
    END

    -- Kiểm tra manv có tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS(SELECT manv FROM Nhanvien WHERE manv = @manv)
    BEGIN
        -- Trả về mã lỗi 2 nếu manv không tồn tại
        SELECT 2 AS ErrorCode
        RETURN
    END

    -- Kiểm tra xem sohdn đã tồn tại chưa
    IF EXISTS(SELECT sohdn FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        -- Nếu đã tồn tại thì cập nhật bảng Nhap
        UPDATE Nhap
        SET masp = @masp, manv = @manv, ngaynhap = @ngaynhap, soluongN = @soluongN, dongiaN = @dongiaN
        WHERE sohdn = @sohdn
    END
    ELSE
    BEGIN
        -- Nếu chưa tồn tại thì thêm mới vào bảng Nhap
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
    END

    -- Trả về mã lỗi 0 nếu thực hiện thành công
    SELECT 0 AS ErrorCode
END
create proc [dbo].[spnhaphangsx]
	@mahangsx varchar(20),
	@tenhang varchar(20),
	@diachi varchar(20),
	@sdt varchar(20),
	@email varchar(20)
as
BEGIN
	IF EXISTS(SELECT * FROM Hangsx WHERE tenhang = @tenhang)
	BEGIN
		RETURN 1;
	END
	ELSE
	BEGIN
		INSERT INTO Hangsx (mahangsx, tenhang, diachi, sdt, email)
		VALUES (@mahangsx, @tenhang, @diachi, @sdt, @email)

		RETURN 0;
	END
END

exec dbo.spnhaphangsx 'H07','svmax','can tho','0098310092','svmax@gmail.com'

/* câu 6: Viết thủ tục nhập dữ liệu cho bảng Nhap với các tham biến
 sohdn, masp, manv, ngaynhap, soluongN, dongiaN. Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không,
  nếu không trả về 1? manv có tồn tại trong bảng nhanvien hay không nếu không trả về 2?
   ngược lại thì hãy kiểm tra: Nếu sohdn đã tồn tại thì cập nhật bảng Nhap theo sohdn,
    ngược lại thêm mới bảng Nhap và trả về mã lỗi 0*/

create proc [dbo].[spinsertNhap]
	@sohdn varchar(5),
	@masp varchar(5),
	@manv varchar(5),
	@ngaynhap date,
	@soluongN int,
	@dongiaN int
as
BEGIN
    -- Kiểm tra masp có tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS(SELECT masp FROM Sanpham WHERE masp = @masp)
    BEGIN
        -- Trả về mã lỗi 1 nếu masp không tồn tại
        SELECT 1 AS ErrorCode
        RETURN
    END

    -- Kiểm tra manv có tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS(SELECT manv FROM Nhanvien WHERE manv = @manv)
    BEGIN
        -- Trả về mã lỗi 2 nếu manv không tồn tại
        SELECT 2 AS ErrorCode
        RETURN
    END

    -- Kiểm tra xem sohdn đã tồn tại chưa
    IF EXISTS(SELECT sohdn FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        -- Nếu đã tồn tại thì cập nhật bảng Nhap
        UPDATE Nhap
        SET masp = @masp, manv = @manv, ngaynhap = @ngaynhap, soluongN = @soluongN, dongiaN = @dongiaN
        WHERE sohdn = @sohdn
    END
    ELSE
    BEGIN
        -- Nếu chưa tồn tại thì thêm mới vào bảng Nhap
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN, dongiaN)
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN, @dongiaN)
    END

    -- Trả về mã lỗi 0 nếu thực hiện thành công
    SELECT 0 AS ErrorCode
END


--- 7:  Viết thủ tập nhập dữ liệu cho bảng xuat với các tham biến sohdx, masp, manv, ngayxuat, soluongX. Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không nếu không trả về 1? manv có tồn tại trong bảng nhanvien hay không nếu không trả về 2? soluongX <= Soluong nếu không trả về 3? ngược lại thì hãy kiểm tra: Nếu sohdx đã tồn tại thì cập nhật bảng Xuat theo sohdx, ngược lại thêm mới bảng Xuat và trả về mã lỗi 0*/

CREATE PROCEDURE spNhapDuLieuXuat 
    @sohdx VARCHAR(20),
    @masp VARCHAR(20),
    @manv VARCHAR(20),
    @ngayxuat DATE,
    @soluongX INT
	AS
BEGIN
    -- Kiểm tra mã sản phẩm có tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE Masp = @masp)
    BEGIN
        RETURN 1; -- Trả về mã lỗi 1 nếu mã sản phẩm không tồn tại
    END
    
    -- Kiểm tra mã nhân viên có tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE Manv = @manv)
    BEGIN
        RETURN 2; -- Trả về mã lỗi 2 nếu mã nhân viên không tồn tại
    END
    
    -- Kiểm tra số lượng xuất có lớn hơn 0 và không vượt quá số lượng sản phẩm tồn kho
    IF @soluongX <= 0 OR @soluongX > (SELECT Soluong FROM Sanpham WHERE Masp = @masp)
    BEGIN
        RETURN 3; -- Trả về mã lỗi 3 nếu số lượng xuất không hợp lệ
    END
    
    -- Kiểm tra nếu sohdx đã tồn tại thì cập nhật bảng Xuat, ngược lại thêm mới bảng Xuat
    IF EXISTS (SELECT * FROM Xuat WHERE Sohdx = @sohdx)
    BEGIN
        UPDATE Xuat
        SET Masp = @masp, Manv = @manv, Ngayxuat = @ngayxuat, SoluongX = @soluongX
        WHERE Sohdx = @sohdx;
    END
    ELSE
    BEGIN
        INSERT INTO Xuat (Sohdx, Masp, Manv, Ngayxuat, SoluongX)
        VALUES (@sohdx, @masp, @manv, @ngayxuat, @soluongX);
    END
    
    RETURN 0; -- Trả về mã lỗi 0 nếu thêm hoặc cập nhật bảng Xuat thành công
END