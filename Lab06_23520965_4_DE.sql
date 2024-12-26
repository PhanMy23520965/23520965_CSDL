--De 1
CREATE DATABASE QUANLYSACH
GO

CREATE TABLE TACGIA(
     MaTG char(5) PRIMARY KEY,
	 HoTen varchar(20),
	 DiaChi varchar(50),
	 NgSinh smalldatetime,
	 SoDT varchar(15)
)
GO

CREATE TABLE SACH(
     MaSach char(5) PRIMARY KEY,
	 TenSach varchar(25),
	 TheLoai varchar(25)
)
GO

CREATE TABLE TACGIA_SACH(
     MaTG char(5) FOREIGN KEY REFERENCES TACGIA(MaTG),
	 MaSach char(5) FOREIGN KEY REFERENCES SACH(MaSach),
	 CONSTRAINT PK_TGS PRIMARY KEY(MaTG, MaSach)
)
GO

CREATE TABLE PHATHANH(
     MaPH char(5) PRIMARY KEY,
	 MaSach char(5) FOREIGN KEY REFERENCES SACH(MaSach),
	 NgayPH smalldatetime,
	 SoLuong int,
	 NhaXuatBan varchar(20)
)
GO

--2.1
CREATE TRIGGER trg_tg_ph ON PHATHANH
AFTER INSERT, UPDATE
AS
BEGIN
     IF EXISTS(
	    SELECT *
		FROM TACGIA tg, inserted i, TACGIA_SACH tgs
		WHERE tg.MaTG=tgs.MaTG AND tgs.MaSach=i.MaSach AND i.NgayPH>=tg.NgSinh
	 )
	 BEGIN
	    ROLLBACK TRANSACTION
	    RAISERROR('LOI: NGAY PHAT HANH KHONG HOP LE!', 16, 1)
	 END
END
GO

--2.2
CREATE TRIGGER trg_s_ph ON PHATHANH
AFTER INSERT, UPDATE
AS
BEGIN
     IF EXISTS(
	     SELECT *
		 FROM SACH s, INSERTED i
		 WHERE s.MaSach=i.MaSach AND s.TheLoai='Giao khoa' AND i.NhaXuatBan<>'Giaoduc'
	 )
	 BEGIN
	     ROLLBACK TRANSACTION
		 RAISERROR('LOI: THE LOAI GIAO KHOA DO NHA PHAT HANH GIAO DUC PHAT HANH',16, 1)
	 END
END
GO

--3.1
SELECT tg.MaTG, tg.HoTen, tg.SoDT
FROM TACGIA tg, SACH s, PHATHANH ph, TACGIA_SACH tgs
WHERE tg.MaTG=tgs.MaTG AND s.MaSach=tgs.MaSach 
      AND s.MaSach=ph.MaSach AND s.TheLoai='Van hoc' 
	  AND ph.NhaXuatBan='Tre'
GO

--3.2
SELECT NhaXuatBan 
FROM(
SELECT TOP 1 WITH TIES NhaXuatBan, COUNT(DISTINCT s.TheLoai) AS SLTL
FROM PHATHANH ph LEFT JOIN SACH s ON ph.MaSach=s.MaSach
GROUP BY NhaXuatBan
ORDER BY COUNT(DISTINCT s.MaSach) DESC) NXB_TL
GO

--3.3
SELECT ph.NhaXuatBan, tg.MaTG, tg.HoTen
FROM PHATHANH ph, TACGIA tg, TACGIA_SACH tgs
WHERE ph.MaSach=tgs.MaSach AND tg.MaTG=tgs.MaTG 
GROUP BY ph.NhaXuatBan, tg.MaTG, tg.HoTen
HAVING COUNT(ph.MaSach)>=ALL(
SELECT COUNT(ph1.MaSach)
FROM PHATHANH ph1, TACGIA_SACH tgs1 
WHERE tgs1.MaTG=tg.MaTG AND  ph1.MaSach=tgs1.MaSach AND ph1.NhaXuatBan=ph.NhaXuatBan
GROUP BY tgs1.MaTG) 
GO

-------------------------------------------------------------------------------------------------------------------
--DE 2
CREATE DATABASE QUANLYXE
GO

CREATE TABLE PHONGBAN(
    MaPhong char(5) PRIMARY KEY,
	TenPhong varchar(25),
	TruongPhong char(5)
)
GO

CREATE TABLE NHANVIEN(
    MaNV char(5) PRIMARY KEY,
	HoTen varchar(20),
	NgayVL smalldatetime,
	HSLuong numeric(4,2),
	MaPhong char(5) FOREIGN KEY REFERENCES PHONGBAN(MaPhong)
)
GO

ALTER TABLE PHONGBAN ADD CONSTRAINT FK_PB_TP FOREIGN KEY(TruongPhong) REFERENCES NHANVIEN(MaNV)
GO

CREATE TABLE XE(
    MaXe char(5) PRIMARY KEY,
	LoaiXe varchar(5),
	SoChoNgoi int,
	NamSX int
)
GO

CREATE TABLE PHANCONG(
    MaPC char(5) PRIMARY KEY,
	MaNV char(5) FOREIGN KEY REFERENCES NHANVIEN(MaNV),
	MaXe char(5) FOREIGN KEY REFERENCES XE(MaXe),
	NgayDi smalldatetime,
	NgayVe smalldatetime,
	NoiDen varchar(25)
)
GO

--2.1
ALTER TABLE XE ADD CONSTRAINT CK_XE_NSX CHECK(LoaiXe<>'Toyota' OR NamSX>=2006)
GO

--2.2
CREATE TRIGGER trg_pc_xe ON PHANCONG 
AFTER INSERT, UPDATE
AS
BEGIN
     IF EXISTS(
	     SELECT *
		 FROM XE x, INSERETD i, PHONGBAN pb, NHANVIEN nv
		 WHERE x.MaXe=i.MaXe AND nv.MaNV=i.MaNV AND nv.MaPhong=pb.MaPhong
		       AND pb.TenPhong='Ngoai thanh' AND x.LoaiXe<>'Toyota'
	 )
	 BEGIN
	     ROLLBACK TRANSACTION
		 RAISERROR('LOI: NHAN VIEN NAY CHI DUOC LAI XE TOYOTA',16, 1)
		 END
END
GO

--3.1
SELECT MaNV, HoTen 
FROM NHANVIEN nv JOIN PHONGBAN pb ON nv.MapHong=pb.MaPhong
WHERE TenPhong='Noi thanh' AND MaNV IN(
SELECT MANV
FROM PHANCONG pc JOIN XE x ON pc.MaXe=x.MaXe
WHERE LoaiXe='Toyota' AND SoChoNgoi=4
)
GO

--3.2
SELECT MaNV, HoTen 
FROM NHANVIEN nv JOIN PHONGBAN pb ON nv.MaNV=pb.TruongPhong
WHERE NOT EXISTS(
SELECT *
FROM XE x
WHERE NOT EXISTS(
SELECT *
FROM PHANCONG pc
WHERE pc.MaXe=x.MaXe AND pc.MaNV=nv.MaNV)
)
GO

--3.3
SELECT MaPhong, pc.MaNV, HoTen
FROM PHANCONG pc JOIN NHANVIEN nv ON pc.MaNV=nv.MaNV
JOIN XE x ON pc.MaXe =x.MaXe
WHERE LoaiXe='Toyota'
GROUP BY MaPhong, pc.MaNV, HoTen
HAVING COUNT(pc.MaNV)>=ALL(
SELECT COUNT(pc1.MaNV)
FROM PHANCONG pc1 JOIN XE x ON pc1.MaXe =x.MaXe
JOIN NHANVIEN nv1 ON pc1.MaNV=nv1.MaNV
WHERE LoaiXe='Toyota' AND nv1.MaPhong=nv.MaPhong
GROUP BY MaPhong, pc1.MaNV
)
GO

-------------------------------------------------------------------------------------------------------------------
--DE 3
CREATE DATABASE THUESACH
GO

CREATE TABLE DOCGIA(
     MaDG char(5) PRIMARY KEY,
	 HoTen varchar(30),
	 NgaySinh smalldatetime,
	 DiaChi varchar(30),
	 SoDT varchar(15)
)
GO

CREATE TABLE SACH(
     MaSach char(5) PRIMARY KEY,
	 TenSach varchar(25),
	 TheLoai varchar(25),
	 NhaXuatBan varchar(30)
)
GO

CREATE TABLE PHIEUTHUE(
     MaPT char(5) PRIMARY KEY,
	 MaDG char(5) FOREIGN KEY REFERENCES DOCGIA(MaDG),
	 NgayThue smalldatetime,
	 NgayTra smalldatetime,
	 SoSachThue int
)
GO

CREATE TABLE CHITIET_PT(
     MaPT char(5) FOREIGN KEY REFERENCES PHIEUTHUE(MaPT),
	 MaSach char(5) FOREIGN KEY REFERENCES SACH(MaSach),
	 CONSTRAINT PK_PT_S PRIMARY KEY(MaPT, MaSach)
) 
GO

--2.1
ALTER TABLE PHIEUTHUE ADD CONSTRAINT CK_PT CHECK((NgayTra-NgayThue)<=10)
GO

--2.2
CREATE TRIGGER trg_pt_ctpt ON CHITIET_PT
AFTER INSERT, UPDATE
AS
BEGIN
     DECLARE @sachthue tinyint, @sosach tinyint

	 SELECT @sachthue=@sachthue+COUNT(ctpt.MaPT)
	 FROM CHITIET_PT ctpt, INSERTED i
	 WHERE ctpt.MaPT=i.MaPT 

	 SELECT @sachthue=@sachthue+COUNT(*)
	 FROM INSERTED

	 SELECT @sosach=pt.SoSachThue 
	 FROM PHIEUTHUE pt, INSERTED i
	 WHERE pt.MaPT=i.MaPT 

	 IF(@sachthue<>@sosach)
	 BEGIN
	 ROLLBACK TRANSACTION
	 RAISERROR('LOI: CHI TIET PHIEU THUE VA PHIEU THUE KHONG HOP LE',16, 1)
	 END
END
GO

--3.1
SELECT MaDG, HoTen
FROM DOCGIA
WHERE MaDG IN(
SELECT pt.MaDG
FROM PHIEUTHUE pt JOIN CHITIET_PT ctpt ON pt.MaPT=ctpt.MaPT 
JOIN SACH s ON s.MaSach=ctpt.MaSach 
WHERE TheLoai='Tin hoc' AND YEAR(pt.NgayThue)=2007
)
GO

--3.2
SELECT MaDG, HoTen 
FROM DOCGIA
WHERE MaDG IN(
SELECT TOP 1 WITH TIES MaDG
FROM CHITIET_PT ctpt JOIN PHIEUTHUE pt ON ctpt.MaPT=pt.MaPT
JOIN SACH s ON ctpt.MaSach=s.MaSach
GROUP BY MaDG
ORDER BY COUNT(DISTINCT s.TheLoai) DESC)
GO

--3.3
SELECT TheLoai, s.MaSach, TenSach
FROM CHITIET_PT ctpt RIGHT JOIN SACH s ON ctpt.MaSach=s.MaSach
GROUP BY TheLoai, s.MaSach, TenSach
HAVING COUNT(ctpt.MaSach) >= ALL(
SELECT COUNT(ctpt.MaSach)
FROM CHITIET_PT ctpt RIGHT JOIN SACH s1 ON s1.MaSach=ctpt.MaSach
WHERE s1.TheLoai=s.TheLoai
GROUP BY TheLoai, s1.MaSach, TenSach
)
GO

-------------------------------------------------------------------------------------------------------------------
--DE 4
CREATE DATABASE THUEBANGDIA
GO

CREATE TABLE KHACHHANG(
     MaKH char(5) PRIMARY KEY,
	 HoTen varchar(30),
	 DiaChi varchar(30),
	 SoDT varchar(15),
	 LoaiKH varchar(10)
)
GO

CREATE TABLE BANG_DIA(
     MaBD char(5) PRIMARY KEY,
     TenBD varchar(25),
	 TheLoai varchar(25)
)
GO

CREATE TABLE PHIEUTHUE(
     MaPT char(5) PRIMARY KEY,
	 MaKH char(5) FOREIGN KEY REFERENCES KHACHHANG(MaKH),
	 NgayThue smalldatetime,
	 NgayTra smalldatetime,
     Soluongthue int
)
GO

CREATE TABLE CHITIET_PT(
     MaPT char(5) FOREIGN KEY REFERENCES PHIEUTHUE(MaPT),
	 MaBD char(5) FOREIGN KEY REFERENCES BANG_DIA(MaBD),
	 CONSTRAINT PK_CTPT PRIMARY KEY(MaPT, MaBD)
)
GO

--2.1 
ALTER TABLE BANG_DIA ADD CONSTRAINT CK_BD_TL CHECK(TheLoai IN ('ca nhac', 'phim hanh dong', 'phim tinh cam', 'phim hoat hinh'))
GO

--2.2
CREATE TRIGGER trg_kh_ctpt1 ON PHIEUTHUE
AFTER INSERT, UPDATE
AS
BEGIN
     DECLARE @sobdthue int, @loaikh varchar(10)
 
	 SELECT @sobdthue=i.Soluongthue, @loaikh=kh.LoaiKH
	 FROM KHACHHANG kh INNER JOIN INSERTED i ON kh.MaKH=i.MaKH

	IF(@loaikh<>'VIP' AND @sobdthue>5)
	BEGIN
	     ROLLBACK TRANSACTION
		 RAISERROR('LOI: CHI KHACH HANG VIP MOI DUOC THUE TREN 5 DIA!',16,1)
	END
END
GO

--3.1
SELECT pt.MaKH, HoTen 
FROM KHACHHANG kh INNER JOIN PHIEUTHUE pt ON kh.MaKH=pt.MakH
JOIN CHITIET_PT ctpt ON pt.MaPT=ctpt.MaPT
JOIN BANG_DIA bd ON ctpt.MaBD=bd.MaBD
WHERE TheLoai='phim tinh cam' AND Soluongthue>3
GO

--3.2
SELECT TOP 1 WITH TIES kh.MaKH, HoTen
FROM KHACHHANG kh LEFT JOIN PHIEUTHUE pt ON kh.MaKH=pt.MaKH
GROUP BY kh.MaKH, HoTen
ORDER BY SUM(Soluongthue) DESC
GO

--3.3
SELECT TheLoai, kh.MaKH, HoTen
FROM PHIEUTHUE pt JOIN CHITIET_PT ctpt ON pt.MaPT=ctpt.MaPT
JOIN BANG_DIA bd ON ctpt.MaBD=BD.MaBD
JOIN KHACHHANG kh ON pt.MaKH=kh.MaKH
GROUP BY TheLoai, kh.MaKH, HoTen
HAVING COUNT(ctpt.MaBD)>=ALL(
SELECT COUNT(ctpt.MaBD)
FROM PHIEUTHUE pt JOIN CHITIET_PT ctpt ON pt.MaPT=ctpt.MaPT
JOIN BANG_DIA bd1 ON ctpt.MaBD=bd1.MaBD
JOIN KHACHHANG kh ON pt.MaKH=kh.MaKH
WHERE bd.TheLoai=bd1.TheLoai
GROUP BY TheLoai, kh.MaKH, HoTen)
GO

