//
//  AppIconGenerator.swift
//  GlassCalculator
//
//  Generador de ícono de app programático
//  Este archivo puede usarse para generar el ícono de la app
//

import SwiftUI

// MARK: - App Icon Preview View
struct AppIconView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            // Fondo con gradiente
            LinearGradient(
                colors: [
                    Color(hex: "4A90E2"),
                    Color(hex: "357ABD"),
                    Color(hex: "2A6099")
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Símbolo de función (ƒ) o calculadora
            VStack(spacing: size * 0.08) {
                // Símbolo matemático elegante
                Text("ƒ")
                    .font(.system(size: size * 0.5, weight: .ultraLight, design: .serif))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.9)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                // Pequeña línea decorativa
                Rectangle()
                    .fill(.white.opacity(0.6))
                    .frame(width: size * 0.3, height: 2)
                    .cornerRadius(1)
            }

            // Efecto de brillo en la parte superior (liquid glass)
            LinearGradient(
                colors: [
                    Color.white.opacity(0.4),
                    Color.white.opacity(0.1),
                    Color.clear
                ],
                startPoint: .top,
                endPoint: .center
            )
            .blendMode(.overlay)
        }
        .frame(width: size, height: size)
        .cornerRadius(size * 0.2237) // Radio de esquina estándar de iOS
        .overlay {
            RoundedRectangle(cornerRadius: size * 0.2237)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.3),
                            Color.white.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: size * 0.01
                )
        }
        .shadow(color: .black.opacity(0.3), radius: size * 0.05, x: 0, y: size * 0.02)
    }
}

// MARK: - Preview para visualizar el ícono
struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            AppIconView(size: 1024) // Tamaño completo para exportar
                .frame(width: 300, height: 300)

            HStack(spacing: 20) {
                AppIconView(size: 180)
                AppIconView(size: 120)
                AppIconView(size: 80)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
    }
}

// MARK: - Función auxiliar para generar y guardar el ícono
#if DEBUG
extension AppIconView {
    @MainActor
    func generateIcon(size: CGFloat) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = 3.0 // Para retina displays
        return renderer.uiImage
    }
}
#endif

/*
INSTRUCCIONES PARA GENERAR EL ÍCONO:

1. MÉTODO AUTOMÁTICO (Recomendado):
   - Abre este archivo en Xcode
   - Ve al Preview (Canvas) en el lado derecho
   - Haz clic derecho en el ícono grande de 1024x1024
   - Selecciona "Save Preview to File" o toma un screenshot
   - Guarda la imagen como PNG

2. EXPORTAR EN ALTA RESOLUCIÓN:
   - Ejecuta el siguiente código en un Playground o en la app:

   let iconView = AppIconView(size: 1024)
   if let image = iconView.generateIcon(size: 1024) {
       // Guarda la imagen usando UIImageWriteToSavedPhotosAlbum o similar
       UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
   }

3. AÑADIR AL PROYECTO:
   - Una vez que tengas la imagen de 1024x1024:
   - Abre el proyecto en Xcode
   - Ve a Assets.xcassets > AppIcon
   - Arrastra tu imagen de 1024x1024 al espacio designado
   - Xcode generará automáticamente todos los tamaños necesarios

4. ALTERNATIVA ONLINE:
   - Ve a: https://www.appicon.co
   - Sube tu imagen de 1024x1024
   - Descarga el set completo de íconos
   - Arrastra la carpeta AppIcon.appiconset a tu Assets.xcassets

DISEÑO DEL ÍCONO:
- Fondo: Gradiente azul (estilo iOS)
- Símbolo: "ƒ" (función matemática) en blanco
- Efecto: Liquid glass con brillo superior
- Estilo: Minimalista y elegante

COLORES:
- Azul claro: #4A90E2
- Azul medio: #357ABD
- Azul oscuro: #2A6099
- Texto: Blanco con opacidad variable
*/
