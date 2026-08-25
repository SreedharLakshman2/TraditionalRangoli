import CoreGraphics

enum SymmetryEngine {
    static func copies(of points: [CGPoint], mode: SymmetryMode, center: CGPoint) -> [[CGPoint]] {
        guard !points.isEmpty else { return [] }
        switch mode {
        case .none:
            return [points]
        case .horizontal:
            return [points, mirror(points, across: .horizontal, center: center)]
        case .vertical:
            return [points, mirror(points, across: .vertical, center: center)]
        case .fourWay:
            let h = mirror(points, across: .horizontal, center: center)
            let v = mirror(points, across: .vertical, center: center)
            let hv = mirror(h, across: .vertical, center: center)
            return [points, h, v, hv]
        case .eightWay:
            let angles: [CGFloat] = [0, .pi / 4, .pi / 2, 3 * .pi / 4, .pi, 5 * .pi / 4, 3 * .pi / 2, 7 * .pi / 4]
            return angles.map { rotate(points, by: $0, around: center) }
        }
    }

    static func copies(of point: CGPoint, mode: SymmetryMode, center: CGPoint) -> [CGPoint] {
        copies(of: [point], mode: mode, center: center).compactMap(\.first)
    }

    private enum Axis { case horizontal, vertical }

    private static func mirror(_ points: [CGPoint], across axis: Axis, center: CGPoint) -> [CGPoint] {
        points.map { point in
            switch axis {
            case .horizontal:
                return CGPoint(x: point.x, y: center.y * 2 - point.y)
            case .vertical:
                return CGPoint(x: center.x * 2 - point.x, y: point.y)
            }
        }
    }

    private static func rotate(_ points: [CGPoint], by angle: CGFloat, around center: CGPoint) -> [CGPoint] {
        let cosine = cos(angle)
        let sine = sin(angle)
        return points.map { point in
            let dx = point.x - center.x
            let dy = point.y - center.y
            return CGPoint(
                x: center.x + dx * cosine - dy * sine,
                y: center.y + dx * sine + dy * cosine
            )
        }
    }
}
