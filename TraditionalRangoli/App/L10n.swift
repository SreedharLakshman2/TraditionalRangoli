import Foundation

enum L10n {
    private static let lock = NSLock()
    private static var cached: [String: [String: String]]?

    /// Decode the language table off the main thread during splash.
    static func prepare() {
        DispatchQueue.global(qos: .userInitiated).async {
            let loaded = load()
            lock.lock()
            cached = loaded
            lock.unlock()
        }
    }

    static func string(_ key: String, _ language: AppLanguage) -> String {
        let table = resolvedTable()
        return table[language.rawValue]?[key] ?? table["english"]?[key] ?? key
    }

    private static func resolvedTable() -> [String: [String: String]] {
        lock.lock()
        if let cached {
            lock.unlock()
            return cached
        }
        lock.unlock()
        let loaded = load()
        lock.lock()
        cached = loaded
        lock.unlock()
        return loaded
    }

    private static func load() -> [String: [String: String]] {
        let bundles = [Bundle.main, Bundle(for: L10nBundleAnchor.self)]
        for bundle in bundles {
            guard let url = bundle.url(forResource: "L10nTable", withExtension: "json"),
                  let data = try? Data(contentsOf: url),
                  let root = try? JSONSerialization.jsonObject(with: data) as? NSDictionary else {
                continue
            }
            var out: [String: [String: String]] = [:]
            out.reserveCapacity(root.count)
            for (langAny, packAny) in root {
                guard let lang = langAny as? String, let pack = packAny as? NSDictionary else { continue }
                var row: [String: String] = [:]
                row.reserveCapacity(pack.count)
                for (keyAny, valueAny) in pack {
                    if let key = keyAny as? String, let value = valueAny as? String {
                        row[key] = value
                    }
                }
                out[lang] = row
            }
            if !out.isEmpty { return out }
        }
        return [:]
    }
}

private final class L10nBundleAnchor: NSObject {}
