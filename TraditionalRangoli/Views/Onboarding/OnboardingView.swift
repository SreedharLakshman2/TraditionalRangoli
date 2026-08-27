import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var language: LanguageStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var page = 0
    @State private var languageQuery = ""

    private var teachingCount: Int { 3 }
    private var totalPages: Int { 1 + teachingCount }

    var body: some View {
        ZStack {
            PaperBackground()
            if page == 0 {
                languagePage
            } else {
                teachingPage
            }
        }
        .preferredColorScheme(settings.colorTheme.colorScheme)
        .onAppear {
            if page == 0 {
                language.language = .english
            }
        }
    }

    private var languagePage: some View {
        VStack(spacing: 16) {
            Text(language.t("appName"))
                .font(.rangoliScript(30, language: language.language))
                .foregroundStyle(RangoliColor.ink)
                .multilineTextAlignment(.center)
            Text(language.t("chooseLanguage"))
                .font(RangoliFont.headline(16))
                .foregroundStyle(RangoliColor.gold)
            ScrollView(showsIndicators: false) {
                LanguagePickerList(query: $languageQuery)
                    .padding(.bottom, 8)
            }
            RangoliPrimaryButton(title: language.t("continue")) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    page = 1
                }
            }
        }
        .padding(24)
        .courtyardColumn()
    }

    private var teachingPage: some View {
        let index = page - 1
        let titles = ["onboard1Title", "onboard2Title", "onboard3Title"]
        let bodies = ["onboard1Body", "onboard2Body", "onboard3Body"]
        let motifs: [MotifKind] = [.pulli, .sikkuKnot, .onamPookalam]
        return VStack(spacing: 24) {
            Spacer()
            RangoliPreview(motif: motifs[index], animate: true)
                .frame(width: sizeClass == .regular ? 300 : 220, height: sizeClass == .regular ? 300 : 220)
                .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
                .goldFrame(cornerRadius: 36)
                .shadow(color: Color.black.opacity(0.12), radius: 18, y: 8)
            Text(language.t(titles[index]))
                .font(.rangoliScript(28, language: language.language))
                .foregroundStyle(RangoliColor.ink)
                .multilineTextAlignment(.center)
            Text(language.t(bodies[index]))
                .font(RangoliFont.body(16))
                .foregroundStyle(RangoliColor.muted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
            HStack(spacing: 8) {
                ForEach(0..<totalPages, id: \.self) { dot in
                    Capsule()
                        .fill(dot == page ? RangoliColor.primary : RangoliColor.muted.opacity(0.35))
                        .frame(width: dot == page ? 22 : 8, height: 8)
                }
            }
            Spacer()
            RangoliPrimaryButton(title: page == totalPages - 1 ? language.t("beginLesson") : language.t("next")) {
                if page == totalPages - 1 {
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
        .courtyardColumn()
    }
}
