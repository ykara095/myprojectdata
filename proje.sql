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
INSERT INTO Kategoriler (Kategori_Adi, Tanim) VALUES 
('Elektronik', 'Elektronik ve teknolojik cihazlar'),
('Gıda', 'Yiyecek ve içecek ürünleri');

INSERT INTO Depolar (Depo_Adi, Lokasyon_Adres, Toplam_Kapasite) VALUES 
('Ana Depo', 'İstanbul / Merkez', 5000),
('Şube Depo', 'Ankara / Çankaya', 2000);

INSERT INTO Personel (Ad, Soyad, Gorev, Erisim_Yetkisi, Depo_ID) VALUES 
('Ahmet', 'Yılmaz', 'Depo Sorumlusu', 'Admin', 1),
('Ayşe', 'Kaya', 'Stok Görevlisi', 'User', 2);