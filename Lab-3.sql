
-- 8. Hiển thị tên và cấp độ của tất cả các kỹ năng của chuyên gia có MaChuyenGia là 1.
SELECT TenKyNang, CapDo
FROM KyNang A INNER JOIN ChuyenGia_KyNang B
ON A.MaKyNang=B.MaKyNang
WHERE MaChuyenGia=1
GO

-- 9. Liệt kê tên các chuyên gia tham gia dự án có MaDuAn là 2.
SELECT HoTen 
FROM ChuyenGia 
WHERE MaChuyenGia IN (
SELECT MaChuyenGia 
FROM ChuyenGia_DuAn 
WHERE MaDuAn=2
)
GO

-- 10. Hiển thị tên công ty và tên dự án của tất cả các dự án.
SELECT TenCongTy, TenDuAn 
FROM DuAn INNER JOIN CongTy 
ON DuAn.MaCongTy=CongTy.MaCongTy 
GO

-- 11. Đếm số lượng chuyên gia trong mỗi chuyên ngành.
SELECT ChuyenNganh, COUNT(MaChuyenGia) SoChuyenGia 
FROM ChuyenGia 
GROUP BY ChuyenNganh 
GO

-- 12. Tìm chuyên gia có số năm kinh nghiệm cao nhất.
SELECT MaChuyenGia, HoTen 
FROM ChuyenGia A
WHERE NOT EXISTS (
SELECT 1 
FROM ChuyenGia B 
WHERE A.NamKinhNghiem<B.NamKinhNghiem
)
GO

-- 13. Liệt kê tên các chuyên gia và số lượng dự án họ tham gia.
SELECT HoTen, COUNT(MaDuAn) AS SoDuAn 
FROM ChuyenGia A LEFT JOIN CHuyenGia_DuAn B
ON A.MaChuyenGia=B.MaChuyenGia 
GROUP BY HoTen
GO 

-- 14. Hiển thị tên công ty và số lượng dự án của mỗi công ty.
SELECT TenCongTy, COUNT(MaDuAn) AS SoDuAn 
FROM CongTy LEFT JOIN DuAn 
ON CongTy.MaCongTy=DuAn.MaCongTy 
GROUP BY TenCongTy 
GO

-- 15. Tìm kỹ năng được sở hữu bởi nhiều chuyên gia nhất.
SELECT MaKyNang, TenKyNang 
FROM KyNang 
WHERE MaKyNang IN (
SELECT MaKyNang 
FROM (
SELECT MaKyNang, COUNT(MaChuyenGia) AS SoCG
FROM ChuyenGia_KyNang 
GROUP BY MaKyNang
) A
WHERE SoCG IN (
SELECT MAX(SoCG)
FROM (
SELECT MaKyNang, COUNT(MaChuyenGia) AS SoCG
FROM ChuyenGia_KyNang 
GROUP BY MaKyNang
) A
)
)
GO

-- 16. Liệt kê tên các chuyên gia có kỹ năng 'Python' với cấp độ từ 4 trở lên.
SELECT HoTen 
FROM ChuyenGia 
WHERE MaChuyenGia IN (
SELECT MaChuyenGia 
FROM ChuyenGia_KyNang 
WHERE CapDo>=4 AND MaKyNang IN (
SELECT MaKyNang 
FROM KyNang 
WHERE TenKyNang='Python'
)
)
GO

-- 17. Tìm dự án có nhiều chuyên gia tham gia nhất.
SELECT MaDuAn, TenDuAn 
FROM DuAn 
WHERE MaDuAn IN (
SELECT MaDuAn 
FROM (
SELECT MaDuAn, COUNT(MaChuyenGia) AS SoCG
FROM ChuyenGia_DuAn 
GROUP BY MaDuAn
) C
WHERE SoCG IN (
SELECT MAX(SoCG)
FROM (
SELECT MaDuAn, COUNT(MaChuyenGia) AS SoCG
FROM ChuyenGia_DuAn 
GROUP BY MaDuAn
) C
)
)
GO

-- 18. Hiển thị tên và số lượng kỹ năng của mỗi chuyên gia.
SELECT HoTen, COUNT(MaKyNang) AS SoLuongKyNang 
FROM ChuyenGia A LEFT JOIN ChuyenGia_KyNang B 
ON A.MaChuyenGia=B.MaChuyenGia
GROUP BY HoTen 
GO

-- 19.Tìm các cặp chuyên gia làm việc cùng dự án.
SELECT DISTINCT A.MaChuyenGia, B.MaChuyenGia, A.MaDuAn
FROM ChuyenGia_DuAn A INNER JOIN ChuyenGia_DuAn B 
ON A.MaDuAn=B.MaDuAn 
WHERE A.MaChuyenGia < B.MaChuyenGia
GO

-- 20. Liệt kê tên các chuyên gia và số lượng kỹ năng cấp độ 5 của họ.
SELECT HoTen, COUNT(CASE WHEN B.CapDo=5 THEN 1 END) AS SLKNLONHON5
FROM ChuyenGia A LEFT JOIN ChuyenGia_KyNang B 
ON A.MaChuyenGia=B.MaChuyenGia 
GROUP BY HoTen 
GO 

-- 21. Tìm các công ty không có dự án nào.
SELECT MaCongTy 
FROM CongTy 
EXCEPT 
SELECT MaCongTy 
FROM DuAn
GO

-- 22. Hiển thị tên chuyên gia và tên dự án họ tham gia, bao gồm cả chuyên gia không tham gia dự án nào.
SELECT HoTen, TenDuAn 
FROM ChuyenGia A
LEFT JOIN ChuyenGia_DuAn B ON A.MaChuyenGia=B.MaChuyenGia 
LEFT JOIN DuAn C ON B.MaDuAn=C.MaDuAn 
GO 

-- 23. Tìm các chuyên gia có ít nhất 3 kỹ năng.
SELECT MaChuyenGia
FROM (
SELECT MaChuyenGia, COUNT(MaKyNang) AS SOKN 
FROM ChuyenGia_KyNang 
GROUP BY MaChuyenGia) A
WHERE SOKN>=3
GO

-- 24. Hiển thị tên công ty và tổng số năm kinh nghiệm của tất cả chuyên gia trong các dự án của công ty đó.
SELECT TenCongTy, SUM(NamKinhNghiem) AS TongNKN 
FROM CongTy A INNER JOIN DuAn B ON A.MaCongTy=B.MaCongTy 
INNER JOIN ChuyenGia_DuAn C ON C.MaDuAn=B.MaDuAn 
INNER JOIN ChuyenGia D On D.MaChuyenGia=C.MaChuyenGia
GROUP BY TenCongTy
GO

-- 25. Tìm các chuyên gia có kỹ năng 'Java' nhưng không có kỹ năng 'Python'.
SELECT MaChuyenGia 
FROM ChuyenGia_KyNang 
WHERE MaKyNang IN (
SELECT MaKyNang 
FROM KyNang 
WHERE TenKyNang='Java'
)
EXCEPT 
SELECT MaChuyenGia 
FROM ChuyenGia_KyNang 
WHERE MaKyNang IN (
SELECT MaKyNang 
FROM KyNang 
WHERE TenKyNang='Python'
)
GO 

-- 76. Tìm chuyên gia có số lượng kỹ năng nhiều nhất.
SELECT MaChuyenGia, HoTen
FROM ChuyenGia 
WHERE MaChuyenGia IN (
SELECT MaChuyenGia 
FROM (
SELECT MaChuyenGia, COUNT(MaKyNang) AS SoKN 
FROM ChuyenGia_KyNang 
GROUP BY MaChuyenGia 
) A
WHERE SoKN IN (SELECT MAX(SoKN) FROM (
SELECT MaChuyenGia, COUNT(MaKyNang) AS SoKN 
FROM ChuyenGia_KyNang 
GROUP BY MaChuyenGia 
) A
)
)
GO

-- 77. Liệt kê các cặp chuyên gia có cùng chuyên ngành.
SELECT A.MaChuyenGia, B.MaChuyenGia, A.ChuyenNganh 
FROM ChuyenGia A INNER JOIN ChuyenGia B ON A.ChuyenNganh=B.ChuyenNganh 
WHERE A.MaChuyenGia<B.MaChuyenGia
GO 

-- 78. Tìm công ty có tổng số năm kinh nghiệm của các chuyên gia trong dự án cao nhất.
SELECT MaCongTy, TenCongTy
FROM CongTy
WHERE MaCongTy IN (
SELECT MaCongTy 
FROM (
SELECT MaCongTy, SUM(NamKinhNghiem) AS TongNKN 
FROM DuAn B 
INNER JOIN ChuyenGia_DuAn C ON C.MaDuAn=B.MaDuAn 
INNER JOIN ChuyenGia D On D.MaChuyenGia=C.MaChuyenGia
GROUP BY MaCongTy
) A
WHERE TongNKN IN (
SELECT MAX(TongNKN) 
FROM (
SELECT MaCongTy, SUM(NamKinhNghiem) AS TongNKN 
FROM DuAn B 
INNER JOIN ChuyenGia_DuAn C ON C.MaDuAn=B.MaDuAn 
INNER JOIN ChuyenGia D On D.MaChuyenGia=C.MaChuyenGia
GROUP BY MaCongTy
) A
)
)
GO

-- 79. Tìm kỹ năng được sở hữu bởi tất cả các chuyên gia.
SELECT MaKyNang
FROM ChuyenGia_KyNang A
WHERE NOT EXISTS (
SELECT MaChuyenGia 
FROM ChuyenGia
WHERE MaChuyenGia NOT IN (
SELECT MaChuyenGia 
FROM ChuyenGia_KyNang B 
WHERE A.MaKyNang=B.MaKyNang)
)
GO
