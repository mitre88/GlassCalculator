#!/bin/bash

# Script para verificar que la configuración de In-App Purchases esté correcta
# Glass Calculator - IAP Setup Verification

echo "🔍 Verificando configuración de In-App Purchases..."
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SUCCESS=0
WARNINGS=0
ERRORS=0

# Función para check
check_success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((SUCCESS++))
}

check_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

check_error() {
    echo -e "${RED}❌ $1${NC}"
    ((ERRORS++))
}

echo "📦 1. Verificando archivos del proyecto..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check StoreManager.swift
if [ -f "GlassCalculator/StoreManager.swift" ]; then
    check_success "StoreManager.swift existe"

    # Check Product ID
    if grep -q "com.glasscalculator.premium" "GlassCalculator/StoreManager.swift"; then
        check_success "Product ID correcto: com.glasscalculator.premium"
    else
        check_error "Product ID no encontrado o incorrecto"
    fi
else
    check_error "StoreManager.swift no encontrado"
fi

# Check Configuration.storekit
if [ -f "GlassCalculator/Configuration.storekit" ]; then
    check_success "Configuration.storekit existe"

    # Verify product in storekit
    if grep -q "com.glasscalculator.premium" "GlassCalculator/Configuration.storekit"; then
        check_success "Product configurado en StoreKit testing"
    else
        check_warning "Product no configurado en StoreKit testing"
    fi
else
    check_warning "Configuration.storekit no encontrado (opcional para testing)"
fi

# Check PremiumPurchaseView.swift
if [ -f "GlassCalculator/PremiumPurchaseView.swift" ]; then
    check_success "PremiumPurchaseView.swift existe"
else
    check_error "PremiumPurchaseView.swift no encontrado"
fi

echo ""
echo "📱 2. Verificando configuración del proyecto..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check project file
if [ -f "GlassCalculator.xcodeproj/project.pbxproj" ]; then
    check_success "Proyecto Xcode encontrado"

    # Check Bundle ID
    if grep -q "com.glasscalculator.app" "GlassCalculator.xcodeproj/project.pbxproj"; then
        check_success "Bundle ID configurado: com.glasscalculator.app"
    else
        check_warning "Bundle ID podría necesitar ajuste"
    fi
else
    check_error "Proyecto Xcode no encontrado"
fi

# Check Info.plist
if [ -f "GlassCalculator/Info.plist" ]; then
    check_success "Info.plist existe"
else
    check_warning "Info.plist no encontrado"
fi

echo ""
echo "🎨 3. Verificando assets..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check App Icon
if [ -f "GlassCalculator/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png" ]; then
    check_success "App Icon (1024x1024) presente"
else
    check_warning "App Icon no encontrado - necesario para App Store"
fi

echo ""
echo "🔧 4. Verificando modo de desarrollo..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check development mode configuration
if grep -q "#if DEBUG" "GlassCalculator/StoreManager.swift" && \
   grep -q "private let isDevelopmentMode = true" "GlassCalculator/StoreManager.swift"; then
    check_success "Modo desarrollo correctamente configurado"
    echo "   ℹ️  En DEBUG: Premium desbloqueado automáticamente"
    echo "   ℹ️  En Release: Requiere compra real"
else
    check_warning "Configuración de modo desarrollo no encontrada"
fi

echo ""
echo "📚 5. Verificando documentación..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check documentation files
if [ -f "SETUP_IN_APP_PURCHASES.md" ]; then
    check_success "Guía completa de IAP presente"
else
    check_warning "Guía de IAP no encontrada"
fi

if [ -f "QUICK_START_IAP.md" ]; then
    check_success "Guía rápida de IAP presente"
else
    check_warning "Guía rápida no encontrada"
fi

if [ -f "README.md" ]; then
    check_success "README.md presente"
else
    check_warning "README.md no encontrado"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 RESUMEN"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}✅ Exitosos: $SUCCESS${NC}"
echo -e "${YELLOW}⚠️  Advertencias: $WARNINGS${NC}"
echo -e "${RED}❌ Errores: $ERRORS${NC}"
echo ""

if [ $ERRORS -eq 0 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}🎉 ¡TODO LISTO PARA IN-APP PURCHASES!${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📋 PRÓXIMOS PASOS:"
    echo ""
    echo "1️⃣  Testing Local (Simulador):"
    echo "   • Xcode → Product → Scheme → Edit Scheme"
    echo "   • Run → Options → StoreKit Configuration"
    echo "   • Selecciona: Configuration.storekit"
    echo "   • Run (⌘R)"
    echo ""
    echo "2️⃣  Testing en Dispositivo Real:"
    echo "   • Crea Sandbox Tester en App Store Connect"
    echo "   • Settings → App Store → Sandbox Account"
    echo "   • Compila en tu iPhone y prueba"
    echo ""
    echo "3️⃣  Publicar en App Store:"
    echo "   • Lee: SETUP_IN_APP_PURCHASES.md"
    echo "   • Configura App Store Connect"
    echo "   • Crea el In-App Purchase"
    echo "   • Submit para revisión"
    echo ""
    echo "💡 Quick Start: Lee QUICK_START_IAP.md"
    echo ""
else
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${RED}⚠️  ERRORES ENCONTRADOS${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Por favor corrige los errores antes de continuar."
    echo ""
fi

if [ $WARNINGS -gt 0 ] && [ $ERRORS -eq 0 ]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${YELLOW}ℹ️  ADVERTENCIAS ENCONTRADAS${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Las advertencias no bloquean el desarrollo,"
    echo "pero deberían resolverse antes de publicar."
    echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔗 RECURSOS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📖 Guía completa: SETUP_IN_APP_PURCHASES.md"
echo "⚡ Quick Start: QUICK_START_IAP.md"
echo "🌐 App Store Connect: https://appstoreconnect.apple.com"
echo "📚 StoreKit Docs: https://developer.apple.com/storekit"
echo ""
