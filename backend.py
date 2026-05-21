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

def get_db_connection():
    return mysql.connector.connect(**db_config)

def fetch_procedure_result(cursor):
    """ Saklı yordamdan (Stored Procedure) dönen veri setini alır """
    results = []
    for result in cursor.stored_results():
        results.extend(result.fetchall())
    return results

# 1. Ürünleri Listeleme (GET İsteği)
@app.route('/api/urunler', methods=['GET'])
def get_urunler():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        search_query = request.args.get('search', None)
        min_fiyat = request.args.get('minFiyat', type=float, default=None)
        max_fiyat = request.args.get('maxFiyat', type=float, default=None)
        sort_by = request.args.get('sort_by', 'Urun_ID')
        order = request.args.get('order', 'DESC').upper()
        
        cursor.callproc('GetUrunler', [search_query, min_fiyat, max_fiyat, sort_by, order])
        urunler = fetch_procedure_result(cursor)
        return jsonify(urunler), 200
    except Exception as e:
        return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

# 2. Yeni Ürün Ekleme (POST İsteği)
@app.route('/api/urunler', methods=['POST'])
def add_urun():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('AddUrun', [
            data['Urun_Adi'], 
            data['Barkod'], 
            data['Birim_Fiyat'], 
            data['Kritik_Stok_Seviyesi'], 
            data['Kategori_ID']
        ])
        conn.commit()
        result = fetch_procedure_result(cursor)
        inserted_id = result[0]['id'] if result else None
        return jsonify({"mesaj": "Ürün başarıyla eklendi", "id": inserted_id}), 201
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
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('DeleteUrun', [urun_id])
        conn.commit()
        result = fetch_procedure_result(cursor)
        affected = result[0]['affected_rows'] if result else 0
        if affected == 0:
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
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', None)
        sort_by = request.args.get('sort_by', 'Kategori_ID')
        order = request.args.get('order', 'DESC').upper()

        cursor.callproc('GetKategoriler', [search, sort_by, order])
        return jsonify(fetch_procedure_result(cursor)), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/kategoriler', methods=['POST'])
def add_kategori():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('AddKategori', [data['Kategori_Adi'], data['Tanim']])
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/kategoriler/<int:id>', methods=['DELETE'])
def delete_kategori(id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('DeleteKategori', [id])
        conn.commit()
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

# --- DEPOLAR ROTALARI ---
@app.route('/api/depolar', methods=['GET'])
def get_depolar():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', None)
        sort_by = request.args.get('sort_by', 'Depo_ID')
        order = request.args.get('order', 'DESC').upper()

        cursor.callproc('GetDepolar', [search, sort_by, order])
        return jsonify(fetch_procedure_result(cursor)), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/depolar', methods=['POST'])
def add_depo():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('AddDepo', [data['Depo_Adi'], data['Lokasyon_Adres'], data['Toplam_Kapasite']])
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/depolar/<int:id>', methods=['DELETE'])
def delete_depo(id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('DeleteDepo', [id])
        conn.commit()
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

# --- PERSONEL ROTALARI ---
@app.route('/api/personel', methods=['GET'])
def get_personel():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', None)
        depo_id = request.args.get('depoId', type=int, default=None)
        sort_by = request.args.get('sort_by', 'Personel_ID')
        order = request.args.get('order', 'DESC').upper()

        cursor.callproc('GetPersonel', [search, depo_id, sort_by, order])
        return jsonify(fetch_procedure_result(cursor)), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/personel', methods=['POST'])
def add_personel():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('AddPersonel', [data['Ad'], data['Soyad'], data['Gorev'], data['Erisim_Yetkisi'], data['Depo_ID']])
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/personel/<int:id>', methods=['DELETE'])
def delete_personel(id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('DeletePersonel', [id])
        conn.commit()
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

# --- TEDARİKÇİLER ROTALARI ---
@app.route('/api/tedarikciler', methods=['GET'])
def get_tedarikciler():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', None)
        sort_by = request.args.get('sort_by', 'Tedarikci_ID')
        order = request.args.get('order', 'DESC').upper()

        cursor.callproc('GetTedarikciler', [search, sort_by, order])
        return jsonify(fetch_procedure_result(cursor)), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/tedarikciler', methods=['POST'])
def add_tedarikci():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('AddTedarikci', [data['Firma_Adi'], data['Iletisim_Bilgileri']])
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/tedarikciler/<int:id>', methods=['DELETE'])
def delete_tedarikci(id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('DeleteTedarikci', [id])
        conn.commit()
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

# --- STOK HAREKETLERİ ROTALARI ---
@app.route('/api/stokhareketleri', methods=['GET'])
def get_stokhareketleri():
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        search = request.args.get('search', None)
        sort_by = request.args.get('sort_by', 'Hareket_ID')
        order = request.args.get('order', 'DESC').upper()

        cursor.callproc('GetStokHareketleri', [search, sort_by, order])
        return jsonify(fetch_procedure_result(cursor)), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/stokhareketleri', methods=['POST'])
def add_stokhareketi():
    data = request.json
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('AddStokHareketi', [data['Islem_Tipi'], data['Miktar'], data['Urun_ID'], data['Depo_ID'], data['Personel_ID']])
        conn.commit()
        return jsonify({"mesaj": "Eklendi"}), 201
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

@app.route('/api/stokhareketleri/<int:id>', methods=['DELETE'])
def delete_stokhareketi(id):
    try:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.callproc('DeleteStokHareketi', [id])
        conn.commit()
        result = fetch_procedure_result(cursor)
        affected = result[0]['affected_rows'] if result else 0
        if affected == 0:
            return jsonify({"mesaj": "Kayıt bulunamadı"}), 404
        return jsonify({"mesaj": "Silindi"}), 200
    except Exception as e: return jsonify({"hata": str(e)}), 500
    finally:
        if 'conn' in locals() and conn.is_connected(): cursor.close(); conn.close()

if __name__ == '__main__':
    # JavaScript kodunda değişiklik yapmamak için portu yine 3000 olarak ayarlıyoruz
    app.run(port=3000, debug=True)