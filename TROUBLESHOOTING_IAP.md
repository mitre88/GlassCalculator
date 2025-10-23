# 🔧 Troubleshooting: Error de ID en App Store Connect

## Error: "is not a valid ID for this relationship"

### 🔴 Problema

Estás viendo este error al configurar In-App Purchase:
```
'6754394412' is not a valid ID for this relationship.
(ID: 3a7ecfd4-b059-4675-b8c5-2558e2579921)
```

### ✅ Soluciones

Este error ocurre típicamente al configurar un In-App Purchase en App Store Connect. Aquí están las soluciones:

---

## Solución 1: No Asociar con App ID Interno (Más Común)

### Problema:
App Store Connect está intentando asociar el IAP con un ID interno incorrecto.

### Solución:
Cuando crees el In-App Purchase, **NO necesitas** seleccionar ningún "App" específico en algunos campos.

**Pasos correctos:**

1. **Ve a tu App en App Store Connect**
   - My Apps → Glass Calculator

2. **Features → In-App Purchases → +**

3. **Selecciona Tipo**
   - Non-Consumable

4. **Completa SOLO estos campos básicos:**
   ```
   Reference Name: Glass Calculator Premium
   Product ID: com.glasscalculator.premium
   ```

5. **NO selecciones nada en campos como:**
   - "Apps" (si aparece)
   - "Related Apps"
   - Cualquier dropdown de asociación de apps

6. **Pricing → Add Pricing**
   - Selecciona precio: $2.99 USD (Tier 2)

7. **Localizations**
   - Display Name: Premium Calculator
   - Description: Unlock all premium features...

8. **Review Screenshot**
   - Sube un screenshot simple del iPhone

9. **Save**

---

## Solución 2: Crear App Primero

### Problema:
El In-App Purchase necesita que la app esté creada primero.

### Solución:

**Paso 1: Verifica que tu app esté creada**
```
1. Ve a App Store Connect
2. My Apps
3. ¿Ves "Glass Calculator" en la lista?
```

**Si NO está:**
```
1. Click el botón "+" (esquina superior izquierda)
2. New App
3. Completa:
   - Name: Glass Calculator
   - Primary Language: English
   - Bundle ID: com.glasscalculator.app
   - SKU: glasscalculator-001
   - User Access: Full Access
4. Create
```

**Paso 2: LUEGO crea el In-App Purchase**
- Desde DENTRO de tu app (no desde la página principal)
- Sidebar: Features → In-App Purchases

---

## Solución 3: Bundle ID Correcto

### Problema:
El Bundle ID en Xcode no coincide.

### Verificar:

1. **En Xcode:**
   - Abre el proyecto
   - Select target "GlassCalculator"
   - General tab
   - Bundle Identifier debe ser: `com.glasscalculator.app`

2. **En App Store Connect:**
   - My Apps → Glass Calculator
   - App Information
   - Bundle ID debe ser: `com.glasscalculator.app`

3. **Si no coinciden:**
   - Cambia uno de los dos para que sean iguales
   - Recomendado: Cambiar en Xcode si aún no publicaste

---

## Solución 4: Espera y Reintenta

### Problema:
Glitch temporal en App Store Connect.

### Solución:
```
1. Guarda lo que puedas
2. Cierra sesión de App Store Connect
3. Espera 5-10 minutos
4. Inicia sesión nuevamente
5. Intenta crear el IAP de nuevo
```

---

## Solución 5: Recrear desde Cero

### Si nada funciona:

**Paso 1: Eliminar IAP (si existe)**
```
1. Features → In-App Purchases
2. Encuentra el producto problemático
3. Delete (si es posible)
```

**Paso 2: Crear nuevo IAP con método simple**
```
1. Features → In-App Purchases → +
2. Type: Non-Consumable
3. Product ID: com.glasscalculator.premium2
   (Nota: Agregué "2" al final por si el anterior está bloqueado)
4. Reference Name: Glass Calculator Premium
5. Add Pricing: $2.99
6. Add Localization:
   - Display Name: Premium Calculator
   - Description: Unlock all premium features
7. Screenshot: Cualquier screenshot de la app
8. Save
```

**Paso 3: Actualizar código (solo si usaste otro Product ID)**

Si usaste `com.glasscalculator.premium2`:

En `StoreManager.swift`:
```swift
private let productIds: [String] = ["com.glasscalculator.premium2"]
```

Y en `Configuration.storekit`:
```json
"productID" : "com.glasscalculator.premium2"
```

---

## Solución 6: Acuerdos Pendientes

### Problema:
Los acuerdos de "Paid Applications" no están firmados.

### Solución:
```
1. App Store Connect
2. Agreements, Tax, and Banking
3. Paid Applications Agreement → Request
4. Completa todos los pasos
5. Espera aprobación (puede tardar horas o días)
6. Luego intenta crear el IAP
```

---

## Solución 7: Usar el App ID Correcto

### Problema:
Estás en el lugar equivocado de App Store Connect.

### Solución correcta:

**NO crees el IAP desde:**
- ❌ Home → In-App Purchases (global)

**Créalo desde:**
- ✅ My Apps → **TU APP** → Features → In-App Purchases

**Pasos correctos:**
```
1. App Store Connect
2. My Apps
3. Click en "Glass Calculator" (tu app)
4. Sidebar izquierdo: Features → In-App Purchases
5. Click el botón "+"
6. Ahora crea el IAP
```

---

## Método Alternativo: Usar Xcode

### En lugar de App Store Connect, crea desde Xcode:

**Xcode 15+:**
```
1. Abre tu proyecto en Xcode
2. Select target "GlassCalculator"
3. Signing & Capabilities tab
4. Click "+" → In-App Purchase
5. Esto creará automáticamente la configuración
```

**Luego en App Store Connect:**
- Solo completa los detalles de pricing y descripción

---

## Verificación Final

Después de crear el IAP exitosamente:

### ✅ Checklist:

- [ ] Product ID: `com.glasscalculator.premium` (exacto)
- [ ] Type: Non-Consumable
- [ ] Pricing: $2.99 configurado
- [ ] Localization: Al menos inglés
- [ ] Screenshot subido
- [ ] Status: "Ready to Submit" (amarillo)

### 🧪 Probar:

1. **En Xcode:**
   ```
   Product → Scheme → Edit Scheme
   Run → Options → StoreKit Configuration
   Select: Configuration.storekit
   Run (⌘R)
   ```

2. **En la app:**
   - Toca botón "Premium"
   - Debe mostrar el precio
   - Puedes simular compra

---

## Si Sigues Teniendo Problemas

### Contacta a Apple Developer Support:

1. **Developer Forums:**
   - https://developer.apple.com/forums/
   - Busca tu error específico

2. **Technical Support:**
   - https://developer.apple.com/support/
   - Necesitas cuenta de desarrollador activa

3. **Email:**
   - En App Store Connect: Help → Contact Us

### Información a proporcionar:
```
- Error exacto: '6754394412' is not a valid ID...
- ID: 3a7ecfd4-b059-4675-b8c5-2558e2579921
- Bundle ID: com.glasscalculator.app
- Product ID: com.glasscalculator.premium
- Account: [tu email de developer]
```

---

## Workaround Temporal: Usar Otro Product ID

Si necesitas continuar urgentemente:

### Paso 1: En App Store Connect
```
Crea IAP con un ID ligeramente diferente:
- com.glasscalculator.premium.v1
- com.glasscalculator.calculator.premium
- com.glasscalculator.unlockpremium
```

### Paso 2: Actualizar código

En `StoreManager.swift`:
```swift
private let productIds: [String] = ["com.glasscalculator.premium.v1"]
```

En `Configuration.storekit`:
```json
"productID" : "com.glasscalculator.premium.v1"
```

### Paso 3: Probar
```bash
./verify_iap_setup.sh
```

---

## Notas Importantes

⚠️ **Antes de publicar:**
- El Product ID NO se puede cambiar después de publicar
- Elige bien el ID final
- Prueba exhaustivamente antes de submit

✅ **Durante desarrollo:**
- Puedes cambiar IDs cuantas veces quieras
- Solo actualiza el código para que coincida
- Vuelve a probar

🔄 **Si cambias el Product ID:**
1. Actualiza `StoreManager.swift`
2. Actualiza `Configuration.storekit`
3. Run el script: `./verify_iap_setup.sh`
4. Limpia build: Shift+Cmd+K
5. Rebuild: Cmd+B

---

## Resumen

**Causa más común:**
- Intentar asociar el IAP con un ID de app incorrecto

**Solución más común:**
1. Crear la app PRIMERO en App Store Connect
2. LUEGO crear el IAP DESDE dentro de esa app
3. No llenar campos opcionales de asociación

**Si nada funciona:**
- Usa un Product ID alternativo temporalmente
- Contacta a Apple Developer Support
- Intenta después de 24 horas

---

¿Sigue sin funcionar? Proporciona más detalles:
- ¿En qué paso exactamente ves el error?
- ¿Ya creaste la app en App Store Connect?
- ¿Qué campos estás llenando cuando aparece el error?
