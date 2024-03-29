Create Database DA_QLCT

Use DA_QLCT

// Tạo table tài khoản

CREATE TABLE TaiKhoan
(
    TenDangNhap NVARCHAR(50) PRIMARY KEY,
    MatKhau NVARCHAR(50),
    HoTen NVARCHAR(50),
    GioiTinh NVARCHAR(10),
    NgaySinh DATE,
    SDT NVARCHAR(15),
    DiaChi NVARCHAR(100),
    LoaiTaiKhoan NVARCHAR(50)
)
Select * From TaiKhoan

UPDATE TaiKhoan
SET LoaiTaiKhoan = 'ADMIN'
WHERE TenDangNhap = 'Tuanmun;
//
CREATE PROCEDURE CheckTaiKhoan
    @taikhoan NVARCHAR(50),
    @matkhau NVARCHAR(50),
    @loai NVARCHAR(50)
AS
BEGIN
    SELECT COUNT(*) FROM TaiKhoan
    WHERE TenDangNhap = @taikhoan AND MatKhau = @matkhau AND LoaiTaiKhoan = @loai;
END

//
CREATE PROCEDURE DoiMatKhauTaiKhoan
    @taikhoan NVARCHAR(50),
    @matkhaumoi NVARCHAR(50)
AS
BEGIN
    UPDATE TaiKhoan
    SET MatKhau = @matkhaumoi
    WHERE TenDangNhap = @taikhoan;

    IF @@ROWCOUNT > 0
        SELECT 1 AS Result
    ELSE
        SELECT 0 AS Result
END
//

CREATE PROCEDURE CapNhatTaiKhoan
    @taikhoan NVARCHAR(50),
    @hoten NVARCHAR(50),
    @gioitinh NVARCHAR(10),
    @ngaysinh DATE,
    @sdt NVARCHAR(15),
    @diachi NVARCHAR(100)
AS
BEGIN
    UPDATE TaiKhoan
    SET HoTen = @hoten, GioiTinh = @gioitinh, NgaySinh = @ngaysinh, SDT = @sdt, DiaChi = @diachi
    WHERE TenDangNhap = @taikhoan;

    IF @@ROWCOUNT > 0
        SELECT 1 AS Result
    ELSE
        SELECT 0 AS Result
END

//
CREATE PROCEDURE XoaTaiKhoan
    @taikhoan NVARCHAR(50)
AS
BEGIN
    DELETE FROM TaiKhoan
    WHERE TenDangNhap = @taikhoan;

    IF @@ROWCOUNT > 0
        SELECT 1 AS Result
    ELSE
        SELECT 0 AS Result
END

//

CREATE PROCEDURE ThemTaiKhoan
    @taikhoan NVARCHAR(50),
    @matkhau NVARCHAR(50),
    @hoten NVARCHAR(50),
    @gioitinh NVARCHAR(10),
    @ngaysinh DATE,
    @sdt NVARCHAR(15),
    @diachi NVARCHAR(100),
    @loaitaikhoan NVARCHAR(50)
AS
BEGIN
    INSERT INTO TaiKhoan(TenDangNhap, MatKhau, HoTen, GioiTinh, NgaySinh, SDT, DiaChi, LoaiTaiKhoan)
    VALUES (@taikhoan, @matkhau, @hoten, @gioitinh, @ngaysinh, @sdt, @diachi, @loaitaikhoan);

    RETURN @@ROWCOUNT;
END

//
CREATE TABLE PhuongThucThanhToan
(
    MaPhuongThucThanhToan NVARCHAR(50) PRIMARY KEY,
    TenPhuongThucThanhToan NVARCHAR(50)
)
drop table PhuongThucThanhToan
CREATE TABLE DanhMucThu
(
    MaDanhMuc NVARCHAR(50) PRIMARY KEY,
    TenDanhMuc NVARCHAR(50)
)
//
INSERT INTO DanhMucThu (MaDanhMuc, TenDanhMuc)
VALUES 
('DM01', N'Lương'), 
('DM02', N'Đòi nợ'), 
('DM03', N'Tiền cho thuê nhà'),
('DM04', N'Bán hàng'),
('DM05', N'Đầu tư');
//
INSERT INTO PhuongThucThanhToan (MaPhuongThucThanhToan, TenPhuongThucThanhToan)
VALUES 
('PT01', N'Tiền mặt'), 
('PT02', N'Chuyển khoản'),
('PT03', N'Thẻ');
select* from DanhMucThu
select*from PhuongThucThanhToan
//

DELETE FROM DanhMucThu WHERE TenDanhMuc = N'Bán hàng';
DELETE FROM DanhMucThu WHERE TenDanhMuc = N'Tiền cho thuê nhà';

//

CREATE TABLE CTGiaoDichThu
(
    MaGiaoDich INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap NVARCHAR(50) FOREIGN KEY REFERENCES TaiKhoan(TenDangNhap),
    MaDanhMuc NVARCHAR(50) FOREIGN KEY REFERENCES DanhMucThu(MaDanhMuc),
    MaPhuongThucThanhToan NVARCHAR(50) FOREIGN KEY REFERENCES PhuongThucThanhToan(MaPhuongThucThanhToan),
    SoTien DECIMAL(18, 2),
    MoTa NVARCHAR(MAX),
    NgayGiaoDich DATE
)
//

CREATE PROCEDURE CapNhatGiaoDichThu
    @magiaodich NVARCHAR(50),
    @taikhoan NVARCHAR(50),
    @madanhmuc NVARCHAR(50),
    @maphuongthucthanhtoan NVARCHAR(50),
    @sotien DECIMAL(18, 2),
    @mota NVARCHAR(MAX),
    @ngaygiaodich DATE
AS
BEGIN
    UPDATE CTGiaoDichThu
    SET TenDangNhap = @taikhoan, MaDanhMuc = @madanhmuc, MaPhuongThucThanhToan = @maphuongthucthanhtoan, SoTien = @sotien, MoTa = @mota, NgayGiaoDich = @ngaygiaodich
    WHERE MaGiaoDich = @magiaodich;
END

//


CREATE PROCEDURE ThemGiaoDichThu
    @taikhoan NVARCHAR(50),
    @madanhmuc NVARCHAR(50),
    @maphuongthucthanhtoan NVARCHAR(50),
    @sotien DECIMAL(18, 2),
    @mota NVARCHAR(MAX),
    @ngaygiaodich DATE
AS
BEGIN
    INSERT INTO CTGiaoDichThu(TenDangNhap, MaDanhMuc, MaPhuongThucThanhToan, SoTien, MoTa, NgayGiaoDich)
    VALUES (@taikhoan, @madanhmuc, @maphuongthucthanhtoan, @sotien, @mota, @ngaygiaodich);
END

//

SELECT CTGiaoDichThu.MaGiaoDich, TenDangNhap, CTGiaoDichThu.MaDanhMuc,TenDanhMuc, SoTien, MoTa, NgayGiaoDich,
CTGiaoDichThu.MaPhuongThucThanhToan , TenPhuongThucThanhToan 
FROM CTGiaoDichThu 
INNER JOIN DanhMucThu ON CTGiaoDichThu.MaDanhMuc = DanhMucThu.MaDanhMuc 
INNER JOIN PhuongThucThanhToan ON CTGiaoDichThu.MaPhuongThucThanhToan = PhuongThucThanhToan.MaPhuongThucThanhToan;


//

CREATE TABLE DanhMucChi
(
    MaDanhMuc NVARCHAR(50) PRIMARY KEY,
    TenDanhMuc NVARCHAR(50)
)
drop table DanhMucChi
drop table CTGiaoDichChi
INSERT INTO DanhMucChi(MaDanhMuc, TenDanhMuc)
VALUES 
('DM01', N'Yêu đương'), 
('DM02', N'Ăn chơi'), 
('DM03', N'Chăm sóc sức khỏe'),
('DM04', N'Mua sắm'),
('DM05', N'Đầu tư');
//

select* from DanhMucChi
select*from PhuongThucThanhToan
DROP TABle CTGiaoDichThu
dROP TABLE PhuongThucThanhToan
DROP TABLE DanhMucThu

//

CREATE TABLE CTGiaoDichChi
(
    MaGiaoDich INT IDENTITY(1,1) PRIMARY KEY,
    TenDangNhap NVARCHAR(50) FOREIGN KEY REFERENCES TaiKhoan(TenDangNhap),
    MaDanhMuc NVARCHAR(50) FOREIGN KEY REFERENCES DanhMucChi(MaDanhMuc),
    MaPhuongThucThanhToan NVARCHAR(50) FOREIGN KEY REFERENCES PhuongThucThanhToan(MaPhuongThucThanhToan),
    SoTien DECIMAL(18, 2),
    MoTa NVARCHAR(MAX),
    NgayGiaoDich DATE
)


//


//GiaoDichChi
CREATE PROCEDURE CapNhatGiaoDichChi
    @magiaodich NVARCHAR(50),
    @taikhoan NVARCHAR(50),
    @madanhmuc NVARCHAR(50),
    @maphuongthucthanhtoan NVARCHAR(50),
    @sotien DECIMAL(18, 2),
    @mota NVARCHAR(MAX),
    @ngaygiaodich DATE
AS
BEGIN
    UPDATE CTGiaoDichChi
    SET TenDangNhap = @taikhoan,
        MaDanhMuc = @madanhmuc,
        MaPhuongThucThanhToan = @maphuongthucthanhtoan,
        SoTien = @sotien,
        MoTa = @mota,
        NgayGiaoDich = @ngaygiaodich
    WHERE MaGiaoDich = @magiaodich;
END
//
CREATE PROCEDURE ThemGiaoDichChi
    @taikhoan NVARCHAR(50),
    @madanhmuc NVARCHAR(50),
    @maphuongthucthanhtoan NVARCHAR(50),
    @sotien DECIMAL(18, 2),
    @mota NVARCHAR(MAX),
    @ngaygiaodich DATE
AS
BEGIN
    INSERT INTO CTGiaoDichChi(TenDangNhap, MaDanhMuc, MaPhuongThucThanhToan, SoTien, MoTa, NgayGiaoDich)
    VALUES (@taikhoan, @madanhmuc, @maphuongthucthanhtoan, @sotien, @mota, @ngaygiaodich);
END
//

SELECT CTGiaoDichChi.MaGiaoDich, TenDangNhap, CTGiaoDichChi.MaDanhMuc, TenDanhMuc, SoTien, MoTa, NgayGiaoDich,
CTGiaoDichChi.MaPhuongThucThanhToan , TenPhuongThucThanhToan 
FROM CTGiaoDichChi 
INNER JOIN DanhMucChi ON CTGiaoDichChi.MaDanhMuc = DanhMucChi.MaDanhMuc 
INNER JOIN PhuongThucThanhToan ON CTGiaoDichChi.MaPhuongThucThanhToan = PhuongThucThanhToan.MaPhuongThucThanhToan;

//





select *from TaiKhoan



