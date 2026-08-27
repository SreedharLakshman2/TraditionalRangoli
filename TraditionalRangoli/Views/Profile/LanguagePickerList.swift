import SwiftUI

struct LanguagePickerList: View {
    @EnvironmentObject private var language: LanguageStore
    @EnvironmentObject private var settings: SettingsStore
    @Environment(\.horizontalSizeClass) private var sizeClass
    @Binding var query: String
    var onSelect: (() -> Void)? = nil

    private var filteredIndian: [AppLanguage] {
        filter(AppLanguage.indianLanguages)
    }

    private var filteredWorld: [AppLanguage] {
        filter(AppLanguage.worldLanguages)
    }

    private var isSearching: Bool {
        !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            searchField
            if !isSearching {
                currentCard
            }
            if !filteredIndian.isEmpty {
                languageSection(title: language.t("indianLanguages"), languages: filteredIndian)
            }
            if !filteredWorld.isEmpty {
                languageSection(title: language.t("worldLanguages"), languages: filteredWorld)
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(RangoliColor.muted)
            TextField(language.t("searchLanguage"), text: $query)
                .font(RangoliFont.body(16))
                .foregroundStyle(RangoliColor.ink)
        }
        .padding(14)
        .background(RangoliColor.paper, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .goldFrame(cornerRadius: 16)
        .accessibilityLabel(language.t("searchLanguage"))
    }

    private var currentCard: some View {
        let lang = language.language
        return HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(lang.isIndian ? language.t("indianLanguages") : language.t("worldLanguages"))
                    .font(RangoliFont.label(11))
                    .tracking(1.2)
                    .foregroundStyle(RangoliColor.gold)
                Text(lang.nativeName)
                    .font(.rangoliScript(26, language: lang))
                    .foregroundStyle(RangoliColor.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                if lang.nativeName != lang.englishName {
                    Text(lang.englishName)
                        .font(RangoliFont.headline(15))
                        .foregroundStyle(RangoliColor.muted)
                }
            }
            Spacer(minLength: 8)
            RangoliPreview(motif: .lotusDot, animate: true)
                .frame(width: 68, height: 68)
                .clipShape(Circle())
                .overlay(Circle().stroke(RangoliColor.gold.opacity(0.45), lineWidth: 1))
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [RangoliColor.paper, RangoliColor.cardWash],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: RangoliRadius.lg, style: .continuous)
        )
        .goldFrame(cornerRadius: RangoliRadius.lg)
        .shadow(color: RangoliColor.primary.opacity(0.10), radius: 14, y: 8)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(lang.nativeName), \(lang.englishName)")
        .accessibilityAddTraits(.isSelected)
    }

    private func languageSection(title: String, languages: [AppLanguage]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(RangoliFont.label(12))
                .tracking(1.6)
                .foregroundStyle(RangoliColor.gold)
            LazyVGrid(columns: CourtyardLayout.languageColumns(regular: sizeClass == .regular), spacing: 10) {
                ForEach(languages) { lang in
                    languageTile(lang)
                }
            }
        }
    }

    private func languageTile(_ lang: AppLanguage) -> some View {
        let selected = language.language == lang
        return Button {
            Haptics.tap(settings)
            withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                language.language = lang
            }
            onSelect?()
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(lang.monogram)
                        .font(RangoliFont.headline(14))
                        .foregroundStyle(selected ? RangoliColor.onAccent : RangoliColor.primary)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle().fill(selected ? RangoliColor.primary : RangoliColor.primary.opacity(0.10))
                        )
                    Spacer(minLength: 0)
                    if selected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(RangoliColor.primary)
                    }
                }
                Text(lang.nativeName)
                    .font(lang.usesLatinScript ? RangoliFont.headline(16) : RangoliFont.tamil(16))
                    .foregroundStyle(RangoliColor.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                if lang.nativeName != lang.englishName {
                    Text(lang.englishName)
                        .font(RangoliFont.caption(12))
                        .foregroundStyle(RangoliColor.muted)
                        .lineLimit(1)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: selected
                        ? [RangoliColor.paper, RangoliColor.cardWash]
                        : [RangoliColor.paper, RangoliColor.paper],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                in: RoundedRectangle(cornerRadius: RangoliRadius.md, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: RangoliRadius.md, style: .continuous)
                    .stroke(
                        selected ? RangoliColor.gold : RangoliColor.gold.opacity(0.28),
                        lineWidth: selected ? 1.6 : 1
                    )
            )
            .shadow(
                color: selected ? RangoliColor.primary.opacity(0.12) : Color.black.opacity(0.04),
                radius: selected ? 10 : 6,
                y: 4
            )
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityLabel("\(lang.nativeName), \(lang.englishName)")
        .accessibilityAddTraits(selected ? .isSelected : [])
    }

    private func filter(_ list: [AppLanguage]) -> [AppLanguage] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return list }
        return list.filter { $0.searchBlob.contains(q) }
    }
}
