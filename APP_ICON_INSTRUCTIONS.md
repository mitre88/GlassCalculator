# Instrucciones para Crear el Ícono de la App

## Diseño del Ícono

El ícono de Glass Calculator tiene:
- **Fondo**: Gradiente azul (del #4A90E2 al #2A6099)
- **Símbolo**: "ƒ" (función matemática) en blanco
- **Estilo**: Liquid glass con efecto de brillo
- **Tamaño**: 1024x1024 píxeles

## Método 1: Usar Figma o Sketch (Recomendado)

### Paso 1: Crear el Diseño
1. Crea un nuevo documento de **1024x1024 píxeles**
2. Agrega un gradiente con estos colores:
   - Superior izquierda: `#4A90E2`
   - Inferior derecha: `#2A6099`
3. Agrega el símbolo "ƒ" en fuente SF Pro Display (o similar)
   - Tamaño: ~500px
   - Color: Blanco (#FFFFFF)
   - Peso: Ultra Light o Thin
   - Centrado
4. Agrega un gradiente de brillo blanco en la parte superior (20% opacidad)
5. Redondea las esquinas (22.37% del tamaño = ~229px de radio)

### Paso 2: Exportar
1. Exporta como PNG a 1024x1024 píxeles
2. Guarda el archivo como `AppIcon-1024.png`

## Método 2: Usar el Generador Programático

### Opción A: Preview en Xcode
1. Abre `AppIconGenerator.swift` en Xcode
2. Activa el Preview (Canvas) presionando `⌥⌘↩` (Option + Command + Enter)
3. Espera a que el preview se cargue
4. Haz clic derecho en el ícono grande
5. Selecciona "Export Preview" o toma un screenshot
6. Guarda como PNG

### Opción B: Código Swift
```swift
// Ejecuta esto en un Playground o añádelo temporalmente a la app

import SwiftUI

let iconView = AppIconView(size: 1024)
let renderer = ImageRenderer(content: iconView)
renderer.scale = 3.0

if let image = renderer.uiImage {
    // Guarda la imagen
    let data = image.pngData()
    // Guarda 'data' en un archivo
}
```

## Método 3: Herramientas Online

### Opción A: Crear desde Cero
1. Ve a [Canva](https://www.canva.com) o [Figma](https://www.figma.com)
2. Crea un diseño de 1024x1024
3. Sigue las especificaciones de diseño arriba
4. Exporta como PNG

### Opción B: Generar Todos los Tamaños
Una vez que tengas tu ícono de 1024x1024:

1. Ve a [AppIcon.co](https://www.appicon.co)
2. Sube tu imagen
3. Descarga el set completo
4. Reemplaza la carpeta `AppIcon.appiconset` en tu proyecto

## Método 4: Usar SF Symbols (Rápido para Testing)

Para pruebas rápidas, puedes usar un símbolo temporal:

1. Abre Xcode
2. Ve a `Assets.xcassets > AppIcon`
3. Por ahora, usa el ícono predeterminado de Xcode

## Añadir el Ícono al Proyecto

Una vez que tengas tu ícono de 1024x1024:

### Paso 1: Abrir Assets
1. Abre el proyecto en Xcode
2. Navega a: `GlassCalculator/Assets.xcassets/AppIcon.appiconset`

### Paso 2: Añadir la Imagen
1. Arrastra tu archivo `AppIcon-1024.png` al espacio "1024x1024"
2. Xcode generará automáticamente todos los tamaños

### Paso 3: Verificar
1. Compila la app
2. Verifica que el ícono aparezca en el Home Screen del simulador

## Especificaciones Técnicas

### Tamaños Requeridos por iOS
- **1024x1024**: App Store (requerido)
- Los demás tamaños los genera Xcode automáticamente

### Formato
- **Tipo**: PNG
- **Color**: RGB (no CMYK)
- **Transparencia**: No permitida (usar fondo sólido)
- **Perfil de color**: sRGB

### Esquinas
- iOS redondea automáticamente las esquinas
- No agregues esquinas redondeadas tú mismo
- Radio teórico: 22.37% del tamaño del ícono

## Diseño Alternativo: Versión Simple

Si prefieres algo más simple, puedes usar:
- Fondo degradado azul/morado
- Símbolo "123" o "="
- Estilo minimalista

## Testing

Para probar cómo se ve tu ícono:

1. Compila la app en el simulador
2. Ve al Home Screen
3. Verifica:
   - ✅ El ícono se ve claro y legible
   - ✅ Los colores son vibrantes
   - ✅ El símbolo es reconocible
   - ✅ No hay bordes extraños

## Recursos Útiles

- [Apple HIG - App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [AppIcon.co](https://www.appicon.co) - Generador de íconos
- [SF Symbols](https://developer.apple.com/sf-symbols/) - Símbolos de Apple
- [Figma](https://www.figma.com) - Herramienta de diseño gratuita

## Problemas Comunes

### El ícono no aparece
- Verifica que la imagen sea exactamente 1024x1024
- Asegúrate de que sea PNG
- Limpia el build (⇧⌘K) y vuelve a compilar

### El ícono se ve borroso
- Usa PNG, no JPG
- Asegúrate de que sea 1024x1024, no menor
- Verifica que la escala sea @1x (no @2x o @3x)

### Los colores se ven diferentes
- Usa perfil de color sRGB
- No uses transparencias
- Verifica en dispositivo real, no solo simulador
