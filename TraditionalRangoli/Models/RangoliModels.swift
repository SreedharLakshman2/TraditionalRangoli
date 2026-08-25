import Foundation
import CoreGraphics

enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case beginner, intermediate, advanced

    var id: String { rawValue }

    var title: String {
        switch self {
        case .beginner: return "Beginner"
        case .intermediate: return "Intermediate"
        case .advanced: return "Advanced"
        }
    }
}

enum PatternFamily: String, Codable, CaseIterable, Identifiable {
    case pulliKolam, sikkuKolam, freehandRangoli, geometric, floral

    var id: String { rawValue }

    var title: String {
        switch self {
        case .pulliKolam: return "Pulli Kolam"
        case .sikkuKolam: return "Sikku Kolam"
        case .freehandRangoli: return "Freehand Rangoli"
        case .geometric: return "Geometric"
        case .floral: return "Floral"
        }
    }
}

enum MotifTheme: String, Codable, CaseIterable, Identifiable {
    case lotus, peacock, diya, flowers, mandala, traditional

    var id: String { rawValue }

    var title: String {
        switch self {
        case .lotus: return "Lotus"
        case .peacock: return "Peacock"
        case .diya: return "Diya"
        case .flowers: return "Flowers"
        case .mandala: return "Mandala"
        case .traditional: return "Traditional Motifs"
        }
    }

    var symbol: String {
        switch self {
        case .lotus: return "🪷"
        case .peacock: return "🦚"
        case .diya: return "🪔"
        case .flowers: return "🌸"
        case .mandala: return "✦"
        case .traditional: return "卍"
        }
    }
}

enum Festival: String, Codable, CaseIterable, Identifiable {
    case pongal, diwali, navratri, onam, ugadi, newYear

    var id: String { rawValue }

    var title: String {
        switch self {
        case .pongal: return "Pongal"
        case .diwali: return "Diwali"
        case .navratri: return "Navratri"
        case .onam: return "Onam"
        case .ugadi: return "Ugadi"
        case .newYear: return "New Year"
        }
    }
}

enum BrowseCollection: String, CaseIterable, Identifiable {
    case festival, dotKolam, floral, peacock, mandala, geometric

    var id: String { rawValue }

    var title: String {
        switch self {
        case .festival: return "Festival"
        case .dotKolam: return "Dot Kolam"
        case .floral: return "Floral"
        case .peacock: return "Peacock"
        case .mandala: return "Mandala"
        case .geometric: return "Geometric"
        }
    }

    var symbol: String {
        switch self {
        case .festival: return "🪔"
        case .dotKolam: return "⚬"
        case .floral: return "❀"
        case .peacock: return "🦚"
        case .mandala: return "✦"
        case .geometric: return "◇"
        }
    }

    var matches: (RangoliPattern) -> Bool {
        switch self {
        case .festival: return { !$0.festivals.isEmpty }
        case .dotKolam: return { $0.family == .pulliKolam || $0.family == .sikkuKolam }
        case .floral: return { $0.family == .floral || $0.theme == .flowers || $0.theme == .lotus }
        case .peacock: return { $0.theme == .peacock }
        case .mandala: return { $0.theme == .mandala }
        case .geometric: return { $0.family == .geometric }
        }
    }
}

enum MotifKind: String, Codable {
    case lotusDot, simpleFlower, peacock, diya, pulli, spiral, eightPetal
    case geometricStar, festivalFlower, mandala, butterfly, pongalPot
    case sikkuKnot, onamPookalam, sunBurst, mangoLeaf
}

struct Point2D: Codable, Hashable {
    var x: Double
    var y: Double

    var cg: CGPoint { CGPoint(x: x, y: y) }

    init(_ point: CGPoint) {
        x = point.x
        y = point.y
    }

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

struct RangoliStep: Identifiable, Hashable, Codable {
    var id: String
    var instruction: String
    var strokeIndex: Int
}

struct RangoliPattern: Identifiable, Hashable {
    var id: String
    var title: String
    var family: PatternFamily
    var theme: MotifTheme
    var festivals: [Festival]
    var difficulty: Difficulty
    var gridSize: Int
    var estimatedMinutes: Int
    var description: String
    var tags: [String]
    var motif: MotifKind
    var xpReward: Int

    var stepCount: Int { steps.count }
    var steps: [RangoliStep] { GeometryFactory.steps(for: self) }
}

enum SymmetryMode: String, Codable, CaseIterable, Identifiable {
    case none, horizontal, vertical, fourWay, eightWay

    var id: String { rawValue }

    var title: String {
        switch self {
        case .none: return "None"
        case .horizontal: return "Horizontal"
        case .vertical: return "Vertical"
        case .fourWay: return "4-way"
        case .eightWay: return "8-way"
        }
    }

    var symbol: String {
        switch self {
        case .none: return "slash.circle"
        case .horizontal: return "rectangle.split.1x2"
        case .vertical: return "rectangle.split.2x1"
        case .fourWay: return "square.split.2x2"
        case .eightWay: return "circle.grid.cross"
        }
    }
}

enum DrawTool: String, Codable {
    case brush, eraser, fill, rice, flower, diya, dots
}

enum BrushSize: String, CaseIterable, Identifiable {
    case small, medium, large

    var id: String { rawValue }

    var width: CGFloat {
        switch self {
        case .small: return 2.4
        case .medium: return 4.2
        case .large: return 7.2
        }
    }

    var title: String {
        switch self {
        case .small: return "Small"
        case .medium: return "Medium"
        case .large: return "Large"
        }
    }
}

enum StudioKind: String, Codable {
    case dots, freehand, template
}

struct DrawStroke: Identifiable, Codable, Hashable {
    var id: UUID
    var points: [Point2D]
    var colorHex: UInt32
    var width: CGFloat
    var tool: DrawTool
    var symmetry: SymmetryMode

    init(
        id: UUID = UUID(),
        points: [Point2D],
        colorHex: UInt32,
        width: CGFloat,
        tool: DrawTool,
        symmetry: SymmetryMode
    ) {
        self.id = id
        self.points = points
        self.colorHex = colorHex
        self.width = width
        self.tool = tool
        self.symmetry = symmetry
    }
}

struct FillBlob: Identifiable, Codable, Hashable {
    var id: UUID
    var center: Point2D
    var colorHex: UInt32
    var radius: Double
    var kind: DrawTool

    init(id: UUID = UUID(), center: Point2D, colorHex: UInt32, radius: Double, kind: DrawTool) {
        self.id = id
        self.center = center
        self.colorHex = colorHex
        self.radius = radius
        self.kind = kind
    }
}

struct UserArtwork: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var createdDate: Date
    var updatedDate: Date
    var patternId: String?
    var studio: StudioKind
    var gridSize: Int
    var strokes: [DrawStroke]
    var fills: [FillBlob]
    var thumbnailPNG: Data?
    var isFavorite: Bool
    var colors: [UInt32]

    var formattedDate: String {
        createdDate.formatted(date: .abbreviated, time: .omitted)
    }
}
