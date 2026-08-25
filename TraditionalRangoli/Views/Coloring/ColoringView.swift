import SwiftUI

struct ColoringView: View {
    @ObservedObject var session: DrawingSession
    var onDone: () -> Void
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        GeometryReader { geo in
            let split = CourtyardLayout.splitStudio(
                width: geo.size.width,
                height: geo.size.height,
                regular: sizeClass == .regular
            )
            ZStack {
                PaperBackground(showWatermark: false)
                VStack(spacing: split ? 10 : 14) {
                    header
                    if !split {
                        caption
                    }
                    if split {
                        HStack(alignment: .center, spacing: 8) {
                            DrawingCanvas(session: session)
                                .padding(.leading, 16)
                                .padding(.bottom, 16)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            VStack(spacing: 16) {
                                caption
                                decoRow
                                ColorPaletteBar(selection: $session.color)
                                    .padding(.horizontal, 8)
                                Spacer(minLength: 0)
                            }
                            .frame(width: min(360, max(280, geo.size.width * 0.34)))
                            .padding(.trailing, 16)
                            .padding(.bottom, 16)
                        }
                    } else {
                        DrawingCanvas(session: session)
                            .padding(.horizontal, 16)
                            .frame(maxHeight: .infinity)
                        decoRow
                            .padding(.horizontal, 16)
                            .courtyardControls(560)
                        ColorPaletteBar(selection: $session.color)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 16)
                            .courtyardControls(640)
                    }
                }
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            session.tool = .fill
            session.snapToDots = false
            session.showGrid = false
        }
    }

    private var header: some View {
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
    }

    private var caption: some View {
        Text("Tap enclosed spaces to fill. Add rice powder, flowers or a diya.")
            .font(RangoliFont.caption(13))
            .foregroundStyle(RangoliColor.muted)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }

    private var decoRow: some View {
        HStack(spacing: 10) {
            deco(.fill, "paintpalette.fill", "Fill")
            deco(.rice, "circle.fill", "Rice")
            deco(.flower, "camera.macro", "Flower")
            deco(.diya, "flame.fill", "Diya")
            deco(.dots, "circle.grid.2x2.fill", "Dots")
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
