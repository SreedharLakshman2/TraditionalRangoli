import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settings: SettingsStore
    @Environment(\.horizontalSizeClass) private var sizeClass
    private let daily = PatternCatalog.daily

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 26) {
                header
                dailyCard
                collections
                popular
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 24)
            .courtyardColumn()
        }
        .background(Color.clear)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(greeting)
                    .font(RangoliFont.display(30))
                    .foregroundStyle(RangoliColor.ink)
                Text("Create something beautiful today.")
                    .font(RangoliFont.body(16))
                    .foregroundStyle(RangoliColor.muted)
            }
            Spacer()
            VStack(spacing: 4) {
                Text("🔥")
                Text("\(max(settings.streak, 0))")
                    .font(RangoliFont.headline(14))
                    .foregroundStyle(RangoliColor.primary)
            }
            .padding(10)
            .background(RangoliColor.paper, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .goldFrame(cornerRadius: 14)
            .accessibilityLabel("\(settings.streak) day streak")
        }
    }

    private var dailyCard: some View {
        NavigationLink {
            PatternDetailView(pattern: daily)
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("DAILY RANGOLI")
                        .font(RangoliFont.label(11))
                        .tracking(1.4)
                        .foregroundStyle(RangoliColor.gold)
                    Spacer()
                    MetaChip(text: daily.difficulty.title)
                }
                RangoliPreview(motif: daily.motif, animate: true)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(GoldCornerFrame().padding(10))
                Text(daily.title)
                    .font(RangoliFont.title(24))
                    .foregroundStyle(RangoliColor.ink)
                HStack(spacing: 10) {
                    MetaChip(text: "\(daily.gridSize) × \(daily.gridSize) dots")
                    MetaChip(text: "\(daily.stepCount) steps")
                }
                HStack {
                    Text("Start Drawing")
                        .font(RangoliFont.headline(16))
                        .foregroundStyle(RangoliColor.onAccent)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 12)
                        .background(RangoliColor.primary, in: Capsule())
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundStyle(RangoliColor.gold)
                }
            }
            .padding(18)
            .background(
                LinearGradient(colors: [RangoliColor.paper, Color(hex: 0xF3E6D0)], startPoint: .top, endPoint: .bottom),
                in: RoundedRectangle(cornerRadius: RangoliRadius.xl, style: .continuous)
            )
            .goldFrame(cornerRadius: RangoliRadius.xl)
            .shadow(color: RangoliColor.primary.opacity(0.12), radius: 18, y: 10)
        }
        .buttonStyle(PressScaleStyle(amount: 0.985))
    }

    private var collections: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Explore Collections")
            if sizeClass == .regular {
                LazyVGrid(columns: CourtyardLayout.categoryColumns(regular: true), spacing: 12) {
                    collectionLinks
                }
                .environment(\.courtyardExpandedCards, true)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        collectionLinks
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    @ViewBuilder
    private var collectionLinks: some View {
        ForEach(BrowseCollection.allCases) { collection in
            NavigationLink {
                CollectionListView(collection: collection)
            } label: {
                CategoryCard(
                    title: collection.title,
                    symbol: collection.symbol,
                    motif: PatternCatalog.matching(collection).first?.motif ?? .lotusDot
                )
            }
            .buttonStyle(PressScaleStyle())
        }
    }

    private var popular: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Popular Patterns", subtitle: "Large, slow-drawn courtyard pieces")
            LazyVGrid(columns: CourtyardLayout.patternColumns(regular: sizeClass == .regular), spacing: 16) {
                ForEach(PatternCatalog.popular) { pattern in
                    NavigationLink {
                        PatternDetailView(pattern: pattern)
                    } label: {
                        RangoliCard(pattern: pattern, large: true)
                    }
                    .buttonStyle(PressScaleStyle(amount: 0.985))
                }
            }
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning 👋"
        case 12..<17: return "Good Afternoon 👋"
        default: return "Good Evening 👋"
        }
    }
}

struct CollectionListView: View {
    let collection: BrowseCollection
    @Environment(\.horizontalSizeClass) private var sizeClass

    var body: some View {
        ScrollView {
            LazyVGrid(columns: CourtyardLayout.patternColumns(regular: sizeClass == .regular), spacing: 16) {
                ForEach(PatternCatalog.matching(collection)) { pattern in
                    NavigationLink {
                        PatternDetailView(pattern: pattern)
                    } label: {
                        RangoliCard(pattern: pattern, large: true)
                    }
                    .buttonStyle(PressScaleStyle(amount: 0.985))
                }
            }
            .padding(20)
            .courtyardColumn(1100)
        }
        .background(PaperBackground(showWatermark: false).ignoresSafeArea())
        .navigationTitle(collection.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
