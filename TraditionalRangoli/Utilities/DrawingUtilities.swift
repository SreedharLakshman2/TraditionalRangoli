import SwiftUI

enum DrawingUtilities {
    static func gridPoints(size: Int, in canvas: CGSize, insetRatio: CGFloat = 0.1) -> [CGPoint] {
        guard size > 1 else { return [] }
        let inset = min(canvas.width, canvas.height) * insetRatio
        let usable = min(canvas.width, canvas.height) - inset * 2
        let origin = CGPoint(
            x: (canvas.width - usable) / 2,
            y: (canvas.height - usable) / 2
        )
        let cell = usable / CGFloat(size - 1)
        var points: [CGPoint] = []
        points.reserveCapacity(size * size)
        for row in 0..<size {
            for col in 0..<size {
                points.append(CGPoint(x: origin.x + CGFloat(col) * cell, y: origin.y + CGFloat(row) * cell))
            }
        }
        return points
    }

    static func snap(_ point: CGPoint, gridSize: Int, in canvas: CGSize, threshold: CGFloat = 0.38) -> CGPoint {
        let dots = gridPoints(size: gridSize, in: canvas)
        guard let nearest = dots.min(by: { hypot($0.x - point.x, $0.y - point.y) < hypot($1.x - point.x, $1.y - point.y) }) else {
            return point
        }
        let cell = min(canvas.width, canvas.height) * 0.8 / CGFloat(max(gridSize - 1, 1))
        if hypot(nearest.x - point.x, nearest.y - point.y) <= cell * threshold {
            return nearest
        }
        return point
    }

    static func shouldAccept(from last: CGPoint, to next: CGPoint, cell: CGFloat) -> Bool {
        let distance = hypot(next.x - last.x, next.y - last.y)
        return distance > 0.6 && distance < cell * 2.4
    }

    static func interpolate(from: CGPoint, to: CGPoint, spacing: CGFloat) -> [CGPoint] {
        let distance = hypot(to.x - from.x, to.y - from.y)
        guard distance > spacing else { return [to] }
        let steps = Int(distance / spacing)
        var points: [CGPoint] = []
        for i in 1...steps {
            let t = CGFloat(i) / CGFloat(steps)
            points.append(CGPoint(x: from.x + (to.x - from.x) * t, y: from.y + (to.y - from.y) * t))
        }
        return points
    }

    static func smoothPath(points: [CGPoint]) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        guard points.count > 1 else { return path }
        if points.count == 2 {
            path.addLine(to: points[1])
            return path
        }
        for index in 1..<points.count {
            let previous = points[index - 1]
            let current = points[index]
            let mid = CGPoint(x: (previous.x + current.x) / 2, y: (previous.y + current.y) / 2)
            path.addQuadCurve(to: mid, control: previous)
        }
        path.addLine(to: points.last!)
        return path
    }

    static func mapped(_ point: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(x: point.x * size.width, y: point.y * size.height)
    }

    static func normalized(_ point: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: size.width == 0 ? 0 : point.x / size.width,
            y: size.height == 0 ? 0 : point.y / size.height
        )
    }

    static func strokeCloseness(user: [CGPoint], target: [CGPoint], in size: CGSize) -> CGFloat {
        guard !user.isEmpty, !target.isEmpty else { return 0 }
        let mappedUser = user.map { point in
            point.x <= 1.2 && point.y <= 1.2 ? mapped(point, in: size) : point
        }
        let mappedTarget = target.map { mapped($0, in: size) }
        let sample = stride(from: 0, to: mappedTarget.count, by: max(1, mappedTarget.count / 18)).map { mappedTarget[$0] }
        var hits = 0
        let threshold = min(size.width, size.height) * 0.11
        for goal in sample {
            if mappedUser.contains(where: { hypot($0.x - goal.x, $0.y - goal.y) < threshold }) {
                hits += 1
            }
        }
        return CGFloat(hits) / CGFloat(max(sample.count, 1))
    }

    /// Older drawings stored pixel coordinates. New strokes are 0...1 of the square canvas.
    static func normalizedStrokes(_ strokes: [DrawStroke]) -> [DrawStroke] {
        let coords = strokes.flatMap(\.points)
        guard let maxV = coords.map({ max($0.x, $0.y) }).max(), maxV > 1.2 else { return strokes }
        let scale = max(320, maxV)
        return strokes.map { stroke in
            var copy = stroke
            copy.points = stroke.points.map { Point2D(x: $0.x / scale, y: $0.y / scale) }
            return copy
        }
    }
}
