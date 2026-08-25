import SwiftUI

struct CreateView: View {
    @EnvironmentObject private var router: AppRouter
    @State private var showTemplates = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                SectionHeader(title: "Create", subtitle: "Three ways to lay powder on the floor")
                createCard(
                    title: "DOT RANGOLI",
                    subtitle: "Create using a dot grid.",
                    motif: .pulli,
                    tint: RangoliColor.primary
                ) {
                    router.studio = StudioRoute(kind: .dots(nil))
                }
                createCard(
                    title: "FREEHAND",
                    subtitle: "Draw your own rangoli.",
                    motif: .festivalFlower,
                    tint: RangoliColor.secondary
                ) {
                    router.studio = StudioRoute(kind: .freehand)
                }
                createCard(
                    title: "TEMPLATE",
                    subtitle: "Start from a traditional pattern.",
                    motif: .lotusDot,
                    tint: RangoliColor.green
                ) {
                    showTemplates = true
                }
            }
            .padding(20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showTemplates) {
            NavigationStack {
                PatternGridView(title: "Choose a template", patterns: PatternCatalog.all)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") { showTemplates = false }
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
            .padding(16)
            .paperCard(radius: RangoliRadius.xl)
        }
        .buttonStyle(PressScaleStyle(amount: 0.98))
        .accessibilityLabel("\(title). \(subtitle)")
    }
}
