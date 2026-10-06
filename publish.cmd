@echo off
chcp 65001 >nul
cd /d "%~dp0"
set LOG=deploy-log.txt
echo ===== %date% %time% ===== > %LOG%
echo Deploying to Firebase ...
call firebase deploy --project hajj-catering-urcc --non-interactive >> %LOG% 2>&1
echo EXIT %ERRORLEVEL% >> %LOG%
type %LOG%
echo.
echo Site: https://hajj-catering-urcc.web.app
timeout /t 20
