-- 1. Bài tập 1
-- Sinh viên hoàn thành Phần III bài tập QuanLyBanHang từ câu 19 đến 30.

-- 19.Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(*) AS SOHOADON
FROM HOADON 
WHERE MAKH NOT IN (
SELECT MAKH 
FROM KHACHHANG
WHERE HOADON.MAKH=KHACHHANG.MAKH)
GO

-- 20.Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(DISTINCT MASP)
FROM CTHD INNER JOIN HOADON 
ON CTHD.SOHD=HOADON.SOHD
WHERE YEAR(NGHD)=2006
GO

-- 21.Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu?
SELECT MIN(TRIGIA) AS HDTHAPNHAT, MAX(TRIGIA) AS HDCAONHAT 
FROM HOADON 
GO

-- 22.Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA) AS TRIGIATB 
FROM HOADON 
WHERE YEAR(NGHD)=2006
GO

-- 23.Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) AS TRIGIATB 
FROM HOADON 
WHERE YEAR(NGHD)=2006
GO

-- 24.Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD
FROM HOADON 
WHERE YEAR(NGHD)=2006 AND TRIGIA>=ALL(SELECT TRIGIA FROM HOADON WHERE YEAR(NGHD)=2006)
GO

-- 25.Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT HOTEN 
FROM KHACHHANG KH INNER JOIN HOADON HD ON KH.MAKH=HD.MAKH 
WHERE YEAR(NGHD)=2006 AND TRIGIA>=ALL(SELECT TRIGIA FROM HOADON WHERE YEAR(NGHD)=2006)
GO

-- 26.In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
SELECT TOP 3 MAKH, HOTEN 
FROM KHACHHANG 
ORDER BY DOANHSO DESC
GO

-- 27.In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE GIA=ANY(SELECT TOP 3 GIA FROM SANPHAM ORDER BY GIA DESC)
GO

-- 28.In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của tất cả các sản phẩm).
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE NUOCSX='Thai Lan' AND GIA=ANY(SELECT TOP 3 GIA FROM SANPHAM ORDER BY GIA DESC)
GO

-- 29.In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE NUOCSX='Trung Quoc' AND GIA=ANY(SELECT TOP 3 GIA FROM SANPHAM WHERE NUOCSX='Trung Quoc' ORDER BY GIA DESC)
GO

-- 30.* In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
SELECT TOP 3 MAKH, HOTEN , RANK() OVER (ORDER BY DOANHSO DESC) XEPHANG 
FROM KHACHHANG
GO


---------------------------------------------------------------------------------------------------------------------------
-- 2. Bài tập 2
-- Sinh viên hoàn thành Phần III bài tập QuanLyGiaoVu từ câu 19 đến câu 25.

-- 19.Khoa nào (mã khoa, tên khoa) được thành lập sớm nhất.
SELECT MAKHOA, TENKHOA 
FROM KHOA 
WHERE NGTLAP<=ALL(SELECT NGTLAP FROM KHOA)
GO

-- 20.Có bao nhiêu giáo viên có học hàm là “GS” hoặc “PGS”.
SELECT COUNT(MAGV) AS SOGV 
FROM GIAOVIEN 
WHERE HOCHAM='GS' OR HOCHAM='PGS' 
GO

-- 21.Thống kê có bao nhiêu giáo viên có học vị là “CN”, “KS”, “Ths”, “TS”, “PTS” trong mỗi khoa.
SELECT MAKHOA, COUNT(MAGV) AS SOGV 
FROM GIAOVIEN 
WHERE HOCVI IN ('CN', 'KS', 'Ths', 'TS', 'PTS')
GROUP BY MAKHOA
GO
-- 22.Mỗi môn học thống kê số lượng học viên theo kết quả (đạt và không đạt).
SELECT MAMH, KQUA, COUNT(MAHV) AS SOLUONG 
FROM KETQUATHI A
WHERE NOT EXISTS(
SELECT 1
FROM KETQUATHI B
WHERE A.MAMH=B.MAMH AND A.MAHV=B.MAHV AND A.LANTHI<B.LANTHI)
GROUP BY MAMH, KQUA
GO

-- 23.Tìm giáo viên (mã giáo viên, họ tên) là giáo viên chủ nhiệm của một lớp, đồng thời dạy cho lớp đó ít nhất một môn học.
SELECT DISTINCT MAGV, HOTEN 
FROM GIAOVIEN GV INNER JOIN LOP L ON GV.MAGV=L.MAGVCN 
WHERE MAGV IN (
SELECT MAGV
FROM GIANGDAY GD
WHERE GD.MAGV=GV.MAGV AND GD.MALOP=L.MALOP
)
GO

-- 24.Tìm họ tên lớp trưởng của lớp có sỉ số cao nhất.
SELECT HO, TEN 
FROM HOCVIEN INNER JOIN LOP ON HOCVIEN.MAHV=LOP.TRGLOP 
WHERE SISO>=ALL(SELECT SISO FROM LOP)
GO

--25.* Tìm họ tên những LOPTRG thi không đạt quá 3 môn (mỗi môn đều thi không đạt ở tất cả các lần thi).
SELECT HO, TEN
FROM LOP INNER JOIN HOCVIEN ON LOP.TRGLOP=HOCVIEN.MAHV 
WHERE EXISTS(
SELECT MAHV, COUNT(MAMH) AS SLUONG
FROM KETQUATHI A
WHERE A.MAHV=HOCVIEN.MAHV AND NOT EXISTS(
SELECT 1
FROM KETQUATHI B
WHERE A.MAMH=B.MAMH AND A.MAHV=B.MAHV AND KQUA='Dat')
GROUP BY MAHV 
HAVING COUNT(MAMH)>3
)
GO

---------------------------------------------------------------------------------------------------------------------------
-- 3. Bài tập 3
-- Sinh viên hoàn thành Phần III bài tập QuanLyBanHang từ câu 31 đến 45.

-- 31.Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(*) AS SOSP
FROM SANPHAM 
WHERE NUOCSX='Trung Quoc' 
GO

-- 32.Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX, COUNT(*) AS SOSP
FROM SANPHAM 
GROUP BY NUOCSX
GO

-- 33.Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) AS GIACAONHAT, MIN(GIA) GIATHAPNHAT, AVG(GIA) AS GIATB 
FROM SANPHAM 
GROUP BY NUOCSX 
GO

-- 34.Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) AS DOANHTHU
FROM HOADON 
GROUP BY NGHD 
GO

-- 35.Tính tổng số lượng của từng sản phẩm bán ra trong tháng 10/2006.
SELECT CTHD.MASP, SUM(SL) AS SOLUONGBANRA 
FROM CTHD INNER JOIN HOADON ON CTHD.SOHD=HOADON.SOHD 
WHERE MONTH(NGHD)=10 AND YEAR(NGHD)=2006
GROUP BY CTHD.MASP
GO

-- 36.Tính doanh thu bán hàng của từng tháng trong năm 2006.
SELECT MONTH(NGHD), SUM(TRIGIA) AS DOANTHU 
FROM HOADON 
WHERE YEAR(NGHD)=2006
GROUP BY MONTH(NGHD) 
GO

-- 37.Tìm hóa đơn có mua ít nhất 4 sản phẩm khác nhau.
SELECT SOHD
FROM CTHD 
GROUP BY SOHD
HAVING COUNT(DISTINCT MASP)>=4
GO

-- 38.Tìm hóa đơn có mua 3 sản phẩm do “Viet Nam” sản xuất (3 sản phẩm khác nhau).
SELECT SOHD 
FROM CTHD INNER JOIN SANPHAM ON CTHD.MASP=SANPHAM.MASP
WHERE NUOCSX='Viet Nam'
GROUP BY SOHD 
HAVING COUNT(DISTINCT CTHD.MASP)=3
GO

-- 39.Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.
SELECT B.MAKH, HOTEN 
FROM KHACHHANG A INNER JOIN (
SELECT TOP 1 MAKH, COUNT(SOHD) AS SOLAN
FROM HOADON 
GROUP BY MAKH 
ORDER BY SOLAN DESC
) B
ON A.MAKH=B.MAKH 
GO

-- 40.Tháng mấy trong năm 2006, doanh số bán hàng cao nhất ?
SELECT THANGMAX 
FROM (
SELECT TOP 1 MONTH(NGHD) AS THANGMAX, SUM(TRIGIA) AS DOANHSO
FROM HOADON
GROUP BY MONTH(NGHD) 
ORDER BY DOANHSO DESC
) A
GO

-- 41.Tìm sản phẩm (MASP, TENSP) có tổng số lượng bán ra thấp nhất trong năm 2006.
SELECT MASP, TENSP 
FROM (
SELECT TOP 1 CTHD.MASP, TENSP, SUM(SL) AS SLG 
FROM CTHD INNER JOIN SANPHAM ON CTHD.MASP=SANPHAM.MASP
GROUP BY CTHD.MASP, TENSP 
ORDER BY SLG ASC
) A
GO

-- 42.*Mỗi nước sản xuất, tìm sản phẩm (MASP,TENSP) có giá bán cao nhất.
SELECT NUOCSX, MASP, TENSP
FROM SANPHAM A
WHERE GIA>=ALL(
SELECT GIA 
FROM SANPHAM B
WHERE A.NUOCSX=B.NUOCSX
)
GO

-- 43.Tìm nước sản xuất sản xuất ít nhất 3 sản phẩm có giá bán khác nhau.
SELECT NUOCSX 
FROM SANPHAM 
GROUP BY NUOCSX 
HAVING COUNT(DISTINCT GIA)>=3 
GO

-- 44.*Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
WITH TOP_10 AS(
SELECT TOP 10 MAKH, HOTEN
FROM KHACHHANG 
ORDER BY DOANHSO DESC
)
SELECT TOP 1 WITH TIES A.MAKH, HOTEN 
FROM TOP_10 A INNER JOIN (
SELECT MAKH, COUNT(*) AS SLMUA 
FROM HOADON 
GROUP BY MAKH) B 
ON A.MAKH=B.MAKH
ORDER BY SLMUA DESC
GO

---------------------------------------------------------------------------------------------------------------------------
-- 4. Bài tập 4
-- Sinh viên hoàn thành Phần III bài tập QuanLyGiaoVu từ câu 26 đến câu 35.

-- 26.Tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
SELECT MAHV, HO+' '+TEN AS HOTEN
FROM (
SELECT TOP 1 WITH TIES HV.MAHV, HO, TEN, COUNT(DIEM) AS SODIEM
FROM HOCVIEN HV INNER JOIN KETQUATHI KQ
ON HV.MAHV=KQ.MAHV
WHERE DIEM BETWEEN 9 AND 10
GROUP BY HV.MAHV, HO, TEN 
ORDER BY SODIEM DESC 
) A
GO

-- 27.Trong từng lớp, tìm học viên (mã học viên, họ tên) có số môn đạt điểm 9, 10 nhiều nhất.
WITH SODIEM_9_10 AS (
SELECT A.MAHV, MALOP, HO, TEN, COUNT(DIEM) AS SODIEM 
FROM KETQUATHI A INNER JOIN HOCVIEN B ON A.MAHV=B.MAHV
WHERE DIEM BETWEEN 9 AND 10
GROUP BY A.MAHV, MALOP, HO, TEN
)
SELECT MALOP, MAHV, HO+' '+TEN AS HOTEN  
FROM SODIEM_9_10 C
WHERE NOT EXISTS (
SELECT 1
FROM SODIEM_9_10 D 
WHERE C.MALOP=D.MALOP AND C.SODIEM<D.SODIEM
)
GO 

-- 28.Trong từng học kỳ của từng năm, mỗi giáo viên phân công dạy bao nhiêu môn học, bao nhiêu lớp.
SELECT NAM, HOCKY, MAGV, COUNT(DISTINCT MAMH) AS SOMONHOC, COUNT(DISTINCT MALOP) AS SOLOP
FROM GIANGDAY 
GROUP BY NAM, HOCKY, MAGV
GO

-- 29.Trong từng học kỳ của từng năm, tìm giáo viên (mã giáo viên, họ tên) giảng dạy nhiều nhất.
WITH SOLOP AS (
SELECT NAM, HOCKY, MAGV, COUNT(*) AS SOLOPGD 
FROM GIANGDAY 
GROUP BY NAM, HOCKY, MAGV 
)
SELECT NAM, HOCKY, A.MAGV, HOTEN
FROM SOLOP A INNER JOIN GIAOVIEN ON A.MAGV=GIAOVIEN.MAGV 
WHERE NOT EXISTS (
SELECT 1
FROM SOLOP B
WHERE A.NAM=B.NAM AND A.HOCKY=B.HOCKY AND A.SOLOPGD<B.SOLOPGD)
GO

-- 30.Tìm môn học (mã môn học, tên môn học) có nhiều học viên thi không đạt (ở lần thi thứ 1) nhất.
WITH MHKDAT AS(
SELECT MAMH, COUNT(MAHV) AS SOMH 
FROM KETQUATHI 
WHERE LANTHI=1 AND KQUA='Khong Dat' 
GROUP BY MAMH 
)
SELECT TOP 1 WITH TIES A.MAMH, TENMH 
FROM MHKDAT A INNER JOIN MONHOC B ON A.MAMH=B.MAMH 
ORDER BY SOMH ASC
GO

-- 31.Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi thứ 1).
SELECT DISTINCT A.MAHV, HO+' '+TEN AS HOTEN 
FROM KETQUATHI A INNER JOIN HOCVIEN B ON A.MAHV=B.MAHV 
WHERE NOT EXISTS(
SELECT 1 
FROM KETQUATHI C 
WHERE A.MAHV=C.MAHV AND LANTHI=1 AND KQUA='Khong Dat'
)
GO

-- 32.* Tìm học viên (mã học viên, họ tên) thi môn nào cũng đạt (chỉ xét lần thi sau cùng).
(SELECT DISTINCT A.MAHV, HO+' '+TEN AS HOTEN 
FROM KETQUATHI A INNER JOIN HOCVIEN B ON A.MAHV=B.MAHV
)
EXCEPT 
(SELECT C.MAHV,  HO+' '+TEN AS HOTEN 
FROM KETQUATHI C INNER JOIN HOCVIEN D ON C.MAHV=D.MAHV
WHERE C.KQUA='Khong Dat' AND NOT EXISTS( 
SELECT 1 
FROM KETQUATHI E 
WHERE C.MAMH=E.MAMH AND C.MAHV=E.MAHV AND C.LANTHI<E.LANTHI
)
)
GO

-- 33.* Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi thứ 1).
SELECT MAHV, HO+' '+TEN AS HOTEN 
FROM HOCVIEN HV
WHERE NOT EXISTS(
SELECT * 
FROM KETQUATHI MH
WHERE NOT EXISTS(
SELECT *
FROM KETQUATHI KQ
WHERE KQ.MAHV=HV.MAHV AND KQ.MAMH=MH.MAMH AND LANTHI=1 AND KQUA='Dat'
)
)
GO

-- 34.* Tìm học viên (mã học viên, họ tên) đã thi tất cả các môn và đều đạt (chỉ xét lần thi sau cùng).
SELECT MAHV, HO+' '+TEN AS HOTEN 
FROM HOCVIEN HV
WHERE NOT EXISTS(
SELECT * 
FROM KETQUATHI MH
WHERE NOT EXISTS(
SELECT *
FROM KETQUATHI KQ
WHERE KQ.MAHV=HV.MAHV AND KQ.MAMH=MH.MAMH AND KQUA='Dat' AND NOT EXISTS(
SELECT * FROM KETQUATHI LT WHERE KQ.MAHV=LT.MAHV AND KQ.MAMH=LT.MAMH AND KQ.LANTHI<LT.LANTHI)
)
)
GO

-- 35.** Tìm học viên (mã học viên, họ tên) có điểm thi cao nhất trong từng môn (lấy điểm ở lần thi sau cùng).
SELECT MAMH, A.MAHV, HO+' '+TEN AS HOTEN
FROM KETQUATHI A INNER JOIN HOCVIEN B ON A.MAHV=B.MAHV 
WHERE DIEM>=ALL(
SELECT DIEM 
FROM KETQUATHI C 
WHERE A.MAMH=C.MAMH)
ORDER BY MAMH ASC
GO

