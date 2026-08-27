import Combine
import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable, Codable {
    case english, hindi, tamil, telugu, kannada
    case malayalam, marathi, gujarati, bengali, punjabi
    case odia, assamese, nepali, sanskrit
    case spanish, french, german, portuguese
    case indonesian, japanese, chinese

    var id: String { rawValue }

    var code: String {
        switch self {
        case .english: return "en"
        case .hindi: return "hi"
        case .tamil: return "ta"
        case .telugu: return "te"
        case .kannada: return "kn"
        case .malayalam: return "ml"
        case .marathi: return "mr"
        case .gujarati: return "gu"
        case .bengali: return "bn"
        case .punjabi: return "pa"
        case .odia: return "or"
        case .assamese: return "as"
        case .nepali: return "ne"
        case .sanskrit: return "sa"
        case .spanish: return "es"
        case .french: return "fr"
        case .german: return "de"
        case .portuguese: return "pt"
        case .indonesian: return "id"
        case .japanese: return "ja"
        case .chinese: return "zh"
        }
    }

    var nativeName: String {
        switch self {
        case .english: return "English"
        case .hindi: return "हिन्दी"
        case .tamil: return "தமிழ்"
        case .telugu: return "తెలుగు"
        case .kannada: return "ಕನ್ನಡ"
        case .malayalam: return "മലയാളം"
        case .marathi: return "मराठी"
        case .gujarati: return "ગુજરાતી"
        case .bengali: return "বাংলা"
        case .punjabi: return "ਪੰਜਾਬੀ"
        case .odia: return "ଓଡ଼ିଆ"
        case .assamese: return "অসমীয়া"
        case .nepali: return "नेपाली"
        case .sanskrit: return "संस्कृतम्"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .portuguese: return "Português"
        case .indonesian: return "Bahasa Indonesia"
        case .japanese: return "日本語"
        case .chinese: return "中文"
        }
    }

    var englishName: String {
        switch self {
        case .english: return "English"
        case .hindi: return "Hindi"
        case .tamil: return "Tamil"
        case .telugu: return "Telugu"
        case .kannada: return "Kannada"
        case .malayalam: return "Malayalam"
        case .marathi: return "Marathi"
        case .gujarati: return "Gujarati"
        case .bengali: return "Bengali"
        case .punjabi: return "Punjabi"
        case .odia: return "Odia"
        case .assamese: return "Assamese"
        case .nepali: return "Nepali"
        case .sanskrit: return "Sanskrit"
        case .spanish: return "Spanish"
        case .french: return "French"
        case .german: return "German"
        case .portuguese: return "Portuguese"
        case .indonesian: return "Indonesian"
        case .japanese: return "Japanese"
        case .chinese: return "Chinese"
        }
    }

    var isIndian: Bool {
        switch self {
        case .english, .spanish, .french, .german, .portuguese, .indonesian, .japanese, .chinese:
            return false
        default:
            return true
        }
    }

    var usesLatinScript: Bool {
        switch self {
        case .english, .spanish, .french, .german, .portuguese, .indonesian:
            return true
        default:
            return false
        }
    }

    var searchBlob: String {
        "\(nativeName) \(englishName) \(code)".lowercased()
    }

    static var indianLanguages: [AppLanguage] {
        let rest = allCases.filter { $0.isIndian && $0 != .tamil }
        return [.tamil] + rest
    }

    static var worldLanguages: [AppLanguage] {
        allCases.filter { !$0.isIndian }
    }

    static func fromDevice() -> AppLanguage {
        for preferred in Locale.preferredLanguages {
            let code = Locale(identifier: preferred).language.languageCode?.identifier ?? ""
            switch code {
            case "hi": return .hindi
            case "ta": return .tamil
            case "te": return .telugu
            case "kn": return .kannada
            case "ml": return .malayalam
            case "mr": return .marathi
            case "gu": return .gujarati
            case "bn": return .bengali
            case "pa": return .punjabi
            case "or": return .odia
            case "as": return .assamese
            case "ne": return .nepali
            case "sa": return .sanskrit
            case "es": return .spanish
            case "fr": return .french
            case "de": return .german
            case "pt": return .portuguese
            case "id": return .indonesian
            case "ja": return .japanese
            case "zh": return .chinese
            case "en": return .english
            default: continue
            }
        }
        return .english
    }
}

final class LanguageStore: ObservableObject {
    static let shared = LanguageStore()
    private let key = "rangoli.language"

    @Published var language: AppLanguage {
        didSet { UserDefaults.standard.set(language.rawValue, forKey: key) }
    }

    private init() {
        if let raw = UserDefaults.standard.string(forKey: key),
           let value = AppLanguage(rawValue: raw) {
            language = value
        } else {
            language = AppLanguage.fromDevice()
        }
    }

    func t(_ key: String) -> String {
        L10n.string(key, language)
    }

    func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: L10n.string(key, language), arguments: arguments)
    }
}

extension Font {
    static func rangoliScript(_ size: CGFloat, weight: Font.Weight = .semibold, language: AppLanguage) -> Font {
        if language.usesLatinScript {
            return .system(size: size, weight: weight, design: .serif)
        }
        return .system(size: size, weight: weight, design: .rounded)
    }
}
