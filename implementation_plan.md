# Page-Specific Sorting and Filtering Migration Plan

The goal is to replace the centralized "Sorgular" (Queries) system with inline sorting and filtering on the respective pages for each entity. The `sorgular.html` page will be entirely removed. 

## Open Questions
- Should the specific `api/raporlar/...` routes in `backend.py` be completely deleted, since the functionality is being moved to the main `GET` requests? The plan assumes we will remove the old unused report routes to keep the codebase clean.

## Proposed Changes

### Frontend HTML Files
Remove the `Sorgular` link from the navbar across all HTML pages. Make specific table headers clickable for sorting and add the required filter input fields.

#### [MODIFY] `main.html` (Ürünler)
- Remove `sorgular.html` from navbar.
- Add "En Az" and "En Çok" price filter inputs.
- Make `Birim Fiyat`, `Kategori ID`, and `Ürün ID` table headers clickable (sorting).

#### [MODIFY] `kategori.html`
- Remove `sorgular.html` from navbar.
- Make `Kategori ID` table header clickable.

#### [MODIFY] `depo.html`
- Remove `sorgular.html` from navbar.
- Make `Toplam Kapasite` and `Depo ID` table headers clickable.

#### [MODIFY] `personel.html`
- Remove `sorgular.html` from navbar.
- Add a search input for "Çalıştığı Depo ID".
- Make `Personel ID` table header clickable.

#### [MODIFY] `tedarik.html`
- Remove `sorgular.html` from navbar.
- Make `Tedarikçi ID` table header clickable.

#### [MODIFY] `stok.html`
- Remove `sorgular.html` from navbar.
- Make `Hareket ID` and `İşlem Tarihi` table headers clickable.

#### [DELETE] `sorgular.html`
- Completely remove this file as per requirements.

---

### Frontend Logic
Update the central frontend logic to handle column sorting state and filter parameters.

#### [MODIFY] `script.js`
- Delete the entire "7. SORGULAR VE RAPORLAR SAYFASI" section at the end of the file.
- For each page section (Ürünler, Kategoriler, vb.):
  - Add a state object for sorting: `let currentSortColumn = ''; let currentSortOrder = 'DESC';`
  - Update the `verileriGetir()` function to accept sorting (`sort_by`, `order`) and filtering arguments, appending them to the API URL.
  - Implement a `sortTable(kolonAdi)` function that toggles the sort order (DESC -> ASC -> DESC) and triggers `verileriGetir()`.
  - Add event listeners for the new filter inputs (Price filters in `main.html` and Depo ID filter in `personel.html`) to trigger `verileriGetir()`.

---

### Backend Logic
Extend the main `GET` endpoints to accept and safely apply SQL sorting (`ORDER BY`) and filtering (`WHERE`) logic.

#### [MODIFY] `backend.py`
- Modify `GET /api/urunler` to accept `sort_by`, `order`, `minFiyat`, and `maxFiyat`.
- Modify `GET /api/kategoriler` to accept `sort_by` and `order`.
- Modify `GET /api/depolar` to accept `sort_by` and `order`.
- Modify `GET /api/personel` to accept `sort_by`, `order`, and `depo_id` parameter.
- Modify `GET /api/tedarikciler` to accept `sort_by` and `order`.
- Modify `GET /api/stokhareketleri` to accept `sort_by` and `order`.
- Safely validate `sort_by` values against allowed columns to prevent SQL injection.
- (Optional but recommended) Remove the unused `/api/raporlar/...` endpoints since their functionality is now redundant.

## Verification Plan

### Automated Tests
- Run the python backend and check for syntax errors.

### Manual Verification
- Open `main.html` and verify the new Price filters work correctly. Click the `Birim Fiyat`, `Kategori ID` and `Ürün ID` headers and check if sorting toggles correctly.
- Verify `Depo ID` search works in `personel.html`.
- Confirm `sorgular.html` is completely removed from the project and navigation menus.
