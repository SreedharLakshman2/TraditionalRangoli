import SwiftUI

struct RangoliPreview: View {
    var motif: MotifKind
    var progress: CGFloat = 1
    var floor: Bool = true
    var animate: Bool = false

    var body: some View {
        TimelineView(.animation(minimumInterval: animate ? 1 / 30 : 120, paused: !animate)) { timeline in
            let t = animate ? loopProgress(timeline.date) : progress
            Canvas { context, size in
                if floor {
                    let rect = Path(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: size.width * 0.18)
                    context.fill(
                        rect,
                        with: .radialGradient(
                            Gradient(colors: [RangoliColor.floorLight, RangoliColor.floorDeep]),
                            center: CGPoint(x: size.width / 2, y: size.height / 2),
                            startRadius: 4,
                            endRadius: size.width * 0.7
                        )
                    )
                }
                let strokes = GeometryFactory.strokes(for: motif)
                guard !strokes.isEmpty else { return }
                let visible = max(0.02, min(1, t))
                let total = CGFloat(strokes.count)
                for (index, stroke) in strokes.enumerated() {
                    let start = CGFloat(index) / total
                    let end = CGFloat(index + 1) / total
                    let local = min(1, max(0, (visible - start) / max(end - start, 0.0001)))
                    guard local > 0 else { continue }
                    let count = max(2, Int(CGFloat(stroke.points.count) * local))
                    let slice = Array(stroke.points.prefix(count)).map { DrawingUtilities.mapped($0, in: size) }
                    var path = DrawingUtilities.smoothPath(points: slice)
                    if stroke.closed && local >= 0.98, let first = slice.first {
                        path.addLine(to: first)
                        path.closeSubpath()
                    }
                    context.stroke(
                        path,
                        with: .color(Color(hex: stroke.colorHex)),
                        style: StrokeStyle(lineWidth: max(1.2, stroke.width * size.width / 180), lineCap: .round, lineJoin: .round)
                    )
                }
            }
        }
        .accessibilityHidden(true)
    }

    private func loopProgress(_ date: Date) -> CGFloat {
        let cycle = date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 6.5) / 6.5
        if cycle < 0.7 {
            return CGFloat(cycle / 0.7)
        }
        return 1
    }
}

struct ArtworkRenderer: View {
    let strokes: [DrawStroke]
    let fills: [FillBlob]
    var gridSize: Int = 9
    var showGrid: Bool = false
    var livePoints: [CGPoint] = []
    var liveColor: Color = RangoliColor.rice
    var liveWidth: CGFloat = 4
    var liveSymmetry: SymmetryMode = .none
    var liveTool: DrawTool = .brush
    var motifGuide: MotifKind? = nil
    var guideProgress: CGFloat = 1
    var canvasSize: CGSize? = nil

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            if showGrid {
                drawGrid(context: &context, size: size)
            }
            if let motifGuide {
                drawGuide(motif: motifGuide, progress: guideProgress, context: &context, size: size)
            }
            for fill in fills {
                drawFill(fill, context: &context, size: size)
            }
            for stroke in strokes {
                drawStroke(stroke, context: &context, size: size, center: center)
            }
            if livePoints.count > 1 {
                let copies = SymmetryEngine.copies(of: livePoints, mode: liveSymmetry, center: center)
                for points in copies {
                    let path = DrawingUtilities.smoothPath(points: points)
                    if liveTool == .eraser {
                        context.blendMode = .destinationOut
                        context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: liveWidth * 1.8, lineCap: .round, lineJoin: .round))
                        context.blendMode = .normal
                    } else {
                        context.stroke(path, with: .color(liveColor), style: StrokeStyle(lineWidth: liveWidth, lineCap: .round, lineJoin: .round))
                    }
                }
            }
        }
    }

    private func drawGrid(context: inout GraphicsContext, size: CGSize) {
        let dots = DrawingUtilities.gridPoints(size: gridSize, in: size)
        for dot in dots {
            let rect = CGRect(x: dot.x - 2.2, y: dot.y - 2.2, width: 4.4, height: 4.4)
            context.fill(Path(ellipseIn: rect), with: .color(RangoliColor.rice.opacity(0.55)))
        }
    }

    private func drawGuide(motif: MotifKind, progress: CGFloat, context: inout GraphicsContext, size: CGSize) {
        let strokes = GeometryFactory.strokes(for: motif)
        let visible = max(0.02, min(1, progress))
        let total = CGFloat(max(strokes.count, 1))
        for (index, stroke) in strokes.enumerated() {
            let start = CGFloat(index) / total
            let end = CGFloat(index + 1) / total
            let local = min(1, max(0, (visible - start) / max(end - start, 0.0001)))
            guard local > 0 else { continue }
            let count = max(2, Int(CGFloat(stroke.points.count) * local))
            let slice = Array(stroke.points.prefix(count)).map { DrawingUtilities.mapped($0, in: size) }
            let path = DrawingUtilities.smoothPath(points: slice)
            context.stroke(
                path,
                with: .color(Color(hex: stroke.colorHex).opacity(0.28)),
                style: StrokeStyle(lineWidth: 1.6, lineCap: .round, dash: [5, 6])
            )
        }
    }

    private func drawStroke(_ stroke: DrawStroke, context: inout GraphicsContext, size: CGSize, center: CGPoint) {
        let points = stroke.points.map(\.cg)
        let copies = SymmetryEngine.copies(of: points, mode: stroke.symmetry, center: center)
        for copy in copies {
            let path = DrawingUtilities.smoothPath(points: copy)
            if stroke.tool == .eraser {
                context.blendMode = .destinationOut
                context.stroke(path, with: .color(.white), style: StrokeStyle(lineWidth: stroke.width, lineCap: .round, lineJoin: .round))
                context.blendMode = .normal
            } else {
                context.stroke(
                    path,
                    with: .color(Color(hex: stroke.colorHex)),
                    style: StrokeStyle(lineWidth: stroke.width, lineCap: .round, lineJoin: .round)
                )
            }
        }
    }

    private func drawFill(_ fill: FillBlob, context: inout GraphicsContext, size: CGSize) {
        let center = DrawingUtilities.mapped(fill.center.cg, in: size)
        let radius = fill.radius * min(size.width, size.height)
        switch fill.kind {
        case .flower:
            let petals = 6
            for i in 0..<petals {
                let a = CGFloat(i) / CGFloat(petals) * .pi * 2
                let tip = CGPoint(x: center.x + cos(a) * radius, y: center.y + sin(a) * radius)
                var path = Path()
                path.move(to: center)
                path.addQuadCurve(
                    to: tip,
                    control: CGPoint(x: center.x + cos(a + 0.4) * radius * 0.6, y: center.y + sin(a + 0.4) * radius * 0.6)
                )
                context.stroke(path, with: .color(Color(hex: fill.colorHex)), lineWidth: 2)
            }
        case .diya:
            var flame = Path()
            flame.move(to: CGPoint(x: center.x, y: center.y - radius))
            flame.addQuadCurve(to: CGPoint(x: center.x - radius * 0.5, y: center.y + radius * 0.2), control: CGPoint(x: center.x - radius * 0.7, y: center.y - radius * 0.2))
            flame.addQuadCurve(to: CGPoint(x: center.x, y: center.y - radius), control: CGPoint(x: center.x + radius * 0.7, y: center.y - radius * 0.2))
            context.fill(flame, with: .color(Color(hex: 0xE3B23C).opacity(0.9)))
            let bowl = Path(ellipseIn: CGRect(x: center.x - radius * 0.7, y: center.y, width: radius * 1.4, height: radius * 0.7))
            context.fill(bowl, with: .color(Color(hex: fill.colorHex)))
        case .dots, .rice:
            let rect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
            context.fill(Path(ellipseIn: rect), with: .color(Color(hex: fill.colorHex).opacity(0.92)))
        default:
            let rect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
            context.fill(Path(ellipseIn: rect), with: .color(Color(hex: fill.colorHex).opacity(0.55)))
        }
    }
}
