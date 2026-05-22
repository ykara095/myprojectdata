DROP DATABASE IF EXISTS AkilliStokDB;
CREATE DATABASE AkilliStokDB;
USE AkilliStokDB;

CREATE TABLE Kategoriler (
    Kategori_ID INT PRIMARY KEY AUTO_INCREMENT,
    Kategori_Adi VARCHAR(100) NOT NULL,
    Tanim TEXT
);

CREATE TABLE Depolar (
    Depo_ID INT PRIMARY KEY AUTO_INCREMENT,
    Depo_Adi VARCHAR(100) NOT NULL,
    Lokasyon_Adres TEXT,
    Toplam_Kapasite INT
);

CREATE TABLE Tedarikciler (
    Tedarikci_ID INT PRIMARY KEY AUTO_INCREMENT,
    Firma_Adi VARCHAR(150) NOT NULL,
    Iletisim_Bilgileri TEXT
);

CREATE TABLE Personel (
    Personel_ID INT PRIMARY KEY AUTO_INCREMENT,
    Ad VARCHAR(50) NOT NULL,
    Soyad VARCHAR(50) NOT NULL,
    Gorev VARCHAR(100),
    Erisim_Yetkisi VARCHAR(50),
    Depo_ID INT NOT NULL,
    FOREIGN KEY (Depo_ID) REFERENCES Depolar(Depo_ID)
);

CREATE TABLE Urunler (
    Urun_ID INT PRIMARY KEY AUTO_INCREMENT,
    Urun_Adi VARCHAR(150) NOT NULL,
    Barkod VARCHAR(50) UNIQUE,
    Birim_Fiyat DECIMAL(10, 2),
    Kritik_Stok_Seviyesi INT,
    Kategori_ID INT NOT NULL,
    FOREIGN KEY (Kategori_ID) REFERENCES Kategoriler(Kategori_ID)
);

CREATE TABLE Depo_Urun_Stok (
    Depo_ID INT,
    Urun_ID INT,
    Guncel_Stok INT DEFAULT 0, 
    PRIMARY KEY (Depo_ID, Urun_ID),
    FOREIGN KEY (Depo_ID) REFERENCES Depolar(Depo_ID),
    FOREIGN KEY (Urun_ID) REFERENCES Urunler(Urun_ID)
);

CREATE TABLE Tedarikci_Urun (
    Tedarikci_ID INT,
    Urun_ID INT,
    PRIMARY KEY (Tedarikci_ID, Urun_ID),
    FOREIGN KEY (Tedarikci_ID) REFERENCES Tedarikciler(Tedarikci_ID),
    FOREIGN KEY (Urun_ID) REFERENCES Urunler(Urun_ID)
);

CREATE TABLE Stok_Hareketleri (
    Hareket_ID INT PRIMARY KEY AUTO_INCREMENT,
    Islem_Tipi ENUM('Giriş', 'Çıkış') NOT NULL,
    Miktar INT NOT NULL CHECK (Miktar > 0),
    Islem_Tarihi DATETIME DEFAULT CURRENT_TIMESTAMP,
    Urun_ID INT NOT NULL,
    Depo_ID INT NOT NULL,
    Personel_ID INT NOT NULL,
    FOREIGN KEY (Urun_ID) REFERENCES Urunler(Urun_ID),
    FOREIGN KEY (Depo_ID) REFERENCES Depolar(Depo_ID),
    FOREIGN KEY (Personel_ID) REFERENCES Personel(Personel_ID)
);

-- Başlangıç Verileri (Seed Data)

-- 1. Kategoriler
INSERT INTO Kategoriler (Kategori_Adi, Tanim) VALUES 
('Elektronik', 'Bilgisayar, telefon ve akıllı ev aletleri'),
('Gıda', 'Temel gıda, atıştırmalık ve içecek ürünleri'),
('Temizlik', 'Endüstriyel ve ev tipi temizlik malzemeleri'),
('Mobilya', 'Ofis ve çalışma alanı mobilyaları'),
('Kırtasiye', 'Defter, kalem ve sarf malzemeler');

-- 2. Depolar
INSERT INTO Depolar (Depo_Adi, Lokasyon_Adres, Toplam_Kapasite) VALUES 
('Marmara Merkez Depo', 'İstanbul / Tuzla Organize Sanayi', 10000),
('Ege Bölge Deposu', 'İzmir / Kemalpaşa', 5000),
('İç Anadolu Lojistik', 'Ankara / Kahramankazan', 7500),
('Akdeniz Aktarma', 'Antalya / Kepez', 3000);

-- 3. Tedarikçiler
INSERT INTO Tedarikciler (Firma_Adi, Iletisim_Bilgileri) VALUES 
('TeknoDağıtım A.Ş.', 'iletisim@teknodagitim.com - 0212 555 11 22'),
('GıdaBirlik Toptan', 'bilgi@gidabirlik.com - 0232 444 55 66'),
('PakKimya Temizlik Ürünleri', 'satis@pakkimya.com - 0312 777 88 99'),
('OfisLine Mobilya', 'destek@ofisline.com - 0224 999 00 11'),
('KalemTraş Kırtasiye', 'iletisim@kalemtras.com - 0216 333 44 55');

-- 4. Personel
INSERT INTO Personel (Ad, Soyad, Gorev, Erisim_Yetkisi, Depo_ID) VALUES 
('Ahmet', 'Yılmaz', 'Depo Müdürü', 'Admin', 1),
('Ayşe', 'Kaya', 'Stok Görevlisi', 'User', 1),
('Mehmet', 'Demir', 'Lojistik Uzmanı', 'Admin', 2),
('Fatma', 'Şahin', 'Stok Görevlisi', 'User', 3),
('Ali', 'Can', 'Depo Sorumlusu', 'Admin', 4);

-- 5. Ürünler
INSERT INTO Urunler (Urun_Adi, Barkod, Birim_Fiyat, Kritik_Stok_Seviyesi, Kategori_ID) VALUES 
('Laptop 15.6 inç', 'TR-ELK-1001', 25000.00, 10, 1),
('Akıllı Telefon 128GB', 'TR-ELK-1002', 18500.00, 20, 1),
('Baldo Pirinç 5KG', 'TR-GID-2001', 350.00, 100, 2),
('Naturel Sızma Zeytinyağı 5L', 'TR-GID-2002', 1200.00, 50, 2),
('Çamaşır Suyu 4L', 'TR-TMZ-3001', 90.00, 200, 3),
('Sıvı Bulaşık Deterjanı 1L', 'TR-TMZ-3002', 45.00, 150, 3),
('Ergonomik Ofis Sandalyesi', 'TR-MOB-4001', 3200.00, 15, 4),
('Çalışma Masası 120cm', 'TR-MOB-4002', 1800.00, 20, 4),
('A4 Fotokopi Kağıdı 500lü', 'TR-KRT-5001', 120.00, 300, 5);

-- 6. Tedarikçi - Ürün Eşleştirmesi (Hangi ürün hangi tedarikçiden alınır)
INSERT INTO Tedarikci_Urun (Tedarikci_ID, Urun_ID) VALUES 
(1, 1), (1, 2), -- TeknoDağıtım -> Elektronikler
(2, 3), (2, 4), -- GıdaBirlik -> Gıdalar
(3, 5), (3, 6), -- PakKimya -> Temizlik
(4, 7), (4, 8), -- OfisLine -> Mobilya
(5, 9);         -- KalemTraş -> Kağıt

-- 7. Depo Ürün Stok (Mevcut Durum)
INSERT INTO Depo_Urun_Stok (Depo_ID, Urun_ID, Guncel_Stok) VALUES 
(1, 1, 45), (1, 2, 80), (1, 9, 500), -- Merkez Depo Elektronik ve Kağıt
(2, 3, 250), (2, 4, 120),            -- İzmir Depo Gıda
(3, 5, 800), (3, 6, 600),            -- Ankara Depo Temizlik
(4, 7, 40), (4, 8, 35);              -- Antalya Depo Mobilya

-- 8. Stok Hareketleri (Geçmiş Loglar)
INSERT INTO Stok_Hareketleri (Islem_Tipi, Miktar, Islem_Tarihi, Urun_ID, Depo_ID, Personel_ID) VALUES 
('Giriş', 50, '2025-01-10 10:00:00', 1, 1, 1),
('Çıkış', 5, '2025-01-15 14:30:00', 1, 1, 2),
('Giriş', 100, '2025-01-12 09:15:00', 2, 1, 1),
('Çıkış', 20, '2025-01-18 11:00:00', 2, 1, 2),
('Giriş', 300, '2025-02-05 11:45:00', 3, 2, 3),
('Çıkış', 50, '2025-02-10 16:20:00', 3, 2, 3),
('Giriş', 150, '2025-03-01 08:30:00', 4, 2, 3),
('Çıkış', 30, '2025-03-05 09:45:00', 4, 2, 3),
('Giriş', 1000, '2025-03-15 13:00:00', 5, 3, 4),
('Çıkış', 200, '2025-03-20 15:45:00', 5, 3, 4),
('Giriş', 50, '2025-04-10 09:00:00', 7, 4, 5), 
('Çıkış', 10, '2025-04-15 11:30:00', 7, 4, 5),
('Giriş', 600, '2025-05-01 10:00:00', 9, 1, 1),
('Çıkış', 100, '2025-05-05 16:00:00', 9, 1, 2);

-- --- YENİ EKLENEN VERİLER ---

-- Yeni Kategoriler
INSERT INTO Kategoriler (Kategori_Adi, Tanim) VALUES 
('Giyim', 'Tekstil, giyim ve aksesuar ürünleri'),
('Otomotiv', 'Araç bakım ve yedek parça'),
('Spor', 'Spor aletleri ve giyim'),
('Kozmetik', 'Kişisel bakım ve makyaj ürünleri');

-- Yeni Depolar
INSERT INTO Depolar (Depo_Adi, Lokasyon_Adres, Toplam_Kapasite) VALUES 
('Karadeniz Ana Depo', 'Samsun / İlkadım', 4000),
('Doğu Anadolu Deposu', 'Erzurum / Yakutiye', 2500),
('Trakya Lojistik Merkezi', 'Tekirdağ / Çorlu', 6000);

-- Yeni Tedarikçiler
INSERT INTO Tedarikciler (Firma_Adi, Iletisim_Bilgileri) VALUES 
('ModaTekstil A.Ş.', 'satis@modatekstil.com - 0212 111 22 33'),
('OtoParça Dünyası', 'bilgi@otoparca.com - 0216 222 33 44'),
('SporLife Malzemeleri', 'destek@sporlife.com - 0312 333 44 55'),
('Güzellik Kozmetik', 'iletisim@guzellik.com - 0232 444 55 66'),
('Mega Dağıtım Ticaret', 'info@megadagitim.com - 0224 555 66 77');

-- Yeni Personel
INSERT INTO Personel (Ad, Soyad, Gorev, Erisim_Yetkisi, Depo_ID) VALUES 
('Canan', 'Sarı', 'Depo Yöneticisi', 'Admin', 5),
('Burak', 'Koç', 'Stok Görevlisi', 'User', 5),
('Hasan', 'Öz', 'Lojistik Uzmanı', 'Admin', 6),
('Zeynep', 'Çelik', 'Stok Görevlisi', 'User', 6),
('Onur', 'Aydın', 'Depo Şefi', 'Admin', 7);

-- Yeni Ürünler
-- Giyim (Kategori_ID: 6)
INSERT INTO Urunler (Urun_Adi, Barkod, Birim_Fiyat, Kritik_Stok_Seviyesi, Kategori_ID) VALUES 
('Erkek Pamuklu Tişört', 'TR-GYM-6001', 250.00, 50, 6),
('Kadın Spor Tayt', 'TR-GYM-6002', 350.00, 40, 6),
('Kışlık Kaban', 'TR-GYM-6003', 1500.00, 20, 6),
-- Otomotiv (Kategori_ID: 7)
('Motor Yağı 4L', 'TR-OTO-7001', 850.00, 30, 7),
('Oto Cam Suyu 5L', 'TR-OTO-7002', 120.00, 100, 7),
('Silecek Takımı', 'TR-OTO-7003', 200.00, 50, 7),
-- Spor (Kategori_ID: 8)
('Dumbell Seti 20kg', 'TR-SPR-8001', 800.00, 15, 8),
('Yoga Matı', 'TR-SPR-8002', 250.00, 30, 8),
('Basketbol Topu', 'TR-SPR-8003', 450.00, 25, 8),
-- Kozmetik (Kategori_ID: 9)
('Nemlendirici Krem 50ml', 'TR-KOZ-9001', 300.00, 40, 9),
('Güneş Kremi 50 SPF', 'TR-KOZ-9002', 450.00, 30, 9),
('Parfüm 100ml', 'TR-KOZ-9003', 1200.00, 20, 9),
-- Elektronik (Kategori_ID: 1)
('Kablosuz Kulaklık', 'TR-ELK-1003', 1200.00, 50, 1),
('Akıllı Saat', 'TR-ELK-1004', 3500.00, 30, 1),
-- Gıda (Kategori_ID: 2)
('Siyah Çay 1KG', 'TR-GID-2003', 150.00, 200, 2),
('Fındık Ezmesi 320g', 'TR-GID-2004', 90.00, 100, 2);

-- Tedarikçi Ürün Eşleştirmesi
INSERT INTO Tedarikci_Urun (Tedarikci_ID, Urun_ID) VALUES 
(6, 10), (6, 11), (6, 12),
(7, 13), (7, 14), (7, 15),
(8, 16), (8, 17), (8, 18),
(9, 19), (9, 20), (9, 21),
(10, 22), (10, 23),
(2, 24), (2, 25);

-- Depo Ürün Stok
INSERT INTO Depo_Urun_Stok (Depo_ID, Urun_ID, Guncel_Stok) VALUES 
(5, 10, 150), (5, 11, 200), (5, 12, 50),
(6, 13, 100), (6, 14, 300), (6, 15, 80),
(7, 16, 45), (7, 17, 90), (7, 18, 60),
(1, 19, 120), (2, 20, 150), (3, 21, 60),
(1, 22, 250), (1, 23, 100),
(2, 24, 500), (2, 25, 300);

-- Stok Hareketleri
INSERT INTO Stok_Hareketleri (Islem_Tipi, Miktar, Islem_Tarihi, Urun_ID, Depo_ID, Personel_ID) VALUES 
('Giriş', 200, '2025-05-10 10:00:00', 10, 5, 6),
('Çıkış', 50, '2025-05-12 14:30:00', 10, 5, 7),
('Giriş', 150, '2025-05-15 09:15:00', 13, 6, 8),
('Çıkış', 50, '2025-05-18 11:00:00', 13, 6, 9),
('Giriş', 100, '2025-05-20 11:45:00', 16, 7, 10),
('Çıkış', 55, '2025-05-22 16:20:00', 16, 7, 10);

-- Daha fazla Tedarikçi Ürün Eşleştirmesi
INSERT INTO Tedarikci_Urun (Tedarikci_ID, Urun_ID) VALUES 
(1, 3), (1, 5), (1, 7), (2, 2), (2, 6), (3, 1), (3, 8), (4, 4), (4, 9), (5, 10), (5, 15),
(6, 13), (6, 20), (7, 18), (7, 24), (8, 22), (8, 25), (9, 14), (10, 11), (10, 12);

-- Daha fazla Depo Ürün Stok
INSERT INTO Depo_Urun_Stok (Depo_ID, Urun_ID, Guncel_Stok) VALUES 
(1, 3, 200), (1, 4, 150), (1, 5, 80), (1, 6, 90), (1, 7, 30), (1, 8, 40),
(2, 1, 50), (2, 2, 70), (2, 5, 120), (2, 6, 80), (2, 9, 300), (2, 10, 45),
(3, 1, 20), (3, 2, 40), (3, 3, 100), (3, 4, 90), (3, 7, 20), (3, 8, 25),
(4, 1, 15), (4, 2, 25), (4, 3, 80), (4, 4, 60), (4, 5, 150), (4, 6, 110),
(5, 1, 60), (5, 2, 85), (5, 13, 200), (5, 14, 150), (5, 15, 95), (5, 16, 75),
(6, 1, 30), (6, 2, 45), (6, 10, 110), (6, 11, 130), (6, 12, 65), (6, 16, 50),
(7, 3, 150), (7, 4, 110), (7, 5, 250), (7, 6, 180), (7, 19, 90), (7, 20, 105);

-- Daha fazla Stok Hareketleri
INSERT INTO Stok_Hareketleri (Islem_Tipi, Miktar, Islem_Tarihi, Urun_ID, Depo_ID, Personel_ID) VALUES 
('Giriş', 100, '2025-06-01 08:00:00', 1, 1, 1),
('Çıkış', 20, '2025-06-02 09:30:00', 1, 1, 2),
('Giriş', 50, '2025-06-03 10:15:00', 2, 2, 3),
('Çıkış', 10, '2025-06-04 11:45:00', 2, 2, 3),
('Giriş', 200, '2025-06-05 13:00:00', 3, 3, 4),
('Çıkış', 40, '2025-06-06 14:20:00', 3, 3, 4),
('Giriş', 150, '2025-06-07 15:30:00', 4, 4, 5),
('Çıkış', 30, '2025-06-08 16:45:00', 4, 4, 5),
('Giriş', 80, '2025-06-09 09:00:00', 5, 5, 6),
('Çıkış', 15, '2025-06-10 10:10:00', 5, 5, 7),
('Giriş', 120, '2025-06-11 11:20:00', 6, 6, 8),
('Çıkış', 25, '2025-06-12 12:30:00', 6, 6, 9),
('Giriş', 60, '2025-06-13 13:40:00', 7, 7, 10),
('Çıkış', 12, '2025-06-14 14:50:00', 7, 7, 10),
('Giriş', 300, '2025-06-15 15:00:00', 8, 1, 1),
('Çıkış', 50, '2025-06-16 16:10:00', 8, 1, 2),
('Giriş', 250, '2025-06-17 08:20:00', 9, 2, 3),
('Çıkış', 45, '2025-06-18 09:30:00', 9, 2, 3),
('Giriş', 110, '2025-06-19 10:40:00', 10, 3, 4),
('Çıkış', 22, '2025-06-20 11:50:00', 10, 3, 4),
('Giriş', 180, '2025-06-21 13:00:00', 11, 4, 5),
('Çıkış', 35, '2025-06-22 14:10:00', 11, 4, 5),
('Giriş', 90, '2025-06-23 15:20:00', 12, 5, 6),
('Çıkış', 18, '2025-06-24 16:30:00', 12, 5, 7),
('Giriş', 140, '2025-06-25 09:40:00', 13, 6, 8),
('Çıkış', 28, '2025-06-26 10:50:00', 13, 6, 9),
('Giriş', 70, '2025-06-27 11:00:00', 14, 7, 10),
('Çıkış', 14, '2025-06-28 12:10:00', 14, 7, 10),
('Giriş', 220, '2025-06-29 13:20:00', 15, 1, 1),
('Çıkış', 44, '2025-06-30 14:30:00', 15, 1, 2),
('Giriş', 160, '2025-07-01 15:40:00', 16, 2, 3),
('Çıkış', 32, '2025-07-02 16:50:00', 16, 2, 3),
('Giriş', 130, '2025-07-03 08:00:00', 17, 3, 4),
('Çıkış', 26, '2025-07-04 09:10:00', 17, 3, 4),
('Giriş', 210, '2025-07-05 10:20:00', 18, 4, 5),
('Çıkış', 42, '2025-07-06 11:30:00', 18, 4, 5),
('Giriş', 100, '2025-07-07 12:40:00', 19, 5, 6),
('Çıkış', 20, '2025-07-08 13:50:00', 19, 5, 7),
('Giriş', 150, '2025-07-09 14:00:00', 20, 6, 8),
('Çıkış', 30, '2025-07-10 15:10:00', 20, 6, 9),
('Giriş', 80, '2025-07-11 16:20:00', 21, 7, 10),
('Çıkış', 16, '2025-07-12 09:30:00', 21, 7, 10),
('Giriş', 280, '2025-07-13 10:40:00', 22, 1, 1),
('Çıkış', 56, '2025-07-14 11:50:00', 22, 1, 2),
('Giriş', 170, '2025-07-15 12:00:00', 23, 2, 3),
('Çıkış', 34, '2025-07-16 13:10:00', 23, 2, 3),
('Giriş', 350, '2025-07-17 14:20:00', 24, 3, 4),
('Çıkış', 70, '2025-07-18 15:30:00', 24, 3, 4),
('Giriş', 200, '2025-07-19 16:40:00', 25, 4, 5),
('Çıkış', 40, '2025-07-20 08:50:00', 25, 4, 5);

-- =============================================
-- SAKLI YORDAMLAR (STORED PROCEDURES)
-- =============================================
DELIMITER //

DROP PROCEDURE IF EXISTS GetUrunler //
CREATE PROCEDURE GetUrunler(
    IN p_search VARCHAR(255),
    IN p_minFiyat DECIMAL(10,2),
    IN p_maxFiyat DECIMAL(10,2),
    IN p_Kategori_ID INT,
    IN p_sort_by VARCHAR(50),
    IN p_order VARCHAR(10)
)
BEGIN
    SET @sql = 'SELECT * FROM Urunler WHERE 1=1';
    IF p_search IS NOT NULL AND p_search != '' THEN
        SET @sql = CONCAT(@sql, ' AND (Urun_Adi LIKE ', QUOTE(CONCAT('%', p_search, '%')), ' OR Barkod LIKE ', QUOTE(CONCAT('%', p_search, '%')), ')');
    END IF;
    IF p_minFiyat IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND Birim_Fiyat >= ', p_minFiyat);
    END IF;
    IF p_maxFiyat IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND Birim_Fiyat <= ', p_maxFiyat);
    END IF;
    IF p_Kategori_ID IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND Kategori_ID = ', p_Kategori_ID);
    END IF;
    IF p_sort_by IN ('Birim_Fiyat', 'Kategori_ID', 'Urun_ID') THEN
        IF p_order = 'ASC' THEN
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' ASC');
        ELSE
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' DESC');
        END IF;
    END IF;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DROP PROCEDURE IF EXISTS AddUrun //
CREATE PROCEDURE AddUrun(
    IN p_Urun_Adi VARCHAR(150),
    IN p_Barkod VARCHAR(50),
    IN p_Birim_Fiyat DECIMAL(10,2),
    IN p_Kritik_Stok_Seviyesi INT,
    IN p_Kategori_ID INT
)
BEGIN
    INSERT INTO Urunler (Urun_Adi, Barkod, Birim_Fiyat, Kritik_Stok_Seviyesi, Kategori_ID) 
    VALUES (p_Urun_Adi, p_Barkod, p_Birim_Fiyat, p_Kritik_Stok_Seviyesi, p_Kategori_ID);
    SELECT LAST_INSERT_ID() AS id;
END //

DROP PROCEDURE IF EXISTS DeleteUrun //
CREATE PROCEDURE DeleteUrun(IN p_Urun_ID INT)
BEGIN
    DELETE FROM Urunler WHERE Urun_ID = p_Urun_ID;
    SELECT ROW_COUNT() AS affected_rows;
END //

DROP PROCEDURE IF EXISTS GetKategoriler //
CREATE PROCEDURE GetKategoriler(
    IN p_search VARCHAR(255),
    IN p_sort_by VARCHAR(50),
    IN p_order VARCHAR(10)
)
BEGIN
    SET @sql = 'SELECT * FROM Kategoriler WHERE 1=1';
    IF p_search IS NOT NULL AND p_search != '' THEN
        SET @sql = CONCAT(@sql, ' AND Kategori_Adi LIKE ', QUOTE(CONCAT('%', p_search, '%')));
    END IF;
    IF p_sort_by IN ('Kategori_ID') THEN
        IF p_order = 'ASC' THEN
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' ASC');
        ELSE
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' DESC');
        END IF;
    END IF;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DROP PROCEDURE IF EXISTS AddKategori //
CREATE PROCEDURE AddKategori(IN p_Adi VARCHAR(100), IN p_Tanim TEXT)
BEGIN
    INSERT INTO Kategoriler (Kategori_Adi, Tanim) VALUES (p_Adi, p_Tanim);
    SELECT LAST_INSERT_ID() AS id;
END //

DROP PROCEDURE IF EXISTS DeleteKategori //
CREATE PROCEDURE DeleteKategori(IN p_ID INT)
BEGIN
    DELETE FROM Kategoriler WHERE Kategori_ID = p_ID;
    SELECT ROW_COUNT() AS affected_rows;
END //

DROP PROCEDURE IF EXISTS GetDepolar //
CREATE PROCEDURE GetDepolar(
    IN p_search VARCHAR(255),
    IN p_Lokasyon VARCHAR(255),
    IN p_sort_by VARCHAR(50),
    IN p_order VARCHAR(10)
)
BEGIN
    SET @sql = 'SELECT * FROM Depolar WHERE 1=1';
    IF p_search IS NOT NULL AND p_search != '' THEN
        SET @sql = CONCAT(@sql, ' AND (Depo_Adi LIKE ', QUOTE(CONCAT('%', p_search, '%')), ' OR Lokasyon_Adres LIKE ', QUOTE(CONCAT('%', p_search, '%')), ')');
    END IF;
    IF p_Lokasyon IS NOT NULL AND p_Lokasyon != '' THEN
        SET @sql = CONCAT(@sql, ' AND Lokasyon_Adres LIKE ', QUOTE(CONCAT('%', p_Lokasyon, '%')));
    END IF;
    IF p_sort_by IN ('Toplam_Kapasite', 'Depo_ID') THEN
        IF p_order = 'ASC' THEN
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' ASC');
        ELSE
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' DESC');
        END IF;
    END IF;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DROP PROCEDURE IF EXISTS AddDepo //
CREATE PROCEDURE AddDepo(IN p_Adi VARCHAR(100), IN p_Adres TEXT, IN p_Kapasite INT)
BEGIN
    INSERT INTO Depolar (Depo_Adi, Lokasyon_Adres, Toplam_Kapasite) VALUES (p_Adi, p_Adres, p_Kapasite);
    SELECT LAST_INSERT_ID() AS id;
END //

DROP PROCEDURE IF EXISTS DeleteDepo //
CREATE PROCEDURE DeleteDepo(IN p_ID INT)
BEGIN
    DELETE FROM Depolar WHERE Depo_ID = p_ID;
    SELECT ROW_COUNT() AS affected_rows;
END //

DROP PROCEDURE IF EXISTS GetPersonel //
CREATE PROCEDURE GetPersonel(
    IN p_search VARCHAR(255),
    IN p_depo_id INT,
    IN p_sort_by VARCHAR(50),
    IN p_order VARCHAR(10)
)
BEGIN
    SET @sql = 'SELECT * FROM Personel WHERE 1=1';
    IF p_search IS NOT NULL AND p_search != '' THEN
        SET @sql = CONCAT(@sql, ' AND (Ad LIKE ', QUOTE(CONCAT('%', p_search, '%')), ' OR Soyad LIKE ', QUOTE(CONCAT('%', p_search, '%')), ')');
    END IF;
    IF p_depo_id IS NOT NULL THEN
        SET @sql = CONCAT(@sql, ' AND Depo_ID = ', p_depo_id);
    END IF;
    IF p_sort_by IN ('Personel_ID') THEN
        IF p_order = 'ASC' THEN
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' ASC');
        ELSE
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' DESC');
        END IF;
    END IF;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DROP PROCEDURE IF EXISTS AddPersonel //
CREATE PROCEDURE AddPersonel(IN p_Ad VARCHAR(50), IN p_Soyad VARCHAR(50), IN p_Gorev VARCHAR(100), IN p_Yetki VARCHAR(50), IN p_Depo_ID INT)
BEGIN
    INSERT INTO Personel (Ad, Soyad, Gorev, Erisim_Yetkisi, Depo_ID) VALUES (p_Ad, p_Soyad, p_Gorev, p_Yetki, p_Depo_ID);
    SELECT LAST_INSERT_ID() AS id;
END //

DROP PROCEDURE IF EXISTS DeletePersonel //
CREATE PROCEDURE DeletePersonel(IN p_ID INT)
BEGIN
    DELETE FROM Personel WHERE Personel_ID = p_ID;
    SELECT ROW_COUNT() AS affected_rows;
END //

DROP PROCEDURE IF EXISTS GetTedarikciler //
CREATE PROCEDURE GetTedarikciler(
    IN p_search VARCHAR(255),
    IN p_sort_by VARCHAR(50),
    IN p_order VARCHAR(10)
)
BEGIN
    SET @sql = 'SELECT * FROM Tedarikciler WHERE 1=1';
    IF p_search IS NOT NULL AND p_search != '' THEN
        SET @sql = CONCAT(@sql, ' AND Firma_Adi LIKE ', QUOTE(CONCAT('%', p_search, '%')));
    END IF;
    IF p_sort_by IN ('Tedarikci_ID') THEN
        IF p_order = 'ASC' THEN
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' ASC');
        ELSE
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' DESC');
        END IF;
    END IF;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DROP PROCEDURE IF EXISTS AddTedarikci //
CREATE PROCEDURE AddTedarikci(IN p_Firma_Adi VARCHAR(150), IN p_Iletisim TEXT)
BEGIN
    INSERT INTO Tedarikciler (Firma_Adi, Iletisim_Bilgileri) VALUES (p_Firma_Adi, p_Iletisim);
    SELECT LAST_INSERT_ID() AS id;
END //

DROP PROCEDURE IF EXISTS DeleteTedarikci //
CREATE PROCEDURE DeleteTedarikci(IN p_ID INT)
BEGIN
    DELETE FROM Tedarikciler WHERE Tedarikci_ID = p_ID;
    SELECT ROW_COUNT() AS affected_rows;
END //

DROP PROCEDURE IF EXISTS GetStokHareketleri //
CREATE PROCEDURE GetStokHareketleri(
    IN p_search VARCHAR(255),
    IN p_sort_by VARCHAR(50),
    IN p_order VARCHAR(10)
)
BEGIN
    SET @sql = 'SELECT * FROM Stok_Hareketleri WHERE 1=1';
    IF p_search IS NOT NULL AND p_search != '' THEN
        SET @sql = CONCAT(@sql, ' AND Islem_Tipi LIKE ', QUOTE(CONCAT('%', p_search, '%')));
    END IF;
    IF p_sort_by IN ('Hareket_ID', 'Islem_Tarihi') THEN
        IF p_order = 'ASC' THEN
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' ASC');
        ELSE
            SET @sql = CONCAT(@sql, ' ORDER BY ', p_sort_by, ' DESC');
        END IF;
    END IF;
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DROP PROCEDURE IF EXISTS AddStokHareketi //
CREATE PROCEDURE AddStokHareketi(IN p_Tip VARCHAR(20), IN p_Miktar INT, IN p_Urun_ID INT, IN p_Depo_ID INT, IN p_Personel_ID INT)
BEGIN
    INSERT INTO Stok_Hareketleri (Islem_Tipi, Miktar, Urun_ID, Depo_ID, Personel_ID) 
    VALUES (p_Tip, p_Miktar, p_Urun_ID, p_Depo_ID, p_Personel_ID);
    SELECT LAST_INSERT_ID() AS id;
END //

DROP PROCEDURE IF EXISTS DeleteStokHareketi //
CREATE PROCEDURE DeleteStokHareketi(IN p_ID INT)
BEGIN
    DELETE FROM Stok_Hareketleri WHERE Hareket_ID = p_ID;
    SELECT ROW_COUNT() AS affected_rows;
END //

DELIMITER ;
