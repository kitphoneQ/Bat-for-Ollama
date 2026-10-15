@echo off
setlocal
title MerDot 1.0 Kurulumu
cd /d "%~dp0"

echo ============================
echo       MERDOT 1.0 KURULUMU
echo ============================
echo.

if not exist "%~dp0MerDot.exe" (
    echo HATA: MerDot.exe bulunamadi!
    echo MerDot.exe dosyasini bu BAT dosyasinin yanina koy.
    pause
    exit /b 1
)

where winget >nul 2>&1
if errorlevel 1 (
    echo HATA: winget bulunamadi.
    echo Ollama'yi buradan kur:
    echo https://ollama.com/download/windows
    pause
    exit /b 1
)

where ollama >nul 2>&1
if errorlevel 1 (
    echo Ollama kuruluyor...
    winget install --id Ollama.Ollama -e
    if errorlevel 1 (
        echo Ollama kurulumu basarisiz oldu.
        pause
        exit /b 1
    )
)

set "OLLAMA=%LOCALAPPDATA%\Programs\Ollama\ollama.exe"

if not exist "%OLLAMA%" (
    for /f "delims=" %%I in ('where ollama 2^>nul') do (
        set "OLLAMA=%%I"
        goto :found
    )
)

:found
if not exist "%OLLAMA%" (
    echo Ollama bulunamadi. Bilgisayari yeniden baslatip dene.
    pause
    exit /b 1
)

echo Ollama kontrol ediliyor...
curl.exe -fsS http://localhost:11434/api/tags >nul 2>&1
if errorlevel 1 (
    echo Ollama baslatiliyor...
    start "Ollama Server" /min "%OLLAMA%" serve
    timeout /t 10 /nobreak >nul
)

echo.
echo Llama 3.2 modeli indiriliyor veya kontrol ediliyor...
"%OLLAMA%" pull llama3.2

if errorlevel 1 (
    echo Model indirilemedi. Internet baglantisini kontrol et.
    pause
    exit /b 1
)

echo.
echo Kurulum tamamlandi! MerDot aciliyor...
start "" "%~dp0MerDot.exe"
exit /b 0
