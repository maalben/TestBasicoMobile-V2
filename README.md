# TestBasicoMobile

Este proyecto contiene una suite de pruebas automatizadas para aplicaciones móviles Android e iOS usando Ruby, Cucumber y Appium.

## 📦 Requisitos

- Ruby (versión recomendada 3.2.x)
- Bundler
- Appium (`npm install -g appium`)
- Emulador Android o simulador iOS funcionando
- Appium Inspector (opcional, para depuración)

## 🚀 Instalación

```bash
bundle install
```

## 🧪 Ejecutar pruebas

### Solo Android

```bash
PLATFORM=android APPIUM_PORT=4723 bundle exec cucumber
```

### Solo iOS

```bash
PLATFORM=ios APPIUM_PORT=4725 bundle exec cucumber
```

## 🔁 Ejecutar pruebas en paralelo (Android + iOS)

Este proyecto incluye un script para ejecutar pruebas en ambas plataformas al mismo tiempo.

### Paso 1: Ejecuta Appium en dos terminales o en segundo plano

```bash
appium --port 4723 > android_log.txt 2>&1 &
appium --port 4725 > ios_log.txt 2>&1 &
```

### Paso 2: Ejecuta el script de pruebas

```bash
ruby run_all.rb
```

El script:
- Ejecuta pruebas Android e iOS en paralelo
- Guarda logs en la carpeta `/logs`

### Ver resultados

- `logs/android.log`: resultados de pruebas Android
- `logs/ios.log`: resultados de pruebas iOS
- `logs/appium_android.log`: log del servidor Appium para Android
- `logs/appium_ios.log`: log del servidor Appium para iOS

## 🧹 Limpieza

Puedes detener Appium manualmente si es necesario o matar procesos con:

```bash
killall node
```

---

¡Listo para probar en ambas plataformas a la vez! 🚀