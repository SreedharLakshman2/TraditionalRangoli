import Foundation

enum PatternCatalog {
    static let all: [RangoliPattern] = [
        RangoliPattern(
            id: "lotus-dot",
            title: "Lotus Dot Rangoli",
            family: .floral,
            theme: .lotus,
            festivals: [.diwali, .navratri],
            difficulty: .beginner,
            gridSize: 9,
            estimatedMinutes: 10,
            description: "A lotus at the threshold — place the pulli, then open the petals as a welcome.",
            tags: ["lotus", "dots", "beginner"],
            motif: .lotusDot,
            xpReward: 50
        ),
        RangoliPattern(
            id: "simple-flower",
            title: "Simple Flower Kolam",
            family: .floral,
            theme: .flowers,
            festivals: [.ugadi],
            difficulty: .beginner,
            gridSize: 7,
            estimatedMinutes: 8,
            description: "A gentle four-petal flower kolam — perfect first powder on the courtyard floor.",
            tags: ["flower", "kolam"],
            motif: .simpleFlower,
            xpReward: 40
        ),
        RangoliPattern(
            id: "peacock",
            title: "Peacock Rangoli",
            family: .freehandRangoli,
            theme: .peacock,
            festivals: [.diwali, .navratri],
            difficulty: .intermediate,
            gridSize: 11,
            estimatedMinutes: 16,
            description: "Fan feathers, a quiet crest, and the proud posture of a courtyard peacock.",
            tags: ["peacock", "festival"],
            motif: .peacock,
            xpReward: 80
        ),
        RangoliPattern(
            id: "diya",
            title: "Diya Rangoli",
            family: .freehandRangoli,
            theme: .diya,
            festivals: [.diwali],
            difficulty: .beginner,
            gridSize: 9,
            estimatedMinutes: 9,
            description: "A lamp at the heart, petals for light — the classic Deepavali threshold.",
            tags: ["diya", "diwali"],
            motif: .diya,
            xpReward: 45
        ),
        RangoliPattern(
            id: "pulli",
            title: "Traditional Pulli Kolam",
            family: .pulliKolam,
            theme: .traditional,
            festivals: [.pongal],
            difficulty: .intermediate,
            gridSize: 9,
            estimatedMinutes: 14,
            description: "Loop the rice powder around a lattice of pulli without breaking the line.",
            tags: ["pulli", "tamil"],
            motif: .pulli,
            xpReward: 75
        ),
        RangoliPattern(
            id: "spiral",
            title: "Spiral Kolam",
            family: .sikkuKolam,
            theme: .traditional,
            festivals: [.pongal],
            difficulty: .intermediate,
            gridSize: 11,
            estimatedMinutes: 12,
            description: "A continuous sikku spiral that grows from a single bindu into a full kolam.",
            tags: ["spiral", "sikku"],
            motif: .spiral,
            xpReward: 70
        ),
        RangoliPattern(
            id: "eight-petal",
            title: "Eight Petal Lotus",
            family: .floral,
            theme: .lotus,
            festivals: [.navratri, .diwali],
            difficulty: .intermediate,
            gridSize: 11,
            estimatedMinutes: 15,
            description: "Ashtadala padma — eight petals in layered terracotta, gold, and leaf green.",
            tags: ["lotus", "ashtadala"],
            motif: .eightPetal,
            xpReward: 80
        ),
        RangoliPattern(
            id: "geo-star",
            title: "Geometric Star",
            family: .geometric,
            theme: .mandala,
            festivals: [.newYear],
            difficulty: .beginner,
            gridSize: 9,
            estimatedMinutes: 10,
            description: "An eight-point star nested in an octagon, drawn with temple-geometry calm.",
            tags: ["star", "geometry"],
            motif: .geometricStar,
            xpReward: 55
        ),
        RangoliPattern(
            id: "festival-flower",
            title: "Festival Flower Rangoli",
            family: .floral,
            theme: .flowers,
            festivals: [.diwali, .navratri, .onam],
            difficulty: .intermediate,
            gridSize: 11,
            estimatedMinutes: 14,
            description: "Concentric festival petals in red, gold, and marigold for any threshold.",
            tags: ["festival", "flower"],
            motif: .festivalFlower,
            xpReward: 70
        ),
        RangoliPattern(
            id: "mandala",
            title: "Mandala Rangoli",
            family: .geometric,
            theme: .mandala,
            festivals: [.navratri, .newYear],
            difficulty: .advanced,
            gridSize: 15,
            estimatedMinutes: 22,
            description: "Layered rings of petals, stars, and bindu — a meditative mandala for skilled hands.",
            tags: ["mandala", "advanced"],
            motif: .mandala,
            xpReward: 120
        ),
        RangoliPattern(
            id: "butterfly",
            title: "Butterfly Rangoli",
            family: .freehandRangoli,
            theme: .flowers,
            festivals: [.onam, .ugadi],
            difficulty: .intermediate,
            gridSize: 11,
            estimatedMinutes: 13,
            description: "Twin wings, a slender body, and garden color for a spring courtyard.",
            tags: ["butterfly", "freehand"],
            motif: .butterfly,
            xpReward: 65
        ),
        RangoliPattern(
            id: "pongal-pot",
            title: "Pongal Pot Rangoli",
            family: .freehandRangoli,
            theme: .traditional,
            festivals: [.pongal],
            difficulty: .intermediate,
            gridSize: 11,
            estimatedMinutes: 15,
            description: "The overflowing pongal pot with mango leaves — harvest joy at the doorway.",
            tags: ["pongal", "pot"],
            motif: .pongalPot,
            xpReward: 75
        ),
        RangoliPattern(
            id: "sikku-knot",
            title: "Sikku Knot Kolam",
            family: .sikkuKolam,
            theme: .traditional,
            festivals: [.pongal],
            difficulty: .advanced,
            gridSize: 11,
            estimatedMinutes: 18,
            description: "Interlocking sikku knots that never lift from the floor — a Tamil classic.",
            tags: ["sikku", "knot"],
            motif: .sikkuKnot,
            xpReward: 100
        ),
        RangoliPattern(
            id: "onam-pookalam",
            title: "Onam Pookalam",
            family: .floral,
            theme: .flowers,
            festivals: [.onam],
            difficulty: .intermediate,
            gridSize: 13,
            estimatedMinutes: 16,
            description: "Rings of flower color inspired by Kerala’s Onam pookalam carpets.",
            tags: ["onam", "pookalam"],
            motif: .onamPookalam,
            xpReward: 85
        ),
        RangoliPattern(
            id: "sun-burst",
            title: "New Year Sunburst",
            family: .geometric,
            theme: .mandala,
            festivals: [.newYear, .ugadi],
            difficulty: .beginner,
            gridSize: 9,
            estimatedMinutes: 9,
            description: "A rising sun of gold rays — simple geometry for a new year’s morning.",
            tags: ["sun", "new year"],
            motif: .sunBurst,
            xpReward: 50
        ),
        RangoliPattern(
            id: "mango-leaf",
            title: "Mango Leaf Toran",
            family: .floral,
            theme: .traditional,
            festivals: [.ugadi, .diwali],
            difficulty: .beginner,
            gridSize: 9,
            estimatedMinutes: 8,
            description: "A circular toran of mango leaves around a gold bindu.",
            tags: ["mango", "toran"],
            motif: .mangoLeaf,
            xpReward: 45
        )
    ]

    static func pattern(id: String) -> RangoliPattern? {
        all.first { $0.id == id }
    }

    static var daily: RangoliPattern { today.pattern }

    static var today: DailyLesson { KolamCalendar.lesson() }

    static var popular: [RangoliPattern] {
        Array(all.prefix(6))
    }

    static func matching(_ collection: BrowseCollection) -> [RangoliPattern] {
        all.filter(collection.matches)
    }

    static func search(_ query: String, language: AppLanguage = LanguageStore.shared.language) -> [RangoliPattern] {
        let raw = query.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmed = raw.lowercased()
        guard !trimmed.isEmpty else { return all }
        return all.filter {
            $0.title.lowercased().contains(trimmed)
                || $0.localizedTitle(language).localizedCaseInsensitiveContains(raw)
                || $0.tamilTitle.contains(raw)
                || $0.localizedNote(language).localizedCaseInsensitiveContains(raw)
                || $0.culturalNote.lowercased().contains(trimmed)
                || $0.tags.contains(where: { $0.contains(trimmed) })
                || $0.family.title.lowercased().contains(trimmed)
                || $0.family.localizedTitle(language).localizedCaseInsensitiveContains(raw)
                || $0.family.tamilTitle.contains(raw)
                || $0.theme.title.lowercased().contains(trimmed)
                || $0.theme.localizedTitle(language).localizedCaseInsensitiveContains(raw)
                || $0.festivals.contains(where: {
                    $0.title.lowercased().contains(trimmed)
                        || $0.localizedTitle(language).localizedCaseInsensitiveContains(raw)
                        || $0.rawValue.contains(trimmed)
                        || $0.tamilTitle.contains(raw)
                })
        }
    }
}
