import SwiftUI

struct PaperBackground: View {
    var showWatermark: Bool = true

    var body: some View {
        ZStack {
            RangoliColor.ivory
            Canvas { context, size in
                for i in 0..<28 {
                    let y = size.height * CGFloat(i) / 28
                    var fiber = Path()
                    fiber.move(to: CGPoint(x: 0, y: y + CGFloat(i % 3)))
                    fiber.addLine(to: CGPoint(x: size.width, y: y))
                    context.stroke(fiber, with: .color(RangoliColor.gold.opacity(0.04)), lineWidth: 0.6)
                }
                for i in 0..<40 {
                    let x = CGFloat((i * 47) % 97) / 97 * size.width
                    let y = CGFloat((i * 73) % 89) / 89 * size.height
                    let speckle = Path(ellipseIn: CGRect(x: x, y: y, width: 1.4, height: 1.4))
                    context.fill(speckle, with: .color(Color.black.opacity(0.025)))
                }
            }
            .allowsHitTesting(false)
            if showWatermark {
                KolamWatermark()
                    .opacity(0.07)
                    .allowsHitTesting(false)
            }
        }
        .ignoresSafeArea()
    }
}

struct KolamWatermark: View {
    var body: some View {
        GeometryReader { geo in
            RangoliPreview(motif: .mandala, progress: 1, floor: false)
                .frame(width: geo.size.width * 1.15, height: geo.size.width * 1.15)
                .position(x: geo.size.width * 0.82, y: geo.size.height * 0.18)
        }
    }
}

struct ClayFloor: View {
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [RangoliColor.floorLight, RangoliColor.floorMid, RangoliColor.floorDeep],
                center: .center,
                startRadius: 10,
                endRadius: 280
            )
            Canvas { context, size in
                for i in 0..<70 {
                    let x = CGFloat((i * 37) % 101) / 101 * size.width
                    let y = CGFloat((i * 53) % 97) / 97 * size.height
                    let grain = Path(ellipseIn: CGRect(x: x, y: y, width: 2.2, height: 1.4))
                    context.fill(grain, with: .color(Color.black.opacity(0.08)))
                }
            }
        }
    }
}

struct GoldCornerFrame: View {
    var body: some View {
        GeometryReader { geo in
            let w = min(28, geo.size.width * 0.12)
            ZStack {
                corner.position(x: w, y: w)
                corner.rotationEffect(.degrees(90)).position(x: geo.size.width - w, y: w)
                corner.rotationEffect(.degrees(180)).position(x: geo.size.width - w, y: geo.size.height - w)
                corner.rotationEffect(.degrees(270)).position(x: w, y: geo.size.height - w)
            }
        }
        .allowsHitTesting(false)
    }

    private var corner: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 18))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 18, y: 0))
        }
        .stroke(RangoliColor.gold.opacity(0.7), style: StrokeStyle(lineWidth: 1.4, lineCap: .round))
    }
}
