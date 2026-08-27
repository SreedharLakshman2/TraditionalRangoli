import Foundation

extension RangoliPattern {
    func localizedTitle(_ language: AppLanguage) -> String {
        if language == .tamil { return tamilTitle }
        return L10n.string("pattern.\(id).title", language)
    }

    func localizedNote(_ language: AppLanguage) -> String {
        L10n.string("pattern.\(id).note", language)
    }

    func steps(language: AppLanguage) -> [RangoliStep] {
        GeometryFactory.steps(for: self, language: language)
    }
}

extension PatternFamily {
    func localizedTitle(_ language: AppLanguage) -> String {
        if language == .tamil { return tamilTitle }
        switch self {
        case .pulliKolam: return L10n.string("familyPulli", language)
        case .sikkuKolam: return L10n.string("familySikku", language)
        case .freehandRangoli: return L10n.string("familyFreehand", language)
        case .geometric: return L10n.string("familyGeometric", language)
        case .floral: return L10n.string("familyFloral", language)
        }
    }
}

extension MotifTheme {
    func localizedTitle(_ language: AppLanguage) -> String {
        switch self {
        case .lotus: return L10n.string("themeLotus", language)
        case .peacock: return L10n.string("themePeacock", language)
        case .diya: return L10n.string("themeDiya", language)
        case .flowers: return L10n.string("themeFlowers", language)
        case .mandala: return L10n.string("themeMandala", language)
        case .traditional: return L10n.string("themeTraditional", language)
        }
    }
}

extension Festival {
    func localizedTitle(_ language: AppLanguage) -> String {
        if language == .tamil { return tamilTitle }
        switch self {
        case .pongal: return L10n.string("festivalPongal", language)
        case .diwali: return L10n.string("festivalDiwali", language)
        case .navratri: return L10n.string("festivalNavratri", language)
        case .onam: return L10n.string("festivalOnam", language)
        case .ugadi: return L10n.string("festivalUgadi", language)
        case .newYear: return L10n.string("festivalNewYear", language)
        }
    }
}

extension BrowseCollection {
    func localizedTitle(_ language: AppLanguage) -> String {
        switch self {
        case .festival: return L10n.string("collectionFestival", language)
        case .dotKolam: return L10n.string("collectionDot", language)
        case .floral: return L10n.string("collectionFloral", language)
        case .peacock: return L10n.string("collectionPeacock", language)
        case .mandala: return L10n.string("collectionMandala", language)
        case .geometric: return L10n.string("collectionGeometric", language)
        }
    }
}

extension Difficulty {
    func localizedTitle(_ language: AppLanguage) -> String {
        switch self {
        case .beginner: return L10n.string("difficultyBeginner", language)
        case .intermediate: return L10n.string("difficultyIntermediate", language)
        case .advanced: return L10n.string("difficultyAdvanced", language)
        }
    }
}

extension SymmetryMode {
    func localizedTitle(_ language: AppLanguage) -> String {
        switch self {
        case .none: return L10n.string("symNone", language)
        case .horizontal: return L10n.string("symHorizontal", language)
        case .vertical: return L10n.string("symVertical", language)
        case .fourWay: return L10n.string("symFour", language)
        case .eightWay: return L10n.string("symEight", language)
        }
    }
}

extension BrushSize {
    func localizedTitle(_ language: AppLanguage) -> String {
        switch self {
        case .small: return L10n.string("brushSmall", language)
        case .medium: return L10n.string("brushMedium", language)
        case .large: return L10n.string("brushLarge", language)
        }
    }
}

extension CourtyardColorTheme {
    func localizedTitle(_ language: AppLanguage) -> String {
        L10n.string(l10nKey, language)
    }
}

enum LocalizationChrome {
    /// Copy that must not stay English on Home, Explore, and Saved.
    static let visibleTabKeys: [String] = [
        "exploreCollections", "kolamLessons", "kolamLessonsSub",
        "familyPulli", "familySikku", "familyFreehand", "familyGeometric", "familyFloral",
        "themeLotus", "themePeacock", "themeDiya",
        "festivalPongal", "festivalDiwali", "festivalNavratri", "festivalOnam", "festivalUgadi", "festivalNewYear",
        "exploreSubtitle", "searchHint", "sectionTraditional", "sectionThemes", "sectionFestivals",
        "pulliNxN", "stepsCount",
        "headlineOnam", "myCreations", "favorites",
        "emptyGalleryTitle", "emptyGallerySub", "createRangoli",
        "emptyFavTitle", "emptyFavSub", "explorePatterns",
        "pattern.onam-pookalam.title", "pattern.onam-pookalam.note"
    ]

    static func differsFromEnglish(_ key: String, _ language: AppLanguage) -> Bool {
        language == .english || L10n.string(key, language) != L10n.string(key, .english)
    }
}

extension PowderSwatch {
    func localizedTitle(_ language: AppLanguage) -> String {
        switch self {
        case .rice: return L10n.string("rice", language)
        case .traditionalRed: return L10n.string("colorRed", language)
        case .terracotta: return L10n.string("colorTerracotta", language)
        case .yellow: return L10n.string("colorYellow", language)
        case .green: return L10n.string("colorGreen", language)
        case .white: return L10n.string("colorWhite", language)
        case .orange: return L10n.string("colorOrange", language)
        case .pink: return L10n.string("colorPink", language)
        case .purple: return L10n.string("colorPurple", language)
        case .gold: return L10n.string("colorGold", language)
        }
    }
}

extension KolamOccasion {
    func kicker(_ language: AppLanguage) -> String {
        switch self {
        case .festival(let festival):
            return String(format: L10n.string("todayLesson", language), festival.localizedTitle(language))
        case .threshold:
            return L10n.string("thresholdKicker", language)
        }
    }

    func headline(_ language: AppLanguage) -> String {
        switch self {
        case .festival(.pongal): return L10n.string("headlinePongal", language)
        case .festival(.diwali): return L10n.string("headlineDiwali", language)
        case .festival(.navratri): return L10n.string("headlineNavratri", language)
        case .festival(.onam): return L10n.string("headlineOnam", language)
        case .festival(.ugadi): return L10n.string("headlineUgadi", language)
        case .festival(.newYear): return L10n.string("headlineNewYear", language)
        case .threshold: return L10n.string("headlineThreshold", language)
        }
    }
}

extension DailyLesson {
    func kicker(_ language: AppLanguage) -> String { occasion.kicker(language) }
    func headline(_ language: AppLanguage) -> String { occasion.headline(language) }
}

extension AppTab {
    var l10nKey: String {
        switch self {
        case .home: return "tabHome"
        case .explore: return "tabExplore"
        case .create: return "tabCreate"
        case .saved: return "tabSaved"
        case .profile: return "tabProfile"
        }
    }
}

extension SettingsStore {
    func localizedLevelTitle(_ language: AppLanguage) -> String {
        switch xp {
        case ..<80: return L10n.string("levelBeginner", language)
        case ..<220: return L10n.string("levelApprentice", language)
        case ..<500: return L10n.string("levelArtist", language)
        default: return L10n.string("levelMaster", language)
        }
    }

    func localizedStyle(_ language: AppLanguage) -> String {
        if let theme = MotifTheme(rawValue: favoriteStyle) {
            return theme.localizedTitle(language)
        }
        return MotifTheme.allCases.first { $0.title == favoriteStyle }?.localizedTitle(language) ?? favoriteStyle
    }
}

extension DrawingSession {
    func displayTitle(_ language: AppLanguage) -> String {
        if let pattern {
            return pattern.localizedTitle(language)
        }
        return L10n.string(studio == .freehand ? "freehandTitle" : "dotRangoliTitle", language)
    }
}
