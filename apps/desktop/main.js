// تطبيق سطح المكتب: نافذة بتفتح موقع النظام، فأي تحديث على الموقع بيوصل للتطبيق تلقائيًا
const { app, BrowserWindow, shell } = require('electron');
const path = require('path');
const URL_APP = 'https://hajj-catering-urcc.web.app';

if (!app.requestSingleInstanceLock()) app.quit();

function createWindow() {
  const win = new BrowserWindow({
    width: 1280, height: 820, minWidth: 380,
    title: 'إعاشة الحجاج',
    icon: path.join(__dirname, 'icon.png'),
    autoHideMenuBar: true,
    backgroundColor: '#F3F5F2',
    webPreferences: { contextIsolation: true, sandbox: true }
  });
  win.webContents.setUserAgent(win.webContents.getUserAgent() + ' HajjCateringApp');
  win.webContents.setWindowOpenHandler(({ url }) => {
    if (url.startsWith(URL_APP) || url.startsWith('blob:') || url.startsWith('about:blank')) return { action: 'allow' };
    shell.openExternal(url); return { action: 'deny' };
  });
  win.webContents.on('will-navigate', (e, url) => {
    if (!url.startsWith(URL_APP)) { e.preventDefault(); shell.openExternal(url); }
  });
  win.loadURL(URL_APP);
}

app.on('second-instance', () => { const w = BrowserWindow.getAllWindows()[0]; if (w) { if (w.isMinimized()) w.restore(); w.focus(); } });
app.whenReady().then(createWindow);
app.on('window-all-closed', () => app.quit());
