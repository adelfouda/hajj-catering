@echo off
chcp 65001 >nul
cd /d "%~dp0"
set P=hajj-catering-urcc
set LOG=deploy-log.txt
echo ===== %date% %time% ===== > %LOG%
echo [1/6] Creating Firebase project %P% ...
call firebase projects:create %P% --display-name "Hajj Catering" >> %LOG% 2>&1
echo [2/6] Creating Firestore database ...
call firebase firestore:databases:create "(default)" --location me-central2 --project %P% >> %LOG% 2>&1
echo [3/6] Creating web app ...
call firebase apps:create web "Hajj Catering" --project %P% >> %LOG% 2>&1
echo [4/6] Writing firebase-config.js ...
call firebase apps:sdkconfig web --project %P% --out firebase-sdk.json >> %LOG% 2>&1
powershell -NoProfile -Command "$j=Get-Content -Raw -Encoding UTF8 firebase-sdk.json|ConvertFrom-Json; if($j.sdkConfig){$j=$j.sdkConfig}; 'window.FIREBASE_CONFIG = '+($j|ConvertTo-Json -Compress)+';' | Set-Content -Encoding UTF8 firebase-config.js" >> %LOG% 2>&1
echo [5/6] Creating hosting site ...
call firebase hosting:sites:create %P% --project %P% >> %LOG% 2>&1
echo [6/6] Deploying ...
call firebase deploy --project %P% >> %LOG% 2>&1
echo DONE >> %LOG%
type %LOG%
echo.
echo Site: https://%P%.web.app
pause
