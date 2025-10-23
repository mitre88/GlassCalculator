#!/usr/bin/env python3
"""
Generador de Ícono para Glass Calculator
Genera un ícono de 1024x1024 con el diseño de la app
Requiere: pip install Pillow
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import math

def create_app_icon():
    # Tamaño del ícono
    size = 1024

    # Crear imagen con fondo transparente
    img = Image.new('RGB', (size, size))
    draw = ImageDraw.Draw(img, 'RGBA')

    # Crear gradiente de fondo (azul)
    for y in range(size):
        # Interpolación de color del gradiente
        ratio = y / size
        r = int(74 + (42 - 74) * ratio)      # 4A -> 2A en hex
        g = int(144 + (96 - 144) * ratio)     # 90 -> 60 en hex
        b = int(226 + (153 - 226) * ratio)    # E2 -> 99 en hex

        draw.rectangle([(0, y), (size, y+1)], fill=(r, g, b))

    # Agregar efecto de brillo en la parte superior
    overlay = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    overlay_draw = ImageDraw.Draw(overlay)

    # Gradiente de brillo blanco
    for y in range(size // 2):
        ratio = y / (size // 2)
        alpha = int(100 * (1 - ratio))  # De 100 a 0
        overlay_draw.rectangle([(0, y), (size, y+1)], fill=(255, 255, 255, alpha))

    # Aplicar overlay
    img = Image.alpha_composite(img.convert('RGBA'), overlay)

    # Agregar texto "ƒ" (símbolo de función)
    try:
        # Intentar usar SF Pro Display si está disponible
        font_size = 500
        font = ImageFont.truetype("/System/Library/Fonts/SFNSDisplay.ttf", font_size)
    except:
        try:
            # Alternativa: usar fuente del sistema
            font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 500)
        except:
            # Si no hay fuentes disponibles, usar la predeterminada
            font = ImageFont.load_default()
            print("⚠️  Usando fuente predeterminada. Para mejor resultado, asegúrate de tener fuentes del sistema.")

    # Dibujar el símbolo "ƒ"
    text = "ƒ"

    # Obtener tamaño del texto para centrarlo
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]

    # Posición centrada
    x = (size - text_width) // 2
    y = (size - text_height) // 2 - 50  # Ajuste fino

    # Dibujar sombra del texto
    shadow_offset = 4
    draw.text((x + shadow_offset, y + shadow_offset), text, font=font, fill=(0, 0, 0, 80))

    # Dibujar texto principal en blanco
    draw.text((x, y), text, font=font, fill=(255, 255, 255, 255))

    # Agregar línea decorativa debajo
    line_width = 300
    line_x = (size - line_width) // 2
    line_y = y + text_height + 40
    draw.rectangle(
        [(line_x, line_y), (line_x + line_width, line_y + 3)],
        fill=(255, 255, 255, 180)
    )

    # Guardar imagen
    output_path = "AppIcon-1024.png"
    img = img.convert('RGB')  # Convertir a RGB para guardar como PNG
    img.save(output_path, 'PNG', quality=100)

    print(f"✅ Ícono generado exitosamente: {output_path}")
    print(f"📐 Tamaño: {size}x{size} píxeles")
    print(f"\n📋 Próximos pasos:")
    print(f"1. Abre el proyecto en Xcode")
    print(f"2. Ve a Assets.xcassets > AppIcon")
    print(f"3. Arrastra {output_path} al espacio de 1024x1024")
    print(f"4. ¡Listo! 🎉")

    return img

if __name__ == "__main__":
    print("🎨 Generando ícono de Glass Calculator...\n")

    try:
        create_app_icon()
    except ImportError:
        print("❌ Error: Pillow no está instalado")
        print("💡 Instala con: pip3 install Pillow")
        print("   o: python3 -m pip install Pillow")
    except Exception as e:
        print(f"❌ Error al generar el ícono: {e}")
        print("\n💡 Alternativas:")
        print("1. Usa el generador online en https://www.appicon.co")
        print("2. Abre AppIconGenerator.swift en Xcode y usa el Preview")
        print("3. Crea el ícono manualmente en Figma o Sketch")
