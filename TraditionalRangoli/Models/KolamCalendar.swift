import Foundation

enum KolamOccasion: Equatable {
    case festival(Festival)
    case threshold

    var kicker: String {
        switch self {
        case .festival(let festival):
            return "TODAY'S \(festival.title.uppercased()) LESSON"
        case .threshold:
            return "TODAY'S THRESHOLD KOLAM"
        }
    }

    var headline: String {
        switch self {
        case .festival(.pongal):
            return "Thai Pongal — a harvest lesson for the doorway."
        case .festival(.diwali):
            return "Deepavali — light sits with the lamps at the threshold."
        case .festival(.navratri):
            return "Navratri — a lotus lesson for nine nights."
        case .festival(.onam):
            return "Onam — a pookalam lesson drawn in powder."
        case .festival(.ugadi):
            return "Ugadi and Puthandu — the year opens at the step."
        case .festival(.newYear):
            return "A rising-sun lesson for the new year."
        case .threshold:
            return "The everyday morning kolam, drawn for the house and the ants."
        }
    }
}

struct DailyLesson {
    var occasion: KolamOccasion
    var pattern: RangoliPattern

    var kicker: String { occasion.kicker }
    var headline: String { occasion.headline }
}

enum PatternCulture {
    static func tamilTitle(for id: String) -> String {
        switch id {
        case "lotus-dot": return "தாமரைப் புள்ளி கோலம்"
        case "simple-flower": return "எளிய பூக்கோலம்"
        case "peacock": return "மயில் கோலம்"
        case "diya": return "தீபக் கோலம்"
        case "pulli": return "புள்ளி கோலம்"
        case "spiral": return "சுழல் சிக்கு"
        case "eight-petal": return "எட்டு இதழ்த் தாமரை"
        case "geo-star": return "நட்சத்திர கோலம்"
        case "festival-flower": return "திருவிழாப் பூக்கோலம்"
        case "mandala": return "மண்டல கோலம்"
        case "butterfly": return "வண்ணத்துப்பூச்சி"
        case "pongal-pot": return "பொங்கல் பானை"
        case "sikku-knot": return "சிக்கு முடிச்சு கோலம்"
        case "onam-pookalam": return "ஓணம் பூக்கோலம்"
        case "sun-burst": return "புத்தாண்டு சூரியன்"
        case "mango-leaf": return "மாவிலைத் தோரணம்"
        default: return "கோலம்"
        }
    }

    static func culturalNote(for id: String) -> String {
        switch id {
        case "lotus-dot":
            return "Lotus is drawn at the door as a welcome — padma for a clean, auspicious step."
        case "simple-flower":
            return "A small flower kolam is the everyday greeting before the house wakes."
        case "peacock":
            return "Peacock rangoli is a festival sight: beauty at the threshold when guests are expected."
        case "diya":
            return "Diya kolam is drawn at Deepavali so the lamp and the floor speak together."
        case "pulli":
            return "Pulli kolam is Tamil morning writing: rice-flour dots, then one line looping around them — also left for ants."
        case "spiral":
            return "A sikku spiral trains the hand never to lift the powder, a continuous blessing around the dots."
        case "eight-petal":
            return "Eight petals make a complete doorway lotus, the ashtadala form used in temple geometry."
        case "geo-star":
            return "Star geometry is drawn for new beginnings — calm, even points at the step."
        case "festival-flower":
            return "Marigold-coloured petals are the common festival floor when the house is expecting company."
        case "mandala":
            return "A layered mandala is a longer vow of concentration, often for Navratri and the new year."
        case "butterfly":
            return "Spring courtyards draw butterflies for Onam and Ugadi — a garden on the clay."
        case "pongal-pot":
            return "The overflowing pot is Thai Pongal: harvest, sugarcane, and pongalo pongal at the door."
        case "sikku-knot":
            return "Sikku knots are a Tamil classic — the line never breaks, the house is bound in one thread."
        case "onam-pookalam":
            return "Pookalam is Kerala’s Onam flower carpet; this lesson draws those rings in rice powder."
        case "sun-burst":
            return "A rising sun for Puthandu and Ugadi — the year opens at the threshold."
        case "mango-leaf":
            return "Mango-leaf toran is hung and drawn for Ugadi and Deepavali as a living welcome."
        default:
            return "A courtyard kolam drawn as geometry, not a coloring page."
        }
    }
}

extension RangoliPattern {
    var tamilTitle: String { PatternCulture.tamilTitle(for: id) }
    var culturalNote: String { PatternCulture.culturalNote(for: id) }
}

extension PatternFamily {
    var tamilTitle: String {
        switch self {
        case .pulliKolam: return "புள்ளி கோலம்"
        case .sikkuKolam: return "சிக்கு கோலம்"
        case .freehandRangoli: return "ரங்கோலி"
        case .geometric: return "வடிவ கோலம்"
        case .floral: return "பூக்கோலம்"
        }
    }
}

extension Festival {
    var tamilTitle: String {
        switch self {
        case .pongal: return "பொங்கல்"
        case .diwali: return "தீபாவளி"
        case .navratri: return "நவராத்திரி"
        case .onam: return "ஓணம்"
        case .ugadi: return "உகாதி"
        case .newYear: return "புத்தாண்டு"
        }
    }
}

enum KolamCalendar {
    private static let namesakeId: [Festival: String] = [
        .pongal: "pongal-pot",
        .diwali: "diya",
        .navratri: "eight-petal",
        .onam: "onam-pookalam",
        .ugadi: "mango-leaf",
        .newYear: "sun-burst"
    ]

    private static let thresholdIds = ["pulli", "simple-flower", "sikku-knot", "spiral"]

    static func lesson(on date: Date = Date(), calendar: Calendar = Calendar(identifier: .gregorian)) -> DailyLesson {
        if ScreenshotLaunch.isActive {
            return screenshotLesson
        }
        if let festival = festival(on: date, calendar: calendar) {
            let pattern = namesake(for: festival) ?? firstMatching(festival) ?? PatternCatalog.all[0]
            return DailyLesson(occasion: .festival(festival), pattern: pattern)
        }
        let day = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let id = thresholdIds[day % thresholdIds.count]
        let pattern = PatternCatalog.pattern(id: id) ?? PatternCatalog.all[0]
        return DailyLesson(occasion: .threshold, pattern: pattern)
    }

    static var screenshotLesson: DailyLesson {
        DailyLesson(
            occasion: .threshold,
            pattern: PatternCatalog.pattern(id: "pulli") ?? PatternCatalog.all[0]
        )
    }

    static func festival(on date: Date, calendar: Calendar) -> Festival? {
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let stamp = month * 100 + day
        if stamp >= 110 && stamp <= 205 { return .pongal }
        if stamp >= 322 && stamp <= 422 { return .ugadi }
        if stamp >= 815 && stamp <= 918 { return .onam }
        if stamp >= 922 && stamp <= 1012 { return .navratri }
        if stamp >= 1018 && stamp <= 1115 { return .diwali }
        if stamp >= 1226 || stamp <= 107 { return .newYear }
        return nil
    }

    private static func namesake(for festival: Festival) -> RangoliPattern? {
        namesakeId[festival].flatMap(PatternCatalog.pattern(id:))
    }

    private static func firstMatching(_ festival: Festival) -> RangoliPattern? {
        PatternCatalog.all.first { $0.festivals.contains(festival) }
    }
}
