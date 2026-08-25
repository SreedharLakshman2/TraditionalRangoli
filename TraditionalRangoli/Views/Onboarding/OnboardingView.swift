import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var settings: SettingsStore
    @Environment(\.dismiss) private var dismiss
    @State private var page = 0

    private let pages: [(title: String, body: String, motif: MotifKind)] = [
        ("Discover living kolam", "Browse lotus, pulli, peacock and festival rangoli — each drawn as true courtyard geometry, not clip-art.", .lotusDot),
        ("Learn, then trace", "Watch a stroke bloom on the dots, then try it yourself. The app is kind about the path.", .pulli),
        ("Create with symmetry", "One line becomes four or eight. Rice powder, flowers and diyas finish the floor.", .mandala)
    ]

    var body: some View {
        ZStack {
            PaperBackground()
            VStack(spacing: 24) {
                Spacer()
                RangoliPreview(motif: pages[page].motif, animate: true)
                    .frame(width: 220, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
                    .goldFrame(cornerRadius: 36)
                    .shadow(color: Color.black.opacity(0.12), radius: 18, y: 8)
                Text(pages[page].title)
                    .font(RangoliFont.display(28))
                    .foregroundStyle(RangoliColor.ink)
                    .multilineTextAlignment(.center)
                Text(pages[page].body)
                    .font(RangoliFont.body(16))
                    .foregroundStyle(RangoliColor.muted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == page ? RangoliColor.primary : RangoliColor.muted.opacity(0.35))
                            .frame(width: index == page ? 22 : 8, height: 8)
                    }
                }
                Spacer()
                RangoliPrimaryButton(title: page == pages.count - 1 ? "Enter the courtyard" : "Next") {
                    if page == pages.count - 1 {
                        settings.hasSeenOnboarding = true
                        dismiss()
                    } else {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            page += 1
                        }
                    }
                }
            }
            .padding(24)
        }
        .preferredColorScheme(.light)
    }
}
