# Akıllı Stok Yönetimi

Bu proje, bir şirketin veya deponun ürün, personel, tedarikçi, depo ve stok hareketleri gibi süreçlerini yönetmesi için tasarlanmış web tabanlı bir uygulamadır. Arka uçta (backend) **Python (Flask)**, veritabanı olarak **MySQL**, ön uçta (frontend) ise **HTML, CSS ve JavaScript** kullanılmaktadır.

Aşağıdaki adımları takip ederek projeyi kendi bilgisayarınızda temiz ve sorunsuz bir şekilde çalıştırabilirsiniz.

## 🛠 Ön Gereksinimler

Projeyi çalıştırmadan önce bilgisayarınızda aşağıdakilerin kurulu olduğundan emin olun:
- [Python 3.x](https://www.python.org/downloads/)
- [MySQL Server](https://dev.mysql.com/downloads/mysql/)

---

## 🚀 1. Veritabanı Kurulumu (MySQL)

Öncelikle projenin ihtiyaç duyduğu veritabanını oluşturmalısınız:

1. MySQL sunucunuzun (örneğin XAMPP, WAMP veya yerel MySQL) çalıştığından emin olun.
2. MySQL komut satırı aracını veya **phpMyAdmin**, **MySQL Workbench** gibi bir arayüzü açın.
3. Aşağıdaki komutu çalıştırarak veritabanını oluşturun:
   ```sql
   CREATE DATABASE AkilliStokDB;
   ```
4. Veritabanını seçip proje klasöründeki `proje.sql` dosyasının içeriğini çalıştırarak tabloları oluşturun.
5. `backend.py` dosyasını açın ve 12. ve 13. satırlardaki MySQL giriş bilgilerinizi kendi sisteminize göre güncelleyin:
   ```python
   # MySQL Veritabanı Bağlantı Ayarları
   db_config = {
       'host': 'localhost',
       'user': 'root',          # Kendi MySQL kullanıcı adınız
       'password': 'sifreniz',  # Kendi MySQL şifreniz
       'database': 'AkilliStokDB'
   }
   ```

---

## 🐍 2. Backend (Sunucu) Kurulumu

Python kütüphanelerini izole bir ortamda kurmak en temiz yöntemdir. Terminal veya Komut İstemini (cmd/powershell) proje klasöründe (`d:\projects\Proje`) açıp sırasıyla şu adımları uygulayın:

**1. Sanal Ortam (Virtual Environment) Oluşturma:**
```bash
python -m venv venv
```

**2. Sanal Ortamı Aktif Etme:**
- **Windows (Command Prompt / PowerShell):**
  ```bash
  .\venv\Scripts\activate
  ```
  *(Not: Eğer MSYS2/MinGW tarzı bir terminal kullanıyorsanız `source ./venv/bin/activate` komutunu deneyin.)*

**3. Gerekli Kütüphanelerin Yüklenmesi:**
Sanal ortam aktifken (terminalinizin başında `(venv)` yazmalıdır), projenin bağımlılıklarını kurun:
```bash
pip install flask flask-cors mysql-connector-python
```

**4. Sunucuyu Başlatma:**
Kurulum (kütüphane yükleme) işlemleri **sadece bir kereye mahsustur**. 
Projeyi çalıştırmak istediğinizde sadece proje klasöründeki **`baslat.bat`** dosyasına çift tıklamanız yeterlidir! (Sanal ortam otomatik aktifleşir ve sunucu başlar.)
*(Sunucu başarılı şekilde çalışırsa, terminalde `Running on http://127.0.0.1:3000` yazısını göreceksiniz.)*

---

## 🌐 3. Frontend (Arayüz) Kullanımı

Backend sunucusu arka planda çalışmaya devam ederken arayüze erişebilirsiniz:

- Proje klasöründeki `main.html` dosyasına çift tıklayarak varsayılan tarayıcınızda açabilirsiniz.
- **Veya** daha iyi bir deneyim için Visual Studio Code kullanıyorsanız, `main.html` dosyasına sağ tıklayıp **"Open with Live Server"** seçeneğine tıklayarak arayüzü çalıştırabilirsiniz.

Menüyü kullanarak Ürünler, Kategoriler, Depolar, Personeller ve Tedarikçiler gibi modüller arasında gezinebilir ve işlem yapabilirsiniz.

---

## 📝 Notlar
- Sistemi kullanırken veya test ederken `backend.py` komutunun çalıştığı terminali **kapatmayın**. Terminal kapanırsa veritabanı iletişimi kesilir.
- Projede değişiklik yaparsanız, projeyi GitHub'a gönderirken `venv/` klasörünün gönderilmemesi için `.gitignore` dosyasının kullanıldığından emin olun (Mevcut yapıda ayarlıdır).

İyi çalışmalar! 🚀
