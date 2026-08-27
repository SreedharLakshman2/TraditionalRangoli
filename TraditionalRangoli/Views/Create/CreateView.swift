import SwiftUI

struct CreateView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var language: LanguageStore
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var showTemplates = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                SectionHeader(title: language.t("createTitle"), subtitle: language.t("createSubtitle"))
                LazyVGrid(columns: CourtyardLayout.createColumns(regular: sizeClass == .regular), spacing: 16) {
                    createCard(
                        title: language.t("dotKolam"),
                        subtitle: language.t("dotKolamSub"),
                        motif: .pulli,
                        tint: RangoliColor.primary
                    ) {
                        router.studio = StudioRoute(kind: .dots(nil))
                    }
                    createCard(
                        title: language.t("freehand"),
                        subtitle: language.t("freehandSub"),
                        motif: .festivalFlower,
                        tint: RangoliColor.secondary
                    ) {
                        router.studio = StudioRoute(kind: .freehand)
                    }
                    createCard(
                        title: language.t("template"),
                        subtitle: language.t("templateSub"),
                        motif: .lotusDot,
                        tint: RangoliColor.green
                    ) {
                        showTemplates = true
                    }
                }
            }
            .padding(20)
            .courtyardColumn(sizeClass == .regular ? 1100 : 780)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showTemplates) {
            NavigationStack {
                PatternGridView(title: language.t("chooseTemplate"), patterns: PatternCatalog.all)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(language.t("close")) { showTemplates = false }
                        }
                    }
            }
            .presentationDetents([.large])
        }
        .onChange(of: router.studio?.id) { _, _ in
            showTemplates = false
        }
    }

    private func createCard(title: String, subtitle: String, motif: MotifKind, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Group {
                if sizeClass == .regular {
                    VStack(alignment: .leading, spacing: 14) {
                        RangoliPreview(motif: motif, animate: true)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        Text(title)
                            .font(RangoliFont.title(20))
                            .foregroundStyle(RangoliColor.ink)
                        Text(subtitle)
                            .font(RangoliFont.body(15))
                            .foregroundStyle(RangoliColor.muted)
                        Capsule()
                            .fill(tint)
                            .frame(width: 36, height: 4)
                    }
                } else {
                    HStack(spacing: 16) {
                        RangoliPreview(motif: motif, animate: true)
                            .frame(width: 96, height: 96)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        VStack(alignment: .leading, spacing: 6) {
                            Text(title)
                                .font(RangoliFont.title(20))
                                .foregroundStyle(RangoliColor.ink)
                            Text(subtitle)
                                .font(RangoliFont.body(15))
                                .foregroundStyle(RangoliColor.muted)
                            Capsule()
                                .fill(tint)
                                .frame(width: 36, height: 4)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(RangoliColor.gold)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .paperCard(radius: RangoliRadius.xl)
        }
        .buttonStyle(PressScaleStyle(amount: 0.98))
        .accessibilityLabel("\(title). \(subtitle)")
    }
}
