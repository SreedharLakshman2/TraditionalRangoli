import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var artworks: ArtworkStore
    @EnvironmentObject private var language: LanguageStore
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var languageQuery = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(title: language.t("profileJourney"))
                stats
                progressCard
                achievements
                languageCard
                themeCard
                settingsCard
                about
            }
            .padding(20)
            .padding(.bottom, 12)
            .courtyardColumn()
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var stats: some View {
        HStack(spacing: 10) {
            statTile("\(settings.patternsCompleted)", language.t("patternsStat"))
            statTile(settings.localizedLevelTitle(language.language), language.t("levelStat"))
            statTile("\(settings.xp)", language.t("xpStat"))
            statTile(settings.localizedStyle(language.language), language.t("styleStat"))
        }
    }

    private func statTile(_ value: String, _ label: String) -> some View {
        VStack(spacing: 6) {
            Text(value)
                .font(RangoliFont.headline(13))
                .foregroundStyle(RangoliColor.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(label)
                .font(RangoliFont.label(10))
                .foregroundStyle(RangoliColor.muted)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .paperCard(radius: RangoliRadius.md)
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(settings.localizedLevelTitle(language.language))
                .font(.rangoliScript(20, language: language.language))
                .foregroundStyle(RangoliColor.ink)
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(RangoliColor.gold.opacity(0.18))
                    Capsule()
                        .fill(RangoliColor.primary)
                        .frame(width: geo.size.width * settings.levelProgress)
                }
            }
            .frame(height: 8)
            Text(language.t("practiceNote"))
                .font(RangoliFont.caption(12))
                .foregroundStyle(RangoliColor.muted)
        }
        .padding(16)
        .paperCard()
    }

    private var achievements: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(language.t("achievements"))
                .font(.rangoliScript(20, language: language.language))
            LazyVGrid(columns: CourtyardLayout.achievementColumns(regular: sizeClass == .regular), spacing: 10) {
                badge("🪷", language.t("badgeFirst"), unlocked: settings.patternsCompleted >= 1)
                badge("🌸", language.t("badgeFive"), unlocked: settings.patternsCompleted >= 5)
                badge("🔥", language.t("badgeStreak"), unlocked: settings.streak >= 7)
                badge("🏆", language.t("badgeMaster"), unlocked: settings.xp >= 500)
            }
        }
    }

    private func badge(_ emoji: String, _ title: String, unlocked: Bool) -> some View {
        VStack(spacing: 8) {
            Text(emoji)
                .font(.title)
                .opacity(unlocked ? 1 : 0.35)
            Text(title)
                .font(RangoliFont.caption(12))
                .foregroundStyle(unlocked ? RangoliColor.ink : RangoliColor.muted)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .paperCard(radius: RangoliRadius.md)
        .opacity(unlocked ? 1 : 0.7)
        .accessibilityLabel("\(title), \(language.t(unlocked ? "unlocked" : "locked"))")
    }

    private var languageCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: language.t("language"), subtitle: language.t("chooseLanguage"))
            LanguagePickerList(query: $languageQuery)
        }
    }

    private var settingsCard: some View {
        VStack(spacing: 0) {
            Toggle(language.t("sound"), isOn: $settings.soundEnabled)
                .padding(.vertical, 12)
            Divider()
            Toggle(language.t("haptics"), isOn: $settings.hapticsEnabled)
                .padding(.vertical, 12)
            Divider()
            Toggle(language.t("showGuides"), isOn: $settings.showGuides)
                .padding(.vertical, 12)
            Divider()
            Picker(language.t("defaultGrid"), selection: $settings.defaultGrid) {
                Text("7 × 7").tag(7)
                Text("9 × 9").tag(9)
                Text("11 × 11").tag(11)
                Text("15 × 15").tag(15)
            }
            .padding(.vertical, 8)
        }
        .font(RangoliFont.body(16))
        .foregroundStyle(RangoliColor.ink)
        .padding(.horizontal, 16)
        .paperCard()
        .tint(RangoliColor.primary)
    }

    private var themeCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(language.t("chooseTheme"))
                .font(.rangoliScript(20, language: language.language))
                .foregroundStyle(RangoliColor.ink)
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(CourtyardColorTheme.allCases) { theme in
                    Button {
                        Haptics.tap(settings)
                        settings.colorTheme = theme
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Circle().fill(theme.palette.primary).frame(width: 16, height: 16)
                                Circle().fill(theme.palette.gold).frame(width: 16, height: 16)
                                Circle().fill(theme.palette.paper).frame(width: 16, height: 16)
                                    .overlay(Circle().stroke(theme.palette.ink.opacity(0.18), lineWidth: 1))
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(theme.palette.primary)
                                    .opacity(settings.colorTheme == theme ? 1 : 0)
                            }
                            Text(theme.localizedTitle(language.language))
                                .font(RangoliFont.caption(12))
                                .foregroundStyle(theme.palette.ink)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, minHeight: 88, alignment: .topLeading)
                        .background(theme.palette.ivory, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(
                                    settings.colorTheme == theme ? theme.palette.primary : theme.palette.ink.opacity(0.14),
                                    lineWidth: settings.colorTheme == theme ? 2 : 1
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(theme.localizedTitle(language.language))
                    .accessibilityAddTraits(settings.colorTheme == theme ? .isSelected : [])
                }
            }
        }
        .padding(16)
        .paperCard()
    }

    private var about: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(language.t("about"))
                .font(.rangoliScript(20, language: language.language))
                .foregroundStyle(RangoliColor.ink)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(language.t("aboutApp"))
                .font(RangoliFont.body(15))
                .foregroundStyle(RangoliColor.muted)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
            Text(language.t("adsNote"))
                .font(RangoliFont.caption(13))
                .foregroundStyle(RangoliColor.muted)
                .padding(.top, 8)
            aboutLink(language.t("support"), RangoliColor.supportURL)
                .padding(.top, 14)
            Divider()
            aboutLink(language.t("privacy"), RangoliColor.privacyURL)
            Divider()
            Button {
                Haptics.tap(settings)
                ReviewPrompt.requestReview()
            } label: {
                HStack {
                    Text(language.t("rateApp"))
                        .font(RangoliFont.headline(16))
                        .foregroundStyle(RangoliColor.primary)
                    Spacer()
                    Image(systemName: "star.fill")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(RangoliColor.gold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(language.t("rateApp"))
            Text(RangoliColor.copyright)
                .font(RangoliFont.caption(12))
                .foregroundStyle(RangoliColor.muted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .paperCard()
    }

    private func aboutLink(_ title: String, _ url: URL) -> some View {
        Link(destination: url) {
            HStack {
                Text(title)
                    .font(RangoliFont.headline(16))
                    .foregroundStyle(RangoliColor.primary)
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(RangoliColor.gold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
    }
}
