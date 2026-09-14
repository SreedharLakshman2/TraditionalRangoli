import Foundation

enum L10n {
    static func string(_ key: String, _ language: AppLanguage) -> String {
        table[language.rawValue]?[key] ?? table["english"]?[key] ?? key
    }

    private static let table: [String: [String: String]] = load()

    private static func load() -> [String: [String: String]] {
        let bundles = [Bundle.main, Bundle(for: L10nBundleAnchor.self)]
        for bundle in bundles {
            if let url = bundle.url(forResource: "L10nTable", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let decoded = try? JSONDecoder().decode([String: [String: String]].self, from: data) {
                return decoded
            }
        }
        return [:]
    }
}

private final class L10nBundleAnchor: NSObject {}
