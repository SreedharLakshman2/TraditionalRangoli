import SwiftUI

struct MotifStroke: Identifiable, Hashable {
    var id: Int
    var points: [CGPoint]
    var colorHex: UInt32
    var width: CGFloat
    var closed: Bool
}

enum GeometryFactory {
    static func strokes(for motif: MotifKind) -> [MotifStroke] {
        switch motif {
        case .lotusDot: return lotus(petals: 8, rings: 2)
        case .simpleFlower: return simpleFlower()
        case .peacock: return peacock()
        case .diya: return diya()
        case .pulli: return pulliKolam()
        case .spiral: return spiral()
        case .eightPetal: return lotus(petals: 8, rings: 3)
        case .geometricStar: return geometricStar()
        case .festivalFlower: return festivalFlower()
        case .mandala: return mandala()
        case .butterfly: return butterfly()
        case .pongalPot: return pongalPot()
        case .sikkuKnot: return sikkuKnot()
        case .onamPookalam: return onamPookalam()
        case .sunBurst: return sunBurst()
        case .mangoLeaf: return mangoLeaf()
        }
    }

    static func steps(for pattern: RangoliPattern) -> [RangoliStep] {
        let all = strokes(for: pattern.motif)
        let n = max(all.count, 1)
        let groups = min(8, n)
        return (0..<groups).map { index in
            let strokeIndex = min(n - 1, Int((Double(index) + 0.5) / Double(groups) * Double(n)))
            return RangoliStep(
                id: "\(pattern.id)-step-\(index)",
                instruction: instruction(for: pattern.motif, index: index, total: groups),
                strokeIndex: strokeIndex
            )
        }
    }

    static func instruction(for motif: MotifKind, index: Int, total: Int) -> String {
        let starters = [
            "Begin at the heart of the kolam and rest the first curve on the nearest two dots.",
            "Trace a calm powder line around the center, keeping the wrist light.",
            "Mirror the petal on the opposite side so the rangoli stays balanced."
        ]
        let middles = [
            "Sweep around the next pair of dots without lifting the powder line.",
            "Let the curve kiss the dots rather than cutting through them.",
            "Keep the spacing even — traditional kolam lives in rhythm.",
            "Add the decorative loop, then return toward the center."
        ]
        let finishes = [
            "Close the outer border and rest the last stroke on the starting point.",
            "Soften the corners so the rangoli feels hand-drawn, not rigid.",
            "Finish with a quiet center mark, like a bindu of rice powder."
        ]
        if index == 0 { return starters[abs(motif.rawValue.hashValue) % starters.count] }
        if index >= total - 1 { return finishes[index % finishes.count] }
        return middles[index % middles.count]
    }

    // MARK: - Motifs

    private static func lotus(petals: Int, rings: Int) -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        strokes.append(circle(center: c, radius: 0.06, color: 0xC89B3C, width: 2.4))
        strokes.append(circle(center: c, radius: 0.11, color: 0x9B2C2C, width: 2.0))
        for ring in 0..<rings {
            let radius: CGFloat = 0.16 + CGFloat(ring) * 0.12
            let length: CGFloat = 0.12 + CGFloat(ring) * 0.06
            let color: UInt32 = ring == 0 ? 0x9B2C2C : (ring == 1 ? 0xC45C2A : 0xC89B3C)
            for i in 0..<petals {
                let angle = CGFloat(i) / CGFloat(petals) * .pi * 2 - .pi / 2
                strokes.append(petal(center: c, angle: angle, distance: radius, length: length, width: 0.055, color: color))
            }
        }
        strokes.append(circle(center: c, radius: 0.42, color: 0x3F6B4F, width: 1.8))
        let dots = (0..<petals).map { i -> MotifStroke in
            let a = CGFloat(i) / CGFloat(petals) * .pi * 2 - .pi / 2
            return circle(center: polar(c, 0.38, a), radius: 0.012, color: 0xC89B3C, width: 1.4, filledHint: true)
        }
        strokes.append(contentsOf: dots)
        return numbered(strokes)
    }

    private static func simpleFlower() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        strokes.append(circle(center: c, radius: 0.07, color: 0xC89B3C, width: 2.6))
        for i in 0..<4 {
            let angle = CGFloat(i) * .pi / 2
            strokes.append(petal(center: c, angle: angle, distance: 0.16, length: 0.18, width: 0.08, color: 0x9B2C2C))
        }
        for i in 0..<4 {
            let angle = CGFloat(i) * .pi / 2 + .pi / 4
            strokes.append(leaf(center: c, angle: angle, distance: 0.28, color: 0x3F6B4F))
        }
        strokes.append(circle(center: c, radius: 0.4, color: 0xD97706, width: 1.6))
        return numbered(strokes)
    }

    private static func peacock() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        let body = teardrop(center: CGPoint(x: 0.5, y: 0.62), angle: -.pi / 2, length: 0.18, width: 0.07, color: 0x3F6B4F)
        strokes.append(body)
        for i in 0..<9 {
            let t = CGFloat(i) / 8
            let angle = -.pi * 0.95 + t * .pi * 0.9
            strokes.append(petal(center: CGPoint(x: 0.5, y: 0.58), angle: angle, distance: 0.12, length: 0.22, width: 0.045, color: i % 2 == 0 ? 0x9B2C2C : 0xC89B3C))
            let eye = polar(CGPoint(x: 0.5, y: 0.58), 0.28, angle)
            strokes.append(circle(center: eye, radius: 0.018, color: 0x3F6B4F, width: 1.6))
        }
        strokes.append(circle(center: CGPoint(x: 0.5, y: 0.46), radius: 0.035, color: 0xC89B3C, width: 2))
        strokes.append(MotifStroke(id: 0, points: [CGPoint(x: 0.5, y: 0.43), CGPoint(x: 0.47, y: 0.34), CGPoint(x: 0.5, y: 0.3), CGPoint(x: 0.53, y: 0.34), CGPoint(x: 0.5, y: 0.43)], colorHex: 0xC45C2A, width: 2, closed: true))
        return numbered(strokes)
    }

    private static func diya() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        let bowl = [
            CGPoint(x: 0.32, y: 0.58),
            CGPoint(x: 0.28, y: 0.66),
            CGPoint(x: 0.38, y: 0.74),
            CGPoint(x: 0.5, y: 0.76),
            CGPoint(x: 0.62, y: 0.74),
            CGPoint(x: 0.72, y: 0.66),
            CGPoint(x: 0.68, y: 0.58),
            CGPoint(x: 0.5, y: 0.6),
            CGPoint(x: 0.32, y: 0.58)
        ]
        strokes.append(MotifStroke(id: 0, points: bowl, colorHex: 0xC45C2A, width: 2.6, closed: true))
        strokes.append(petal(center: CGPoint(x: 0.5, y: 0.52), angle: -.pi / 2, distance: 0.02, length: 0.12, width: 0.045, color: 0xE3B23C))
        for i in 0..<8 {
            let a = CGFloat(i) / 8 * .pi * 2 - .pi / 2
            strokes.append(petal(center: c, angle: a, distance: 0.28, length: 0.1, width: 0.04, color: 0x9B2C2C))
        }
        strokes.append(circle(center: c, radius: 0.44, color: 0xC89B3C, width: 1.7))
        return numbered(strokes)
    }

    private static func pulliKolam() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        let n = 5
        var dots: [CGPoint] = []
        for row in 0..<n {
            for col in 0..<n {
                let x = 0.22 + CGFloat(col) / CGFloat(n - 1) * 0.56
                let y = 0.22 + CGFloat(row) / CGFloat(n - 1) * 0.56
                dots.append(CGPoint(x: x, y: y))
                strokes.append(circle(center: CGPoint(x: x, y: y), radius: 0.01, color: 0xF4E6C3, width: 1.4))
            }
        }
        for row in 0..<n {
            for col in 0..<n - 1 {
                let a = dots[row * n + col]
                let b = dots[row * n + col + 1]
                strokes.append(sikku(between: a, and: b, color: 0xFFF8E7))
            }
        }
        for row in 0..<n - 1 {
            for col in 0..<n {
                let a = dots[row * n + col]
                let b = dots[(row + 1) * n + col]
                strokes.append(sikku(between: a, and: b, color: 0xF4E6C3))
            }
        }
        return numbered(strokes)
    }

    private static func spiral() -> [MotifStroke] {
        var points: [CGPoint] = []
        for i in 0..<120 {
            let t = CGFloat(i) / 120
            let angle = t * .pi * 6
            let radius = 0.04 + t * 0.34
            points.append(polar(c, radius, angle))
        }
        var strokes = [MotifStroke(id: 0, points: points, colorHex: 0x9B2C2C, width: 2.4, closed: false)]
        strokes.append(circle(center: c, radius: 0.42, color: 0xC89B3C, width: 1.8))
        for i in 0..<10 {
            let a = CGFloat(i) / 10 * .pi * 2
            strokes.append(petal(center: c, angle: a, distance: 0.34, length: 0.08, width: 0.03, color: 0x3F6B4F))
        }
        return numbered(strokes)
    }

    private static func geometricStar() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        strokes.append(star(center: c, points: 8, inner: 0.14, outer: 0.32, color: 0x9B2C2C, width: 2.4))
        strokes.append(star(center: c, points: 8, inner: 0.08, outer: 0.18, color: 0xC89B3C, width: 2))
        strokes.append(regularPolygon(center: c, sides: 8, radius: 0.38, color: 0x3F6B4F, width: 1.8))
        strokes.append(circle(center: c, radius: 0.06, color: 0xD97706, width: 2))
        return numbered(strokes)
    }

    private static func festivalFlower() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        let rings: [(CGFloat, UInt32, Int)] = [
            (0.14, 0xC89B3C, 8),
            (0.24, 0x9B2C2C, 12),
            (0.34, 0xD97706, 16)
        ]
        for (distance, color, count) in rings {
            for i in 0..<count {
                let a = CGFloat(i) / CGFloat(count) * .pi * 2
                strokes.append(petal(center: c, angle: a, distance: distance, length: 0.08, width: 0.035, color: color))
            }
        }
        strokes.append(circle(center: c, radius: 0.07, color: 0x3F6B4F, width: 2.2))
        return numbered(strokes)
    }

    private static func mandala() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        strokes.append(circle(center: c, radius: 0.08, color: 0xC89B3C, width: 2))
        strokes.append(star(center: c, points: 8, inner: 0.1, outer: 0.18, color: 0x9B2C2C, width: 1.8))
        for i in 0..<12 {
            let a = CGFloat(i) / 12 * .pi * 2
            strokes.append(petal(center: c, angle: a, distance: 0.22, length: 0.1, width: 0.04, color: 0xC45C2A))
        }
        strokes.append(regularPolygon(center: c, sides: 12, radius: 0.36, color: 0x3F6B4F, width: 1.6))
        for i in 0..<16 {
            let a = CGFloat(i) / 16 * .pi * 2
            strokes.append(circle(center: polar(c, 0.4, a), radius: 0.012, color: 0xC89B3C, width: 1.3))
        }
        strokes.append(circle(center: c, radius: 0.45, color: 0x9B2C2C, width: 1.5))
        return numbered(strokes)
    }

    private static func butterfly() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        let body = [
            CGPoint(x: 0.5, y: 0.28),
            CGPoint(x: 0.48, y: 0.4),
            CGPoint(x: 0.5, y: 0.7),
            CGPoint(x: 0.52, y: 0.4),
            CGPoint(x: 0.5, y: 0.28)
        ]
        strokes.append(MotifStroke(id: 0, points: body, colorHex: 0x2D241F, width: 2.4, closed: true))
        strokes.append(petal(center: CGPoint(x: 0.5, y: 0.42), angle: -.pi * 0.75, distance: 0.04, length: 0.18, width: 0.1, color: 0x9B2C2C))
        strokes.append(petal(center: CGPoint(x: 0.5, y: 0.42), angle: -.pi * 0.25, distance: 0.04, length: 0.18, width: 0.1, color: 0x9B2C2C))
        strokes.append(petal(center: CGPoint(x: 0.5, y: 0.55), angle: .pi * 0.78, distance: 0.04, length: 0.14, width: 0.08, color: 0xC89B3C))
        strokes.append(petal(center: CGPoint(x: 0.5, y: 0.55), angle: .pi * 0.22, distance: 0.04, length: 0.14, width: 0.08, color: 0xC89B3C))
        strokes.append(circle(center: CGPoint(x: 0.38, y: 0.38), radius: 0.03, color: 0x3F6B4F, width: 1.6))
        strokes.append(circle(center: CGPoint(x: 0.62, y: 0.38), radius: 0.03, color: 0x3F6B4F, width: 1.6))
        strokes.append(MotifStroke(id: 0, points: [CGPoint(x: 0.5, y: 0.28), CGPoint(x: 0.42, y: 0.18)], colorHex: 0x2D241F, width: 1.6, closed: false))
        strokes.append(MotifStroke(id: 0, points: [CGPoint(x: 0.5, y: 0.28), CGPoint(x: 0.58, y: 0.18)], colorHex: 0x2D241F, width: 1.6, closed: false))
        return numbered(strokes)
    }

    private static func pongalPot() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        let pot = [
            CGPoint(x: 0.38, y: 0.38),
            CGPoint(x: 0.34, y: 0.42),
            CGPoint(x: 0.32, y: 0.55),
            CGPoint(x: 0.36, y: 0.7),
            CGPoint(x: 0.5, y: 0.74),
            CGPoint(x: 0.64, y: 0.7),
            CGPoint(x: 0.68, y: 0.55),
            CGPoint(x: 0.66, y: 0.42),
            CGPoint(x: 0.62, y: 0.38),
            CGPoint(x: 0.38, y: 0.38)
        ]
        strokes.append(MotifStroke(id: 0, points: pot, colorHex: 0xC45C2A, width: 2.6, closed: true))
        strokes.append(MotifStroke(id: 0, points: [CGPoint(x: 0.4, y: 0.38), CGPoint(x: 0.6, y: 0.38)], colorHex: 0xC89B3C, width: 2.2, closed: false))
        for i in 0..<5 {
            let a = -.pi * 0.8 + CGFloat(i) / 4 * .pi * 0.6
            strokes.append(leaf(center: CGPoint(x: 0.5, y: 0.36), angle: a, distance: 0.02, color: 0x3F6B4F))
        }
        strokes.append(circle(center: c, radius: 0.42, color: 0x9B2C2C, width: 1.6))
        for i in 0..<8 {
            let a = CGFloat(i) / 8 * .pi * 2
            strokes.append(circle(center: polar(c, 0.38, a), radius: 0.012, color: 0xC89B3C, width: 1.3))
        }
        return numbered(strokes)
    }

    private static func sikkuKnot() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        let nodes = [
            CGPoint(x: 0.5, y: 0.28),
            CGPoint(x: 0.72, y: 0.5),
            CGPoint(x: 0.5, y: 0.72),
            CGPoint(x: 0.28, y: 0.5)
        ]
        for i in 0..<nodes.count {
            strokes.append(sikku(between: nodes[i], and: nodes[(i + 1) % nodes.count], color: 0xFFF8E7))
        }
        strokes.append(sikku(between: nodes[0], and: nodes[2], color: 0xC89B3C))
        strokes.append(sikku(between: nodes[1], and: nodes[3], color: 0x9B2C2C))
        strokes.append(circle(center: c, radius: 0.08, color: 0x3F6B4F, width: 2))
        return numbered(strokes)
    }

    private static func onamPookalam() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        let palette: [UInt32] = [0x9B2C2C, 0xD97706, 0xE3B23C, 0x3F6B4F, 0xC45D7A]
        for ring in 0..<5 {
            let count = 8 + ring * 4
            let distance = 0.1 + CGFloat(ring) * 0.07
            for i in 0..<count {
                let a = CGFloat(i) / CGFloat(count) * .pi * 2 + CGFloat(ring) * 0.08
                strokes.append(petal(center: c, angle: a, distance: distance, length: 0.055, width: 0.028, color: palette[ring % palette.count]))
            }
        }
        strokes.append(circle(center: c, radius: 0.06, color: 0xC89B3C, width: 2.2))
        return numbered(strokes)
    }

    private static func sunBurst() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        strokes.append(circle(center: c, radius: 0.12, color: 0xE3B23C, width: 2.6))
        for i in 0..<16 {
            let a = CGFloat(i) / 16 * .pi * 2
            let inner = polar(c, 0.16, a)
            let outer = polar(c, i % 2 == 0 ? 0.4 : 0.32, a)
            strokes.append(MotifStroke(id: 0, points: [inner, outer], colorHex: 0xD97706, width: 2.2, closed: false))
        }
        strokes.append(circle(center: c, radius: 0.44, color: 0x9B2C2C, width: 1.6))
        return numbered(strokes)
    }

    private static func mangoLeaf() -> [MotifStroke] {
        var strokes: [MotifStroke] = []
        for i in 0..<8 {
            let a = CGFloat(i) / 8 * .pi * 2 - .pi / 2
            strokes.append(leaf(center: c, angle: a, distance: 0.12, color: 0x3F6B4F))
        }
        strokes.append(circle(center: c, radius: 0.1, color: 0xC89B3C, width: 2))
        strokes.append(star(center: c, points: 6, inner: 0.05, outer: 0.09, color: 0x9B2C2C, width: 1.8))
        strokes.append(circle(center: c, radius: 0.42, color: 0xC45C2A, width: 1.6))
        return numbered(strokes)
    }

    // MARK: - Primitives

    private static let c = CGPoint(x: 0.5, y: 0.5)

    private static func polar(_ center: CGPoint, _ radius: CGFloat, _ angle: CGFloat) -> CGPoint {
        CGPoint(x: center.x + cos(angle) * radius, y: center.y + sin(angle) * radius)
    }

    private static func numbered(_ strokes: [MotifStroke]) -> [MotifStroke] {
        strokes.enumerated().map { index, stroke in
            var copy = stroke
            copy.id = index
            return copy
        }
    }

    private static func circle(center: CGPoint, radius: CGFloat, color: UInt32, width: CGFloat, filledHint: Bool = false) -> MotifStroke {
        let samples = 48
        var points: [CGPoint] = []
        for i in 0...samples {
            let a = CGFloat(i) / CGFloat(samples) * .pi * 2
            points.append(polar(center, radius, a))
        }
        return MotifStroke(id: 0, points: points, colorHex: color, width: filledHint ? width + 1 : width, closed: true)
    }

    private static func petal(center: CGPoint, angle: CGFloat, distance: CGFloat, length: CGFloat, width: CGFloat, color: UInt32) -> MotifStroke {
        let base = polar(center, distance, angle)
        let tip = polar(center, distance + length, angle)
        let left = polar(center, distance + length * 0.45, angle - width * 2.2)
        let right = polar(center, distance + length * 0.45, angle + width * 2.2)
        let points = sampleQuad(base, left, tip) + sampleQuad(tip, right, base)
        return MotifStroke(id: 0, points: points, colorHex: color, width: 2.1, closed: true)
    }

    private static func leaf(center: CGPoint, angle: CGFloat, distance: CGFloat, color: UInt32) -> MotifStroke {
        petal(center: center, angle: angle, distance: distance, length: 0.14, width: 0.035, color: color)
    }

    private static func teardrop(center: CGPoint, angle: CGFloat, length: CGFloat, width: CGFloat, color: UInt32) -> MotifStroke {
        petal(center: CGPoint(x: center.x - cos(angle) * length * 0.3, y: center.y - sin(angle) * length * 0.3), angle: angle, distance: 0.02, length: length, width: width, color: color)
    }

    private static func star(center: CGPoint, points: Int, inner: CGFloat, outer: CGFloat, color: UInt32, width: CGFloat) -> MotifStroke {
        var pts: [CGPoint] = []
        for i in 0..<(points * 2) {
            let a = CGFloat(i) / CGFloat(points * 2) * .pi * 2 - .pi / 2
            pts.append(polar(center, i % 2 == 0 ? outer : inner, a))
        }
        pts.append(pts[0])
        return MotifStroke(id: 0, points: pts, colorHex: color, width: width, closed: true)
    }

    private static func regularPolygon(center: CGPoint, sides: Int, radius: CGFloat, color: UInt32, width: CGFloat) -> MotifStroke {
        var pts: [CGPoint] = []
        for i in 0...sides {
            let a = CGFloat(i) / CGFloat(sides) * .pi * 2 - .pi / 2
            pts.append(polar(center, radius, a))
        }
        return MotifStroke(id: 0, points: pts, colorHex: color, width: width, closed: true)
    }

    private static func sikku(between a: CGPoint, and b: CGPoint, color: UInt32) -> MotifStroke {
        let mx = (a.x + b.x) / 2
        let my = (a.y + b.y) / 2
        let dx = b.x - a.x
        let dy = b.y - a.y
        let length = hypot(dx, dy)
        guard length > 0 else { return MotifStroke(id: 0, points: [a, b], colorHex: color, width: 2, closed: false) }
        let nx = -dy / length * 0.045
        let ny = dx / length * 0.045
        let left = CGPoint(x: mx + nx, y: my + ny)
        let right = CGPoint(x: mx - nx, y: my - ny)
        let loop = sampleQuad(a, left, b) + sampleQuad(b, right, a)
        return MotifStroke(id: 0, points: loop, colorHex: color, width: 2.0, closed: true)
    }

    private static func sampleQuad(_ start: CGPoint, _ control: CGPoint, _ end: CGPoint, steps: Int = 12) -> [CGPoint] {
        (0...steps).map { i in
            let t = CGFloat(i) / CGFloat(steps)
            let mt = 1 - t
            return CGPoint(
                x: mt * mt * start.x + 2 * mt * t * control.x + t * t * end.x,
                y: mt * mt * start.y + 2 * mt * t * control.y + t * t * end.y
            )
        }
    }
}
