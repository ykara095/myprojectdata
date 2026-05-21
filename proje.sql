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
('Giriş', 50, '2024-01-10 10:00:00', 1, 1, 1),
('Çıkış', 5, '2024-01-15 14:30:00', 1, 1, 2),
('Giriş', 100, '2024-01-12 09:15:00', 2, 1, 1),
('Çıkış', 20, '2024-01-18 11:00:00', 2, 1, 2),
('Giriş', 300, '2024-02-05 11:45:00', 3, 2, 3),
('Çıkış', 50, '2024-02-10 16:20:00', 3, 2, 3),
('Giriş', 150, '2024-03-01 08:30:00', 4, 2, 3),
('Çıkış', 30, '2024-03-05 09:45:00', 4, 2, 3),
('Giriş', 1000, '2024-03-15 13:00:00', 5, 3, 4),
('Çıkış', 200, '2024-03-20 15:45:00', 5, 3, 4),
('Giriş', 50, '2024-04-10 09:00:00', 7, 4, 5), 
('Çıkış', 10, '2024-04-15 11:30:00', 7, 4, 5),
('Giriş', 600, '2024-05-01 10:00:00', 9, 1, 1),
('Çıkış', 100, '2024-05-05 16:00:00', 9, 1, 2);
