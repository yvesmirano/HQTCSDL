use QuanLyBanHang
go 

--LAB 7
--1. Tạo thủ tục nhập liệu cho bảng Hangsx, với các tham biến truyền vào mahangsx, tenhang, diachi, sodt, email. Hãy kiểm tra xem tenhang đã tồn tại trước đó hay chưa? Nếu có rồi thì không cho nhập và đưa ra thông báo
create proc nhap_hangSX(
		@ma nvarchar(10),
		@ten nvarchar(30),
		@dc nvarchar(30),
		@sdt nvarchar(12),
		@email nvarchar(40) )
as
begin
	if (exists (select * from HangSX where TenHang= @ten))
		print 'ten hang da ton tai moi ban nhap ten khac'
	else 
		insert into HangSX values( @ma, @ten, @dc, @sdt, @email)
end

--2. Tạo thủ tục nhập dữ liệu cho bảng sản phẩm với các tham biến truyền vào masp, tenhangsx, tensp, soluong, mausac, giaban, donvitinh, mota. Hãy kiểm tra xem nếu masp đã tồn tại thì cập nhật thông tin sản phẩm theo mã, ngược lại thêm mới sản phẩm vào bảng sanpham.

create proc nhap_sp(
		@ma nvarchar(10),
		@mahang nvarchar(30),
		@tensp nvarchar(30),
		@sl int,
		@mausac nvarchar(20),
		@gia money,
		@donvi nvarchar(20),
		@mota nvarchar(max)
		 )
as
begin
	if (exists (select * from SanPham where MaSP=@ma))
	begin
		update SanPham
		set SoLuong =  @sl + SoLuong
		where MaSP=@ma
	end
	else 
		insert into HangSX values( @ma,@mahang, @tensp, @sl, @mausac,@gia, @donvi, @mota)
end

--3. Viết thủ tục xóa dữ liệu bảng hangsx với tham biến là tenhang. Nếu tenhang chưa có thì thông báo, ngược lại xóa hangsx với hãng bị xóa là tenhang. (Lưu ý: xóa hangsx thì phải xóa các sản phẩm mà hangsx này cung ứng).

create proc xoa_hangsx @tenhang nvarchar(50)
as
begin
    set nocount on;
    
    IF NOT EXISTS (SELECT * FROM hangsx WHERE tenhang = @tenhang)
    BEGIN
        PRINT N'Hãng sản xuất không tồn tại!'
        RETURN
    END
    else
    BEGIN TRANSACTION
    DECLARE @mahang int = (SELECT MaHangSX FROM HangSX WHERE TenHang = @tenhang)
    
    DELETE FROM SanPham WHERE SanPham.MaHangSX = @mahang
    DELETE FROM HangSX WHERE TenHang = @tenhang

    COMMIT TRANSACTION
    
    PRINT N'Xóa thành công!'
END

--4. Viết thủ tục nhập dữ liệu cho bảng nhân viên với các tham biến, manv, tennv, gioitinh, diachi, sdt, email, phong, và 1 biến cờ Flag. Nếu Flag = 0 thì cập nhật dữ liệu cho bảng nhân viên theo manv, ngược lại thêm mới nhân viên này.
CREATE PROCEDURE sp_NhapDuLieuNhanVien
    @manv varchar(10),
    @tennv nvarchar(50),
    @gioitinh nvarchar(10),
    @diachi nvarchar(100),
    @sdt varchar(15),
    @email nvarchar(50),
    @phong nvarchar(50),
    @Flag bit
AS
BEGIN
    IF @Flag = 0
    BEGIN
        UPDATE nhanvien
        SET tennv = @tennv,
            gioitinh = @gioitinh,
            diachi = @diachi,
            sdt = @sdt,
            email = @email,
            phong = @phong
        WHERE manv = @manv
    END
    ELSE
    BEGIN
        INSERT INTO nhanvien
        VALUES(@manv, @tennv, @gioitinh, @diachi, @sdt, @email, @phong)
    END
END

--5. Viết thủ tục  nhập dữ liệu cho bảng Nhap với các tham biến sohdn, masp, manv, ngaynhap, soluongN. Kiểm tra xem masp, có tồn tại trong bảng Sanpham hay không? manv có tồn tại trong bảng nhân viên hay không? Nếu không thì thông báo, ngược lại thì hãy kiểm tra: Nếu sohdn đã tồn tại thì cập nhật bảng Nhap theo sohdn, ngược lại thêm mới bảng Nhap.

CREATE PROCEDURE pc_insertNhap
    @sohdn int,
    @masp int,
    @manv int,
    @ngaynhap date,
    @soluongN int
AS
BEGIN
    -- Kiểm tra sản phẩm có tồn tại trong bảng Sanpham hay không
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Sản phẩm không tồn tại trong bảng Sanpham'
        RETURN
    END

    -- Kiểm tra nhân viên có tồn tại trong bảng Nhanvien hay không
    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Nhân viên không tồn tại trong bảng Nhanvien'
        RETURN
    END

    -- Kiểm tra nếu số hóa đơn đã tồn tại thì cập nhật, ngược lại thêm mới
    IF EXISTS (SELECT * FROM Nhap WHERE sohdn = @sohdn)
    BEGIN
        UPDATE Nhap 
        SET masp = @masp, 
            manv = @manv, 
            ngaynhap = @ngaynhap, 
            soluongN = @soluongN 
        WHERE sohdn = @sohdn
    END
    ELSE
    BEGIN
        INSERT INTO Nhap (sohdn, masp, manv, ngaynhap, soluongN) 
        VALUES (@sohdn, @masp, @manv, @ngaynhap, @soluongN)
    END
END

--6. Viết thủ tục nhập dữ liệu cho bảng xuat với các tham biến sohdx, masp, manv, ngayxuat, soluongX. Kiểm tra xem masp có tồn tại trong bảng Sanpham hay không? manv có tồn tại trong bảng nhanvien không? soluongX <= Soluong? Nếu không thì thông báo, ngược lại thì hãy kiểm tra: Nếu sohdx đã tồn tại thì cập nhật bảng Xuat theo sohdx,  ngược lại thêm mới bảng Xuat.
CREATE PROCEDURE sp_InsertXuat
    @sohdx INT,
    @masp VARCHAR(10),
    @manv VARCHAR(10),
    @ngayxuat DATE,
    @soluongX INT
AS
BEGIN
    -- Kiểm tra sản phẩm tồn tại trong bảng Sanpham hay không?
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        PRINT 'Mã sản phẩm không tồn tại trong bảng Sanpham.'
        RETURN
    END

    -- Kiểm tra nhân viên tồn tại trong bảng nhanvien hay không?
    IF NOT EXISTS (SELECT * FROM nhanvien WHERE manv = @manv)
    BEGIN
        PRINT 'Mã nhân viên không tồn tại trong bảng nhanvien.'
        RETURN
    END

    -- Kiểm tra số lượng xuất không vượt quá số lượng tồn kho
    DECLARE @tonkho INT
    SELECT @tonkho = soluong FROM Sanpham WHERE masp = @masp
    IF @soluongX > @tonkho
    BEGIN
        PRINT 'Số lượng xuất vượt quá số lượng tồn kho.'
        RETURN
    END

    -- Kiểm tra nếu sohdx đã tồn tại thì cập nhật bảng Xuat, ngược lại thêm mới bảng Xuat
    IF EXISTS (SELECT * FROM Xuat WHERE sohdx = @sohdx)
    BEGIN
        UPDATE Xuat 
        SET masp = @masp, manv = @manv, ngayxuat = @ngayxuat, soluongX = @soluongX
        WHERE sohdx = @sohdx
        PRINT 'Cập nhật thành công.'
    END
    ELSE
    BEGIN
        INSERT INTO Xuat(sohdx, masp, manv, ngayxuat, soluongX)
        VALUES(@sohdx, @masp, @manv, @ngayxuat, @soluongX)
        PRINT 'Thêm mới thành công.'
    END
END

--7. Viết thủ tục xóa dữ liệu bảng nhanvien với tham biến là manv. Nếu manv chưa có thì thông báo, ngược lại xóa nhanvien với nhanvien bị xóa là manv. (Lưu ý: Xóa nhanvien thì phải xóa các bảng Nhap, Xuat mà nhân viên này tham gia).
CREATE PROCEDURE sp_XoaNhanVien
    @manv INT
AS
BEGIN
    -- Kiểm tra xem nhân viên đã tham gia nhập/xuất hàng chưa
    IF EXISTS (SELECT * FROM Nhap WHERE manv = @manv) OR EXISTS (SELECT * FROM Xuat WHERE manv = @manv)
    BEGIN
        -- Nếu đã tham gia thì xóa các bản ghi trong bảng Nhap/Xuat liên quan đến nhân viên này trước khi xóa nhân viên
        DELETE FROM Nhap WHERE manv = @manv
        DELETE FROM Xuat WHERE manv = @manv
    END

    -- Kiểm tra xem nhân viên có tồn tại trong bảng nhanvien hay không
    IF EXISTS (SELECT * FROM nhanvien WHERE manv = @manv)
    BEGIN
        -- Nếu tồn tại thì xóa nhân viên đó
        DELETE FROM nhanvien WHERE manv = @manv
        PRINT 'Đã xóa nhân viên có mã ' + CAST(@manv AS VARCHAR) + ' thành công!'
    END
    ELSE
    BEGIN
        -- Nếu không tồn tại thì thông báo
        PRINT 'Không tồn tại nhân viên có mã ' + CAST(@manv AS VARCHAR) + '!'
    END
END
--8. Viết thủ tục xóa dữ liệu bảng sanpham với tham biến là masp. Nếu masp chưa có thì thông báo, ngược lại xóa sanpham với sanpham bị xóa là masp. (Lưu ý: xóa sanpham thì phải xóa các bảng Nhap, Xuat mà sanpham này cung ứng
CREATE PROCEDURE sp_DeleteProduct
    @masp VARCHAR(10)
AS
BEGIN
    -- Kiểm tra xem sản phẩm có tồn tại trong bảng sản phẩm hay không
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE Masp = @masp)
    BEGIN
        PRINT 'Sản phẩm không tồn tại'
        RETURN
    END

    -- Xóa dữ liệu trong bảng Nhap dựa trên mã sản phẩm
    DELETE FROM Nhap WHERE Masp = @masp

    -- Xóa dữ liệu trong bảng Xuat dựa trên mã sản phẩm
    DELETE FROM Xuat WHERE Masp = @masp

    -- Xóa dữ liệu trong bảng Sanpham dựa trên mã sản phẩm
    DELETE FROM Sanpham WHERE Masp = @masp

    PRINT 'Xóa sản phẩm thành công'
END
