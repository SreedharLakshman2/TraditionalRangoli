import SwiftUI
import UIKit

enum RangoliColor {
    static let ivory = Color(hex: 0xFFF8EE)
    static let paper = Color(hex: 0xFFFCF6)
    static let clay = Color(hex: 0xC48A5A)
    static let floorDeep = Color(hex: 0x6A3A22)
    static let floorMid = Color(hex: 0x8A5333)
    static let floorLight = Color(hex: 0xB07A4C)
    static let primary = Color(hex: 0x9B2C2C)
    static let maroon = Color(hex: 0x6B1D1D)
    static let terracotta = Color(hex: 0xC45C2A)
    static let secondary = Color(hex: 0xD97706)
    static let gold = Color(hex: 0xC89B3C)
    static let goldSoft = Color(hex: 0xE8C56B)
    static let green = Color(hex: 0x3F6B4F)
    static let leaf = Color(hex: 0x5C8A64)
    static let ink = Color(hex: 0x2D241F)
    static let muted = Color(hex: 0x806F63)
    static let rice = Color(hex: 0xF7F1E3)
    static let powderWhite = Color(hex: 0xFFF8E7)
    static let stroke = Color.black.opacity(0.08)
    static let onAccent = Color(hex: 0xFFF8EE)

    static let brand = "Traditional Rangoli"
    static let company = "Sai Laksha Technologies"
    static let developer = "Sreedhar Lakshmanan"
    static let copyright = "© 2026 Sai Laksha Technologies"
    static let supportURL = URL(string: "https://sreedharlakshman2.github.io/traditional-rangoli/")!
    static let privacyURL = URL(string: "https://sreedharlakshman2.github.io/traditional-rangoli/privacy.html")!
    static let marketingURL = URL(string: "https://sreedharlakshman2.github.io")!
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
        return Array(repeating: GridItem(.flexible(), spacing: 14), count: count)
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

    static func createColumns(regular: Bool) -> [GridItem] {
        let count = regular ? 3 : 1
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: count)
    }

    /// iPad landscape (and similarly wide regular-width scenes): tools sit beside a square canvas.
    static func splitStudio(width: CGFloat, height: CGFloat, regular: Bool) -> Bool {
        regular && width > height + 40
    }
}
