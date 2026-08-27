import SwiftUI

struct LanguagePickerList: View {
    @EnvironmentObject private var language: LanguageStore
    @Binding var query: String
    var onSelect: (() -> Void)? = nil

    private var filteredIndian: [AppLanguage] {
        filter(AppLanguage.indianLanguages)
    }

    private var filteredWorld: [AppLanguage] {
        filter(AppLanguage.worldLanguages)
    }

    var body: some View {
        VStack(spacing: 10) {
            TextField(language.t("searchLanguage"), text: $query)
                .font(RangoliFont.body(16))
                .padding(14)
                .background(RangoliColor.paper, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .goldFrame(cornerRadius: 16)

            if !filteredIndian.isEmpty {
                sectionTitle(language.t("indianLanguages"))
                ForEach(filteredIndian) { lang in
                    languageRow(lang)
                }
            }

            if !filteredWorld.isEmpty {
                sectionTitle(language.t("worldLanguages"))
                    .padding(.top, 6)
                ForEach(filteredWorld) { lang in
                    languageRow(lang)
                }
            }
        }
    }

    private func filter(_ list: [AppLanguage]) -> [AppLanguage] {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return list }
        return list.filter { $0.searchBlob.contains(q) }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(RangoliFont.label(12))
            .tracking(1.2)
            .foregroundStyle(RangoliColor.gold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func languageRow(_ lang: AppLanguage) -> some View {
        let selected = language.language == lang
        return Button {
            language.language = lang
            onSelect?()
        } label: {
            HStack(spacing: 12) {
                Text(lang.nativeName)
                    .font(RangoliFont.tamil(17))
                    .foregroundStyle(RangoliColor.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer(minLength: 8)
                Text(lang.englishName)
                    .font(RangoliFont.caption(13))
                    .foregroundStyle(RangoliColor.muted)
                    .lineLimit(1)
                if selected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(RangoliColor.primary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(selected ? RangoliColor.primary.opacity(0.12) : RangoliColor.paper)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(selected ? RangoliColor.gold : RangoliColor.gold.opacity(0.28), lineWidth: selected ? 1.5 : 1)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(lang.nativeName), \(lang.englishName)")
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}
