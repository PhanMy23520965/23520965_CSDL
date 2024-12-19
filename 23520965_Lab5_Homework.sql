-- Câu hỏi và ví dụ về Triggers (101-110)

-- 101. Tạo một trigger để tự động cập nhật trường NgayCapNhat trong bảng ChuyenGia mỗi khi có sự thay đổi thông tin.
ALTER TABLE ChuyenGia ADD NgayCapNhat smalldatetime;
CREATE TRIGGER trg_ins_ncn ON ChuyenGia 
AFTER UPDATE 
AS
BEGIN
UPDATE ChuyenGia
SET NgayCapNhat=GETDATE()
FROM ChuyenGia C INNER JOIN inserted i ON C.MaChuyenGia=i.MaChuyenGia
END;
GO

-- 102. Tạo một trigger để ghi log mỗi khi có sự thay đổi trong bảng DuAn.
-- 103. Tạo một trigger để đảm bảo rằng một chuyên gia không thể tham gia vào quá 5 dự án cùng một lúc.
CREATE TRIGGER trg_ins_cgda ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
declare @SL tinyint, @ngaythamgia smalldatetime, @ngayketthuc smalldatetime
SELECT @ngaythamgia=I.NgayThamGia, @ngayketthuc=D.NgayKetThuc 
FROM inserted i INNER JOIN DuAn D ON i.MaDuAn=D.MaDuAn
SET @SL=@SL+(
SELECT 1
FROM ChuyenGia_DuAn CD, INSERTED I, DuAn D
WHERE CD.MaChuyenGia=I.MaChuyenGia AND CD.MaDuAn=D.MaDuAn AND D.NgayKetThuc>=@ngaythamgia AND @ngaythamgia<=D.NgayKetThuc
)
IF(@SL>=5)
BEGIN 
	    PRINT 'LOI: MOT CHUYEN GIA CHI DUOC THAM GIA 5 DU AN MOT LUC!'
		ROLLBACK TRANSACTION
	END
	ELSE 
	BEGIN 
	PRINT 'THAY DOI DU LIEU THANH CONG!'
	END
END
GO

-- 104. Tạo một trigger để tự động cập nhật số lượng nhân viên trong bảng CongTy mỗi khi có sự thay đổi trong bảng ChuyenGia.
ALTER TABLE ChuyenGia ADD MaCongTy INT;
GO
CREATE TRIGGER trg_UpdateSoNhanVien
ON ChuyenGia
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted)
    BEGIN
        UPDATE CongTy
        SET SoNhanVien = (
            SELECT COUNT(*)
            FROM ChuyenGia
            WHERE ChuyenGia.MaCongTy = CongTy.MaCongTy
        )
        WHERE MaCongTy IN (SELECT MaCongTy FROM inserted);
    END
    IF EXISTS (SELECT 1 FROM deleted)
    BEGIN
        UPDATE CongTy
        SET SoNhanVien = (
            SELECT COUNT(*)
            FROM ChuyenGia
            WHERE ChuyenGia.MaCongTy = CongTy.MaCongTy
        )
        WHERE MaCongTy IN (SELECT MaCongTy FROM deleted);
    END;
END;
GO

-- 105. Tạo một trigger để ngăn chặn việc xóa các dự án đã hoàn thành.
CREATE TRIGGER trg_del_da ON DuAn
AFTER DELETE
AS
BEGIN
DECLARE @trgthai nvarchar(50)
SELECT @trgthai=TrangThai FROM DELETED
IF(@trgthai=N'Hoàn thành')
BEGIN 
	    PRINT 'LOI: KHONG THE XOA DU AN DA HOAN THANH!'
		ROLLBACK TRANSACTION 
	END
	ELSE
	BEGIN 
	    PRINT 'XOA DU AN THANH CONG!'
	END
END
GO
INSERT INTO DuAn VALUES(6,N'xxx',2,'2023-01-01','2023-01-03',N'Hoàn thành')
DELETE FROM DuAn 
WHERE MaDuAn=6
SELECT * FROM DuAn
GO

-- 106. Tạo một trigger để tự động cập nhật cấp độ kỹ năng của chuyên gia khi họ tham gia vào một dự án mới.
CREATE TRIGGER trg_UpdateCapDo
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    UPDATE ChuyenGia_KyNang
    SET CapDo=CapDo+1
    WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM inserted);
END;
GO

-- 107. Tạo một trigger để ghi log mỗi khi có sự thay đổi cấp độ kỹ năng của chuyên gia.
-- 108. Tạo một trigger để đảm bảo rằng ngày kết thúc của dự án luôn lớn hơn ngày bắt đầu.
CREATE TRIGGER trg_ins_upd_da ON DuAn 
AFTER INSERT, UPDATE
AS
BEGIN
IF EXISTS(
SELECT *
FROM INSERTED 
WHERE NgayBatDau>NgayKetThuc)
BEGIN 
	    PRINT 'LOI: NGAY BAT DAU VA KET THUC KHONG HOP LE!'
		ROLLBACK TRANSACTION 
	END
	ELSE
	BEGIN 
	    PRINT 'THEM/SUA THONG TIN DU AN THANH CONG!'
	END
END
GO

-- 109. Tạo một trigger để tự động xóa các bản ghi liên quan trong bảng ChuyenGia_KyNang khi một kỹ năng bị xóa.
CREATE TRIGGER trg_del_kn ON KyNang
AFTER DELETE 
AS
BEGIN
DECLARE @makn int
SELECT @makn=MaKyNang FROM DELETED
DELETE FROM ChuyenGia_KyNang 
WHERE MaKyNang=@makn
END
GO

-- 110. Tạo một trigger để đảm bảo rằng một công ty không thể có quá 10 dự án đang thực hiện cùng một lúc.
CREATE TRIGGER trg_LimitSoDuAn
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT MaCongTy
        FROM DuAn
        WHERE TrangThai = N'Đang thực hiện'
        GROUP BY MaCongTy
        HAVING COUNT(*) > 10
    )
    BEGIN
        RAISERROR ('Một công ty không thể có quá 10 dự án đang thực hiện cùng một lúc.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Câu hỏi và ví dụ về Triggers bổ sung (123-135)

-- 123. Tạo một trigger để tự động cập nhật lương của chuyên gia dựa trên cấp độ kỹ năng và số năm kinh nghiệm.
ALTER TABLE ChuyenGia ADD Luong MONEY;

CREATE TRIGGER trg_UpdateLuongChuyenGia
ON ChuyenGia
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE ChuyenGia
    SET Luong = k.CapDo * c.NamKinhNghiem * 1000000
    FROM ChuyenGia c
    INNER JOIN ChuyenGia_KyNang k ON c.MaChuyenGia = k.MaChuyenGia
    WHERE c.MaChuyenGia IN (SELECT MaChuyenGia FROM inserted);
END;
GO
-
-- 124. Tạo một trigger để tự động gửi thông báo khi một dự án sắp đến hạn (còn 7 ngày).
-- Tạo bảng ThongBao nếu chưa có
CREATE TABLE ThongBao (
    MaThongBao INT PRIMARY KEY,
    MaDuAn INT,                  
    ThongBao NVARCHAR(255),  
    NgayThongBao DATETIME DEFAULT GETDATE(), 
    TrangThai NVARCHAR(50) 
);

CREATE TRIGGER trg_ThongBaoDenHan
ON DuAn
AFTER INSERT, UPDATE
AS
BEGIN
    INSERT INTO ThongBao (MaDuAn, ThongBao)
    SELECT d.MaDuAn, 
           'Dự án ' + d.TenDuAn + ' sẽ hết hạn trong 7 ngày tới.'
    FROM DuAn d
    INNER JOIN inserted i ON d.MaDuAn = i.MaDuAn
    WHERE DATEDIFF(DAY, GETDATE(), d.NgayKetThuc) = 7
    AND d.NgayKetThuc IS NOT NULL;
END;
GO

-- 125. Tạo một trigger để ngăn chặn việc xóa hoặc cập nhật thông tin của chuyên gia đang tham gia dự án.
CREATE TRIGGER trg_PreventDeleteChuyenGia
ON ChuyenGia
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM ChuyenGia_DuAn
        WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM deleted)
    )
    BEGIN
        RAISERROR('Không thể xóa chuyên gia vì họ đang tham gia dự án.', 16, 1);
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- Nếu không tham gia dự án, cho phép xóa
        DELETE FROM ChuyenGia
        WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM deleted);
    END
END;
GO

-- 126. Tạo một trigger để tự động cập nhật số lượng chuyên gia trong mỗi chuyên ngành.
-- Tạo bảng ThongKeChuyenNganh nếu chưa có
CREATE TABLE ThongKeChuyenNganh (
    MaChuyenNganh INT PRIMARY KEY,   
    TenChuyenNganh NVARCHAR(255),    
    SoLuongChuyenGia INT 
);
CREATE TRIGGER trg_UpdateSoLuongChuyenGia
ON ChuyenGia
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE ThongKeChuyenNganh
    SET SoLuongChuyenGia = (
        SELECT COUNT(*)
        FROM ChuyenGia
        WHERE ChuyenNganh = ThongKeChuyenNganh.MaChuyenNganh
    )
    WHERE MaChuyenNganh IN (SELECT DISTINCT ChuyenNganh FROM inserted);
END;
GO


-- 127. Tạo một trigger để tự động tạo bản sao lưu của dự án khi nó được đánh dấu là hoàn thành.
-- Tạo bảng DuAnHoanThanh nếu chưa có
CREATE TABLE DuAnHoanThanh (
    MaDuAn INT PRIMARY KEY,         
    TenDuAn NVARCHAR(255),           
    TrangThai NVARCHAR(50),
	MaCongTy INT,
    NgayBatDau SMALLDATETIME, 
	NgayKetThuc SMALLDATETIME,
    CONSTRAINT FK_DuAnHoanThanh FOREIGN KEY (MaDuAn) REFERENCES DuAn(MaDuAn)
);

CREATE TRIGGER trg_BackupDuAn
ON DuAn
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE TrangThai = 'Hoàn thành')
    BEGIN
        INSERT INTO DuAnHoanThanh (MaDuAn, TenDuAn, TrangThai, NgayBatDau, NgayKetThuc, MaCongTy)
        SELECT MaDuAn, TenDuAn, TrangThai,NgayBatDau, NgayKetThuc, MaCongTy
        FROM inserted
        WHERE TrangThai = 'Hoàn thành';
    END
END;
GO

-- 128. Tạo một trigger để tự động cập nhật điểm đánh giá trung bình của công ty dựa trên điểm đánh giá của các dự án.
-- 129. Tạo một trigger để tự động phân công chuyên gia vào dự án dựa trên kỹ năng và kinh nghiệm.
-- 130. Tạo một trigger để tự động cập nhật trạng thái "bận" của chuyên gia khi họ được phân công vào dự án mới.
ALTER TABLE ChuyenGia ADD TT NVARCHAR(50)
GO
CREATE TRIGGER trg_UpdateTrangThaiBunt
ON ChuyenGia_DuAn
AFTER INSERT
AS
BEGIN
    UPDATE ChuyenGia
    SET TT = N'Bận'
    WHERE MaChuyenGia IN (SELECT MaChuyenGia FROM inserted);
END;
GO

-- 131. Tạo một trigger để ngăn chặn việc thêm kỹ năng trùng lặp cho một chuyên gia.
CREATE TRIGGER trg_AvoidDuplicateKyNang
ON ChuyenGia_KyNang
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN ChuyenGia_KyNang c
        ON i.MaChuyenGia = c.MaChuyenGia AND i.MaKyNang = c.MaKyNang
    )
    BEGIN
        RAISERROR('Kỹ năng đã tồn tại cho chuyên gia này!', 16, 1);
    END
END;
GO

-- 132. Tạo một trigger để tự động tạo báo cáo tổng kết khi một dự án kết thúc.
-- 133. Tạo một trigger để tự động cập nhật thứ hạng của công ty dựa trên số lượng dự án hoàn thành và điểm đánh giá.
-- 134. Tạo một trigger để tự động gửi thông báo khi một chuyên gia được thăng cấp (dựa trên số năm kinh nghiệm).
-- 135. Tạo một trigger để tự động cập nhật trạng thái "khẩn cấp" cho dự án khi thời gian còn lại ít hơn 10% tổng thời gian dự án.
-- 136. Tạo một trigger để tự động cập nhật số lượng dự án đang thực hiện của mỗi chuyên gia.
-- 137. Tạo một trigger để tự động tính toán và cập nhật tỷ lệ thành công của công ty dựa trên số dự án hoàn thành và tổng số dự án.
-- 138. Tạo một trigger để tự động ghi log mỗi khi có thay đổi trong bảng lương của chuyên gia.
-- 139. Tạo một trigger để tự động cập nhật số lượng chuyên gia cấp cao trong mỗi công ty.
-- 140. Tạo một trigger để tự động cập nhật trạng thái "cần bổ sung nhân lực" cho dự án khi số lượng chuyên gia tham gia ít hơn yêu cầu.


