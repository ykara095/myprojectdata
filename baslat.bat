@echo off
chcp 65001 > nul
echo ==========================================
echo       Akilli Stok Yonetimi - Backend      
echo ==========================================
echo.
echo Sunucu baslatiliyor... Lutfen bekleyin.

if exist venv\bin\activate.bat (
    call venv\bin\activate.bat
) else if exist venv\Scripts\activate.bat (
    call venv\Scripts\activate.bat
) else (
    echo [HATA] Sanal ortam (venv) bulunamadi! Lutfen README dosyasindaki kurulum adimlarini izleyin.
    pause
    exit /b 1
)

python backend.py
pause
