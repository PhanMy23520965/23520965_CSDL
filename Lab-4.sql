-- 76. Liệt kê top 3 chuyên gia có nhiều kỹ năng nhất và số lượng kỹ năng của họ.
SELECT TOP 3 CG.MaChuyenGia, HoTen, COUNT(CG.MaChuyengia) AS SLKN
FROM Chuyengia CG INNER JOIN ChuyenGia_KyNang CK ON CG.MaChuyenGia=CK.MaChuyenGia 
GROUP BY CG.MaChuyenGia, HoTen 
ORDER BY SLKN DESC
GO

-- 77. Tìm các cặp chuyên gia có cùng chuyên ngành và số năm kinh nghiệm chênh lệch không quá 2 năm.
SELECT A.MaChuyenGia, B.MaChuyenGia 
FROM ChuyenGia A, ChuyenGia B
WHERE A.ChuyenNganh=B.ChuyenNganh AND ABS(A.NamKinhNghiem-B.NamKinhNghiem)<=2 AND A.MaChuyenGia<>B.MaChuyenGia
GO

-- 78. Hiển thị tên công ty, số lượng dự án và tổng số năm kinh nghiệm của các chuyên gia tham gia dự án của công ty đó.
SELECT TenCongTy, COUNT(*) AS SLDA 
FROM DuAn INNER JOIN CongTy ON DuAn.MaCongTy=CongTy.MaCongTy 
GROUP BY TenCongTy 
GO

-- 79. Tìm các chuyên gia có ít nhất một kỹ năng cấp độ 5 nhưng không có kỹ năng nào dưới cấp độ 3.
SELECT MaChuyenGia, HoTen 
FROM ChuyenGia A
WHERE NOT EXISTS(
SELECT 1
FROM ChuyenGia_KyNang B
WHERE A.MaChuyenGia=B.MaChuyenGia AND CapDo<3)
AND EXISTS(
SELECT 1 
FROM ChuyenGia_KyNang C 
WHERE A.MaChuyenGia=C.MaChuyenGia AND CapDo=5
)
GO

-- 80. Liệt kê các chuyên gia và số lượng dự án họ tham gia, bao gồm cả những chuyên gia không tham gia dự án nào.
SELECT A.MaChuyenGia, HoTen, COUNT(MaDuAn) AS SLDA 
FROM ChuyenGia A LEFT JOIN ChuyenGia_DuAn B ON A.MaChuyenGia=B.MaChuyenGia 
GROUP BY A.MaChuyenGia, HoTen
GO

-- 81*. Tìm chuyên gia có kỹ năng ở cấp độ cao nhất trong mỗi loại kỹ năng.
SELECT MaKyNang, A.MaChuyenGia, HoTen
FROM ChuyenGia_KyNang A INNER JOIN ChuyenGia B ON A.MaChuyenGia=B.MaChuyenGia
WHERE A.CapDo>=ALL(
SELECT CapDo 
FROM ChuyenGia_KyNang C
WHERE A.MaKyNang=C.MaKyNang)
ORDER BY MaKyNang ASC
GO

-- 82. Tính tỷ lệ phần trăm của mỗi chuyên ngành trong tổng số chuyên gia.
WITH SCN AS (
SELECT ChuyenNganh, COUNT(*) AS SoLuong
FROM ChuyenGia
GROUP BY ChuyenNganh
),
SCG AS (
SELECT COUNT(*) AS TongSo
FROM ChuyenGia
)
SELECT SCN.ChuyenNganh, SCN.SoLuong, CAST(SCN.SoLuong AS FLOAT) / SCG.TongSo * 100 AS PhanTram
FROM SCN, SCG;
GO

-- 83. Tìm các cặp kỹ năng thường xuất hiện cùng nhau nhất trong hồ sơ của các chuyên gia.
SELECT KN1.TenKyNang, KN2.TenKyNang, COUNT(*) AS SoLanXuatHien
FROM ChuyenGia_KyNang CK1 JOIN ChuyenGia_KyNang CK2 ON CK1.MaChuyenGia=CK2.MaChuyenGia 
JOIN KyNang KN1 ON CK1.MaKyNang=KN1.MakyNang 
JOIN KyNang KN2 ON CK2.MaKyNang=KN2.MaKyNang
WHERE CK1.MaKyNang<CK2.MaKYNang 
GROUP BY KN1.TenKyNang, KN2.TenKyNang
ORDER BY SoLanXuatHien DESC
GO

-- 84. Tính số ngày trung bình giữa ngày bắt đầu và ngày kết thúc của các dự án cho mỗi công ty.
SELECT TenCongTy, AVG(DATEDIFF(DAY, NgayBatDau, NgayKetThuc)) AS SoNgayTRungBinh
FROM ConGTy INNER JOIN DuAn ON CongTy.MaCongTy=DuAn.MaCongTy 
WHERE NgayKetThuc IS NOT NULL AND NgayBatDau IS NOT NULL
GROUP BY TenCongTy 
GO

-- 85*. Tìm chuyên gia có sự kết hợp độc đáo nhất của các kỹ năng (kỹ năng mà chỉ họ có).
SELECT DISTINCT CK1.MaChuyenGIa, HoTen 
FROM ChuyenGia CG INNER JOIN ChuyenGia_KyNang CK1 ON CG.MaChuyenGia=CK1.MaChuyenGia 
WHERE NOT EXISTS(
SELECT 1 
FROM ChuyenGia_KyNang CK2
WHERE CK1.MaChuyenGia<CK2.MaChuyenGia AND CK1.MaKyNang=Ck2.MaKyNang)
GO

-- 86*. Tạo một bảng xếp hạng các chuyên gia dựa trên số lượng dự án và tổng cấp độ kỹ năng.
SELECT CG.MaChuyenGia, HoTen, COUNT(DISTINCT CD.MaDuAn) AS SLDA, COALESCE(SUM(CapDo), 0) AS TongCapDoKN, 
RANK() OVER (ORDER BY COUNT(CD.MaDuAn) DESC, SUM(CapDo) DESC) AS XepHang
FROM ChuyenGia CG LEFT JOIN ChuyenGia_KyNang CK ON CG.MaChuyenGia=CK.MaChuyenGia 
LEFT JOIN ChuyenGia_DuAn CD ON CG.MaChuyenGia=CD.MaChuyenGia 
GROUP BY CG.MaChuyenGia, HoTen
GO 

-- 87. Tìm các dự án có sự tham gia của chuyên gia từ tất cả các chuyên ngành.
WITH SoChuyenNganh AS(
SELECT COUNT(DISTINCT ChuyenNganh) AS SLCN
FROM ChuyenGia 
),
DuAn_ChuyenNganh AS(
SELECT CD.MaDuAN, TenDuAn, COUNT(DISTINCT ChuyenNganh) AS SLCNDA
FROM ChuyenGia_DuAn CD INNER JOIN DuAn DA ON CD.MaDuAN=DA.MaDuAn 
INNER JOIN ChuyenGia CG ON CD.MaChuyenGia=CG.MaChuyenGia 
GROUP BY CD.MaDuAN, TenDuAn
)
SELECT DC.MaDuAn, DC.TenDuAn
FROM SoChuyenNganh SCN, DuAn_ChuyenNganh DC
WHERE SCN.SLCN=DC.SLCNDA
GO

-- 88. Tính tỷ lệ thành công của mỗi công ty dựa trên số dự án hoàn thành so với tổng số dự án.
WITH SDA AS(
SELECT COUNT(*) AS SL
FROM DuAn
),
SDAHT AS(
SELECT A.MaCongTy, A.TenCongTy, SUM(CASE WHEN B.TrangThai=N'Hoàn thành' THEN 1 ELSE 0 END) AS SDAHoanThanh 
FROM CongTy A LEFT JOIN DuAn B ON A.MaCongTy=B.MaCongTy 
GROUP BY A.MaCongTy, A.TenCongTy
)
SELECT SDAHT.MaCongTy,SDAHT.TenCongTy, SDAHT.SDAHoanThanh, CASE WHEN (SDAHT.SDAHoanThanh>0) THEN CAST(SDAHT.SDAHoanThanh AS FLOAT)/SDA.SL ELSE 0 END AS TYLETHANHCONG
FROM SDA, SDAHT;
GO

-- 89. Tìm các chuyên gia có kỹ năng "bù trừ" nhau (một người giỏi kỹ năng A nhưng yếu kỹ năng B, người kia ngược lại).
WITH CK AS(
SELECT CK1.MaChuyenGia AS CG1, CK2.MaChuyenGia AS CG2,
       CK1.MaKyNang AS KN1, CK2.MaKyNang AS KN2,
	   CK1.CapDo AS CD1, CK2.CapDo AS CD2 
FROM ChuyenGia_KyNang CK1 INNER JOIN ChuyenGia_KyNang CK2 ON CK1.MaKyNang=CK2.MaKyNang AND CK1.MaChuyenGia<CK2.MaChuyenGia
)
SELECT DISTINCT A.CG1, A.KN1, B.CG2, B.KN2
FROM CK A INNER JOIN CK B ON A.CG1=B.CG1 AND A.CG2=B.CG2 AND A.KN1<B.KN1
WHERE (A.CD1>A.CD2 AND B.CD1<B.CD2) OR (A.CD1<A.CD2 AND B.CD1>B.CD2)
GO
