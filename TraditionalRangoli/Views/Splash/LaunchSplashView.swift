import SwiftUI

struct LaunchSplashView: View {
    var onFinished: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var drawn: CGFloat = 0
    @State private var glow = false

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
                    Text("Traditional Rangoli")
                        .font(RangoliFont.display(30))
                        .foregroundStyle(RangoliColor.ink)
                    Text("Courtyard art, drawn by hand")
                        .font(RangoliFont.body(15))
                        .foregroundStyle(RangoliColor.muted)
                }
            }
        }
        .onAppear {
            if reduceMotion {
                drawn = 1
                onFinished()
                return
            }
            withAnimation(.easeInOut(duration: 1.35)) {
                drawn = 1
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                glow = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                onFinished()
            }
        }
        .accessibilityLabel("Traditional Rangoli")
    }
}
