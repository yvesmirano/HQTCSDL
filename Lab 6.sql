use QuanLyBanHang
go

--LAB 6--
--1. Hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím
create function thongtin_sanpham(@tenhang nvarchar(20))
returns @bang table( 
						masp nvarchar(10), tensp nvarchar(20),
						soluong int, mausac nvarchar(20),
						giaban float , donvitinh nvarchar(20),	mota nvarchar(max)
						)
as
begin
	insert into @bang
						select masp , tensp, soluong, mausac, giaban, donvitinh, mota
						from SanPham  inner join HangSX
														on	SanPham.MaHangSX=HangSX.MaHangSX
						where tenhang= @tenhang
	return
end

 

-----2. Hãy viết hàm đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được nhập từ ngày x đến ngày y, với x,y nhập từ bàn phím
create function thongtin_sanpham_theongay(@x date, @y date)
returns @bang1 table( 
						masp nvarchar(10), tensp nvarchar(20),
						soluong int, mausac nvarchar(20),
						giaban float , donvitinh nvarchar(20),	mota nvarchar(max), 
						mahang nvarchar(10), tenhangSX nvarchar(50)
						)
as
begin
	insert into @bang1
						select SanPham.masp , SanPham.tensp, SanPham.soluong, SanPham.mausac, SanPham.giaban, SanPham.donvitinh, SanPham.mota,HangSX.MaHangSX, HangSX.TenHang
						from SanPham  inner join HangSX
														on	SanPham.MaHangSX=HangSX.MaHangSX
									inner join Nhap on SanPham.MaSP=Nhap.MaSP
						where Nhap.NgayNhap BETWEEN @x AND @y
	return
end

---3. Hãy xây dựng hàm đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn, nếu chọn = 0 thì đưa ra danh sách các sản phẩm có soluong = 0, ngược lại lựa chọn = 1 thì đưa ra danh sách các sản phẩm có soluong >0.
create function kiemtra_soluong(@tenhang nvarchar(30), @luachon int)
returns @bang2 table( 
						masp nvarchar(10), tensp nvarchar(20),
						soluong int, mausac nvarchar(20),
						giaban float , donvitinh nvarchar(20),	mota nvarchar(max)
						)
as
begin
	insert into @bang2
						select masp , tensp, soluong, mausac, giaban, donvitinh, mota
						from SanPham  inner join HangSX
														on	SanPham.MaHangSX=HangSX.MaHangSX
						where tenhang= @tenhang
								and (@luachon = 0  and SanPham.soluong=0)
								or	( @luachon =1 and SanPham.soluong>0)
								
	return
end

--4. Hãy xây dựng hàm đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím.
create function kiemtra_danhsach_nhanvien(@tenphong nvarchar(30))
returns @bang3 table( 
						manv nvarchar(10), tenNv nvarchar(30),
						gioitinh nvarchar(5), diachi nvarchar(30),
						sdt nvarchar(12), mail nvarchar(40)
						)
as
begin
	insert into @bang3
						select MaNV, TenNV, GioiTinh, DiaChi, SDT, Email
						from NhanVien  
						where Phong= @tenphong
								
	return
end

--5. Hãy viết hàm đưa ra  hãng sản xuất có địa chỉ nhập từ bàn phím nhập từ bàn phím.
create function xem_hangsx(@diachi nvarchar(30))
returns @bang4 table( 
						mahang nvarchar(10), tenhang nvarchar(20),
						sdt nvarchar(20), mail nvarchar(30)
						)
as
begin
	insert into @bang4
						select MaHangSX, TenHang, SDT, Email
						from HangSX
						where DiaChi= @diachi
								
	return
end

--6. Hãy viết hàm đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được xuất từ năm x đến năm y, với x,y nhập từ bàn phím.
create function kiemtra_soluong(@x int, @y int)
returns @bang5 table( 
						masp nvarchar(10), tensp nvarchar(20),
						soluong int, mausac nvarchar(20),
						giaban float , donvitinh nvarchar(20),	mota nvarchar(max),
						mahangsx nvarchar(10), tenhangsx nvarchar(30)
						)
as
begin
	insert into @bang5
						select MaSP , tensp, soluong, mausac, giaban, donvitinh, mota, HangSX.MaHangSX,HangSX.TenHang
						from SanPham  
							inner join HangSX
												on	SanPham.MaHangSX=HangSX.MaHangSX
							inner join Nhap 
												on Nhap.MaSP=SanPham.MaSP
						where YEAR(Nhap.NgayNhap) >= @x AND YEAR(Nhap.NgayNhap) <= @y
							
	return
end
--7. Hãy xây dựng hàm đưa ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn. nếu lựa chọn = 0 thì đưa ra danh sách các sản phẩm đã được nhập, ngược lại lựa chọn =1 thì đưa ra danh sách các sản phẩm đã được xuất

create function kiemtra_soluong(@tenhang nvarchar(30), @luachon int)
returns @bang6 table( 
						masp nvarchar(10), tensp nvarchar(20),
						soluong int, mausac nvarchar(20),
						giaban float , donvitinh nvarchar(20),	mota nvarchar(max),
						mahangsx nvarchar(10), tenhangsx nvarchar(30)
						)
as
begin
	if @luachon =0
	begin
		insert into @bang6
						select MaSP , tensp, soluong, mausac, giaban, donvitinh, mota, HangSX.MaHangSX,HangSX.TenHang
						from SanPham  
							inner join HangSX
												on	SanPham.MaHangSX=HangSX.MaHangSX
							inner join Nhap 
												on Nhap.MaSP=SanPham.MaSP
							
						where TenHang=@tenhang 
							and exists (Nhap.MaSP=SanPham.MaSP)
	return
	end
	else if @luachon=1
	begin
		insert into @bang6
						select MaSP , tensp, soluong, mausac, giaban, donvitinh, mota, HangSX.MaHangSX,HangSX.TenHang
						from SanPham  
							inner join HangSX
												on	SanPham.MaHangSX=HangSX.MaHangSX
							
							inner join Xuat 
												on Xuat.MaSP=SanPham.MaSP
						where TenHang=@tenhang 
							and exists (Xuat.MaSP=SanPham.MaSP)
	return
	end
end

--8. Hãy xây dựng hàm đưa ra danh sách các nhân viên đã nhập hàng vào ngày được đưa vào từ bàn phím.
create function kiemtra_nhanvien(@x date)
returns @bang7 table( 
						manv nvarchar(10), tenNv nvarchar(30),
						gioitinh nvarchar(5), diachi nvarchar(30),
						sdt nvarchar(12), mail nvarchar(40),phong nvarchar(20)
						)
as
begin
	insert into @bang7
						select MaNV, TenNV, GioiTinh, DiaChi, SDT, Email, Phong
						from NhanVien 
							inner join Nhap 
												on Nhap.MaNV=NhanVien.MaNV
						where Nhap.NgayNhap=@x
							
	return
end

--9. Hãy xây dựng hàm đưa ra danh sách các sản phẩm có giá bán từ x đến y, do tông ty z sản xuất, với x,y nhập từ bàn phím.
create function kiemtra_sp(@x int, @y int, @z nvarchar(30))
returns @bang8 table( 
						masp nvarchar(10), tensp nvarchar(20),
						soluong int, mausac nvarchar(20),
						giaban float , donvitinh nvarchar(20),	mota nvarchar(max),
						mahangsx nvarchar(10), tenhangsx nvarchar(30)
						)
as
begin
	insert into @bang8
						select MaSP , tensp, soluong, mausac, giaban, donvitinh, mota, HangSX.MaHangSX,HangSX.TenHang
						from SanPham  
							inner join HangSX
												on	SanPham.MaHangSX=HangSX.MaHangSX
						where GiaBan between @x and @y
							and TenHang=@z
							
	return
end

--10. Hãy xây dựng hàm không tham biến đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng.
create function kiemtra_sp1()
returns @bang8 table( 
						masp nvarchar(10), tensp nvarchar(20),
						soluong int, mausac nvarchar(20),
						giaban float , donvitinh nvarchar(20),	mota nvarchar(max),
						mahangsx nvarchar(10), tenhangsx nvarchar(30)
						)
as
begin
	insert into @bang8
						select MaSP , tensp, soluong, mausac, giaban, donvitinh, mota, HangSX.MaHangSX,HangSX.TenHang
						from SanPham  
							inner join HangSX
												on	SanPham.MaHangSX=HangSX.MaHangSX
							
	return
end