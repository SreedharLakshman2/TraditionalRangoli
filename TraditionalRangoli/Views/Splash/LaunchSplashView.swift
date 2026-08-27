import SwiftUI

struct LaunchSplashView: View {
    var onFinished: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var sizeClass
    @EnvironmentObject private var language: LanguageStore
    @State private var drawn: CGFloat = 0
    @State private var glow = false
    @State private var appear = false

    var body: some View {
        ZStack {
            RangoliColor.ivory.ignoresSafeArea()
            ClayFloor().opacity(0.18).ignoresSafeArea()
            VStack(spacing: 22) {
                ZStack {
                    Circle()
                        .stroke(RangoliColor.gold.opacity(glow ? 0.55 : 0.18), lineWidth: 1.5)
                        .frame(width: sizeClass == .regular ? 220 : 168, height: sizeClass == .regular ? 220 : 168)
                    RangoliPreview(motif: .lotusDot, progress: drawn, floor: true)
                        .frame(width: sizeClass == .regular ? 196 : 148, height: sizeClass == .regular ? 196 : 148)
                        .clipShape(Circle())
                        .shadow(color: RangoliColor.gold.opacity(0.3), radius: 18)
                }
                VStack(spacing: 8) {
                    Text(language.t("appName"))
                        .font(RangoliFont.display(30))
                        .foregroundStyle(RangoliColor.ink)
                    Text(language.t("tagline"))
                        .font(RangoliFont.body(15))
                        .foregroundStyle(RangoliColor.muted)
                }
            }
            .padding(.bottom, 72)

            studioFooter
                .opacity(appear ? 1 : 0)
                .animation(reduceMotion ? nil : .easeOut(duration: 0.45).delay(0.35), value: appear)
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
        .onAppear {
            appear = true
            if reduceMotion {
                drawn = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                    onFinished()
                }
                return
            }
            withAnimation(.easeInOut(duration: 0.7)) {
                drawn = 1
            }
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                glow = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.95) {
                onFinished()
            }
        }
        .accessibilityLabel("Traditional Rangoli. Sreeo Studio. \(RangoliColor.copyright)")
    }

    private var studioFooter: some View {
        VStack(spacing: 8) {
            sreeoTiles(size: 12, spacing: 4)
            Text(RangoliColor.studio)
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(RangoliColor.studioWordmark)
            Text(RangoliColor.copyright)
                .font(RangoliFont.caption(12))
                .foregroundStyle(RangoliColor.muted)
                .accessibilityLabel("Copyright 2026 Sai Laksha Technologies")
        }
    }

    private func sreeoTiles(size: CGFloat, spacing: CGFloat) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<4, id: \.self) { index in
                RoundedRectangle(cornerRadius: size * 0.23, style: .continuous)
                    .fill(RangoliColor.studioTiles[index])
                    .frame(width: size, height: size)
                    .offset(y: appear || reduceMotion ? 0 : -28)
                    .opacity(appear ? 1 : 0)
                    .animation(
                        reduceMotion ? nil : .spring(response: 0.5, dampingFraction: 0.6).delay(0.12 + Double(index) * 0.1),
                        value: appear
                    )
            }
        }
        .accessibilityHidden(true)
    }
}
