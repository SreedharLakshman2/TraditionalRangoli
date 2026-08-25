import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var settings: SettingsStore
    @EnvironmentObject private var artworks: ArtworkStore

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                SectionHeader(title: "My Rangoli Journey")
                stats
                progressCard
                achievements
                settingsCard
                about
            }
            .padding(20)
            .padding(.bottom, 12)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var stats: some View {
        HStack(spacing: 10) {
            statTile("\(settings.patternsCompleted)", "Patterns")
            statTile(settings.levelTitle.components(separatedBy: " ").last ?? "Beginner", "Level")
            statTile("\(settings.xp)", "Total XP")
            statTile(settings.favoriteStyle, "Style")
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
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .paperCard(radius: RangoliRadius.md)
    }

    private var progressCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(settings.levelTitle)
                .font(RangoliFont.title(20))
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
            Text("Keep a quiet daily practice. XP arrives when a rangoli is completed.")
                .font(RangoliFont.caption(12))
                .foregroundStyle(RangoliColor.muted)
        }
        .padding(16)
        .paperCard()
    }

    private var achievements: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Achievements")
                .font(RangoliFont.title(20))
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                badge("🪷", "First Rangoli", unlocked: settings.patternsCompleted >= 1)
                badge("🌸", "5 Patterns", unlocked: settings.patternsCompleted >= 5)
                badge("🔥", "7 Day Streak", unlocked: settings.streak >= 7)
                badge("🏆", "Master Creator", unlocked: settings.xp >= 500)
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
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .paperCard(radius: RangoliRadius.md)
        .opacity(unlocked ? 1 : 0.7)
        .accessibilityLabel("\(title)\(unlocked ? ", unlocked" : ", locked")")
    }

    private var settingsCard: some View {
        VStack(spacing: 0) {
            Toggle("Sound", isOn: $settings.soundEnabled)
                .padding(.vertical, 12)
            Divider()
            Toggle("Haptics", isOn: $settings.hapticsEnabled)
                .padding(.vertical, 12)
            Divider()
            Toggle("Show Guides", isOn: $settings.showGuides)
                .padding(.vertical, 12)
            Divider()
            Picker("Default Grid", selection: $settings.defaultGrid) {
                Text("7 × 7").tag(7)
                Text("9 × 9").tag(9)
                Text("11 × 11").tag(11)
                Text("15 × 15").tag(15)
            }
            .padding(.vertical, 8)
            Divider()
            HStack {
                Text("Theme")
                Spacer()
                Text("Ivory courtyard")
                    .foregroundStyle(RangoliColor.muted)
            }
            .padding(.vertical, 12)
        }
        .font(RangoliFont.body(16))
        .foregroundStyle(RangoliColor.ink)
        .padding(.horizontal, 16)
        .paperCard()
        .tint(RangoliColor.primary)
    }

    private var about: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About")
                .font(RangoliFont.title(20))
            Text("\(RangoliColor.brand) is a courtyard companion for kolam and rangoli. Artwork stays on this iPhone.")
                .font(RangoliFont.body(15))
                .foregroundStyle(RangoliColor.muted)
            Link("Support", destination: RangoliColor.supportURL)
            Link("Privacy Policy", destination: RangoliColor.privacyURL)
            Text(RangoliColor.copyright)
                .font(RangoliFont.caption(12))
                .foregroundStyle(RangoliColor.muted)
        }
        .padding(16)
        .paperCard()
    }
}
