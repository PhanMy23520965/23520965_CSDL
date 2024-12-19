-- Bài tập 1
-- Sinh viên hoàn thành Phần I bài tập QuanLyBanHang từ câu 11 đến 14.

--11.Ngày mua hàng (NGHD) của một khách hàng thành viên sẽ lớn hơn hoặc bằng ngày khách hàng đó đăng ký thành viên (NGDK).
CREATE TRIGGER trg_ins_hd ON HOADON 
AFTER INSERT 
AS 
BEGIN
    DECLARE @NgayHD smalldatetime, @MaKH char(4), @NgayDK smalldatetime 
	SELECT @NgayHD=NGHD, @MaKH=MAKH 
	FROM INSERTED
	SELECT @NgayDK=NGDK
	FROM KHACHHANG 
	WHERE MAKH=@MaKH
	IF (@NgayHD<@NgayDK) 
	BEGIN 
	    PRINT 'LOI: NGAY HOA DON KHONG HOP LE!'
		ROLLBACK TRANSACTION
	END
	ELSE 
	BEGIN 
	PRINT 'THEM MOI MOT HOA DON THANH CONG!'
	END
END
GO

INSERT INTO HOADON VALUES('1025','2005-01-01','KH01', 'NV01', 20000)
GO

-- 12.Ngày bán hàng (NGHD) của một nhân viên phải lớn hơn hoặc bằng ngày nhân viên đó vào làm.
CREATE TRIGGER trg_ins_upd_nghd ON HOADON 
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @NgHD smalldatetime, @MaNV char(4), @NgVL smalldatetime
	SELECT @NgHD=NGHD, @MaNV=MANV 
	FROM INSERTED 
	SELECT @NgVL=NGVL 
	FROM NHANVIEN 
	WHERE MANV=@MaNV 
	IF (@NgHD<@NgVL)
	BEGIN 
	    PRINT 'LOI: NGAY BAN HANG CUA HOA DON KHONG HOP LE VOI NGAY NHAN VIEN VAO LAM!'
		ROLLBACK TRANSACTION 
	END
	ELSE
	BEGIN 
	    PRINT 'THEM/SUA THONG TIN HOA DON THANH CONG!'
	END
END
GO

--13.Trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
-- Cập nhật trị giá của một hóa đơn khi có 1 CTHD được thêm vào/cập nhật.
CREATE TRIGGER trg_ins_upd_trigia ON CTHD
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @SoHD INT, @MaSP char(4), @Solg INT, @TriGia MONEY
	SELECT @SoHD=SOHD, @MaSP=MASP, @SoLg=SL
	FROM INSERTED
	
	SET @TriGia=@SoLg * (SELECT GIA FROM SANPHAM WHERE MASP=@MaSP)

	DECLARE cur_cthd CURSOR FOR
	SELECT MASP, SL FROM CTHD WHERE SOHD=@SoHD

	OPEN cur_cthd 
	FETCH NEXT FROM cur_cthd INTO @MaSP, @SoLg

	WHILE (@@FETCH_STATUS=0)
	BEGIN
	    SET @TriGia=@TriGia+ @SoLg * (SELECT GIA FROM SANPHAM WHERE MASP=@MaSP)
		FETCH NEXT FROM cur_cthd INTO @MaSP, @SoLg
	END

	CLOSE cur_cthd
	DEALLOCATE cur_cthd
	UPDATE HOADON SET TRIGIA=@TriGia WHERE SOHD=@SoHD
END
GO

-- Kiểm tra xem trị giá của một hóa đơn là tổng thành tiền (số lượng*đơn giá) của các chi tiết thuộc hóa đơn đó.
CREATE TRIGGER trg_check_ins_upd_trigia ON HOADON
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @Tongthanhtien MONEY, @Trigia MONEY
	SELECT @Tongthanhtien=SUM(CTHD.SL * SP.GIA)
	FROM CTHD JOIN SANPHAM SP ON CTHD.MASP=SP.MASP, INSERTED
	WHERE CTHD.SOHD=INSERTED.SOHD

	SELECT @Trigia=TRIGIA FROM INSERTED 

	IF (@Trigia<>@Tongthanhtien)
	BEGIN
	    PRINT 'LOI: TRI GIA HOA DON KHONG BANG TONG THANH TIEN!'
		ROLLBACK TRANSACTION
	END
END
GO

--14.Doanh số của một khách hàng là tổng trị giá các hóa đơn mà khách hàng thành viên đó đã mua.
CREATE TRIGGER trg_check_ins_upd_doanhso ON KHACHHANG
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @Tongtrigia MONEY, @Doanhso MONEY
	SELECT @Tongtrigia=SUM(TRIGIA)
	FROM HOADON, INSERTED
	WHERE HOADON.MAKH=INSERTED.MAKH

	SELECT @Doanhso=DOANHSO FROM INSERTED 

	IF (@Doanhso<>@Tongtrigia)
	BEGIN
	    PRINT 'LOI: DOANH SO KHACH HANG KHONG KHOP VOI TONG GIA TRI CAC HOA DON!'
		ROLLBACK TRANSACTION
	END
END
GO
--------------------------------------------------------------------------------------------------------------------------
-- Bài tập 2
-- Sinh viên hoàn thành Phần I bài tập QuanLyGiaoVu câu 9, 10 và từ câu 15 đến câu 24.

--9.Lớp trưởng của một lớp phải là học viên của lớp đó.
CREATE TRIGGER trg_check_ins_upd_trglop ON LOP
AFTER INSERT, UPDATE 
AS
BEGIN
    DECLARE @MaLop char(3), @MaLopLT char(3)

	SELECT @MaLopLT=HOCVIEN.MALOP, @MaLop=INSERTED.MALOP FROM HOCVIEN,INSERTED WHERE HOCVIEN.MAHV=INSERTED.TRGLOP

	IF (@MaLopLT<>@MaLop) 
	BEGIN
	    PRINT 'LOI: LOP TRUONG MOT LOP PHAI LA HOC VIEN LOP DO!'
		ROLLBACK TRANSACTION
	END
END
GO

--10.Trưởng khoa phải là giáo viên thuộc khoa và có học vị “TS” hoặc “PTS”.
CREATE TRIGGER trg_ins_upt_trgkhoa ON KHOA 
AFTER INSERT, UPDATE 
AS
BEGIN
    DECLARE @MaGV char(4), @MaKhoa varchar(4)
	SELECT @MaGV=TRGKHOA, @MaKhoa=MAKHOA FROM INSERTED
	IF NOT EXISTS(
	    SELECT * 
		FROM KHOA K JOIN GIAOVIEN GV ON K.MAKHOA=GV.MAKHOA
		WHERE @MaGV=MAGV AND HOCVI IN ('TS', 'PTS') AND @MaKhoa=K.MAKHOA)
	BEGIN
	    PRINT 'LOI: TRUONG KHOA PHAI LA GIAO VIEN THUOC KHOA VA CO HOC VI "TS" HOAC "PTS"'
		ROLLBACK TRANSACTION
	END
END
GO

--15.Học viên chỉ được thi một môn học nào đó khi lớp của học viên đã học xong môn học này.
CREATE TRIGGER trg_ins_upd_ngthi ON KETQUATHI
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @mahv CHAR(3), @mamh VARCHAR(10), @ngaythi SMALLDATETIME
	SELECT @mahv=MAHV, @maMH=MAMH, @ngaythi=NGTHI FROM INSERTED
	IF NOT EXISTS(
	   SELECT *
	   FROM GIANGDAY GD, HOCVIEN HV
	   WHERE @mahv=HV.MAHV AND GD.MALOP=HV.MALOP AND GD.MAMH=@mamh AND @ngaythi>GD.DENNGAY)
	BEGIN
	    PRINT 'LOI: HOC VIEN CHUA HOC XONG MON HOC NAY!'
		ROLLBACK TRANSACTION
	END
END
GO

--16.Mỗi học kỳ của một năm học, một lớp chỉ được học tối đa 3 môn.
CREATE TRIGGER trg_ins_upd_hocky ON GIANGDAY
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @hocky TINYINT, @namhoc SMALLINT, @malop CHAR(3), @somonhoc TINYINT
	SELECT @hocky=HOCKY, @namhoc=NAM, @malop=MALOP FROM INSERTED
	SELECT @somonhoc=COUNT(*)
	FROM GIANGDAY
	WHERE @hocky=HOCKY AND @namhoc=NAM AND @malop=MALOP 
	IF (@somonhoc>2)
	BEGIN
	    PRINT 'LOI: SO MON HOC CUA LOP DA DAT 3!'
		ROLLBACK TRANSACTION
	END
END
GO

--17.Sỉ số của một lớp bằng với số lượng học viên thuộc lớp đó.
CREATE TRIGGER trg_ins_upd_siso ON LOP
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @malop CHAR(3), @siso TINYINT, @soluonghv TINYINT
	SELECT @malop=MALOP, @siso=SISO FROM INSERTED
	SELECT @soluonghv=COUNT(*)
	FROM HOCVIEN 
	WHERE MALOP=@malop
	IF (@siso<>@soluonghv) 
	BEGIN
	    PRINT 'LOI: SI SO CUA LOP KHONG KHOP VOI SO LUONG HOC VIEN!'
		ROLLBACK TRANSACTION
	END
END
GO

--18.Trong quan hệ DIEUKIEN giá trị của thuộc tính MAMH và MAMH_TRUOC trong cùng một bộ không được giống nhau (“A”,”A”) và cũng không tồn tại hai bộ (“A”,”B”) và (“B”,”A”).
CREATE TRIGGER trg_ins_upd_dieukien ON DIEUKIEN 
FOR INSERT, UPDATE 
AS
BEGIN
    DECLARE @mamh VARCHAR(10), @mamhtruoc VARCHAR(10)
	SELECT @mamh=MAMH, @mamhtruoc=MAMH_TRUOC FROM INSERTED 
	IF ((@mamh=@mamhtruoc) OR EXISTS(
	                          SELECT *
							  FROM DIEUKIEN
							  WHERE MAMH=@mamhtruoc AND MAMH_TRUOC=@mamh))
	BEGIN
	    PRINT 'LOI: MA MON HOC VA MA MON HOC TRUOC KHONG HOP LE!'
		ROLLBACK TRANSACTION
	END
END
GO

--19.Các giáo viên có cùng học vị, học hàm, hệ số lương thì mức lương bằng nhau.
CREATE TRIGGER trg_ins_upd_luong ON GIAOVIEN
FOR INSERT, UPDATE 
AS
BEGIN
    DECLARE @magv CHAR(4), @heso NUMERIC(4,2), @mucluong MONEY, @hocvi VARCHAR(10), @hocham VARCHAR(10)
	SELECT @magv=MAGV, @heso=HESO, @mucluong=MUCLUONG, @hocvi=HOCVI, @hocham=HOCHAM FROM INSERTED
	IF EXISTS(
	   SELECT *
	   FROM GIAOVIEN 
	   WHERE @magv<>MAGV AND MUCLUONG=@mucluong AND HESO=@heso AND HOCVI=@hocvi AND @hocham=HOCHAM AND MUCLUONG<>@mucluong)
	BEGIN
	    PRINT 'LOI: MUC LUONG CUA GIAO VIEN KHONG PHU HOP!'
		ROLLBACK TRANSACTION
	END
END
GO

--20.Học viên chỉ được thi lại (lần thi >1) khi điểm của lần thi trước đó dưới 5.
CREATE TRIGGER trg_ins_upd_diem ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @mahv CHAR(5), @mamh VARCHAR(10), @lanthi TINYINT
	SELECT  @mahv=MAHV, @mamh=MAMH, @lanthi=LANTHI FROM INSERTED
	IF EXISTS(
	   SELECT *
	   FROM KETQUATHI
	   WHERE MAMH=@mamh AND MAHV=@mahv AND @lanthi>LANTHI AND DIEM>5)
	BEGIN
	    PRINT 'LOI: KHONG DUOC THI LAI KHI DIEM CUA LAN THI TRUOC TU 5 TRO LEN !'
		ROLLBACK TRANSACTION
	END
END
GO

--21.Ngày thi của lần thi sau phải lớn hơn ngày thi của lần thi trước (cùng học viên, cùng môn học).
CREATE TRIGGER trg_ins_upd_kqt ON KETQUATHI
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @ngaythilai SMALLDATETIME, @mahv CHAR(5), @mamh VARCHAR(10), @lanthi TINYINT
	SELECT @ngaythilai=NGTHI, @mahv=MAHV, @mamh=MAMH, @lanthi=LANTHI FROM INSERTED
	IF EXISTS(
	   SELECT *
	   FROM KETQUATHI KQ
	   WHERE MAHV=@mahv AND MAMH=@mamh AND LANTHI<@lanthi AND NGTHI>=@ngaythilai)
	BEGIN
	    PRINT 'LOI: NGAY THI CUA LAN THI SAU PHAI LON HON NGAY THI CUA LAN THI TRUOC!'
		ROLLBACK TRANSACTION
	END
END
GO

--22.Khi phân công giảng dạy một môn học, phải xét đến thứ tự trước sau giữa các môn học (sau khi học xong những môn học phải học trước mới được học những môn liền sau).
CREATE TRIGGER trg_ins_upd_monhoc ON GIANGDAY
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @mamh varchar(10), @tungay SMALLDATETIME
	SELECT @mamh=MAMH, @tungay=TUNGAY FROM INSERTED
    IF NOT EXISTS(
	   SELECT *
	   FROM DIEUKIEN
	   WHERE MAMH=@mamh AND MAMH_TRUOC IN (
	   SELECT MAMH 
	   FROM GIANGDAY
	   WHERE DENNGAY<@tungay))
	BEGIN
	    PRINT 'LOI: PHAI GIANG DAY CAC MON TIEN QUYET TRUOC KHI DAY MON NAY!'
		ROLLBACK TRANSACTION
	END
END
GO

--23.Giáo viên chỉ được phân công dạy những môn thuộc khoa giáo viên đó phụ trách.
CREATE TRIGGER trg_ins_upd ON GIANGDAY
FOR INSERT, UPDATE 
AS
BEGIN
    IF NOT EXISTS(
	   SELECT *
	   FROM INSERTED I, GIAOVIEN GV, MONHOC MH
	   WHERE I.MAGV=GV.MAGV AND I.MAMH=MH.MAMH AND GV.MAKHOA=MH.MAKHOA)
	BEGIN
	    PRINT 'LOI: GIAO VIEN CHI DUOC DAY NHUNG MON THUOC KHOA GIAO VIEN DO PHU TRACH!'
		ROLLBACK TRANSACTION
	END
END
GO
