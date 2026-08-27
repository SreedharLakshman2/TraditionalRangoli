import SwiftUI
import UIKit

struct CourtyardPalette: Equatable {
    let ivoryHex: UInt32
    let paperHex: UInt32
    let clayHex: UInt32
    let floorDeepHex: UInt32
    let floorMidHex: UInt32
    let floorLightHex: UInt32
    let primaryHex: UInt32
    let maroonHex: UInt32
    let terracottaHex: UInt32
    let secondaryHex: UInt32
    let goldHex: UInt32
    let goldSoftHex: UInt32
    let greenHex: UInt32
    let leafHex: UInt32
    let inkHex: UInt32
    let mutedHex: UInt32
    let riceHex: UInt32
    let powderWhiteHex: UInt32
    let onAccentHex: UInt32
    let cardWashHex: UInt32

    var ivory: Color { Color(hex: ivoryHex) }
    var paper: Color { Color(hex: paperHex) }
    var clay: Color { Color(hex: clayHex) }
    var floorDeep: Color { Color(hex: floorDeepHex) }
    var floorMid: Color { Color(hex: floorMidHex) }
    var floorLight: Color { Color(hex: floorLightHex) }
    var primary: Color { Color(hex: primaryHex) }
    var maroon: Color { Color(hex: maroonHex) }
    var terracotta: Color { Color(hex: terracottaHex) }
    var secondary: Color { Color(hex: secondaryHex) }
    var gold: Color { Color(hex: goldHex) }
    var goldSoft: Color { Color(hex: goldSoftHex) }
    var green: Color { Color(hex: greenHex) }
    var leaf: Color { Color(hex: leafHex) }
    var ink: Color { Color(hex: inkHex) }
    var muted: Color { Color(hex: mutedHex) }
    var rice: Color { Color(hex: riceHex) }
    var powderWhite: Color { Color(hex: powderWhiteHex) }
    var onAccent: Color { Color(hex: onAccentHex) }
    var cardWash: Color { Color(hex: cardWashHex) }
}

enum CourtyardColorTheme: String, CaseIterable, Identifiable {
    case ivoryCourtyard
    case midnightIndigo
    case lotusBlush
    case keralaGreen
    case deepavaliGold
    case terracottaClay

    var id: String { rawValue }

    var l10nKey: String {
        switch self {
        case .ivoryCourtyard: return "ivoryCourtyard"
        case .midnightIndigo: return "themeMidnight"
        case .lotusBlush: return "themeLotusBlush"
        case .keralaGreen: return "themeKeralaGreen"
        case .deepavaliGold: return "themeDeepavaliGold"
        case .terracottaClay: return "themeTerracottaClay"
        }
    }

    var colorScheme: ColorScheme {
        self == .midnightIndigo ? .dark : .light
    }

    static let storageKey = "rangoli.colorTheme"
    static var cached: CourtyardColorTheme?

    static var current: CourtyardColorTheme {
        if let cached { return cached }
        let raw = UserDefaults.standard.string(forKey: storageKey) ?? ivoryCourtyard.rawValue
        let value = CourtyardColorTheme(rawValue: raw) ?? .ivoryCourtyard
        cached = value
        return value
    }

    static func setCurrent(_ theme: CourtyardColorTheme) {
        cached = theme
        UserDefaults.standard.set(theme.rawValue, forKey: storageKey)
    }

    var palette: CourtyardPalette {
        let clayFloor = (deep: UInt32(0x6A3A22), mid: UInt32(0x8A5333), light: UInt32(0xB07A4C), clay: UInt32(0xC48A5A))
        switch self {
        case .ivoryCourtyard:
            return CourtyardPalette(
                ivoryHex: 0xFFF8EE, paperHex: 0xFFFCF6, clayHex: clayFloor.clay,
                floorDeepHex: clayFloor.deep, floorMidHex: clayFloor.mid, floorLightHex: clayFloor.light,
                primaryHex: 0x9B2C2C, maroonHex: 0x6B1D1D, terracottaHex: 0xC45C2A,
                secondaryHex: 0xD97706, goldHex: 0xC89B3C, goldSoftHex: 0xE8C56B,
                greenHex: 0x3F6B4F, leafHex: 0x5C8A64, inkHex: 0x2D241F, mutedHex: 0x806F63,
                riceHex: 0xF7F1E3, powderWhiteHex: 0xFFF8E7, onAccentHex: 0xFFF8EE, cardWashHex: 0xF3E6D0
            )
        case .midnightIndigo:
            return CourtyardPalette(
                ivoryHex: 0x161426, paperHex: 0x1E1C32, clayHex: clayFloor.clay,
                floorDeepHex: clayFloor.deep, floorMidHex: clayFloor.mid, floorLightHex: clayFloor.light,
                primaryHex: 0xC9A227, maroonHex: 0x8C6B2A, terracottaHex: 0xD4784A,
                secondaryHex: 0x7C9CFF, goldHex: 0xE8C56B, goldSoftHex: 0xF3DEA0,
                greenHex: 0x7CB89A, leafHex: 0x9FD4B5, inkHex: 0xF4EDE0, mutedHex: 0xB8A99A,
                riceHex: 0x2A2740, powderWhiteHex: 0xF7F1E3, onAccentHex: 0x161426, cardWashHex: 0x252248
            )
        case .lotusBlush:
            return CourtyardPalette(
                ivoryHex: 0xFFF5F7, paperHex: 0xFFFCFC, clayHex: clayFloor.clay,
                floorDeepHex: clayFloor.deep, floorMidHex: clayFloor.mid, floorLightHex: clayFloor.light,
                primaryHex: 0xB83B5E, maroonHex: 0x7A2440, terracottaHex: 0xD46A7A,
                secondaryHex: 0xE8A0B0, goldHex: 0xD4A574, goldSoftHex: 0xE8C4A0,
                greenHex: 0x4F7A5C, leafHex: 0x6B9A78, inkHex: 0x3A242C, mutedHex: 0x8A6B74,
                riceHex: 0xFFF0F3, powderWhiteHex: 0xFFF8F9, onAccentHex: 0xFFF5F7, cardWashHex: 0xF8DCE4
            )
        case .keralaGreen:
            return CourtyardPalette(
                ivoryHex: 0xF4F8F0, paperHex: 0xFBFFF8, clayHex: clayFloor.clay,
                floorDeepHex: clayFloor.deep, floorMidHex: clayFloor.mid, floorLightHex: clayFloor.light,
                primaryHex: 0x1F6B4A, maroonHex: 0x145238, terracottaHex: 0xC45C2A,
                secondaryHex: 0xE3B23C, goldHex: 0xC9A227, goldSoftHex: 0xE8C56B,
                greenHex: 0x2F7A4E, leafHex: 0x5C8A64, inkHex: 0x1E2A22, mutedHex: 0x5E7364,
                riceHex: 0xEEF5E8, powderWhiteHex: 0xF7FBF2, onAccentHex: 0xF4F8F0, cardWashHex: 0xDCE8D0
            )
        case .deepavaliGold:
            return CourtyardPalette(
                ivoryHex: 0xFFF6E8, paperHex: 0xFFFBF3, clayHex: clayFloor.clay,
                floorDeepHex: clayFloor.deep, floorMidHex: clayFloor.mid, floorLightHex: clayFloor.light,
                primaryHex: 0x7A1010, maroonHex: 0x4A0000, terracottaHex: 0xC45C2A,
                secondaryHex: 0xE8B923, goldHex: 0xE0B000, goldSoftHex: 0xF2D36B,
                greenHex: 0x3F6B4F, leafHex: 0x5C8A64, inkHex: 0x2A1810, mutedHex: 0x8A6B4A,
                riceHex: 0xFFF3D6, powderWhiteHex: 0xFFF8E7, onAccentHex: 0xFFF6E8, cardWashHex: 0xF3D9A0
            )
        case .terracottaClay:
            return CourtyardPalette(
                ivoryHex: 0xFBF3EA, paperHex: 0xFFF9F3, clayHex: clayFloor.clay,
                floorDeepHex: clayFloor.deep, floorMidHex: clayFloor.mid, floorLightHex: clayFloor.light,
                primaryHex: 0xC44B1F, maroonHex: 0x8A3014, terracottaHex: 0xC45C2A,
                secondaryHex: 0xE07A3A, goldHex: 0xD4A017, goldSoftHex: 0xE8C46A,
                greenHex: 0x4A6B3F, leafHex: 0x6A8A5C, inkHex: 0x2F2218, mutedHex: 0x8A6F5A,
                riceHex: 0xF7E6D4, powderWhiteHex: 0xFFF4E8, onAccentHex: 0xFBF3EA, cardWashHex: 0xEED3B8
            )
        }
    }
}

enum RangoliColor {
    private static var palette: CourtyardPalette { CourtyardColorTheme.current.palette }

    static var ivory: Color { palette.ivory }
    static var paper: Color { palette.paper }
    static var clay: Color { palette.clay }
    static var floorDeep: Color { palette.floorDeep }
    static var floorMid: Color { palette.floorMid }
    static var floorLight: Color { palette.floorLight }
    static var primary: Color { palette.primary }
    static var maroon: Color { palette.maroon }
    static var terracotta: Color { palette.terracotta }
    static var secondary: Color { palette.secondary }
    static var gold: Color { palette.gold }
    static var goldSoft: Color { palette.goldSoft }
    static var green: Color { palette.green }
    static var leaf: Color { palette.leaf }
    static var ink: Color { palette.ink }
    static var muted: Color { palette.muted }
    static var rice: Color { palette.rice }
    static var powderWhite: Color { palette.powderWhite }
    static var stroke: Color { Color.black.opacity(0.08) }
    static var onAccent: Color { palette.onAccent }
    static var cardWash: Color { palette.cardWash }

    static let brand = "Traditional Rangoli"
    static let company = "Sai Laksha Technologies"
    static let studio = "Sreeo Studio"
    static let developer = "Sreedhar Lakshmanan"
    static let copyright = "© 2026 Sai Laksha Technologies"
    static let supportURL = URL(string: "https://sreedharlakshman2.github.io/traditional-rangoli/")!
    static let privacyURL = URL(string: "https://sreedharlakshman2.github.io/traditional-rangoli/privacy.html")!
    static let marketingURL = URL(string: "https://sreedharlakshman2.github.io")!

    static let studioTiles: [Color] = [.cyan, .purple, .pink, .orange]
    static let studioWordmark = LinearGradient(
        colors: [.cyan, .purple, .pink, .orange],
        startPoint: .leading,
        endPoint: .trailing
    )
}

enum RangoliFont {
    static func display(_ size: CGFloat = 32) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    static func title(_ size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    static func headline(_ size: CGFloat = 17) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }

    static func caption(_ size: CGFloat = 12) -> Font {
        .system(size: size, weight: .medium, design: .rounded)
    }

    static func label(_ size: CGFloat = 11) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    /// Tamil script — avoid New York serif, which is missing Tamil glyphs.
    static func tamil(_ size: CGFloat = 22) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }
}

enum RangoliRadius {
    static let sm: CGFloat = 12
    static let md: CGFloat = 18
    static let lg: CGFloat = 24
    static let xl: CGFloat = 30
}

enum PowderSwatch: String, CaseIterable, Identifiable, Codable {
    case rice, traditionalRed, terracotta, yellow, green, white, orange, pink, purple, gold

    var id: String { rawValue }

    var title: String {
        switch self {
        case .rice: return "Rice"
        case .traditionalRed: return "Red"
        case .terracotta: return "Terracotta"
        case .yellow: return "Yellow"
        case .green: return "Green"
        case .white: return "White"
        case .orange: return "Orange"
        case .pink: return "Pink"
        case .purple: return "Purple"
        case .gold: return "Gold"
        }
    }

    var hex: UInt32 {
        switch self {
        case .rice: return 0xF4E6C3
        case .traditionalRed: return 0x9B2C2C
        case .terracotta: return 0xC45C2A
        case .yellow: return 0xE3B23C
        case .green: return 0x3F6B4F
        case .white: return 0xFFF8E7
        case .orange: return 0xD97706
        case .pink: return 0xC45D7A
        case .purple: return 0x6B3F6B
        case .gold: return 0xC89B3C
        }
    }

    var color: Color { Color(hex: hex) }
}

struct PressScaleStyle: ButtonStyle {
    var amount: CGFloat = 0.97

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? amount : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.28, dampingFraction: 0.78), value: configuration.isPressed)
    }
}

struct RangoliPrimaryButton: View {
    let title: String
    var icon: String? = nil
    var fill: Color = RangoliColor.primary
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(RangoliFont.headline(16))
            .foregroundStyle(RangoliColor.onAccent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(fill, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(RangoliColor.gold.opacity(0.45), lineWidth: 1)
            )
            .shadow(color: fill.opacity(0.28), radius: 10, y: 4)
        }
        .buttonStyle(PressScaleStyle())
        .accessibilityAddTraits(.isButton)
    }
}

struct RangoliSecondaryButton: View {
    let title: String
    var icon: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
            }
            .font(RangoliFont.headline(16))
            .foregroundStyle(RangoliColor.primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(RangoliColor.paper, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(RangoliColor.primary.opacity(0.28), lineWidth: 1)
            )
        }
        .buttonStyle(PressScaleStyle())
    }
}

extension Color {
    init(hex: UInt32, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

extension View {
    func goldFrame(cornerRadius: CGFloat = RangoliRadius.lg) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            RangoliColor.goldSoft.opacity(0.9),
                            RangoliColor.gold.opacity(0.35),
                            RangoliColor.goldSoft.opacity(0.75)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.2
                )
        )
    }

    func paperCard(radius: CGFloat = RangoliRadius.lg) -> some View {
        background(RangoliColor.paper, in: RoundedRectangle(cornerRadius: radius, style: .continuous))
            .goldFrame(cornerRadius: radius)
            .shadow(color: Color.black.opacity(0.06), radius: 16, y: 8)
    }

    /// Keeps copy and cards from stretching edge-to-edge on iPad.
    func courtyardColumn(_ maxWidth: CGFloat = 780) -> some View {
        frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }

    /// Caps primary actions so they stay pill-shaped on a wide iPad.
    func courtyardControls(_ maxWidth: CGFloat = 480) -> some View {
        frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}

private struct CategoryCardExpandedKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var courtyardExpandedCards: Bool {
        get { self[CategoryCardExpandedKey.self] }
        set { self[CategoryCardExpandedKey.self] = newValue }
    }
}

enum CourtyardLayout {
    static func patternColumns(regular: Bool) -> [GridItem] {
        let count = regular ? 2 : 1
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: count)
    }

    static func galleryColumns(regular: Bool) -> [GridItem] {
        let count = regular ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
    }

    static func categoryColumns(regular: Bool) -> [GridItem] {
        let count = regular ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
    }

    static func achievementColumns(regular: Bool) -> [GridItem] {
        let count = regular ? 4 : 2
        return Array(repeating: GridItem(.flexible()), count: count)
    }

    static func languageColumns(regular: Bool) -> [GridItem] {
        let count = regular ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 10), count: count)
    }

    static func createColumns(regular: Bool) -> [GridItem] {
        let count = regular ? 3 : 1
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: count)
    }

    /// iPad landscape (and similarly wide regular-width scenes): tools sit beside a square canvas.
    static func splitStudio(width: CGFloat, height: CGFloat, regular: Bool) -> Bool {
        regular && width > height + 40
    }
}
