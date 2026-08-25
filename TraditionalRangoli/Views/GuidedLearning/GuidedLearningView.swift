import SwiftUI

struct GuidedLearningView: View {
    let pattern: RangoliPattern
    @StateObject private var session: DrawingSession
    @EnvironmentObject private var settings: SettingsStore
    @Environment(\.dismiss) private var dismiss
    @State private var stepIndex = 0
    @State private var successPulse = false
    @State private var hint: String?
    @State private var completed: UserArtwork?
    @State private var strokeMark = 0

    init(pattern: RangoliPattern) {
        self.pattern = pattern
        _session = StateObject(wrappedValue: DrawingSession(studio: .dots, pattern: pattern, gridSize: pattern.gridSize, showGuides: true))
    }

    private var steps: [RangoliStep] { pattern.steps }
    private var total: Int { max(steps.count, 1) }

    var body: some View {
        ZStack {
            PaperBackground(showWatermark: false)
            VStack(spacing: 12) {
                header
                progressDots
                DrawingCanvas(session: session)
                    .padding(.horizontal, 16)
                    .overlay {
                        if successPulse {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .stroke(RangoliColor.gold, lineWidth: 3)
                                .padding(.horizontal, 16)
                        }
                    }
                    .onChange(of: session.strokes.count) { _, count in
                        if count > strokeMark {
                            strokeMark = count
                            validateLatest()
                        }
                    }

                Text("STEP \(stepIndex + 1) OF \(total)")
                    .font(RangoliFont.label(12))
                    .tracking(1.4)
                    .foregroundStyle(RangoliColor.gold)
                Text(hint ?? (steps.indices.contains(stepIndex) ? steps[stepIndex].instruction : "Trace the faint stroke."))
                    .font(RangoliFont.body(16))
                    .foregroundStyle(RangoliColor.ink)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .frame(minHeight: 64)

                HStack(spacing: 12) {
                    RangoliSecondaryButton(title: "Back") {
                        if stepIndex == 0 {
                            dismiss()
                        } else {
                            stepIndex -= 1
                            hint = nil
                        }
                    }
                    RangoliPrimaryButton(title: stepIndex == total - 1 ? "Finish" : "Next") {
                        advance()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .padding(.top, 8)
        }
        .preferredColorScheme(.light)
        .fullScreenCover(item: $completed) { art in
            CompletionView(artwork: art, pattern: pattern) {
                completed = nil
                dismiss()
            }
        }
    }

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(RangoliColor.ink)
                    .frame(width: 40, height: 40)
                    .background(RangoliColor.paper, in: Circle())
            }
            .accessibilityLabel("Close")
            Spacer()
            Text(pattern.title)
                .font(RangoliFont.headline(17))
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 16)
    }

    private var progressDots: some View {
        HStack(spacing: 7) {
            ForEach(0..<total, id: \.self) { index in
                Circle()
                    .fill(index <= stepIndex ? RangoliColor.primary : RangoliColor.muted.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
        .accessibilityLabel("Step \(stepIndex + 1) of \(total)")
    }

    private func validateLatest() {
        let target = GeometryFactory.strokes(for: pattern.motif)
        guard steps.indices.contains(stepIndex), target.indices.contains(steps[stepIndex].strokeIndex) else {
            advance()
            return
        }
        let goal = target[steps[stepIndex].strokeIndex].points
        let user = session.strokes.last.map { $0.points.map(\.cg) } ?? []
        let canvas = CGSize(width: 320, height: 320)
        let score = DrawingUtilities.strokeCloseness(user: user, target: goal, in: canvas)
        if score >= 0.32 {
            Haptics.success(settings)
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                successPulse = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                successPulse = false
                advance()
            }
        } else {
            hint = "Almost — follow the faint stroke a little more closely."
            Haptics.tap(settings)
        }
    }

    private func advance() {
        hint = nil
        if stepIndex >= total - 1 {
            let data = ArtworkSnapshot.png(session: session)
            completed = session.artwork(title: pattern.title, thumbnail: data)
        } else {
            stepIndex += 1
        }
    }
}
