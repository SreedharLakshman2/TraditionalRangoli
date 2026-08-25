import SwiftUI

enum ScreenshotLaunch {
    static var scene: String? {
        if let env = ProcessInfo.processInfo.environment["RANGOLI_SCREENSHOT"]?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           env.isEmpty == false {
            return env
        }
        let args = ProcessInfo.processInfo.arguments
        if let index = args.firstIndex(of: "-storeScreenshot"),
           args.indices.contains(index + 1) {
            let value = args[index + 1].trimmingCharacters(in: .whitespacesAndNewlines)
            return value.isEmpty ? nil : value
        }
        return nil
    }

    static var isActive: Bool { scene != nil }

    static var lotus: RangoliPattern {
        PatternCatalog.pattern(id: "lotus-dot") ?? PatternCatalog.all[0]
    }

    @MainActor
    static func studioSession(decorate: Bool = false) -> DrawingSession {
        let pattern = lotus
        let session = DrawingSession(
            studio: decorate ? .template : .dots,
            pattern: pattern,
            gridSize: pattern.gridSize,
            showGuides: false
        )
        session.apply(motifStrokes: GeometryFactory.strokes(for: pattern.motif))
        session.showGrid = !decorate
        session.snapToDots = false
        session.symmetry = .eightWay
        session.color = .gold
        session.brush = .medium
        if decorate {
            session.applyFestivalFills()
            session.tool = .flower
            session.showGrid = false
        }
        return session
    }
}

struct ScreenshotRoot: View {
    let scene: String

    var body: some View {
        Group {
            switch scene {
            case "learn":
                GuidedLearningView(pattern: ScreenshotLaunch.lotus, screenshotStep: 2)
            case "studio":
                DrawingStudioView(session: ScreenshotLaunch.studioSession())
            case "color":
                ColoringView(session: ScreenshotLaunch.studioSession(decorate: true), onDone: {})
            default:
                RootView()
            }
        }
        .preferredColorScheme(.light)
    }
}
