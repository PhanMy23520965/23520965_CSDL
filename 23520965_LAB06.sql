-- Câu hỏi SQL từ cơ bản đến nâng cao, bao gồm trigger

-- Cơ bản:
--1. Liệt kê tất cả chuyên gia trong cơ sở dữ liệu.
SELECT * FROM ChuyenGia
GO

--2. Hiển thị tên và email của các chuyên gia nữ.
SELECT HoTen, Email
FROM ChuyenGia
WHERE GioiTinh=N'Nữ'
GO

--3. Liệt kê các công ty có trên 100 nhân viên.
SELECT MaCongTy, TenCongTy
FROM CongTy
WHERE SoNhanVien>100
GO

--4. Hiển thị tên và ngày bắt đầu của các dự án trong năm 2023.
SELECT TenDuAn, NgayBatDau
FROM DuAn
WHERE YEAR(NgayBatDau)=2023
GO

-- Trung cấp:
--6. Liệt kê tên chuyên gia và số lượng dự án họ tham gia.
SELECT CG.MaChuyenGia, HoTen, COUNT(*) AS SoLuongDuAn
FROM ChuyenGia CG LEFT JOIN ChuyenGia_DuAn CD
ON CG.MaChuyenGia=CD.MaChuyenGia
GROUP BY CG.MaChuyenGia, CG.HoTen
GO

--7. Tìm các dự án có sự tham gia của chuyên gia có kỹ năng 'Python' cấp độ 4 trở lên.
SELECT MaDuAn
FROM ChuyenGia_DuAn CD
WHERE MaChuyenGia IN (
SELECT CK.MaChuyenGia
FROM ChuyenGia_KyNang CK , KyNang KN
WHERE CK.MaKyNang=KN.MaKyNang AND KN.TenKyNang=N'Python' AND CK.CapDo>4
)
GO


--8. Hiển thị tên công ty và số lượng dự án đang thực hiện.
SELECT CT.MaCongTy, TenCongTy, COUNT(CT.MaCongTy) AS SLDuAn
FROM CongTy CT LEFT JOIN DuAn DA
ON CT.MaCongTy=DA.MaCongTy
GROUP BY CT.MaCongTy, TenCongTy
GO
 
--9. Tìm chuyên gia có số năm kinh nghiệm cao nhất trong mỗi chuyên ngành.
SELECT ChuyenNganh, MaChuyenGia
FROM ChuyenGia C1
WHERE NamKinhNghiem>=ALL(
SELECT NamKinhNGhiem FROM ChuyenGia C2 WHERE C1.ChuyenNganh=C2.ChuyenNganh)
GO

--10. Liệt kê các cặp chuyên gia đã từng làm việc cùng nhau trong ít nhất một dự án.
SELECT DISTINCT C1.MaChuyenGia, C2.MaChuyenGia
FROM ChuyenGia_DuAn C1, ChuyenGia_DuAn C2
WHERE C1.MaDuAn=C2.MaDuAn AND C1.MaChuyenGia>C2.MaChuyenGia
GO

-- Nâng cao:
--11. Tính tổng thời gian (theo ngày) mà mỗi chuyên gia đã tham gia vào các dự án.
SELECT MaChuyenGia, SUM(DATEDIFF(DAY, cgd.NgayThamGia, da.NgayKetThuc)) AS TongThoiGianThamGia
FROM ChuyenGia_DuAn cgd INNER JOIN DuAn da ON cgd.MaDuAn = da.MaDuAn
GROUP BY MaChuyenGia
GO

--12. Tìm các công ty có tỷ lệ dự án hoàn thành cao nhất (trên 90%).
WITH DuAnHoanThanh AS (
    SELECT MaCongTy,
    SUM(CASE WHEN TrangThai =N'Hoàn thành' THEN 1 ELSE 0 END) AS SDAHT
    FROM DuAn
    GROUP BY MaCongTy
),
CongTyDuAn AS(
SELECT MaCongTy, COUNT(*) AS SLDA
FROM DuAn
GROUP BY MaCongTy
),
TyLeHoanThanh AS(
SELECT DISTINCT ctda.MaCongTy, 
CASE WHEN (daht.SDAHT>0) THEN (CAST(daht.SDAHT AS FLOAT)/ctda.SLDA*100) ELSE 0 END AS TyLeHoanThanh
FROM CongTyDuAn ctda, DuAnHoanThanh daht
WHERE ctda.MaCongTy=daht.MaCongTy
)
SELECT DISTINCT MaCongTy, TyLeHoanThanh
FROM TyLeHoanThanh
WHERE TyLeHoanThanh > 90
ORDER BY TyLeHoanThanh DESC
GO

--13. Liệt kê top 3 kỹ năng được yêu cầu nhiều nhất trong các dự án.
SELECT MaKyNang
FROM(
SELECT TOP 3 WITH TIES MaKyNang, COUNT(*) AS SLChuyenGia
FROM ChuyenGia_KyNang CK INNER JOIN ChuyenGia_DuAn CD
ON CK.MaChuyenGia=CD.MaChuyenGia
GROUP BY MaKyNang
ORDER BY COUNT(*) DESC
) KN_DA
GO


--14.Tính lương trung bình của chuyên gia theo từng cấp độ kinh nghiệm (Junior: 0-2 năm, Middle: 3-5 năm, Senior: >5 năm).
CREATE TABLE BangLuong(
      MaChuyenGia INT PRIMARY KEY,
	  Luong MONEY
)

SELECT 
    CASE 
        WHEN cg.NamKinhNghiem BETWEEN 0 AND 2 THEN 'Junior'
        WHEN cg.NamKinhNghiem BETWEEN 3 AND 5 THEN 'Middle'
        WHEN cg.NamKinhNghiem > 5 THEN 'Senior'
		ELSE 'Unknown'
    END AS CapDoKinhNghiem,
    AVG(luong.Luong) AS LuongTrungBinh
FROM ChuyenGia cg JOIN BangLuong luong ON cg.MaChuyenGia = luong.MaChuyenGia
GROUP BY 
    CASE 
        WHEN cg.NamKinhNghiem BETWEEN 0 AND 2 THEN 'Junior'
        WHEN cg.NamKinhNghiem BETWEEN 3 AND 5 THEN 'Middle'
        WHEN cg.NamKinhNghiem > 5 THEN 'Senior'
        ELSE 'Unknown'
    END;
GO

--15.Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
WITH ChuyenNganhDuAn AS (
SELECT cgd.MaDuAn, cg.ChuyenNganh
FROM ChuyenGia_DuAn cgd
JOIN ChuyenGia cg ON cgd.MaChuyenGia = cg.MaChuyenGia
),
SoLuongChuyenNganh AS (
SELECT COUNT(DISTINCT ChuyenNganh) AS TongChuyenNganh
FROM ChuyenGia
)
SELECT MaDuAn
FROM  ChuyenNganhDuAn 
GROUP BY MaDuAn
HAVING COUNT(ChuyenNganh)=(
SELECT TongChuyenNganh
FROM SoLuongChuyenNganh)
GO

-- Trigger:
--16. Tạo một trigger để tự động cập nhật số lượng dự án của công ty khi thêm hoặc xóa dự án.
ALTER TABLE CongTy ADD SLDuAn INT
GO

CREATE TRIGGER trg_da_ins_del 
ON DuAn
AFTER INSERT, DELETE
AS
BEGIN
     IF EXISTS( SELECT 1 FROM INSERTED)
	 BEGIN
	 UPDATE CongTy
	 SET SLDuAn=SLDuAn+(SELECT COUNT(*) FROM DuAn DA, inserted i WHERE DA.MaCongTy=i.MaCongTy)
	 WHERE MaCongTy IN(SELECT MaCongTy FROM inserted)
	 END 

	 IF EXISTS( SELECT 1 FROM DELETED)
	 BEGIN
	 UPDATE CongTy
	 SET SLDuAn=SLDuAn-(SELECT COUNT(*) FROM DuAn DA, deleted d WHERE DA.MaCongTy=d.MaCongTy)
	 WHERE MaCongTy IN(SELECT MaCongTy FROM deleted)
	 END
END
GO

--17. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng ChuyenGia.
CREATE TABLE LOG_CG(
MaChuyenGia int,
ChangeType varchar(10),
OldData varchar(MAX),
NewData varchar(MAX),
ChangeDate smalldatetime
)
GO

CREATE TRIGGER trg_log_cg ON ChuyenGia
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @machuyengia int, @olddata varchar(MAX), @newdata varchar(MAX), @changetype varchar(10)
	
	IF EXISTS(SELECT * FROM INSERTED)
	BEGIN
	    SELECT @machuyengia=MaChuyenGia, @newdata=CONCAT('Ho ten: ',HoTen, ', Ngay sinh: ', NgaySinh, ', Gioi tinh: ',GioiTinh, ', Email: ',Email, ', SDT: ', SoDienThoai, ', Chuyen nganh: ', ChuyenNganh, ', Nam kinh nghiem: ', NamKinhNghiem)
		FROM INSERTED
		SET @changetype='INSERT'
		SET @olddata=NULL
		INSERT INTO LOG_CG (MaChuyenGia, ChangeType, OldData, NewData, ChangeDate)
		VALUES(@machuyengia, @changetype, @olddata, @newdata, GETDATE())
	END

	IF EXISTS(SELECT * FROM DELETED) AND EXISTS(SELECT * FROM INSERTED)
	BEGIN
	    SELECT @machuyengia=MaChuyenGia, @olddata=CONCAT('Ho ten: ',HoTen, ', Ngay sinh: ', NgaySinh, ', Gioi tinh: ',GioiTinh, ', Email: ',Email, ', SDT: ', SoDienThoai, ', Chuyen nganh: ', ChuyenNganh, ', Nam kinh nghiem: ', NamKinhNghiem)
		FROM DELETED
		SELECT @newdata=CONCAT('Ho ten: ',HoTen, ', Ngay sinh: ', NgaySinh, ', Gioi tinh: ',GioiTinh, ', Email: ',Email, ', SDT: ', SoDienThoai, ', Chuyen nganh: ', ChuyenNganh, ', Nam kinh nghiem: ', NamKinhNghiem)
		FROM INSERTED
		SET @changetype='UPDATE'
		SET @newdata=NULL
		INSERT INTO LOG_CG (MaChuyenGia, ChangeType, OldData, NewData, ChangeDate)
		VALUES(@machuyengia, @changetype, @olddata, @newdata, GETDATE())
	END
END
GO


--18. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
CREATE TRIGGER trg_cgda_ins_upd 
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
     DECLARE @slda INT
	 SET @slda=(SELECT COUNT(*) 
	            FROM ChuyenGia_DuAn CD, inserted i, DuAn DA
				WHERE CD.MaChuyenGia=i.MaChuyenGia AND CD.MaDuAn<>i.MaDuAn
				      AND CD.MaDuAn=DA.MaDuAn AND DA.TrangThai=N'Đang thực hiện')
     IF(@slda>=4)
	 BEGIN
	 PRINT 'LOI:DA QUA SO DU AN DUOC THAM GIA!'
	 ROLLBACK TRANSACTION
	 END
END
GO

--19. Tạo một trigger để tự động cập nhật trạng thái của dự án thành 'Hoàn thành' khi tất cả chuyên gia đã kết thúc công việc.
CREATE TRIGGER trg_da ON DuAn
AFTER INSERT, DELETE, UPDATE
AS
BEGIN
     UPDATE DuAn
	 SET TrangThai=N'Hoàn thành'
	 WHERE TrangThai<>N'Hoàn thành'
	 AND NgayKetThuc<GETDATE()
END
GO



--20. Tạo một trigger để tự động tính toán và cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
ALTER TABLE DuAn ADD DiemDanhGia numeric(2,1)
GO
ALTER TABLE CongTy ADD DiemDanhGiaTB numeric(2,1)
GO
CREATE TRIGGER trg_ddg ON DuAn 
AFTER UPDATE, INSERT, DELETE
AS
BEGIN
UPDATE CongTy 
SET DiemDanhGiaTB=(
SELECT AVG(da.DiemDanhGia)
FROM DuAn da 
WHERE da.MaCongTy=CongTy.MaCongTy)
WHERE MaCongTy IN(
SELECT MaCong Ty FROM INSERETD 
UNION 
SELECT MaCongTy FROM DELETED
)
END
GO
