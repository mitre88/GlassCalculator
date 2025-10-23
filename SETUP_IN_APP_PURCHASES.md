# Guía Completa: Integrar Compras In-App (StoreKit)

## 📋 Índice
1. [Estado Actual](#estado-actual)
2. [Requisitos Previos](#requisitos-previos)
3. [Configuración en App Store Connect](#configuración-en-app-store-connect)
4. [Testing Local (Simulador)](#testing-local-simulador)
5. [Testing en Dispositivo Real](#testing-en-dispositivo-real)
6. [Publicación en App Store](#publicación-en-app-store)
7. [Troubleshooting](#troubleshooting)

---

## Estado Actual

✅ **¡Buenas noticias!** Tu app ya tiene **TODO el código necesario** para compras in-app:

- ✅ StoreKit 2 integrado
- ✅ Lógica de compras implementada
- ✅ Verificación de transacciones
- ✅ Restauración de compras
- ✅ UI de compra diseñada
- ✅ Modo desarrollo para testing
- ✅ Manejo de errores
- ✅ Configuración StoreKit local (`Configuration.storekit`)

**Solo necesitas**: Configurar App Store Connect y hacer pruebas.

---

## Requisitos Previos

### 1. Apple Developer Account
- **Necesitas**: Cuenta de desarrollador de Apple ($99 USD/año)
- **URL**: https://developer.apple.com/programs/
- **Nota**: Sin cuenta de pago, solo puedes probar localmente en simulador

### 2. Bundle Identifier
El Bundle ID de tu app es: `com.glasscalculator.app`
- Puedes cambiarlo en Xcode: Target → Signing & Capabilities → Bundle Identifier

### 3. Entitlements
Ya configurados en el proyecto:
- ✅ In-App Purchase capability

---

## Configuración en App Store Connect

### Paso 1: Crear la App en App Store Connect

1. **Ve a App Store Connect**
   - URL: https://appstoreconnect.apple.com
   - Inicia sesión con tu Apple Developer Account

2. **Crear Nueva App**
   - Click en **"My Apps"**
   - Click en el botón **"+"** (esquina superior izquierda)
   - Selecciona **"New App"**

3. **Información de la App**
   ```
   Platforms: ✓ iOS
   Name: Glass Calculator
   Primary Language: English (U.S.) o Spanish
   Bundle ID: com.glasscalculator.app
   SKU: glasscalculator-001 (puede ser cualquier string único)
   User Access: Full Access
   ```

4. **Click "Create"**

### Paso 2: Configurar In-App Purchase

1. **En tu app, ve a la sección "In-App Purchases"**
   - Sidebar: Features → In-App Purchases
   - Click en **"Create"** o el botón **"+"**

2. **Selecciona el tipo**
   - Tipo: **Non-Consumable** (compra única permanente)
   - Click **"Next"**

3. **Información del Producto**
   ```
   Reference Name: Glass Calculator Premium
   Product ID: com.glasscalculator.premium
   ```
   ⚠️ **IMPORTANTE**: El Product ID debe ser **EXACTAMENTE** `com.glasscalculator.premium`
   (Este es el ID que usa el código)

4. **Pricing and Availability**
   - Click **"Add Pricing"**
   - Selecciona el precio (recomendado: Tier 2 = $2.99 USD)
   - Disponibilidad: Todos los territorios

5. **Información Localizada** (Inglés)
   ```
   Display Name: Premium Calculator
   Description: Unlock all premium features of Glass Calculator.
                Enjoy the beautiful liquid glass design, dark mode,
                smooth animations, and lifetime access with no ads
                or tracking. One-time purchase, yours forever.
   ```

6. **Información Localizada** (Español) - Opcional
   - Click **"Add Localization"**
   - Idioma: Spanish (Spain) o Spanish (Mexico)
   ```
   Display Name: Calculadora Premium
   Description: Desbloquea todas las funciones premium de Glass Calculator.
                Disfruta del hermoso diseño liquid glass, modo oscuro,
                animaciones suaves y acceso de por vida sin anuncios
                ni rastreo. Compra única, tuya para siempre.
   ```

7. **Review Screenshot** (Solo para revisión de Apple)
   - Necesitas un screenshot de la pantalla de compra
   - Puede ser un screenshot simple del simulador
   - Tamaño: Cualquier screenshot de iPhone

8. **Click "Save"**

### Paso 3: Completar Información Bancaria

⚠️ **Antes de publicar, debes configurar:**

1. **Agreements, Tax, and Banking**
   - En App Store Connect, ve a: Agreements, Tax, and Banking
   - Completa:
     - ✅ Paid Applications Agreement
     - ✅ Tax Forms (W-8BEN o W-9)
     - ✅ Banking Information

---

## Testing Local (Simulador)

✅ **Ya configurado** - Usa el archivo `Configuration.storekit`

### Probar en Simulador

1. **Abrir Xcode**
2. **Configurar StoreKit Testing**
   - Product → Scheme → Edit Scheme
   - Run → Options
   - StoreKit Configuration: Selecciona `Configuration.storekit`

3. **Ejecutar la App** (⌘R)
   - La app iniciará con el premium desbloqueado (modo desarrollo)
   - Para probar compras:
     - Desactiva temporalmente el modo desarrollo en `StoreManager.swift`:
       ```swift
       #if DEBUG
       private let isDevelopmentMode = false  // Cambiar a false
       #else
       ```

4. **Probar el Flujo de Compra**
   - Toca el botón "Premium"
   - Toca "Comprar Premium"
   - Aparecerá un diálogo simulado de StoreKit
   - Selecciona "Subscribe" o "Buy"
   - ✅ La compra se procesa instantáneamente

5. **Probar Restaurar Compra**
   - En el modal de premium, toca "Restaurar Compra"
   - ✅ Debe detectar la compra simulada

### Gestionar Compras de Prueba

En Xcode mientras el simulador corre:
- Debug → StoreKit → Manage Transactions
- Puedes ver y eliminar transacciones de prueba

---

## Testing en Dispositivo Real

Para probar en un iPhone/iPad real **antes de publicar**:

### Opción A: Sandbox Testing (Recomendado)

1. **Crear Sandbox Tester**
   - Ve a App Store Connect
   - Users and Access → Sandbox Testers
   - Click **"+"**
   - Crea un tester:
     ```
     First Name: Test
     Last Name: User
     Email: test.glasscalc@icloud.com (debe ser email único)
     Password: (crea una contraseña segura)
     Country: Tu país
     ```

2. **Configurar el iPhone**
   - Settings → App Store
   - Scroll hasta **"Sandbox Account"**
   - Inicia sesión con el Sandbox Tester creado
   - ⚠️ NO uses tu Apple ID real

3. **Compilar en el iPhone**
   - Conecta tu iPhone
   - En Xcode, selecciona tu iPhone como target
   - Desactiva modo desarrollo temporalmente
   - Run (⌘R)

4. **Probar Compra**
   - Abre la app en tu iPhone
   - Toca "Premium"
   - Toca "Comprar Premium"
   - Aparecerá: **"[Sandbox] Deseas comprar..."**
   - Ingresa la contraseña del Sandbox Tester
   - ✅ Compra procesada

5. **Verificar**
   - La app debe desbloquear premium
   - Cierra y reabre la app
   - ✅ Debe mantenerse desbloqueado

### Opción B: TestFlight (Más Realista)

1. **Subir Build a TestFlight**
   - Archive la app: Product → Archive
   - Distribute App → App Store Connect
   - Sube a TestFlight

2. **Agregar Internal Testers**
   - En App Store Connect → TestFlight
   - Agrega tu email como tester

3. **Instalar TestFlight**
   - Descarga TestFlight de App Store
   - Acepta la invitación
   - Instala Glass Calculator

4. **Probar**
   - Usa Sandbox Tester para compras
   - Funciona como producción real

---

## Publicación en App Store

### Antes de Publicar - Checklist

- [ ] **Información Bancaria** configurada
- [ ] **Acuerdo de Paid Applications** firmado
- [ ] **Tax Forms** completados
- [ ] **In-App Purchase** aprobado por Apple
- [ ] **App Icon** agregado (1024x1024)
- [ ] **Screenshots** preparados (múltiples tamaños)
- [ ] **App Description** escrita
- [ ] **Privacy Policy** creada (si aplica)
- [ ] **Modo Desarrollo** desactivado en producción

### Paso 1: Deshabilitar Modo Desarrollo

En `StoreManager.swift`, asegúrate de que esté así:

```swift
#if DEBUG
private let isDevelopmentMode = true  // Solo true en DEBUG
#else
private let isDevelopmentMode = false
#endif
```

✅ Esto está correcto - el modo desarrollo solo estará activo en DEBUG

### Paso 2: Preparar App Metadata

1. **App Information**
   ```
   Name: Glass Calculator
   Subtitle: Premium Liquid Glass Calculator
   Category: Utilities
   ```

2. **Description** (Inglés)
   ```
   Glass Calculator is a beautifully designed premium calculator
   that combines elegance with functionality. Built with iOS 26's
   native liquid glass design language, it offers a stunning
   calculation experience.

   FEATURES:
   • Liquid Glass Design - Beautiful iOS 26 native design
   • Dark & Light Mode - Seamless theme switching
   • Smooth Animations - Fluid interactions
   • Privacy First - No ads, no tracking, no data collection
   • Lifetime Access - One-time purchase

   Unlock the full experience with a single purchase. No
   subscriptions, no hidden costs, yours forever.
   ```

3. **Keywords**
   ```
   calculator, glass design, premium calculator, math, liquid glass
   ```

4. **Screenshots**
   - Necesitas screenshots de diferentes tamaños de iPhone
   - Usa simuladores: iPhone 15 Pro Max, iPhone 15, iPhone SE
   - Captura:
     - Pantalla principal (calculadora)
     - Modo oscuro
     - Pantalla de compra premium
   - Tool recomendado: https://www.appscreenshot.studio

5. **Preview Video** (Opcional pero recomendado)
   - 15-30 segundos mostrando la app
   - Muestra el diseño liquid glass
   - Muestra el cambio de tema

### Paso 3: Preparar Build

1. **Actualizar Versión**
   - En Xcode: Target → General
   - Version: 1.0
   - Build: 1

2. **Configurar Signing**
   - Signing & Capabilities
   - Team: Tu equipo de desarrollo
   - Signing Certificate: Distribution

3. **Crear Archive**
   - Product → Archive
   - Espera a que compile
   - Window → Organizer se abrirá

4. **Distribuir**
   - Select Archive → Distribute App
   - App Store Connect
   - Upload
   - Espera a que procese (5-30 minutos)

### Paso 4: Enviar a Revisión

1. **En App Store Connect**
   - Ve a tu app
   - Selecciona la versión
   - Completa toda la información requerida

2. **Seleccionar el Build**
   - En "Build", selecciona el build que subiste

3. **Export Compliance**
   - Pregunta: "Does your app use encryption?"
   - Respuesta: **No** (la app no usa criptografía adicional)

4. **Content Rights**
   - Marca que tienes los derechos del contenido

5. **Submit for Review**
   - Click "Submit for Review"
   - Revisión toma 1-3 días típicamente

---

## Precios Recomendados

### Estrategia de Precio

**Recomendado: $2.99 USD (Tier 2)**

Razones:
- ✅ Precio justo para una app premium sin ads
- ✅ No es demasiado caro
- ✅ No es demasiado barato (percepción de calidad)
- ✅ Punto dulce para compras impulsivas

**Alternativas:**
- $1.99 USD (Tier 1) - Si quieres más volumen
- $4.99 USD (Tier 4) - Si tu app tiene más features

### Precios por País

Apple ajusta automáticamente según el país. Ejemplos con Tier 2 ($2.99):
- 🇺🇸 USA: $2.99
- 🇲🇽 México: $59 MXN
- 🇪🇸 España: 2,99 €
- 🇬🇧 UK: £2.99

---

## Troubleshooting

### Problema: "Cannot connect to App Store"
**Solución:**
- Verifica que el Product ID sea exactamente: `com.glasscalculator.premium`
- Espera 2-3 horas después de crear el in-app purchase
- Asegúrate de estar usando Sandbox Tester en dispositivo real

### Problema: "Product not found"
**Solución:**
- El in-app purchase debe estar en estado "Ready to Submit"
- El Bundle ID debe coincidir exactamente
- Espera 24 horas si acabas de crear el producto

### Problema: "Purchase failed"
**Solución:**
- Verifica conexión a internet
- Cierra sesión del Sandbox Tester y vuelve a iniciar
- Verifica que el acuerdo de Paid Apps esté firmado

### Problema: "Receipt verification failed"
**Solución:**
- Normal en sandbox - la verificación es menos estricta
- En producción funciona automáticamente
- No requiere servidor propio (StoreKit 2 lo maneja)

### Problema: "Restore no encuentra compras"
**Solución:**
- Asegúrate de haber hecho al menos una compra
- Usa el MISMO Sandbox Tester
- Espera unos segundos y vuelve a intentar

---

## Código del Producto

El código de tu app usa:
```swift
private let productIds: [String] = ["com.glasscalculator.premium"]
```

⚠️ **CRÍTICO**: El Product ID en App Store Connect DEBE ser exactamente:
```
com.glasscalculator.premium
```

Si cambias el Product ID en App Store Connect, actualiza también el código en `StoreManager.swift`.

---

## Recursos Adicionales

### Documentación Oficial
- [StoreKit Documentation](https://developer.apple.com/documentation/storekit)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)
- [In-App Purchase Programming Guide](https://developer.apple.com/in-app-purchase/)

### Tools Útiles
- [Revenue Cat](https://www.revenuecat.com) - Analytics para IAP (opcional)
- [App Screenshots](https://www.appscreenshot.studio) - Generar screenshots
- [App Store Preview](https://tools.applemediaservices.com/app-store-preview) - Vista previa de listing

### Testing
- [Sandbox Testing Guide](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_in_xcode)
- [TestFlight Guide](https://developer.apple.com/testflight/)

---

## Checklist Rápido

### Antes de Empezar
- [ ] Cuenta de Apple Developer activa
- [ ] App Store Connect accesible
- [ ] Información bancaria lista

### Configuración
- [ ] App creada en App Store Connect
- [ ] In-App Purchase creado con ID: `com.glasscalculator.premium`
- [ ] Precio configurado
- [ ] Descripciones agregadas
- [ ] Screenshot para revisión subido

### Testing
- [ ] Probado en simulador con StoreKit Configuration
- [ ] Sandbox Tester creado
- [ ] Probado en dispositivo real
- [ ] Compra funciona correctamente
- [ ] Restaurar compra funciona

### Pre-Producción
- [ ] Acuerdos firmados
- [ ] Información bancaria completada
- [ ] Tax forms enviados
- [ ] App Icon agregado
- [ ] Screenshots preparados
- [ ] App description completa
- [ ] Modo desarrollo desactivado para producción

### Publicación
- [ ] Archive creado
- [ ] Build subido a App Store Connect
- [ ] Metadata completo
- [ ] Build asignado a versión
- [ ] Enviado a revisión

---

## Contacto y Soporte

Si tienes problemas:
1. Revisa la sección [Troubleshooting](#troubleshooting)
2. Consulta la documentación oficial de Apple
3. Foros de desarrolladores: https://developer.apple.com/forums/

---

**¡Buena suerte con tu app! 🚀**

El código está listo, ahora solo necesitas configurar App Store Connect y publicar.
