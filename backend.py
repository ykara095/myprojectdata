from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
# HTML arayüzümüzün bu sunucuya takılmadan istek atabilmesi için CORS ekliyoruz
CORS(app) 

# MySQL Veritabanı Bağlantı Ayarları
db_config = {
    'host': 'localhost',
    'user': 'root',          # MySQL kullanıcı adın
    'password': 'muyumuyu88',  # MySQL şifren
    'database': 'AkilliStokDB'
}

# 1. Ürünleri Listeleme (GET İsteği)
@app.route('/api/urunler', methods=['GET'])
def get_urunler():
    try:
        # Veritabanına bağlan ve verileri sözlük (dictionary) formatında çek
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        
        search_query = request.args.get('search', '')
        min_fiyat = request.args.get('minFiyat', type=float)
        max_fiyat = request.args.get('maxFiyat', type=float)
        sort_by = request.args.get('sort_by', '')
        order = request.args.get('order', 'DESC').upper()
        
        query = "SELECT * FROM Urunler WHERE 1=1"
        params = []
        
        if search_query:
            query += " AND (Urun_Adi LIKE %s OR Barkod LIKE %s)"
            like_val = f"%{search_query}%"
            params.extend([like_val, like_val])
            
        if min_fiyat is not None:
            query += " AND Birim_Fiyat >= %s"
            params.append(min_fiyat)
        if max_fiyat is not None:
            query += " AND Birim_Fiyat <= %s"
            params.append(max_fiyat)
            
        allowed_sort = {'Birim_Fiyat', 'Kategori_ID', 'Urun_ID'}
        if sort_by in allowed_sort:
            if order not in ['ASC', 'DESC']: order = 'DESC'
            query += f" ORDER BY {sort_by} {order}"
            
        cursor.execute(query, tuple(params))
        urunler = cursor.fetchall()
        
        return jsonify(urunler), 200
        
    except Exception as e:
        return jsonify({"hata": str(e)}), 500
        
    finally:
        # İşlem bitince bağlantıları güvenli bir şekilde kapat
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

# 2. Yeni Ürün Ekleme (POST İsteği)
@app.route('/api/urunler', methods=['POST'])
def add_urun():
    data = request.json
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        
        # SQL Ekleme Sorgusu
        query = """
            INSERT INTO Urunler 
            (Urun_Adi, Barkod, Birim_Fiyat, Kritik_Stok_Seviyesi, Kategori_ID) 
            VALUES (%s, %s, %s, %s, %s)
        """
        # Arayüzden gelen veriler
        values = (
            data['Urun_Adi'], 
            data['Barkod'], 
            data['Birim_Fiyat'], 
            data['Kritik_Stok_Seviyesi'], 
            data['Kategori_ID']
        )
        
        cursor.execute(query, values)
        conn.commit() # Veritabanına kaydet
        
        return jsonify({"mesaj": "Ürün başarıyla eklendi", "id": cursor.lastrowid}), 201
        
    except Exception as e:
        return jsonify({"hata": str(e)}), 500
        
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

# 3. Ürün Silme (DELETE İsteği)
@app.route('/api/urunler/<int:urun_id>', methods=['DELETE'])
def delete_urun(urun_id):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        
        # SQL Silme Sorgusu (SQL Injection riskine karşı parametreli %s kullanımı)
        query = "DELETE FROM Urunler WHERE Urun_ID = %s"
        cursor.execute(query, (urun_id,))
        conn.commit()
        
        if cursor.rowcount == 0:
            return jsonify({"mesaj": "Ürün bulunamadı"}), 404
            
        return jsonify({"mesaj": "Ürün başarıyla silindi"}), 200
        
    except Exception as e:
        return jsonify({"hata": str(e)}), 500
        
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

# --- KATEGORİLER ROTALARI ---
@app.route('/api/kategoriler', methods=['GET'])
def get_kategoriler():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', '')
        sort_by = request.args.get('sort_by', '')
        order = request.args.get('order', 'DESC').upper()

        query = "SELECT * FROM Kategoriler WHERE 1=1"
        params = []

        if search:
            query += " AND Kategori_Adi LIKE %s"
            params.append(f"%{search}%")

        allowed_sort = {'Kategori_ID'}
        if sort_by in allowed_sort:
            if order not in ['ASC', 'DESC']: order = 'DESC'
            query += f" ORDER BY {sort_by} {order}"

        cursor.execute(query, tuple(params))
        return jsonify(cursor.fetchall()), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/kategoriler', methods=['POST'])
def add_kategori():
    data = request.json
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Kategoriler (Kategori_Adi, Tanim) VALUES (%s, %s)", (data['Kategori_Adi'], data['Tanim']))
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/kategoriler/<int:id>', methods=['DELETE'])
def delete_kategori(id):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Kategoriler WHERE Kategori_ID = %s", (id,))
        conn.commit()
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()


# --- DEPOLAR ROTALARI ---
@app.route('/api/depolar', methods=['GET'])
def get_depolar():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', '')
        sort_by = request.args.get('sort_by', '')
        order = request.args.get('order', 'DESC').upper()

        query = "SELECT * FROM Depolar WHERE 1=1"
        params = []

        if search:
            query += " AND Depo_Adi LIKE %s"
            params.append(f"%{search}%")

        allowed_sort = {'Toplam_Kapasite', 'Depo_ID'}
        if sort_by in allowed_sort:
            if order not in ['ASC', 'DESC']: order = 'DESC'
            query += f" ORDER BY {sort_by} {order}"

        cursor.execute(query, tuple(params))
        return jsonify(cursor.fetchall()), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/depolar', methods=['POST'])
def add_depo():
    data = request.json
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Depolar (Depo_Adi, Lokasyon_Adres, Toplam_Kapasite) VALUES (%s, %s, %s)", (data['Depo_Adi'], data['Lokasyon_Adres'], data['Toplam_Kapasite']))
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/depolar/<int:id>', methods=['DELETE'])
def delete_depo(id):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Depolar WHERE Depo_ID = %s", (id,))
        conn.commit()
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()


# --- PERSONEL ROTALARI ---
@app.route('/api/personel', methods=['GET'])
def get_personel():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', '')
        depo_id = request.args.get('depoId', type=int)
        sort_by = request.args.get('sort_by', '')
        order = request.args.get('order', 'DESC').upper()

        query = "SELECT * FROM Personel WHERE 1=1"
        params = []

        if search:
            query += " AND (Ad LIKE %s OR Soyad LIKE %s)"
            params.extend([f"%{search}%", f"%{search}%"])
        if depo_id is not None:
            query += " AND Depo_ID = %s"
            params.append(depo_id)

        allowed_sort = {'Personel_ID'}
        if sort_by in allowed_sort:
            if order not in ['ASC', 'DESC']: order = 'DESC'
            query += f" ORDER BY {sort_by} {order}"

        cursor.execute(query, tuple(params))
        return jsonify(cursor.fetchall()), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/personel', methods=['POST'])
def add_personel():
    data = request.json
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Personel (Ad, Soyad, Gorev, Erisim_Yetkisi, Depo_ID) VALUES (%s, %s, %s, %s, %s)", (data['Ad'], data['Soyad'], data['Gorev'], data['Erisim_Yetkisi'], data['Depo_ID']))
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/personel/<int:id>', methods=['DELETE'])
def delete_personel(id):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Personel WHERE Personel_ID = %s", (id,))
        conn.commit()
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()


# --- TEDARİKÇİLER ROTALARI ---
@app.route('/api/tedarikciler', methods=['GET'])
def get_tedarikciler():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', '')
        sort_by = request.args.get('sort_by', '')
        order = request.args.get('order', 'DESC').upper()

        query = "SELECT * FROM Tedarikciler WHERE 1=1"
        params = []

        if search:
            query += " AND Firma_Adi LIKE %s"
            params.append(f"%{search}%")

        allowed_sort = {'Tedarikci_ID'}
        if sort_by in allowed_sort:
            if order not in ['ASC', 'DESC']: order = 'DESC'
            query += f" ORDER BY {sort_by} {order}"

        cursor.execute(query, tuple(params))
        return jsonify(cursor.fetchall()), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/tedarikciler', methods=['POST'])
def add_tedarikci():
    data = request.json
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Tedarikciler (Firma_Adi, Iletisim_Bilgileri) VALUES (%s, %s)", (data['Firma_Adi'], data['Iletisim_Bilgileri']))
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/tedarikciler/<int:id>', methods=['DELETE'])
def delete_tedarikci(id):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Tedarikciler WHERE Tedarikci_ID = %s", (id,))
        conn.commit()
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()


# --- STOK HAREKETLERİ ROTALARI ---
@app.route('/api/stokhareketleri', methods=['GET'])
def get_stokhareketleri():
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', '')
        sort_by = request.args.get('sort_by', '')
        order = request.args.get('order', 'DESC').upper()

        query = "SELECT * FROM Stok_Hareketleri WHERE 1=1"
        params = []

        if search:
            query += " AND Islem_Tipi LIKE %s"
            params.append(f"%{search}%")

        allowed_sort = {'Hareket_ID', 'Islem_Tarihi'}
        if sort_by in allowed_sort:
            if order not in ['ASC', 'DESC']: order = 'DESC'
            query += f" ORDER BY {sort_by} {order}"

        cursor.execute(query, tuple(params))
        return jsonify(cursor.fetchall()), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/stokhareketleri', methods=['POST'])
def add_stokhareketi():
    data = request.json
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("INSERT INTO Stok_Hareketleri (Islem_Tipi, Miktar, Urun_ID, Depo_ID, Personel_ID) VALUES (%s, %s, %s, %s, %s)", (data['Islem_Tipi'], data['Miktar'], data['Urun_ID'], data['Depo_ID'], data['Personel_ID']))
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/stokhareketleri/<int:id>', methods=['DELETE'])
def delete_stokhareketi(id):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        cursor.execute("DELETE FROM Stok_Hareketleri WHERE Hareket_ID = %s", (id,))
        conn.commit()
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()




if __name__ == '__main__':
    # JavaScript kodunda değişiklik yapmamak için portu yine 3000 olarak ayarlıyoruz
    app.run(port=3000, debug=True)