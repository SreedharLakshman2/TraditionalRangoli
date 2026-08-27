import SwiftUI

enum AppTab: String, CaseIterable, Identifiable {
    case home, explore, create, saved, profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: return "Home"
        case .explore: return "Explore"
        case .create: return "Create"
        case .saved: return "Saved"
        case .profile: return "Profile"
        }
    }

    var symbol: String {
        switch self {
        case .home: return "house.fill"
        case .explore: return "sparkles"
        case .create: return "plus"
        case .saved: return "square.stack.fill"
        case .profile: return "person.fill"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selection: AppTab
    @EnvironmentObject private var language: LanguageStore
    @Namespace private var ns

    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.78)) {
                        selection = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            if selection == tab {
                                Capsule()
                                    .fill(RangoliColor.primary)
                                    .matchedGeometryEffect(id: "tabGlow", in: ns)
                                    .frame(width: tab == .create ? 46 : 38, height: 28)
                                    .shadow(color: RangoliColor.primary.opacity(0.28), radius: 8, y: 3)
                            }
                            Image(systemName: tab.symbol)
                                .font(.system(size: tab == .create ? 16 : 15, weight: .semibold))
                                .foregroundStyle(selection == tab ? RangoliColor.onAccent : RangoliColor.muted)
                        }
                        Text(language.t(tab.l10nKey))
                            .font(RangoliFont.label(10))
                            .foregroundStyle(selection == tab ? RangoliColor.primary : RangoliColor.muted)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(language.t(tab.l10nKey))
                .accessibilityAddTraits(selection == tab ? .isSelected : [])
            }
        }
        .padding(.horizontal, 10)
        .padding(.top, 6)
        .padding(.bottom, 4)
        .background(
            Capsule(style: .continuous)
                .fill(RangoliColor.paper.opacity(0.96))
                .shadow(color: Color.black.opacity(0.12), radius: 18, y: 8)
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(RangoliColor.gold.opacity(0.35), lineWidth: 1)
                )
        )
        .padding(.horizontal, 18)
        .padding(.bottom, 2)
    }
}
