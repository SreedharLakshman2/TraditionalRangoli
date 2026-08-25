import SwiftUI

struct ColoringView: View {
    @ObservedObject var session: DrawingSession
    var onDone: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            PaperBackground(showWatermark: false)
            VStack(spacing: 14) {
                HStack {
                    Button("Skip") { onDone() }
                        .font(RangoliFont.headline(15))
                        .foregroundStyle(RangoliColor.muted)
                    Spacer()
                    Text("Color & decorate")
                        .font(RangoliFont.title(20))
                    Spacer()
                    Button("Done") { onDone() }
                        .font(RangoliFont.headline(15))
                        .foregroundStyle(RangoliColor.primary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Text("Tap enclosed spaces to fill. Add rice powder, flowers or a diya.")
                    .font(RangoliFont.caption(13))
                    .foregroundStyle(RangoliColor.muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                DrawingCanvas(session: session)
                    .padding(.horizontal, 16)

                HStack(spacing: 10) {
                    deco(.fill, "paintpalette.fill", "Fill")
                    deco(.rice, "circle.fill", "Rice")
                    deco(.flower, "camera.macro", "Flower")
                    deco(.diya, "flame.fill", "Diya")
                    deco(.dots, "circle.grid.2x2.fill", "Dots")
                }
                .padding(.horizontal, 16)

                ColorPaletteBar(selection: $session.color)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            session.tool = .fill
            session.snapToDots = false
            session.showGrid = false
        }
    }

    private func deco(_ tool: DrawTool, _ symbol: String, _ title: String) -> some View {
        Button {
            session.tool = tool
        } label: {
            VStack(spacing: 6) {
                Image(systemName: symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(session.tool == tool ? RangoliColor.onAccent : RangoliColor.primary)
                    .frame(width: 44, height: 44)
                    .background(session.tool == tool ? RangoliColor.primary : RangoliColor.paper, in: Circle())
                    .overlay(Circle().stroke(RangoliColor.gold.opacity(0.3), lineWidth: 1))
                Text(title)
                    .font(RangoliFont.label(10))
                    .foregroundStyle(RangoliColor.muted)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel(title)
        .accessibilityAddTraits(session.tool == tool ? .isSelected : [])
    }
}
