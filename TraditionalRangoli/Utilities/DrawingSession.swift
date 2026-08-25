import SwiftUI
import Combine

@MainActor
final class DrawingSession: ObservableObject {
    @Published var strokes: [DrawStroke] = []
    @Published var fills: [FillBlob] = []
    @Published var undoneStrokes: [DrawStroke] = []
    @Published var undoneFills: [FillBlob] = []
    @Published var livePoints: [CGPoint] = []
    @Published var gridSize: Int
    @Published var showGrid: Bool
    @Published var snapToDots: Bool
    @Published var symmetry: SymmetryMode
    @Published var color: PowderSwatch
    @Published var brush: BrushSize
    @Published var tool: DrawTool
    @Published var studio: StudioKind
    @Published var pattern: RangoliPattern?
    @Published var showGuides: Bool
    @Published var canvasSize: CGSize = CGSize(width: 320, height: 320)

    init(
        studio: StudioKind,
        pattern: RangoliPattern? = nil,
        gridSize: Int? = nil,
        showGuides: Bool = true,
        artwork: UserArtwork? = nil
    ) {
        self.studio = studio
        self.pattern = pattern
        self.gridSize = artwork?.gridSize ?? gridSize ?? pattern?.gridSize ?? 9
        self.showGrid = studio != .freehand
        self.snapToDots = studio == .dots || studio == .template
        self.symmetry = studio == .freehand ? .fourWay : .none
        self.color = studio == .freehand ? .traditionalRed : .rice
        self.brush = .medium
        self.tool = .brush
        self.showGuides = showGuides
        if let artwork {
            strokes = DrawingUtilities.normalizedStrokes(artwork.strokes)
            fills = artwork.fills
        }
    }

    var canUndo: Bool { !strokes.isEmpty || !fills.isEmpty }
    var canRedo: Bool { !undoneStrokes.isEmpty || !undoneFills.isEmpty }
    var title: String { pattern?.title ?? (studio == .freehand ? "Freehand Rangoli" : "Dot Rangoli") }

    func begin(at point: CGPoint, in size: CGSize) {
        canvasSize = size
        if tool == .fill || tool == .rice || tool == .flower || tool == .diya || tool == .dots {
            addFill(at: point, in: size)
            return
        }
        let snapped = prepared(point, in: size)
        livePoints = [DrawingUtilities.normalized(snapped, in: size)]
    }

    func move(to point: CGPoint, in size: CGSize) {
        guard tool == .brush || tool == .eraser else { return }
        canvasSize = size
        let snapped = prepared(point, in: size)
        guard let lastNorm = livePoints.last else {
            livePoints = [DrawingUtilities.normalized(snapped, in: size)]
            return
        }
        let last = DrawingUtilities.mapped(lastNorm, in: size)
        let cell = min(size.width, size.height) * 0.8 / CGFloat(max(gridSize - 1, 1))
        if hypot(snapped.x - last.x, snapped.y - last.y) > cell * 2.6 {
            return
        }
        let extras = DrawingUtilities.interpolate(from: last, to: snapped, spacing: 2.2)
        livePoints.append(contentsOf: extras.map { DrawingUtilities.normalized($0, in: size) })
    }

    func end() {
        guard tool == .brush || tool == .eraser, livePoints.count > 1 else {
            livePoints = []
            return
        }
        let stroke = DrawStroke(
            points: livePoints.map(Point2D.init),
            colorHex: tool == .eraser ? 0x000000 : color.hex,
            width: tool == .eraser ? brush.width * 1.8 : brush.width,
            tool: tool,
            symmetry: symmetry
        )
        strokes.append(stroke)
        undoneStrokes.removeAll()
        livePoints = []
    }

    func undo() {
        if let lastFill = fills.popLast() {
            undoneFills.append(lastFill)
            return
        }
        if let last = strokes.popLast() {
            undoneStrokes.append(last)
        }
    }

    func redo() {
        if let fill = undoneFills.popLast() {
            fills.append(fill)
            return
        }
        if let stroke = undoneStrokes.popLast() {
            strokes.append(stroke)
        }
    }

    func clear() {
        strokes.removeAll()
        fills.removeAll()
        undoneStrokes.removeAll()
        undoneFills.removeAll()
        livePoints.removeAll()
    }

    func artwork(title: String, thumbnail: Data?) -> UserArtwork {
        UserArtwork(
            id: UUID(),
            title: title,
            createdDate: Date(),
            updatedDate: Date(),
            patternId: pattern?.id,
            studio: studio,
            gridSize: gridSize,
            strokes: strokes,
            fills: fills,
            thumbnailPNG: thumbnail,
            isFavorite: false,
            colors: Array(Set(strokes.map(\.colorHex) + fills.map(\.colorHex)))
        )
    }

    func load(_ artwork: UserArtwork) {
        strokes = DrawingUtilities.normalizedStrokes(artwork.strokes)
        fills = artwork.fills
        gridSize = artwork.gridSize
        studio = artwork.studio
        pattern = artwork.patternId.flatMap(PatternCatalog.pattern(id:))
    }

    func apply(motifStrokes: [MotifStroke]) {
        strokes = motifStrokes.map { stroke in
            DrawStroke(
                points: stroke.points.map(Point2D.init),
                colorHex: stroke.colorHex,
                width: max(2.6, stroke.width * 1.12),
                tool: .brush,
                symmetry: .none
            )
        }
        undoneStrokes.removeAll()
    }

    func applyFestivalFills() {
        fills = [
            FillBlob(center: Point2D(x: 0.50, y: 0.50), colorHex: 0xC89B3C, radius: 0.07, kind: .fill),
            FillBlob(center: Point2D(x: 0.33, y: 0.30), colorHex: 0x9B2C2C, radius: 0.05, kind: .flower),
            FillBlob(center: Point2D(x: 0.67, y: 0.30), colorHex: 0xC45C2A, radius: 0.05, kind: .flower),
            FillBlob(center: Point2D(x: 0.24, y: 0.52), colorHex: 0xF7F1E3, radius: 0.034, kind: .rice),
            FillBlob(center: Point2D(x: 0.76, y: 0.52), colorHex: 0xF7F1E3, radius: 0.034, kind: .rice),
            FillBlob(center: Point2D(x: 0.38, y: 0.74), colorHex: 0xE8C56B, radius: 0.042, kind: .diya),
            FillBlob(center: Point2D(x: 0.50, y: 0.80), colorHex: 0xD97706, radius: 0.048, kind: .diya),
            FillBlob(center: Point2D(x: 0.62, y: 0.74), colorHex: 0xE8C56B, radius: 0.042, kind: .diya),
            FillBlob(center: Point2D(x: 0.50, y: 0.22), colorHex: 0x5C8A64, radius: 0.03, kind: .dots)
        ]
        undoneFills.removeAll()
        tool = .flower
    }

    private func addFill(at point: CGPoint, in size: CGSize) {
        let normalized = DrawingUtilities.normalized(point, in: size)
        let radius: Double
        switch tool {
        case .fill: radius = 0.08
        case .rice: radius = 0.035
        case .flower: radius = 0.05
        case .diya: radius = 0.045
        case .dots: radius = 0.018
        default: radius = 0.06
        }
        let blob = FillBlob(center: Point2D(normalized), colorHex: color.hex, radius: radius, kind: tool)
        fills.append(blob)
        undoneFills.removeAll()
    }

    private func prepared(_ point: CGPoint, in size: CGSize) -> CGPoint {
        if snapToDots && showGrid {
            return DrawingUtilities.snap(point, gridSize: gridSize, in: size)
        }
        return point
    }
}
