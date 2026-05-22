const BASE_URL = 'http://localhost:3000/api';

document.addEventListener("DOMContentLoaded", () => {

    // --- 1. ÜRÜNLER SAYFASI ---
    if (document.getElementById('urunEkleBtn')) {
        const API_URL = `${BASE_URL}/urunler`;
        let currentSortColumn = '';
        let currentSortOrder = 'DESC';

        window.siralamaYap = function(kolon) {
            if (currentSortColumn === kolon) {
                currentSortOrder = currentSortOrder === 'DESC' ? 'ASC' : 'DESC';
            } else {
                currentSortColumn = kolon;
                currentSortOrder = 'DESC';
            }
            verileriGetir();
        };

        verileriGetir();

        document.getElementById('urunEkleBtn').addEventListener('click', async () => {
            const fiyat = document.getElementById('fiyat').value;
            const kritikStok = document.getElementById('kritikStok').value;
            const kategoriId = document.getElementById('kategoriId').value;

            const veri = {
                Urun_Adi: document.getElementById('urunAdi').value,
                Barkod: document.getElementById('barkod').value,
                Birim_Fiyat: fiyat ? parseFloat(fiyat) : null,
                Kritik_Stok_Seviyesi: kritikStok ? parseInt(kritikStok) : null,
                Kategori_ID: kategoriId ? parseInt(kategoriId) : null
            };
            if (!veri.Urun_Adi || !veri.Barkod) return alert("Ürün Adı ve Barkod zorunludur.");

            try {
                const res = await fetch(API_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(veri)
                });
                if (!res.ok) {
                    const hata = await res.json();
                    alert("EKLEME HATASI:\n" + (hata.hata || hata.mesaj));
                    return;
                }
                
                // Formu temizle
                document.getElementById('urunAdi').value = '';
                document.getElementById('barkod').value = '';
                document.getElementById('fiyat').value = '';
                document.getElementById('kritikStok').value = '';
                document.getElementById('kategoriId').value = '';

                verileriGetir();
            } catch (err) { alert("Sunucuya bağlanılamadı."); }
        });

        const inputs = ['searchInput', 'minFiyat', 'maxFiyat', 'searchKategoriId'];
        inputs.forEach(id => {
            const el = document.getElementById(id);
            if(el) {
                el.addEventListener('input', () => {
                    setTimeout(() => { verileriGetir(); }, 300);
                });
            }
        });

        async function verileriGetir() {
            try {
                const search = document.getElementById('searchInput') ? document.getElementById('searchInput').value : '';
                const minFiyat = document.getElementById('minFiyat') ? document.getElementById('minFiyat').value : '';
                const maxFiyat = document.getElementById('maxFiyat') ? document.getElementById('maxFiyat').value : '';
                const searchKategoriId = document.getElementById('searchKategoriId') ? document.getElementById('searchKategoriId').value : '';

                const p = new URLSearchParams();
                if (search) p.append('search', search);
                if (minFiyat) p.append('minFiyat', minFiyat);
                if (maxFiyat) p.append('maxFiyat', maxFiyat);
                if (searchKategoriId) p.append('kategoriId', searchKategoriId);
                if (currentSortColumn) {
                    p.append('sort_by', currentSortColumn);
                    p.append('order', currentSortOrder);
                }

                const url = `${API_URL}?${p.toString()}`;
                const res = await fetch(url);
                const veriler = await res.json();
                const tbody = document.getElementById('tabloGövdesi');
                tbody.innerHTML = '';
                veriler.forEach(v => {
                    tbody.innerHTML += `
                        <tr>
                            <td>${v.Urun_ID}</td>
                            <td>${v.Urun_Adi}</td>
                            <td>${v.Barkod}</td>
                            <td>${v.Birim_Fiyat}</td>
                            <td>${v.Kritik_Stok_Seviyesi}</td>
                            <td>${v.Kategori_ID !== null ? v.Kategori_ID : '-'}</td>
                            <td><button style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px;" onclick="kayitSil('${API_URL}', ${v.Urun_ID}, window.verileriGetir)">Sil</button></td>
                        </tr>
                    `;
                });
            } catch (e) { console.error(e); }
        }
        window.verileriGetir = verileriGetir;
    }

    // --- 2. KATEGORİLER SAYFASI ---
    else if (document.getElementById('kategoriEkleBtn')) {
        const API_URL = `${BASE_URL}/kategoriler`;
        let currentSortColumn = '';
        let currentSortOrder = 'DESC';

        window.siralamaYap = function(kolon) {
            if (currentSortColumn === kolon) {
                currentSortOrder = currentSortOrder === 'DESC' ? 'ASC' : 'DESC';
            } else {
                currentSortColumn = kolon;
                currentSortOrder = 'DESC';
            }
            verileriGetir();
        };

        verileriGetir();

        document.getElementById('kategoriEkleBtn').addEventListener('click', async () => {
            const veri = {
                Kategori_Adi: document.getElementById('kategoriAdi').value,
                Tanim: document.getElementById('tanim').value
            };
            if (!veri.Kategori_Adi) return alert("Kategori Adı zorunludur.");

            try {
                const res = await fetch(API_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(veri)
                });
                if (!res.ok) {
                    const hata = await res.json();
                    alert("EKLEME HATASI:\n" + (hata.hata || hata.mesaj));
                    return;
                }
                verileriGetir();
            } catch (err) { alert("Sunucuya bağlanılamadı."); }
        });

        document.getElementById('searchInput').addEventListener('input', (e) => {
            setTimeout(() => { verileriGetir(); }, 300);
        });

        async function verileriGetir() {
            try {
                const search = document.getElementById('searchInput') ? document.getElementById('searchInput').value : '';
                const p = new URLSearchParams();
                if (search) p.append('search', search);
                if (currentSortColumn) {
                    p.append('sort_by', currentSortColumn);
                    p.append('order', currentSortOrder);
                }

                const url = `${API_URL}?${p.toString()}`;
                const res = await fetch(url);
                const veriler = await res.json();
                const tbody = document.getElementById('tabloGövdesi');
                tbody.innerHTML = '';
                veriler.forEach(v => {
                    tbody.innerHTML += `
                        <tr>
                            <td>${v.Kategori_ID}</td>
                            <td>${v.Kategori_Adi}</td>
                            <td>${v.Tanim}</td>
                            <td><button style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px;" onclick="kayitSil('${API_URL}', ${v.Kategori_ID}, window.verileriGetir)">Sil</button></td>
                        </tr>
                    `;
                });
            } catch (e) { console.error(e); }
        }
        window.verileriGetir = verileriGetir;
    }

    // --- 3. DEPOLAR SAYFASI ---
    else if (document.getElementById('depoEkleBtn')) {
        const API_URL = `${BASE_URL}/depolar`;
        let currentSortColumn = '';
        let currentSortOrder = 'DESC';

        window.siralamaYap = function(kolon) {
            if (currentSortColumn === kolon) {
                currentSortOrder = currentSortOrder === 'DESC' ? 'ASC' : 'DESC';
            } else {
                currentSortColumn = kolon;
                currentSortOrder = 'DESC';
            }
            verileriGetir();
        };

        verileriGetir();

        document.getElementById('depoEkleBtn').addEventListener('click', async () => {
            const veri = {
                Depo_Adi: document.getElementById('depoAdi').value,
                Lokasyon_Adres: document.getElementById('lokasyonAdres').value,
                Toplam_Kapasite: document.getElementById('toplamKapasite').value
            };
            if (!veri.Depo_Adi) return alert("Depo Adı zorunludur.");

            try {
                const res = await fetch(API_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(veri)
                });
                if (!res.ok) {
                    const hata = await res.json();
                    alert("EKLEME HATASI:\n" + (hata.hata || hata.mesaj));
                    return;
                }
                verileriGetir();
            } catch (err) { alert("Sunucuya bağlanılamadı."); }
        });

        const inputs = ['searchInput', 'searchLokasyon'];
        inputs.forEach(id => {
            const el = document.getElementById(id);
            if(el) {
                el.addEventListener('input', () => {
                    setTimeout(() => { verileriGetir(); }, 300);
                });
            }
        });

        async function verileriGetir() {
            try {
                const search = document.getElementById('searchInput') ? document.getElementById('searchInput').value : '';
                const searchLokasyon = document.getElementById('searchLokasyon') ? document.getElementById('searchLokasyon').value : '';
                const p = new URLSearchParams();
                if (search) p.append('search', search);
                if (searchLokasyon) p.append('lokasyon', searchLokasyon);
                if (currentSortColumn) {
                    p.append('sort_by', currentSortColumn);
                    p.append('order', currentSortOrder);
                }

                const url = `${API_URL}?${p.toString()}`;
                const res = await fetch(url);
                const veriler = await res.json();
                const tbody = document.getElementById('tabloGövdesi');
                tbody.innerHTML = '';
                veriler.forEach(v => {
                    tbody.innerHTML += `
                        <tr>
                            <td>${v.Depo_ID}</td>
                            <td>${v.Depo_Adi}</td>
                            <td>${v.Lokasyon_Adres}</td>
                            <td>${v.Toplam_Kapasite}</td>
                            <td><button style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px;" onclick="kayitSil('${API_URL}', ${v.Depo_ID}, window.verileriGetir)">Sil</button></td>
                        </tr>
                    `;
                });
            } catch (e) { console.error(e); }
        }
        window.verileriGetir = verileriGetir;
    }

    // --- 4. PERSONEL SAYFASI ---
    else if (document.getElementById('personelEkleBtn')) {
        const API_URL = `${BASE_URL}/personel`;
        let currentSortColumn = '';
        let currentSortOrder = 'DESC';

        window.siralamaYap = function(kolon) {
            if (currentSortColumn === kolon) {
                currentSortOrder = currentSortOrder === 'DESC' ? 'ASC' : 'DESC';
            } else {
                currentSortColumn = kolon;
                currentSortOrder = 'DESC';
            }
            verileriGetir();
        };

        verileriGetir();

        document.getElementById('personelEkleBtn').addEventListener('click', async () => {
            const veri = {
                Ad: document.getElementById('ad').value,
                Soyad: document.getElementById('soyad').value,
                Gorev: document.getElementById('gorev').value,
                Erisim_Yetkisi: document.getElementById('erisimYetkisi').value,
                Depo_ID: document.getElementById('depoId').value
            };
            if (!veri.Ad || !veri.Soyad) return alert("Ad ve Soyad zorunludur.");

            try {
                const res = await fetch(API_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(veri)
                });
                if (!res.ok) {
                    const hata = await res.json();
                    alert("EKLEME HATASI:\n" + (hata.hata || hata.mesaj));
                    return;
                }
                verileriGetir();
            } catch (err) { alert("Sunucuya bağlanılamadı."); }
        });

        const inputs = ['searchInput', 'searchDepoId'];
        inputs.forEach(id => {
            const el = document.getElementById(id);
            if(el) {
                el.addEventListener('input', () => {
                    setTimeout(() => { verileriGetir(); }, 300);
                });
            }
        });

        async function verileriGetir() {
            try {
                const search = document.getElementById('searchInput') ? document.getElementById('searchInput').value : '';
                const searchDepoId = document.getElementById('searchDepoId') ? document.getElementById('searchDepoId').value : '';
                const p = new URLSearchParams();
                if (search) p.append('search', search);
                if (searchDepoId) p.append('depoId', searchDepoId);
                if (currentSortColumn) {
                    p.append('sort_by', currentSortColumn);
                    p.append('order', currentSortOrder);
                }

                const url = `${API_URL}?${p.toString()}`;
                const res = await fetch(url);
                const veriler = await res.json();
                const tbody = document.getElementById('tabloGövdesi');
                tbody.innerHTML = '';
                veriler.forEach(v => {
                    tbody.innerHTML += `
                        <tr>
                            <td>${v.Personel_ID}</td>
                            <td>${v.Ad}</td>
                            <td>${v.Soyad}</td>
                            <td>${v.Gorev}</td>
                            <td>${v.Erisim_Yetkisi}</td>
                            <td>${v.Depo_ID}</td>
                            <td><button style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px;" onclick="kayitSil('${API_URL}', ${v.Personel_ID}, window.verileriGetir)">Sil</button></td>
                        </tr>
                    `;
                });
            } catch (e) { console.error(e); }
        }
        window.verileriGetir = verileriGetir;
    }

    // --- 5. TEDARİKÇİLER SAYFASI ---
    else if (document.getElementById('tedarikciEkleBtn')) {
        const API_URL = `${BASE_URL}/tedarikciler`;
        let currentSortColumn = '';
        let currentSortOrder = 'DESC';

        window.siralamaYap = function(kolon) {
            if (currentSortColumn === kolon) {
                currentSortOrder = currentSortOrder === 'DESC' ? 'ASC' : 'DESC';
            } else {
                currentSortColumn = kolon;
                currentSortOrder = 'DESC';
            }
            verileriGetir();
        };

        verileriGetir();

        document.getElementById('tedarikciEkleBtn').addEventListener('click', async () => {
            const veri = {
                Firma_Adi: document.getElementById('firmaAdi').value,
                Iletisim_Bilgileri: document.getElementById('iletisimBilgileri').value
            };
            if (!veri.Firma_Adi) return alert("Firma Adı zorunludur.");

            try {
                const res = await fetch(API_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(veri)
                });
                if (!res.ok) {
                    const hata = await res.json();
                    alert("EKLEME HATASI:\n" + (hata.hata || hata.mesaj));
                    return;
                }
                verileriGetir();
            } catch (err) { alert("Sunucuya bağlanılamadı."); }
        });

        document.getElementById('searchInput').addEventListener('input', (e) => {
            setTimeout(() => { verileriGetir(); }, 300);
        });

        async function verileriGetir() {
            try {
                const search = document.getElementById('searchInput') ? document.getElementById('searchInput').value : '';
                const p = new URLSearchParams();
                if (search) p.append('search', search);
                if (currentSortColumn) {
                    p.append('sort_by', currentSortColumn);
                    p.append('order', currentSortOrder);
                }

                const url = `${API_URL}?${p.toString()}`;
                const res = await fetch(url);
                const veriler = await res.json();
                const tbody = document.getElementById('tabloGövdesi');
                tbody.innerHTML = '';
                veriler.forEach(v => {
                    tbody.innerHTML += `
                        <tr>
                            <td>${v.Tedarikci_ID}</td>
                            <td>${v.Firma_Adi}</td>
                            <td>${v.Iletisim_Bilgileri}</td>
                            <td><button style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px;" onclick="kayitSil('${API_URL}', ${v.Tedarikci_ID}, window.verileriGetir)">Sil</button></td>
                        </tr>
                    `;
                });
            } catch (e) { console.error(e); }
        }
        window.verileriGetir = verileriGetir;
    }

    // --- 6. STOK HAREKETLERİ SAYFASI ---
    else if (document.getElementById('hareketEkleBtn')) {
        const API_URL = `${BASE_URL}/stokhareketleri`;
        let currentSortColumn = '';
        let currentSortOrder = 'DESC';

        window.siralamaYap = function(kolon) {
            if (currentSortColumn === kolon) {
                currentSortOrder = currentSortOrder === 'DESC' ? 'ASC' : 'DESC';
            } else {
                currentSortColumn = kolon;
                currentSortOrder = 'DESC';
            }
            verileriGetir();
        };

        verileriGetir();

        document.getElementById('hareketEkleBtn').addEventListener('click', async () => {
            const veri = {
                Islem_Tipi: document.getElementById('islemTipi').value,
                Miktar: document.getElementById('miktar').value,
                Urun_ID: document.getElementById('urunId').value,
                Depo_ID: document.getElementById('depoId').value,
                Personel_ID: document.getElementById('personelId').value
            };
            if (!veri.Islem_Tipi || !veri.Miktar) return alert("İşlem tipi ve Miktar zorunludur.");

            try {
                const res = await fetch(API_URL, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(veri)
                });
                if (!res.ok) {
                    const hata = await res.json();
                    alert("EKLEME HATASI:\n" + (hata.hata || hata.mesaj));
                    return;
                }
                verileriGetir();
            } catch (err) { alert("Sunucuya bağlanılamadı."); }
        });

        document.getElementById('searchInput').addEventListener('input', (e) => {
            setTimeout(() => { verileriGetir(); }, 300);
        });

        async function verileriGetir() {
            try {
                const search = document.getElementById('searchInput') ? document.getElementById('searchInput').value : '';
                const p = new URLSearchParams();
                if (search) p.append('search', search);
                if (currentSortColumn) {
                    p.append('sort_by', currentSortColumn);
                    p.append('order', currentSortOrder);
                }

                const url = `${API_URL}?${p.toString()}`;
                const res = await fetch(url);
                const veriler = await res.json();
                const tbody = document.getElementById('tabloGövdesi');
                tbody.innerHTML = '';
                veriler.forEach(v => {
                    tbody.innerHTML += `
                        <tr>
                            <td>${v.Hareket_ID}</td>
                            <td>${v.Islem_Tipi}</td>
                            <td>${v.Miktar}</td>
                            <td>${v.Islem_Tarihi}</td>
                            <td>${v.Urun_ID}</td>
                            <td>${v.Depo_ID}</td>
                            <td>${v.Personel_ID}</td>
                            <td><button style="background-color: #dc3545; color: white; border: none; padding: 5px 10px; cursor: pointer; border-radius: 4px;" onclick="kayitSil('${API_URL}', ${v.Hareket_ID}, window.verileriGetir)">Sil</button></td>
                        </tr>
                    `;
                });
            } catch (e) { console.error(e); }
        }
        window.verileriGetir = verileriGetir;
    }

});

// --- ORTAK SİLME FONKSİYONU ---
async function kayitSil(apiUrl, id, tabloGuncelleCallback) {
    if (!confirm("Bu kaydı silmek istediğinize emin misiniz?")) {
        return;
    }

    try {
        const response = await fetch(`${apiUrl}/${id}`, {
            method: 'DELETE'
        });

        if (!response.ok) {
            const data = await response.json();
            alert("SİLME HATASI:\nİşlem başarısız oldu!\n\nDetay: " + (data.hata || data.mesaj));
            return;
        }

        tabloGuncelleCallback();

    } catch (error) {
        console.error('Silme işlemi hatası:', error);
        alert("Bağlantı hatası oluştu.");
    }
}