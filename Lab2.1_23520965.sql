﻿-- Bài tập 1:
-- Sinh viên tiến hành viết câu lệnh nhập dữ liệu cho CSDL QuanLyBanHang
-- (Phần II, câu 1 bài tập thực hành trang 4).

GO
INSERT INTO NHANVIEN (MANV, HOTEN, SODT, NGVL) VALUES
('NV01', 'Nguyen Nhu NHut', 092735678, '2006-4-13'),
('NV02', 'Le Thi Phi Yen', 0987567390, '2006-4-21'),
('NV03', 'Nguyen Van B', 0997047382, '2006-4-27'),
('NV04', 'Ngo Thanh Tuan', 0913758498, '2006-6-24');
GO

INSERT INTO KHACHHANG (MAKH, HOTEN, DCHI, SODT, NGSINH, DOANHSO, NGDK) VALUES
('KH01', 'Nguyen Van A', '731 Tran Hung Dao, Q5, TpHCM', 08823451, '1960-10-22', 13060000, '2006-07-22'),
('KH02', 'Tran Ngoc Han' ,'23/5 Nguyen Trai, Q5, TpHCM', 0908256478 , '1974-4-3', 280000, '2006-07-30'),
('KH03', 'Tran Ngoc Linh', '45 Nguyen Canh Chan, Q1, TpHCM', 0938776266, '1980-6-12', 3860000, '2006-08-05'),
('KH04', 'Tran Minh Long', '50/34 Le Dai Hanh, Q10, TpHCM', 0917325476, '1965-3-9', 250000, '2006-10-02'),
('KH05', 'Le Nhat Minh', '34 Truong Dinh, Q3, TpHCM', 08246108, '1950-3-10', 21000, '2006-10-28'),
('KH06', 'Le Hoai Thuong', '227 Nguyen Van Cu, Q5, TpHCM', 08631738, '1981-12-31', 915000, '2006-11-24'),
('KH07', 'Nguyen Van Tam', '32/3 Tran Binh Trong, Q5, TpHCM', 0916783565, '1971-4-6', 12500, '2006-12-01'),
('KH08', 'Phan Thi Thanh', '45/2 An Duong Vuong, Q5, TpHCM', 0938435756, '1971-1-10', 365000, '2006-12-13'),
('KH09', 'Le Ha Vinh', '873 Le Hong Phong, Q5, TpHCM', 08654763, '1979-9-3', 70000, '2007-01-14'),
('KH10', 'Ha Duy Lap', '34/34B Nguyen Trai, Q1, TpHCM', 08768904, '1983-5-2', 67500, '2007-01-16');
GO
INSERT INTO SANPHAM (MASP, TENSP, DVT, NUOCSX, GIA) VALUES 
('BC01', 'But chi', 'cay', 'Singapore', 3000),
('BC02', 'But chi', 'cay', 'Singapore', 5000),
('BC03', 'But chi', 'cay', 'Viet Nam', 3500),
('BC04', 'But chi', 'hop', 'Viet Nam', 30000),
('BB01', 'But bi', 'cay', 'Viet Nam', 5000),
('BB02', 'But bi', 'cay', 'Trung Quoc', 7000),
('BB03', 'But bi', 'hop', 'Thai Lan', 100000),
('TV01', 'Tap 100 giay mong', 'quyen', 'Trung Quoc', 2500),
('TV02', 'Tap 200 giay mong', 'quyen', 'Trung Quoc', 4500),
('TV03', 'Tap 100 giay tot', 'quyen', 'Viet Nam', 3000),
('TV04', 'Tap 200 giay tot', 'quyen', 'Viet Nam', 5500),
('TV05', 'Tap 100 trang', 'chuc', 'Viet Nam', 23000),
('TV06', 'Tap 200 trang', 'chuc', 'Viet Nam', 53000),
('TV07', 'Tap 100 trang', 'chuc', 'Trung Quoc', 34000),
('ST01', 'So tay 500 trang', 'quyen', 'Trung Quoc', 40000),
('ST02', 'So tay loai 1', 'quyen', 'Viet Nam', 55000),
('ST03', 'So tay loai 2', 'quyen', 'Viet Nam', 51000),
('ST04', 'So tay', 'quyen', 'Thai Lan', 55000),
('ST05', 'So tay mong', 'quyen', 'Thai Lan', 20000),
('ST06', 'Phan viet bang', 'hop', 'Viet Nam', 5000),
('ST07', 'Phan khong bui', 'hop', 'Viet Nam', 7000),
('ST08', 'Bong bang', 'cai', 'Viet Nam', 1000),
('ST09', 'But long', 'cay', 'Viet Nam', 5000),
('ST10', 'But long', 'cay', 'Trung Quoc', 7000);
GO

INSERT INTO HOADON (SOHD, NGHD, MAKH, MANV, TRIGIA) VALUES
(1001, '2006-07-23', 'KH01', 'NV01', 320000), 
(1002, '2006-08-12', 'KH01', 'NV02', 840000), 
(1003, '2006-08-23', 'KH02', 'NV01', 100000),
(1004, '2006-09-01', 'KH02', 'NV01', 180000),
(1005, '2006-10-20', 'KH01', 'NV02', 3800000),
(1006, '2006-10-16', 'KH01', 'NV03', 2430000),
(1007, '2006-10-28', 'KH03', 'NV03', 510000),
(1008, '2006-10-28', 'KH01', 'NV03', 440000),
(1009, '2006-10-28', 'KH03', 'NV04', 200000),
(1010, '2006-11-01', 'KH01', 'NV01', 5200000),
(1011, '2006-11-04', 'KH04', 'NV03', 250000),
(1012, '2006-11-30', 'KH05', 'NV03', 21000),
(1013, '2006-12-12', 'KH06', 'NV01', 5000),
(1014, '2006-12-31', 'KH03', 'NV02', 3150000),
(1015, '2007-01-01', 'KH06', 'NV01', 910000),
(1016, '2007-01-01', 'KH07', 'NV02', 12500),
(1017, '2007-01-02', 'KH08', 'NV03', 35000),
(1018, '2007-01-13', 'KH08', 'NV03', 330000),
(1019, '2007-01-13', 'KH01', 'NV03', 30000),
(1020, '2007-01-14', 'KH09', 'NV04', 70000),
(1021, '2007-01-16', 'KH10', 'NV03', 67500),
(1022, '2007-01-16', Null, 'NV03', 7000), 
(1023, '2007-01-17', Null, 'NV01', 330000);

GO

INSERT INTO CTHD (SOHD, MASP, SL) VALUES
(1001, 'TV02', 10),
(1001, 'ST01', 5),
(1001, 'BC01', 5),
(1001, 'BC02', 10),
(1001, 'ST08', 10),
(1002, 'BC04', 20),
(1002, 'BB01', 20),
(1002, 'BB02', 20),
(1003, 'BB03', 10),
(1004, 'TV01', 20),
(1004, 'TV02', 10),
(1004, 'TV03', 10),
(1004, 'TV04', 10),
(1005, 'TV05', 50),
(1005, 'TV06', 50),
(1006, 'TV07', 20),
(1006, 'ST01', 30),
(1006, 'ST02', 10),
(1007, 'ST03', 10),
(1008, 'ST04', 8),
(1009, 'ST05', 10),
(1010, 'TV07', 50),
(1010, 'ST07', 50),
(1010, 'ST08', 100),
(1010, 'ST04', 50),
(1010, 'TV03', 100),
(1011, 'ST06', 50),
(1012, 'ST07', 3),
(1013, 'ST08', 5),
(1014, 'BC02', 80),
(1014, 'BB02', 100),
(1014, 'BC04', 60),
(1014, 'BB01', 50),
(1015, 'BB02', 30),
(1015, 'BB03', 7),
(1016, 'TV01', 5),
(1017, 'TV02', 1),
(1017, 'TV03', 1),
(1017, 'TV04', 5),
(1018, 'ST04', 6),
(1019, 'ST05', 1),
(1019, 'ST06', 2),
(1020, 'ST07', 10),
(1021, 'ST08', 5),
(1021, 'TV01', 7),
(1021, 'TV02', 10),
(1022, 'ST07', 1),
(1023, 'ST04', 6);
GO

-------------------------------------------------------------------------------------------------------------------------------

-- Câu 2:
-- Sinh viên tiến hành viết câu lệnh nhập dữ liệu cho CSDL QuanLyGiaoVu.
GO
INSERT INTO KHOA (MAKHOA, TENKHOA, NGTLAP, TRGKHOA) VALUES
('KHMT', 'Khoa hoc may tinh', '2005-6-7', 'GV01'),
('HTTT', 'He thong thong tin', '2005-6-7', 'GV02'),
('CNPM', 'Cong nghe phan mem', '2005-6-7', 'GV04'),
('MTT', 'Mang va truyen thong', '2005-10-20', 'GV03'),
('KTMT', 'Ky thuat may tinh', '2005-12-20', Null);
GO

INSERT INTO LOP (MALOP, TENLOP, TRGLOP, SISO, MAGVCN) VALUES
('K11', 'Lop 1 khoa 1', 'K1108', 11, 'GV07'),
('K12', 'Lop 2 khoa 1', 'K1205', 12, 'GV09'),
('K13', 'Lop 3 khoa 1', 'K1305', 12, 'GV14');
GO

INSERT INTO MONHOC (MAMH, TENMH, TCLT, TCTH, MAKHOA) VALUES
('THDC', 'Tin hoc dai cuong', 4, 1, 'KHMT'),
('CTRR', 'Cau truc roi rac', 5, 2, 'KHMT'),
('CSDL', 'Co so du lieu', 3, 1, 'HTTT'),
('CTDLGT', 'Cau truc du lieu va giai thuat', 3, 1, 'KHMT'),
('PTTKTT', 'Phan tich thiet ke thuat toan', 3, 0, 'KHMT'),
('DHMT', 'Do hoa may tinh', 3, 1, 'KHMT'),
('KTMT', 'Kien truc may tinh', 3, 0, 'KTMT'),
('TKCSDL', 'Thiet ke co so du lieu', 3, 1, 'HTTT'),
('PTTKHTTT', 'Phan tich thiet ke he thong thong tin', 4, 1, 'HTTT'),
('HDH', 'He dieu hanh', 4, 1, 'KTMT'),
('NMCNPM', 'Nhap mon cong nghe phan mem', 3, 0, 'CNPM'),
('LTCFW', 'Lap trinh C for win', 3, 1, 'CNPM'),
('LTHDT', 'Lap trinh huong doi tuong', 3, 1, 'CNPM');
GO

INSERT INTO GIANGDAY (MALOP, MAMH, MAGV, HOCKY, NAM, TUNGAY, DENNGAY) VALUES
('K11', 'THDC', 'GV07', 1, 2006, '2006-1-2', '2006-5-12'),
('K12', 'THDC', 'GV06', 1, 2006, '2006-1-2', '2006-5-12'),
('K13', 'THDC', 'GV15', 1, 2006, '2006-1-2', '2006-5-12'),
('K11', 'CTRR', 'GV02', 1, 2006, '2006-1-9', '2006-5-17'),
('K12', 'CTRR', 'GV02', 1, 2006, '2006-1-9', '2006-5-17'),
('K13', 'CTRR', 'GV08', 1, 2006, '2006-1-9', '2006-5-17'),
('K11', 'CSDL', 'GV05', 2, 2006, '2006-6-1', '2006-7-15'),
('K12', 'CSDL', 'GV09', 2, 2006, '2006-6-1', '2006-7-15'),
('K13', 'CTDLGT', 'GV15', 2, 2006, '2006-6-1', '2006-7-15'),
('K13', 'CSDL', 'GV05', 3, 2006, '2006-8-1', '2006-12-15'),
('K13', 'DHMT', 'GV07', 3, 2006, '2006-8-1', '2006-12-15'),
('K11', 'CTDLGT', 'GV15', 3, 2006, '2006-8-1', '2006-12-15'),
('K12', 'CTDLGT', 'GV15', 3, 2006, '2006-8-1', '2006-12-15'),
('K11', 'HDH', 'GV04', 1, 2007, '2007-1-2', '2007-2-18'),
('K12', 'HDH', 'GV04', 1, 2007, '2007-1-2', '2007-3-20'),
('K11', 'DHMT', 'GV07', 1, 2007, '2007-2-18', '2007-3-20');
GO

INSERT INTO GIAOVIEN (MAGV, HOTEN, HOCVI, HOCHAM, GIOITINH,	NGSINH, NGVL, HESO, MUCLUONG, MAKHOA) VALUES
('GV01', 'Ho Thanh Son', 'PTS', 'GS', 'Nam', '1950-5-2', '2004-1-11', 5.00, 2250000, 'KHMT'), 
('GV02', 'Tran Tam Thanh', 'TS', 'PGS', 'Nam', '1965-12-17', '2004-4-20', 4.50, 2025000, 'HTTT'), 
('GV03', 'Do Nghiem Phung', 'TS', 'GS', 'Nu', '1950-8-1', '2004-9-23', 4.00, 1800000, 'CNPM'), 
('GV04', 'Tran Nam Son', 'TS', 'PGS', 'Nam', '1961-2-22', '2005-1-12', 4.50, 2025000, 'KTMT'), 
('GV05', 'Mai Thanh Danh', 'ThS', 'GV', 'Nam', 	'1958-3-12', '2005-1-12', 3.00, 1350000, 'HTTT'), 
('GV06', 'Tran Doan Hung', 'TS', 'GV', 'Nam', '1953-3-11', '2005-1-12', 4.50, 2025000, 'KHMT'), 
('GV07', 'Nguyen Minh Tien', 'ThS',	'GV', 'Nam', '1971-11-23', 	'2005-3-1', 4.00, 1800000, 'KHMT'), 
('GV08', 'Le Thi Tran', 'KS', Null, 'Nu', '1974-3-26', '2005-3-1', 1.69, 760500, 'KHMT'), 
('GV09', 'Nguyen To Lan', 'ThS', 'GV', 'Nu', '1966-12-31', '2005-3-1', 4.00, 1800000, 'HTTT'), 
('GV10', 'Le Tran Anh Loan', 'KS', Null, 'Nu', '1972-7-7', 	'2005-3-1', 1.86, 837000, 'CNPM'), 
('GV11', 'Ho Thanh Tung', 'CN', 'GV', 'Nam', '1980-1-12', '2005-5-15', 2.67, 1201500, 'MTT'), 
('GV12', 'Tran Van Anh', 'CN', Null, 'Nu', '1981-3-29', '2005-5-15', 1.69, 760500, 'CNPM'), 
('GV13', 'Nguyen Linh Dan', 'CN', Null, 'Nu', '1980-5-23', '2005-5-15', 1.69, 760500, 'KTMT'), 
('GV14', 'Truong Minh Chau', 'ThS', 'GV', 'Nu', '1976-11-30', '2005-5-15', 3.00, 1350000, 'MTT'), 
('GV15', 'Le Ha Thanh', 'ThS', 'GV', 'Nam', '1978-5-4', '2005-5-15', 3.00, 1350000, 'KHMT');
GO

INSERT INTO DIEUKIEN (MAMH,	MAMH_TRUOC) VALUES 
('CSDL', 'CTRR'), 
('CSDL', 'CTDLGT'), 
('CTDLGT', 'THDC'),
('PTTKTT', 'THDC'), 
('PTTKTT', 'CTDLGT'), 
('DHMT', 'THDC'), 
('LTHDT', 'THDC'), 
('PTTKHTTT', 'CSDL'); 
GO

INSERT INTO KETQUATHI (MAHV, MAMH, LANTHI, NGTHI, DIEM, KQUA) VALUES 
('K1101', 'CSDL', 1, '2006-7-20', 10.00, 'Dat'), 
('K1101', 'CTDLGT',	1, '2006-12-28', 9.00, 'Dat'), 
('K1101', 'THDC', 1, '2006-5-20', 9.00, 'Dat'), 
('K1101', 'CTRR', 1, '2006-5-13', 9.50, 'Dat'), 
('K1102', 'CSDL', 1, '2006-7-20', 4.00, 'Khong Dat'), 
('K1102', 'CSDL', 2, '2006-7-27', 4.25, 'Khong Dat'), 
('K1102', 'CSDL', 3, '2006-8-10', 4.50, 'Khong Dat'), 
('K1102', 'CTDLGT', 1, '2006-12-28', 4.50, 'Khong Dat'), 
('K1102', 'CTDLGT', 2, '2007-1-5', 4.00, 'Khong Dat'), 
('K1102', 'CTDLGT', 3, '2007-1-15', 6.00, 'Dat'), 
('K1102', 'THDC', 1, '2006-5-20', 5.00, 'Dat'), 
('K1102', 'CTRR', 1, '2006-5-13', 7.00, 'Dat'), 
('K1103', 'CSDL', 1, '2006-7-20', 3.50, 'Khong Dat'), 
('K1103', 'CSDL', 2, '2006-7-27', 8.25, 'Dat'), 
('K1103', 'CTDLGT', 1, '2006-12-28', 7.00, 'Dat'), 
('K1103', 'THDC', 1, '2006-5-20', 8.00, 'Dat'), 
('K1103', 'CTRR', 1, '2006-5-13', 6.50, 'Dat'), 
('K1104', 'CSDL', 1, '2006-7-20', 3.75,	'Khong Dat'), 
('K1104', 'CTDLGT', 1, '2006-12-28', 4.00, 'Khong Dat'), 
('K1104', 'THDC', 1, '2006-5-20', 4.00, 'Khong Dat'), 
('K1104', 'CTRR', 1, '2006-5-13', 4.00, 'Khong Dat'), 
('K1104', 'CTRR', 2,'2006-5-20', 3.50, 'Khong Dat'), 
('K1104', 'CTRR', 3, '2006-6-30', 4.00, 'Khong Dat'), 
('K1201', 'CSDL', 1, '2006-7-20', 6.00, 'Dat'), 
('K1201', 'CTDLGT', 1, '2006-12-28', 5.00, 'Dat'), 
('K1201', 'THDC', 1, '2006-5-20', 8.50, 'Dat'), 
('K1201','CTRR', 1, '2006-5-13', 9.00, 'Dat'), 
('K1202', 'CSDL', 1, '2006-7-20', 8.00, 'Dat'), 
('K1202', 'CTDLGT', 1, '2006-12-28', 4.00, 'Khong Dat'), 
('K1202', 'CTDLGT', 2, '2007-1-5', 5.00, 'Dat'), 
('K1202', 'THDC', 1, '2006-5-20', 4.00, 'Khong Dat'), 
('K1202', 'THDC', 2, '2006-5-27', 4.00, 'Khong Dat'), 
('K1202', 'CTRR', 1, '2006-5-13', 3.00,	'Khong Dat'), 
('K1202', 'CTRR', 2, '2006-5-20', 4.00, 'Khong Dat'), 
('K1202', 'CTRR', 3, '2006-6-30', 6.25, 'Dat'), 
('K1203', 'CSDL', 1, '2006-7-20', 9.25, 'Dat'), 
('K1203', 'CTDLGT', 1, '2006-12-28', 9.50, 'Dat'), 
('K1203', 'THDC', 1, '2006-5-20', 10.00, 'Dat'), 
('K1203', 'CTRR', 1, '2006-5-13', 10.00, 'Dat'), 
('K1204', 'CSDL', 1, '2006-7-20', 8.50, 'Dat'), 
('K1204', 'CTDLGT', 1, '2006-12-28', 6.75, 'Dat'), 
('K1204', 'THDC', 1, '2006-5-20', 4.00, 'Khong Dat'), 
('K1204', 'CTRR', 1, '2006-5-13', 6.00, 'Dat'), 
('K1301', 'CSDL', 1, '2006-12-20', 4.25, 'Khong Dat'), 
('K1301', 'CTDLGT', 1, '2006-7-25', 8.00, 'Dat'), 
('K1301', 'THDC', 1, '2006-5-20', 7.75, 'Dat'), 
('K1301', 'CTRR', 1, '2006-5-13', 8.00, 'Dat'), 
('K1302', 'CSDL', 1, '2006-12-20', 6.75, 'Dat'), 
('K1302', 'CTDLGT', 1, '2006-7-25', 5.00, 'Dat'), 
('K1302', 'THDC', 1, '2006-5-20', 8.00, 'Dat'), 
('K1302', 'CTRR', 1, '2006-5-13', 8.50, 'Dat'), 
('K1303', 'CSDL', 1, '2006-12-20', 4.00, 'Khong Dat'), 
('K1303', 'CTDLGT',	1, '2006-7-25', 4.50, 'Khong Dat'), 
('K1303', 'CTDLGT', 2, '2006-8-7', 4.00, 'Khong Dat'), 
('K1303', 'CTDLGT', 3, '2006-8-15', 4.25, 'Khong Dat'), 
('K1303', 'THDC', 1, '2006-5-20', 4.50, 'Khong Dat'), 
('K1303', 'CTRR', 1, '2006-5-13', 3.25, 'Khong Dat'), 
('K1303', 'CTRR', 2, '2006-5-20', 5.00, 'Dat'), 
('K1304', 'CSDL', 1, '2006-12-20', 7.75, 'Dat'), 
('K1304', 'CTDLGT', 1, '2006-7-25', 9.75, 'Dat'), 
('K1304', 'THDC', 1, '2006-5-20', 5.50, 'Dat'), 
('K1304', 'CTRR', 1, '2006-5-13', 5.00, 'Dat'), 
('K1305', 'CSDL', 1, '2006-12-20', 9.25, 'Dat'), 
('K1305', 'CTDLGT', 1, '2006-7-25', 10.00, 'Dat'), 
('K1305', 'THDC', 1, '2006-5-20', 8.00, 'Dat'), 
('K1305', 'CTRR', 1, '2006-5-13', 10.00, 'Dat'); 
GO

INSERT INTO HOCVIEN (MAHV, HO, TEN, NGSINH, GIOITINH, NOISINH, MALOP) VALUES 
('K1101', 'Nguyen Van', 'A', '1986-1-27', 'Nam', 'TpHCM', 'K11'), 
('K1102', 'Tran Ngoc', 'Han', '1986-3-14', 'Nu', 'Kien Giang', 'K11'), 
('K1103', 'Ha Duy', 'Lap', '1986-4-18', 'Nam', 'Nghe An', 'K11'), 
('K1104', 'Tran Ngoc', 'Linh', '1986-3-30', 'Nu', 'Tay Ninh', 'K11'), 
('K1105', 'Tran Minh', 'Long',	'1986-2-27', 'Nam',	'TpHCM', 'K11'), 
('K1106', 'Le Nhat', 'Minh', '1986-1-24', 'Nam', 'TpHCM', 'K11'), 
('K1107', 'Nguyen Nhu', 'Nhut', '1986-1-27', 'Nam', 'Ha Noi', 'K11'), 
('K1108', 'Nguyen Manh', 'Tam', '1986-2-27', 'Nam', 'Kien Giang', 'K11'), 
('K1109', 'Phan Thi Thanh', 'Tam', '1986-1-27', 'Nu', 'Vinh Long', 'K11'), 
('K1110', 'Le Hoai', 'Thuong', '1986-2-5', 'Nu', 'Can Tho', 'K11'), 
('K1111', 'Le Ha', 'Vinh', '1986-12-25', 'Nam', 'Vinh Long', 'K11'), 
('K1201', 'Nguyen Van', 'B', '1986-2-11', 'Nam', 'TpHCM', 'K12'), 
('K1202', 'Nguyen Thi Kim', 'Duyen', '1986-1-18', 'Nu', 'TpHCM', 'K12'), 
('K1203', 'Tran Thi Kim', 'Duyen', '1986-9-17', 'Nu', 'TpHCM', 'K12'), 
('K1204', 'Truong My', 'Hanh', '1986-5-19', 'Nu', 'Dong Nai', 'K12'), 
('K1205', 'Nguyen Thanh', 'Nam', '1986-4-17', 'Nam', 'TpHCM', 'K12'), 
('K1206', 'Nguyen Thi Truc', 'Thanh', '1986-3-4', 'Nu', 'Kien Giang', 'K12'),
('K1207', 'Tran Thi Bich', 'Thuy', '1986-2-8', 'Nu', 'Nghe An', 'K12'), 
('K1208', 'Huynh Thi Kim', 'Trieu', '1986-4-8', 'Nu', 'Tay Ninh', 'K12'), 
('K1209', 'Pham Thanh', 'Trieu', '1986-2-23', 'Nam', 'TpHCM', 'K12'), 
('K1210', 'Ngo Thanh', 'Tuan', '1986-2-14', 'Nam', 'TpHCM', 'K12'), 
('K1211', 'Do Thi', 'Xuan', '1986-3-9', 'Nu', 'Ha Noi', 'K12'), 
('K1212', 'Le Thi Phi', 'Yen', '1986-3-12', 'Nu', 'TpHCM', 'K12'), 
('K1301', 'Nguyen Thi Kim', 'Cuc', '1986-6-9', 'Nu', 'Kien Giang', 'K13'), 
('K1302', 'Truong Thi My', 'Hien', '1986-3-18', 'Nu', 'Nghe An', 'K13'), 
('K1303', 'Le Duc', 'Hien', '1986-3-1', 'Nam', 'Tay Ninh', 'K13'), 
('K1304', 'Le Quang', 'Hien', '1986-4-18', 'Nam', 'TpHCM', 'K13'), 
('K1305', 'Le Thi', 'Huong', '1986-3-27', 'Nu', 'TpHCM', 'K13'), 
('K1306', 'Nguyen Thai', 'Huu', '1986-3-30', 'Nam', 'Ha Noi', 'K13'), 
('K1307', 'Tran Minh', 'Man', '1986-5-28', 'Nam', 'TpHCM', 'K13'), 
('K1308', 'Nguyen Hieu', 'Nghia', '1986-4-8', 'Nam', 'Kien Giang', 'K13'), 
('K1309', 'Nguyen Trung', 'Nghia', '1987-1-18', 'Nam', 'Nghe An', 'K13'), 
('K1310', 'Tran Thi Hong', 'Tham',  '1986-4-22', 'Nu', 'Tay Ninh', 'K13'), 
('K1311', 'Tran Minh', 'Thuc', '1986-4-4', 'Nam', 'TpHCM', 'K13'), 
('K1312', 'Nguyen Thi Kim', 'Yen', '1986-9-7', 'Nu', 'TpHCM', 'K13'); 
GO

---------------------------------------------------------------------------------------------------------------------------------------

-- Câu 3: 
-- 2.Tạo quan hệ SANPHAM1 chứa toàn bộ dữ liệu của quan hệ SANPHAM. 
SELECT * INTO SANPHAM1 FROM SANPHAM;
GO

-- Tạo quan hệ KHACHHANG1 chứa toàn bộ dữ liệu của quan hệ KHACHHANG.
SELECT * INTO KHACHHANG1 FROM KHACHHANG;
GO

-- 3.Cập nhật giá tăng 5% đối với những sản phẩm do “Thai Lan” sản xuất (cho quan hệ SANPHAM1)
UPDATE SANPHAM1
SET GIA=GIA*1.05
WHERE NUOCSX='Thai Lan';
GO

-- 4. Cập nhật giá giảm 5% đối với những sản phẩm do “Trung Quoc” sản xuất có giá từ 10.000 trở xuống (cho quan hệ SANPHAM1).
UPDATE SANPHAM1
SET GIA=GIA*0.95
WHERE NUOCSX='Trung Quoc' AND GIA<=10000;
GO

-- 5.Cập nhật giá trị LOAIKH là “Vip” đối với những khách hàng đăng ký thành viên trước ngày 1/1/2007 có doanh số từ 10.000.000 trở lên 
-- hoặc khách hàng đăng ký thành viên từ 1/1/2007 trở về sau có doanh số từ 2.000.000 trở lên (cho quan hệ KHACHHANG1).
 UPDATE KHACHHANG1
 SET LOAIKH='Vip'
 WHERE (NGDK<'2007-1-1' AND DOANHSO>10000000) OR (NGDK>'2007-1-1' AND DOANHSO>20000000);
 GO
 
 ---------------------------------------------------------------------------------------------------------------------------------

 -- Câu 4:
-- 11.Học viên ít nhất là 18 tuổi.
ALTER TABLE HOCVIEN ADD CONSTRAINT CK_TUOI CHECK(GETDATE()-NGSINH>=18);
GO 

-- 12.Giảng dạy một môn học ngày bắt đầu (TUNGAY) phải nhỏ hơn ngày kết thúc (DENNGAY).
ALTER TABLE GIANGDAY ADD CONSTRAINT CK_NGAY CHECK(DENNGAY>TUNGAY);
GO

-- 13.Giáo viên khi vào làm ít nhất là 22 tuổi.
ALTER TABLE GIAOVIEN ADD CONSTRAINT CK_NGVL CHECK(NGVL-NGSINH>=22);
GO

-- 14.Tất cả các môn học đều có số tín chỉ lý thuyết và tín chỉ thực hành chênh lệch nhau không quá 3.
ALTER TABLE MONHOC ADD CONSTRAINT CK_LTTH CHECK(ABS(TCLT-TCTH)<=3);
GO

 ---------------------------------------------------------------------------------------------------------------------------------

-- Câu 5:
-- 1.In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất.
SELECT MASP,TENSP 
FROM SANPHAM 
WHERE NUOCSX='Trung Quoc';
GO

-- 2.In ra danh sách các sản phẩm (MASP, TENSP) có đơn vị tính là “cay”, ”quyen”.
SELECT MASP,TENSP 
FROM SANPHAM
WHERE DVT IN ('cay', 'quyen');
GO

-- 3.In ra danh sách các sản phẩm (MASP,TENSP) có mã sản phẩm bắt đầu là “B” và kết thúc là “01”.
SELECT MASP, TENSP 
FROM SANPHAM
WHERE MASP LIKE 'B%01';
GO

-- 4.In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quốc” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP,TENSP
FROM SANPHAM
WHERE NUOCSX='Trung Quoc' AND GIA BETWEEN 30000 AND 40000;
GO

-- 5.In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” hoặc “Thai Lan” sản xuất có giá từ 30.000 đến 40.000.
SELECT MASP, TENSP 
FROM SANPHAM 
WHERE (NUOCSX='Trung Quoc' OR NUOCSX='Thai Lan') AND (GIA BETWEEN 30000 AND 40000);
GO

-- 6.In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 1/1/2007 và ngày 2/1/2007.
SELECT SOHD, TRIGIA
FROM HOADON
WHERE NGHD BETWEEN '2007-1-1' AND '2007-1-2';
GO

-- 7.In ra các số hóa đơn, trị giá hóa đơn trong tháng 1/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần).
SELECT SOHD, TRIGIA 
FROM HOADON 
WHERE NGHD BETWEEN '2007-1-1' AND '2007-1-31'
ORDER BY NGHD ASC, TRIGIA DESC;
GO

-- 8.In ra danh sách các khách hàng (MAKH, HOTEN) đã mua hàng trong ngày 1/1/2007.
SELECT HOADON.MAKH, KHACHHANG.HOTEN
FROM HOADON, KHACHHANG
WHERE HOADON.MAKH=KHACHHANG.MAKH AND NGHD='2007-1-1';
GO

-- 9.In ra số hóa đơn, trị giá các hóa đơn do nhân viên có tên “Nguyen Van B” lập trong ngày 28/10/2006.
SELECT SOHD, TRIGIA 
FROM HOADON, NHANVIEN 
WHERE HOADON.MANV=NHANVIEN.MANV AND NGHD='2006-10-28' AND NHANVIEN.HOTEN='Nguyen Van B';
GO

-- 10.In ra danh sách các sản phẩm (MASP,TENSP) được khách hàng có tên “Nguyen Van A” mua trong tháng 10/2006.
SELECT CTHD.MASP, SANPHAM.TENSP 
FROM CTHD INNER JOIN SANPHAM 
ON CTHD.MASP = SANPHAM.MASP
WHERE SOHD IN 
(
	SELECT SOHD 
	FROM HOADON INNER JOIN KHACHHANG
	ON HOADON.MAKH = KHACHHANG.MAKH
	WHERE HOTEN = 'Nguyen Van A' AND (NGHD BETWEEN '2006-10-1' AND '2006-10-31') 
)
GO

-- 11.Tìm các số hóa đơn đã mua sản phẩm có mã số “BB01” hoặc “BB02”.
SELECT SOHD
FROM CTHD
WHERE MASP='BB01'
UNION 
SELECT SOHD
FROM CTHD
WHERE MASP='BB02'
GO

------------------------------------------------------------------------------------------------------------------

-- Câu 6:
-- 1.In ra danh sách (mã học viên, họ tên, ngày sinh, mã lớp) lớp trưởng của các lớp.
SELECT MAHV, HO+' '+TEN AS HOTEN, NGSINH, LOP.MALOP
FROM LOP INNER JOIN HOCVIEN
ON LOP.TRGLOP=HOCVIEN.MAHV;
GO

-- 2.In ra bảng điểm khi thi (mã học viên, họ tên, lần thi, điểm số) môn CTRR của lớp “K12”, sắp xếp theo tên, họ học viên.
SELECT KETQUATHI.MAHV, HO+' '+TEN AS HOTEN, LANTHI, DIEM
FROM HOCVIEN INNER JOIN KETQUATHI
ON HOCVIEN.MAHV=KETQUATHI.MAHV
WHERE MAMH='CTRR' AND KETQUATHI.MAHV LIKE 'K12%'
ORDER BY TEN, HO;
GO

-- 3.In ra danh sách những học viên (mã học viên, họ tên) và những môn học mà học viên đó thi lần thứ nhất đã đạt.
SELECT KETQUATHI.MAHV, HO+' '+TEN AS HOTEN, MAMH
FROM HOCVIEN INNER JOIN KETQUATHI
ON HOCVIEN.MAHV=KETQUATHI.MAHV
WHERE LANTHI=1 AND KQUA='Dat';
GO

-- 4.In ra danh sách học viên (mã học viên, họ tên) của lớp “K11” thi môn CTRR không đạt (ở lần thi 1).
SELECT KETQUATHI.MAHV, HO+' '+TEN AS HOCVIEN
FROM HOCVIEN INNER JOIN KETQUATHI
ON HOCVIEN.MAHV=KETQUATHI.MAHV
WHERE LANTHI=1 AND KETQUATHI.MAHV LIKE 'K11%' AND KETQUATHI.MAMH='CTRR' AND KQUA='Khong Dat';
GO

-- 5.* Danh sách học viên (mã học viên, họ tên) của lớp “K” thi môn CTRR không đạt (ở tất cả các lần thi).
SELECT KETQUATHI.MAHV, HO+' '+TEN AS HOTEN
FROM HOCVIEN INNER JOIN KETQUATHI
ON HOCVIEN.MAHV=KETQUATHI.MAHV
WHERE KETQUATHI.MAHV LIKE 'K%' AND MAMH='CTRR'
GROUP BY KETQUATHI.MAHV, HO, TEN
HAVING MAX(KETQUATHI.DIEM)<5;
GO



