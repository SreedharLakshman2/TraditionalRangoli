import Foundation
import CoreGraphics
import ImageIO
import UniformTypeIdentifiers

let size: CGFloat = 1024
let colorSpace = CGColorSpaceCreateDeviceRGB()
let ctx = CGContext(
    data: nil,
    width: Int(size),
    height: Int(size),
    bitsPerComponent: 8,
    bytesPerRow: 0,
    space: colorSpace,
    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
)!

func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> CGColor {
    CGColor(srgbRed: r, green: g, blue: b, alpha: a)
}

let ivory = rgb(1.00, 0.973, 0.933)
let maroon = rgb(0.608, 0.173, 0.173)
let gold = rgb(0.784, 0.608, 0.235)
let goldSoft = rgb(0.910, 0.773, 0.420)
let clay = rgb(0.420, 0.227, 0.133)
let leaf = rgb(0.247, 0.420, 0.310)

ctx.setFillColor(ivory)
ctx.fill(CGRect(x: 0, y: 0, width: size, height: size))

let center = CGPoint(x: size / 2, y: size / 2)

func polar(_ radius: CGFloat, _ angle: CGFloat) -> CGPoint {
    CGPoint(x: center.x + cos(angle) * radius, y: center.y + sin(angle) * radius)
}

// Courtyard disc
ctx.setFillColor(clay)
ctx.fillEllipse(in: CGRect(x: 72, y: 72, width: size - 144, height: size - 144))

// Warm inner wash
let gradient = CGGradient(
    colorsSpace: colorSpace,
    colors: [rgb(0.545, 0.325, 0.204, 1) as Any, clay as Any] as CFArray,
    locations: [0, 1]
)!
ctx.drawRadialGradient(
    gradient,
    startCenter: center,
    startRadius: 20,
    endCenter: center,
    endRadius: 430,
    options: []
)

func petal(angle: CGFloat, distance: CGFloat, length: CGFloat, flare: CGFloat, fill: CGColor, stroke: CGColor) {
    let base = polar(distance, angle)
    let tip = polar(distance + length, angle)
    let left = polar(distance + length * 0.46, angle - flare)
    let right = polar(distance + length * 0.46, angle + flare)
    ctx.beginPath()
    ctx.move(to: base)
    ctx.addQuadCurve(to: tip, control: left)
    ctx.addQuadCurve(to: base, control: right)
    ctx.closePath()
    ctx.setFillColor(fill)
    ctx.fillPath()
    ctx.beginPath()
    ctx.move(to: base)
    ctx.addQuadCurve(to: tip, control: left)
    ctx.addQuadCurve(to: base, control: right)
    ctx.closePath()
    ctx.setStrokeColor(stroke)
    ctx.setLineWidth(7)
    ctx.strokePath()
}

for i in 0..<8 {
    let a = CGFloat(i) / 8 * .pi * 2 - .pi / 2
    petal(angle: a, distance: 118, length: 250, flare: 0.42, fill: maroon, stroke: goldSoft)
}
for i in 0..<8 {
    let a = CGFloat(i) / 8 * .pi * 2 - .pi / 2 + .pi / 8
    petal(angle: a, distance: 108, length: 168, flare: 0.32, fill: gold, stroke: maroon)
}

ctx.setFillColor(goldSoft)
ctx.fillEllipse(in: CGRect(x: center.x - 86, y: center.y - 86, width: 172, height: 172))
ctx.setFillColor(maroon)
ctx.fillEllipse(in: CGRect(x: center.x - 46, y: center.y - 46, width: 92, height: 92))
ctx.setFillColor(goldSoft)
ctx.fillEllipse(in: CGRect(x: center.x - 18, y: center.y - 18, width: 36, height: 36))

ctx.setStrokeColor(gold)
ctx.setLineWidth(14)
ctx.strokeEllipse(in: CGRect(x: 96, y: 96, width: size - 192, height: size - 192))
ctx.setStrokeColor(leaf)
ctx.setLineWidth(6)
ctx.strokeEllipse(in: CGRect(x: 128, y: 128, width: size - 256, height: size - 256))

for i in 0..<16 {
    let a = CGFloat(i) / 16 * .pi * 2
    let p = polar(390, a)
    ctx.setFillColor(goldSoft)
    ctx.fillEllipse(in: CGRect(x: p.x - 14, y: p.y - 14, width: 28, height: 28))
}

guard let image = ctx.makeImage() else { fatalError("no image") }
let dest = URL(fileURLWithPath: CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "AppIcon.png")
let destCG = CGImageDestinationCreateWithURL(dest as CFURL, UTType.png.identifier as CFString, 1, nil)!
CGImageDestinationAddImage(destCG, image, nil)
CGImageDestinationFinalize(destCG)
print("Wrote \(dest.path)")
