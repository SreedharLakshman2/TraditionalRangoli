import SwiftUI
import UIKit

@MainActor
final class SettingsStore: ObservableObject {
    @Published var soundEnabled: Bool {
        didSet { defaults.set(soundEnabled, forKey: Keys.sound) }
    }
    @Published var hapticsEnabled: Bool {
        didSet { defaults.set(hapticsEnabled, forKey: Keys.haptics) }
    }
    @Published var showGuides: Bool {
        didSet { defaults.set(showGuides, forKey: Keys.guides) }
    }
    @Published var defaultGrid: Int {
        didSet { defaults.set(defaultGrid, forKey: Keys.grid) }
    }

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let sound = "rangoli.sound"
        static let haptics = "rangoli.haptics"
        static let guides = "rangoli.guides"
        static let grid = "rangoli.grid"
        static let onboarding = "rangoli.onboarding"
        static let xp = "rangoli.xp"
        static let completed = "rangoli.completed"
        static let patternIds = "rangoli.patternIds"
        static let streak = "rangoli.streak"
        static let lastDay = "rangoli.lastDay"
        static let favorites = "rangoli.favoritePatterns"
        static let style = "rangoli.style"
    }

    init() {
        soundEnabled = defaults.object(forKey: Keys.sound) as? Bool ?? true
        hapticsEnabled = defaults.object(forKey: Keys.haptics) as? Bool ?? true
        showGuides = defaults.object(forKey: Keys.guides) as? Bool ?? true
        defaultGrid = defaults.object(forKey: Keys.grid) as? Int ?? 9
    }

    var hasSeenOnboarding: Bool {
        get { defaults.bool(forKey: Keys.onboarding) }
        set { defaults.set(newValue, forKey: Keys.onboarding); objectWillChange.send() }
    }

    var xp: Int {
        get { defaults.integer(forKey: Keys.xp) }
        set { defaults.set(newValue, forKey: Keys.xp); objectWillChange.send() }
    }

    var patternsCompleted: Int {
        get { defaults.integer(forKey: Keys.completed) }
        set { defaults.set(newValue, forKey: Keys.completed); objectWillChange.send() }
    }

    var completedPatternIds: Set<String> {
        get { Set(defaults.stringArray(forKey: Keys.patternIds) ?? []) }
        set { defaults.set(Array(newValue), forKey: Keys.patternIds); objectWillChange.send() }
    }

    var favoritePatternIds: Set<String> {
        get { Set(defaults.stringArray(forKey: Keys.favorites) ?? []) }
        set { defaults.set(Array(newValue), forKey: Keys.favorites); objectWillChange.send() }
    }

    var favoriteStyle: String {
        get { defaults.string(forKey: Keys.style) ?? "Lotus" }
        set { defaults.set(newValue, forKey: Keys.style); objectWillChange.send() }
    }

    var streak: Int {
        get { defaults.integer(forKey: Keys.streak) }
        set { defaults.set(newValue, forKey: Keys.streak); objectWillChange.send() }
    }

    var levelTitle: String {
        switch xp {
        case ..<80: return "Rangoli Beginner"
        case ..<220: return "Courtyard Apprentice"
        case ..<500: return "Kolam Artist"
        default: return "Master Creator"
        }
    }

    var levelProgress: Double {
        let brackets: [(Int, Int)] = [(0, 80), (80, 220), (220, 500), (500, 900)]
        let pair = brackets.first { xp < $0.1 } ?? (500, 900)
        return min(1, max(0, Double(xp - pair.0) / Double(pair.1 - pair.0)))
    }

    func noteActivity() {
        let today = Calendar.current.startOfDay(for: Date())
        if let last = defaults.object(forKey: Keys.lastDay) as? Date {
            let lastDay = Calendar.current.startOfDay(for: last)
            let gap = Calendar.current.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if gap == 1 {
                streak += 1
            } else if gap > 1 {
                streak = 1
            }
        } else {
            streak = max(streak, 1)
        }
        defaults.set(today, forKey: Keys.lastDay)
    }

    func award(pattern: RangoliPattern?) {
        noteActivity()
        let reward = pattern?.xpReward ?? 40
        xp += reward
        patternsCompleted += 1
        if let id = pattern?.id {
            var ids = completedPatternIds
            ids.insert(id)
            completedPatternIds = ids
            favoriteStyle = pattern?.theme.title ?? favoriteStyle
        }
    }

    func toggleFavorite(patternId: String) {
        var ids = favoritePatternIds
        if ids.contains(patternId) {
            ids.remove(patternId)
        } else {
            ids.insert(patternId)
        }
        favoritePatternIds = ids
    }
}

@MainActor
final class ArtworkStore: ObservableObject {
    @Published private(set) var artworks: [UserArtwork] = []

    private let folder: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        folder = documents.appendingPathComponent("RangoliArtworks", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        loadAll()
    }

    var creations: [UserArtwork] {
        artworks.sorted { $0.updatedDate > $1.updatedDate }
    }

    var favorites: [UserArtwork] {
        creations.filter(\.isFavorite)
    }

    func save(_ artwork: UserArtwork) {
        var copy = artwork
        copy.updatedDate = Date()
        if let index = artworks.firstIndex(where: { $0.id == copy.id }) {
            artworks[index] = copy
        } else {
            artworks.insert(copy, at: 0)
        }
        persist(copy)
    }

    func delete(_ artwork: UserArtwork) {
        artworks.removeAll { $0.id == artwork.id }
        let url = folder.appendingPathComponent("\(artwork.id.uuidString).json")
        try? FileManager.default.removeItem(at: url)
    }

    func duplicate(_ artwork: UserArtwork) {
        var copy = artwork
        copy.id = UUID()
        copy.title = "\(artwork.title) copy"
        copy.createdDate = Date()
        copy.updatedDate = Date()
        copy.isFavorite = false
        save(copy)
    }

    func toggleFavorite(_ artwork: UserArtwork) {
        var copy = artwork
        copy.isFavorite.toggle()
        save(copy)
    }

    private func persist(_ artwork: UserArtwork) {
        let url = folder.appendingPathComponent("\(artwork.id.uuidString).json")
        if let data = try? encoder.encode(artwork) {
            try? data.write(to: url, options: .atomic)
        }
    }

    private func loadAll() {
        guard let files = try? FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil) else { return }
        artworks = files.compactMap { url in
            guard let data = try? Data(contentsOf: url),
                  var art = try? decoder.decode(UserArtwork.self, from: data) else { return nil }
            art.strokes = DrawingUtilities.normalizedStrokes(art.strokes)
            return art
        }
        .sorted { $0.updatedDate > $1.updatedDate }
    }
}

enum Haptics {
    @MainActor
    static func tap(_ settings: SettingsStore) {
        guard settings.hapticsEnabled else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    @MainActor
    static func success(_ settings: SettingsStore) {
        guard settings.hapticsEnabled else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
