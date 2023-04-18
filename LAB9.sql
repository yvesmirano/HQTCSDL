use QuanLyBanHang
go

--1. Tạo trigger kiểm soát việc nhập dữ liệu cho bảng nhập. hãy kiểm tra các ràng buộc toàn vẹn: masp có trong bảng sản phẩm chưa? manv có trong bảng nhân viên chưa? kiểm tra các ràng buộc dữ liệu: soluongN và dongiaN>0? Sau khi nhập thì soluong ở bảng Sanpham sẽ được cập nhật theo.
 CREATE TRIGGER trgNhap ON Nhap AFTER INSERT AS
BEGIN
    DECLARE @masp VARCHAR(10)
    DECLARE @manv VARCHAR(10)
    DECLARE @soluongN INT
    DECLARE @dongiaN FLOAT

    SELECT @masp = masp, @manv = manv, @soluongN = soluongN, @dongiaN = dongiaN FROM inserted

    IF NOT EXISTS (SELECT masp FROM Sanpham WHERE masp = @masp)
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng Sanpham.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF NOT EXISTS (SELECT manv FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng Nhanvien.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF @soluongN <= 0 OR @dongiaN <= 0
    BEGIN
        RAISERROR('Số lượng và đơn giá phải lớn hơn 0.', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    UPDATE Sanpham SET soluong = soluong + @soluongN WHERE masp = @masp
END

--2. Tạo trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc toàn vẹn: masp có trong bảng sản phẩm chưa? manv có trong bảng nhân viên chưa? kiểm tra các ràng buộc dữ liệu: soluongX < soluong trong bảng sanpham? Sau khi xuất thì soluong ở bảng Sanpham sẽ được cập nhật theo.
CREATE TRIGGER kiem_soat_xuat
ON Xuat
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @masp INT, @manv INT, @soluongX INT;

    SELECT @masp = masp, @manv = manv, @soluongX = soluongX
    FROM inserted;

    -- Kiểm tra ràng buộc toàn vẹn
    IF NOT EXISTS (SELECT * FROM Sanpham WHERE masp = @masp)
    BEGIN
        RAISERROR ('Mã sản phẩm không tồn tại trong bảng Sanpham', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    IF NOT EXISTS (SELECT * FROM Nhanvien WHERE manv = @manv)
    BEGIN
        RAISERROR ('Mã nhân viên không tồn tại trong bảng Nhanvien', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Kiểm tra ràng buộc dữ liệu
    IF @soluongX < 1
    BEGIN
        RAISERROR ('Số lượng xuất phải lớn hơn 0', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DECLARE @soluong_old INT;
    DECLARE @cursor CURSOR;

    SET @cursor = CURSOR FAST_FORWARD FOR
        SELECT soluong FROM Sanpham WHERE masp = @masp;

    OPEN @cursor;
    FETCH NEXT FROM @cursor INTO @soluong_old;

    -- Kiểm tra số lượng sản phẩm còn lại
    IF @soluong_old < @soluongX
    BEGIN
        RAISERROR ('Số lượng xuất lớn hơn số lượng hiện có', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Cập nhật số lượng sản phẩm sau khi xuất
    UPDATE Sanpham SET soluong = @soluong_old - @soluongX WHERE masp = @masp;

    CLOSE @cursor;
    DEALLOCATE @cursor;
END;

--3. Tạo trigger kiểm soát việc xóa phiếu xuất, khi phiếu xuất xóa thì số lượng hàng trong bảng sanpham sẽ được cập nhật tăng lên.
CREATE TRIGGER xoa_phieu_xuat
ON Xuat
FOR DELETE
AS
BEGIN
    DECLARE @masp INT
    DECLARE @soluongX INT
    
    DECLARE curXuat CURSOR FOR SELECT masp, soluongX FROM deleted
    OPEN curXuat
    FETCH NEXT FROM curXuat INTO @masp, @soluongX
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Sanpham SET soluong = soluong + @soluongX WHERE masp = @masp
        FETCH NEXT FROM curXuat INTO @masp, @soluongX
    END
    
    CLOSE curXuat
    DEALLOCATE curXuat
END
GO

-- 4. Tạo trigger cho việc cập nhật lại số lượng xuất trong bảng xuất, hãy kiểm tra xem số lượng xuất thay đổi có nhỏ hơn số lượng trong bảng sanpham hay không? số bản ghi thay đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép update bảng xuất và update lại soluong trong bảng sanpham.
 CREATE TRIGGER cap_nhat_soluongxuat
ON Xuat
AFTER UPDATE
AS
BEGIN
    -- Kiểm tra xem có ít nhất 1 bản ghi bị thay đổi hay không
    IF @@ROWCOUNT = 0
        RETURN;

    -- Kiểm tra xem số lượng xuất thay đổi có nhỏ hơn số lượng trong bảng sanpham hay không
    IF EXISTS (
        SELECT x.masp
        FROM inserted i
        JOIN Xuat x ON i.sohdx = x.sohdx
        JOIN Sanpham s ON x.masp = s.masp
        WHERE i.soluongX < x.soluongX - s.soluong
    )
    BEGIN
        RAISERROR('Số lượng xuất thay đổi không hợp lệ!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Cập nhật lại soluong trong bảng sanpham
    UPDATE Sanpham
    SET soluong = soluong + (
        SELECT SUM(i.soluongX - u.soluongX)
        FROM inserted i
        JOIN Xuat u ON i.sohdx = u.sohdx AND i.masp = u.masp
    )
    WHERE masp IN (
        SELECT masp
        FROM inserted
    )

    -- Cập nhật lại bảng xuất
    UPDATE Xuat
    SET soluongX = i.soluongX
    FROM inserted i
    WHERE Xuat.sohdx = i.sohdx AND Xuat.masp = i.masp
END

-- 5. Tạo trigger cho việc cập nhật lại số lượng Nhập trong bảng Nhập. Hãy kiểm tra xem số bản ghi thay đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép update bảng Nhập và update lại soluog trong bảng sanpham.
 CREATE TRIGGER update_soluong_nhap
ON Nhap
AFTER UPDATE
AS
BEGIN
    DECLARE @count INT;
    SELECT @count = COUNT(*) FROM INSERTED;

    IF @count > 1
    BEGIN
        RAISERROR('Cannot update more than 1 row at a time', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DECLARE @masp INT;
    DECLARE @soluongN INT;

    SELECT @masp = i.masp, @soluongN = i.soluongN
    FROM INSERTED i;

    IF @soluongN < 0
    BEGIN
        RAISERROR('Số lượng nhập phải lớn hơn hoặc bằng 0', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE Sanpham
    SET Soluong = Soluong - (SELECT SoluongN FROM DELETED WHERE masp = @masp) + @soluongN
    WHERE MaSP = @masp;

END
--6. Tạo trigger kiểm soát việc xóa phiếu nhập, khi phiếu nhập xóa thì số lượng hàng trong bảng sanpham sẽ được cập nhật giảm xuống.
CREATE TRIGGER [dbo].[xoa_phieu_nhap]
ON [dbo].[Nhap]
AFTER DELETE
AS
BEGIN
    DECLARE @masp INT, @soluong INT

    -- Lấy thông tin sản phẩm và số lượng hàng cần cập nhật
    SELECT @masp = d.Masp, @soluong = d.SoluongN
    FROM deleted d

    -- Cập nhật lại số lượng hàng trong bảng sanpham
    UPDATE Sanpham
    SET Soluong = Soluong - @soluong
    WHERE Masp = @masp
END
