# 📱 Automatización de Pruebas Mobile en Ruby (iOS + Android)

Este proyecto contiene una suite de pruebas automatizadas para aplicaciones móviles Android e iOS usando **Ruby**, **Cucumber** y **Appium**.

---

## 📦 Requisitos

- Ruby 3.2.x
- Bundler
- Node.js (requerido por Appium)
- Appium (`npm install -g appium`)
- Emulador Android y/o simulador iOS en ejecución
- Appium Inspector (opcional para depuración visual)

---

## 🚀 Instalación

```bash
bundle install
```

---

## 🧪 Ejecutar pruebas manualmente

### ✅ Solo Android

```bash
PLATFORM=android APPIUM_PORT=4723 bundle exec cucumber
```
Ejecutar individual con reporte.
```bash
PLATFORM=android APPIUM_PORT=4723 ruby run_all.rb
```

### ✅ Solo iOS

```bash
PLATFORM=ios APPIUM_PORT=4725 bundle exec cucumber
```
Ejecutar individual con reporte.
```bash
PLATFORM=ios APPIUM_PORT=4725 ruby run_all.rb
```

---

## 🔁 Ejecutar pruebas en paralelo (Android + iOS)

Este proyecto incluye un script (`run_all.rb`) que ejecuta pruebas en ambas plataformas al mismo tiempo.

### Paso 1: Ejecuta Appium en segundo plano

```bash
appium --port 4723 > logs/appium_android.log 2>&1 &
appium --port 4725 > logs/appium_ios.log 2>&1 &
```

### Paso 2: Ejecuta el script

```bash
ruby run_all.rb
```

Este script:
- Lanza dos instancias de Appium
- Ejecuta pruebas de Android e iOS en paralelo
- Registra los resultados en la carpeta `/logs`
- Genera reportes individuales y combinados

---

## 📄 Reportes

- `logs/android.log`: resultado detallado Android
- `logs/ios.log`: resultado detallado iOS
- `logs/Report_Android.html`: reporte HTML para Android
- `logs/Report_iOS.html`: reporte HTML para iOS
- `logs/TestMobile_Report.html`: reporte combinado Android + iOS

---

## 📊 Reporte combinado

El reporte `TestMobile_Report.html` incluye:

- Gráficas por plataforma
- Resumen de features y escenarios
- Detalle de cada escenario
- Visualización de pasos y errores si los hay

---

## 🧹 Limpieza

Para detener Appium:

```bash
killall node
```

O matar procesos específicos:

```bash
lsof -i :4723
kill -9 <PID>
```

---

## ✅ ¡Listo para probar en ambas plataformas a la vez!

Disfruta de una experiencia de testing fluida y detallada en Android e iOS 🚀📱
