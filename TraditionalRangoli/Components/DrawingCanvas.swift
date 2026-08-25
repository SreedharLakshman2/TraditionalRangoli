import SwiftUI
import UIKit

struct DrawingCanvas: View {
    @ObservedObject var session: DrawingSession

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let canvas = CGSize(width: side, height: side)
            ZStack {
                ClayFloor()
                ArtworkRenderer(
                    strokes: session.strokes,
                    fills: session.fills,
                    gridSize: session.gridSize,
                    showGrid: session.showGrid,
                    livePoints: session.livePoints,
                    liveColor: session.color.color,
                    liveWidth: session.brush.width,
                    liveSymmetry: session.symmetry,
                    liveTool: session.tool,
                    motifGuide: session.showGuides ? session.pattern?.motif : nil,
                    guideProgress: session.showGuides ? 1 : 0
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .goldFrame(cornerRadius: 28)
            .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .frame(width: side, height: side)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        session.canvasSize = canvas
                        if session.livePoints.isEmpty {
                            session.begin(at: value.location, in: canvas)
                        } else {
                            session.move(to: value.location, in: canvas)
                        }
                    }
                    .onEnded { _ in
                        session.end()
                    }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear { session.canvasSize = canvas }
            .onChange(of: side) { _, newValue in
                session.canvasSize = CGSize(width: newValue, height: newValue)
            }
            .accessibilityLabel("Rangoli drawing canvas")
            .accessibilityHint("Draw with one finger. Strokes snap to nearby dots when the grid is on.")
        }
    }
}

enum ArtworkSnapshot {
    @MainActor
    static func png(session: DrawingSession, size: CGSize = CGSize(width: 720, height: 720)) -> Data? {
        let view = ZStack {
            ClayFloor()
            ArtworkRenderer(
                strokes: session.strokes,
                fills: session.fills,
                gridSize: session.gridSize,
                showGrid: false
            )
        }
        .frame(width: size.width, height: size.height)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 2
        return renderer.uiImage?.pngData()
    }

    @MainActor
    static func image(session: DrawingSession) -> Image? {
        guard let data = png(session: session), let ui = UIImage(data: data) else { return nil }
        return Image(uiImage: ui)
    }
}
