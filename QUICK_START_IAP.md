# 🚀 Quick Start: Configurar Compras In-App

## 📦 Lo que ya tienes (100% listo)

✅ Todo el código de StoreKit
✅ UI de compras diseñada
✅ Lógica de verificación
✅ Restauración de compras
✅ Manejo de errores

## 🎯 Lo que necesitas hacer

### Opción A: Testing Local (5 minutos) ⚡

**Para probar SIN cuenta de desarrollador:**

1. **Abre Xcode**
2. **Product → Scheme → Edit Scheme**
3. **Run → Options → StoreKit Configuration**
4. **Selecciona: `Configuration.storekit`**
5. **Run (⌘R)**

✅ ¡Listo! Ya puedes probar compras en el simulador

---

### Opción B: Publicar en App Store (Completo) 📱

#### Paso 1: App Store Connect (15 min)

**Crear la App:**
```
1. Ve a: https://appstoreconnect.apple.com
2. My Apps → + → New App
3.
   Name: Glass Calculator
   Bundle ID: com.glasscalculator.app
   SKU: glasscalculator-001
```

**Crear In-App Purchase:**
```
1. Features → In-App Purchases → +
2. Type: Non-Consumable
3.
   Product ID: com.glasscalculator.premium  ⚠️ EXACTO
   Name: Glass Calculator Premium
   Price: $2.99 (Tier 2)
4. Save
```

#### Paso 2: Banking & Tax (10 min)

```
App Store Connect → Agreements, Tax, and Banking
1. ✅ Paid Applications Agreement
2. ✅ Tax Form (W-8BEN si no eres de USA)
3. ✅ Banking Info
```

#### Paso 3: Testing (10 min)

**Crear Sandbox Tester:**
```
1. App Store Connect → Users → Sandbox Testers → +
2. Email: test.calculator@icloud.com
3. Password: (crea una segura)
```

**Probar en iPhone:**
```
1. iPhone: Settings → App Store → Sandbox Account
2. Inicia sesión con el tester
3. Compila la app en tu iPhone
4. Prueba la compra
```

#### Paso 4: Publicar (30 min)

**Preparar Build:**
```
1. Xcode → Product → Archive
2. Distribute → App Store Connect
3. Upload
```

**Metadata:**
```
1. Screenshots (3-5 capturas)
2. Description
3. Keywords: calculator, premium, math
4. Select Build
5. Submit for Review
```

⏱️ **Revisión de Apple**: 1-3 días

---

## 💰 Precio Recomendado

**$2.99 USD** (Tier 2)

Por qué:
- ✅ Precio justo para app premium sin ads
- ✅ Punto dulce para conversión
- ✅ Equivalente en otros países:
  - México: $59 MXN
  - España: 2,99 €

---

## 🆘 Problemas Comunes

### "Cannot connect to App Store"
```bash
✅ Solución:
- Espera 2-3 horas después de crear el IAP
- Verifica el Product ID: com.glasscalculator.premium
```

### "No products available"
```bash
✅ Solución:
- El IAP debe estar en "Ready to Submit"
- Bundle ID debe coincidir
- Espera 24 horas si es nuevo
```

### "Purchase failed"
```bash
✅ Solución:
- Verifica conexión a internet
- Reinicia sesión del Sandbox Tester
- Verifica acuerdo de Paid Apps firmado
```

---

## 📋 Checklist Mínimo

Para publicar en App Store necesitas:

**Requisitos Básicos:**
- [ ] Apple Developer Account ($99/año)
- [ ] App Store Connect configurado
- [ ] Banking & Tax info completa

**En App Store Connect:**
- [ ] App creada
- [ ] IAP: `com.glasscalculator.premium` creado
- [ ] Precio: $2.99 configurado

**En Xcode:**
- [ ] Bundle ID configurado
- [ ] Signing & Capabilities OK
- [ ] App Icon agregado (ya lo tienes ✅)

**Para Submit:**
- [ ] 3-5 Screenshots
- [ ] App Description
- [ ] Build subido

---

## 🎓 Tutorial Paso a Paso (Video)

### Testing Local (Simulador)

```
1. Abre Xcode
2. Product → Scheme → Edit Scheme
3. Run → Options
4. StoreKit Configuration → Configuration.storekit
5. Click Close
6. Run (⌘R)
7. En la app: Toca "Premium"
8. Toca "Comprar Premium"
9. En el diálogo: "Subscribe" o "Buy"
10. ✅ ¡Funciona!
```

### Gestionar Transacciones de Prueba

```
Mientras el simulador corre:
Debug → StoreKit → Manage Transactions
```

Aquí puedes:
- Ver transacciones
- Eliminar compras
- Probar restaurar

---

## 🔗 Links Importantes

**Esenciales:**
- [App Store Connect](https://appstoreconnect.apple.com)
- [Apple Developer](https://developer.apple.com)

**Documentación:**
- [StoreKit Docs](https://developer.apple.com/documentation/storekit)
- [IAP Guide](https://developer.apple.com/in-app-purchase/)

**Testing:**
- [Sandbox Testing](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_in_xcode)
- [TestFlight Guide](https://developer.apple.com/testflight/)

**Tools:**
- [Screenshot Studio](https://www.appscreenshot.studio) - Screenshots
- [App Store Preview](https://tools.applemediaservices.com) - Preview

---

## 💡 Tips

### Para Maximizar Ventas

1. **Precio inicial bajo** ($2.99) para generar reviews
2. **Buenas screenshots** mostrando el diseño liquid glass
3. **Keywords relevantes**: calculator, premium, glass design
4. **App Store Optimization**:
   - Usa el espacio del subtitle
   - Menciona "No ads, no subscription"
   - Destaca el diseño único

### Para Testing

1. **Siempre usa Sandbox Testers** en dispositivos reales
2. **NUNCA** uses tu Apple ID real para testing
3. **Prueba restaurar** después de reinstalar
4. **Verifica** que funcione sin internet (debe usar cache)

### Después de Publicar

1. **Monitorea reviews** primeros días
2. **Responde a usuarios** rápidamente
3. **Actualiza regularmente** (cada 2-3 meses)
4. **Analytics**: Checa conversión de compras

---

## ⏱️ Timeline Estimado

**Solo Testing (Simulador):**
- ⚡ 5 minutos

**Testing Completo (Dispositivo Real):**
- 🕐 30 minutos

**Primera Publicación:**
- 📝 Setup inicial: 1 hora
- 🎨 Screenshots y metadata: 1 hora
- ⏳ Revisión de Apple: 1-3 días
- 📱 **Total: 1-4 días**

**Actualizaciones Futuras:**
- 📦 Nuevo build: 30 minutos
- ⏳ Revisión: 1-2 días

---

## 🎉 Siguiente Paso

**Si solo quieres probar:**
→ Ve a [Testing Local](#opción-a-testing-local-5-minutos-)

**Si quieres publicar:**
→ Ve a [SETUP_IN_APP_PURCHASES.md](SETUP_IN_APP_PURCHASES.md)

---

**¿Dudas?** Revisa la guía completa en `SETUP_IN_APP_PURCHASES.md`

¡Tu app está lista para vender! 💰🚀
