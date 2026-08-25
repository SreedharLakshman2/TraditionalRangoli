import SwiftUI

struct DrawingStudioView: View {
    @StateObject var session: DrawingSession
    @EnvironmentObject private var settings: SettingsStore
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var showMore = false
    @State private var coloring = false
    @State private var completed: UserArtwork?
    @State private var shareURL: URL?

    var body: some View {
        GeometryReader { geo in
            let split = CourtyardLayout.splitStudio(
                width: geo.size.width,
                height: geo.size.height,
                regular: sizeClass == .regular
            )
            ZStack {
                PaperBackground(showWatermark: false)
                VStack(spacing: split ? 8 : 12) {
                    topBar
                    if split {
                        HStack(alignment: .center, spacing: 8) {
                            DrawingCanvas(session: session)
                                .padding(.leading, 16)
                                .padding(.bottom, 12)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            VStack(spacing: 12) {
                                toolsColumn
                                Spacer(minLength: 0)
                            }
                            .frame(width: min(360, max(280, geo.size.width * 0.34)))
                            .padding(.trailing, 16)
                            .padding(.bottom, 12)
                        }
                    } else {
                        DrawingCanvas(session: session)
                            .padding(.horizontal, 16)
                            .frame(maxHeight: .infinity)
                        toolsColumn
                            .padding(.bottom, 8)
                    }
                }
                .padding(.top, 8)
            }
        }
        .preferredColorScheme(.light)
        .fullScreenCover(isPresented: $coloring) {
            ColoringView(session: session) {
                coloring = false
                finish()
            }
        }
        .fullScreenCover(item: $completed) { art in
            CompletionView(artwork: art, pattern: session.pattern) {
                completed = nil
                dismiss()
            }
        }
        .confirmationDialog("Canvas", isPresented: $showMore, titleVisibility: .visible) {
            Button("Toggle grid") { session.showGrid.toggle() }
            Button("Toggle snap") { session.snapToDots.toggle() }
            Button("Toggle guides") { session.showGuides.toggle() }
            Button("Clear canvas", role: .destructive) { session.clear() }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(RangoliColor.ink)
                    .frame(width: 40, height: 40)
                    .background(RangoliColor.paper, in: Circle())
                    .goldFrame(cornerRadius: 20)
            }
            .accessibilityLabel("Back")
            Spacer()
            VStack(spacing: 2) {
                Text(session.title)
                    .font(RangoliFont.headline(17))
                    .foregroundStyle(RangoliColor.ink)
                Text(session.symmetry == .none ? "Free line" : session.symmetry.title)
                    .font(RangoliFont.caption(11))
                    .foregroundStyle(RangoliColor.muted)
            }
            Spacer()
            Button { showMore = true } label: {
                Image(systemName: "ellipsis")
                    .font(.headline)
                    .foregroundStyle(RangoliColor.ink)
                    .frame(width: 40, height: 40)
                    .background(RangoliColor.paper, in: Circle())
                    .goldFrame(cornerRadius: 20)
            }
            .accessibilityLabel("More")
        }
        .padding(.horizontal, 16)
    }

    private var toolsColumn: some View {
        VStack(spacing: 12) {
            if session.studio == .dots || session.studio == .template {
                gridPicker
            }
            toolbar
            ColorPaletteBar(selection: $session.color)
                .padding(.horizontal, 16)
                .courtyardControls(640)
            RangoliPrimaryButton(title: "Done", icon: "checkmark") {
                coloring = true
            }
            .padding(.horizontal, 20)
            .courtyardControls()
        }
    }

    private var gridPicker: some View {
        HStack(spacing: 8) {
            ForEach([7, 9, 11, 15], id: \.self) { size in
                Button {
                    session.gridSize = size
                } label: {
                    Text("\(size)×\(size)")
                        .font(RangoliFont.label(11))
                        .foregroundStyle(session.gridSize == size ? RangoliColor.onAccent : RangoliColor.ink)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(session.gridSize == size ? RangoliColor.primary : RangoliColor.paper, in: Capsule())
                }
                .buttonStyle(PressScaleStyle())
            }
        }
        .accessibilityLabel("Grid size")
    }

    private var toolbar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                tool("arrow.uturn.backward", enabled: session.canUndo) { session.undo() }
                tool("arrow.uturn.forward", enabled: session.canRedo) { session.redo() }
                tool(session.showGrid ? "circle.grid.3x3.fill" : "circle.grid.3x3", enabled: true) { session.showGrid.toggle() }
                Menu {
                    ForEach(SymmetryMode.allCases) { mode in
                        Button(mode.title) { session.symmetry = mode }
                    }
                } label: {
                    chip(session.symmetry.symbol, active: session.symmetry != .none)
                }
                Menu {
                    ForEach(BrushSize.allCases) { size in
                        Button(size.title) { session.brush = size }
                    }
                } label: {
                    chip("paintbrush.pointed", active: true)
                }
                tool("trash", enabled: true) { session.clear() }
            }
            .padding(.horizontal, 16)
        }
    }

    private func tool(_ system: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            chip(system, active: enabled)
        }
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.4)
        .buttonStyle(PressScaleStyle())
    }

    private func chip(_ system: String, active: Bool) -> some View {
        Image(systemName: system)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(active ? RangoliColor.primary : RangoliColor.muted)
            .frame(width: 42, height: 42)
            .background(RangoliColor.paper, in: Circle())
            .overlay(Circle().stroke(RangoliColor.gold.opacity(0.28), lineWidth: 1))
    }

    private func finish() {
        Haptics.success(settings)
        let data = ArtworkSnapshot.png(session: session)
        completed = session.artwork(title: session.title, thumbnail: data)
    }
}
