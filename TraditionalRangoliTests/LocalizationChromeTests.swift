import XCTest
@testable import TraditionalRangoli

final class LocalizationChromeTests: XCTestCase {
    func testChineseHomeExploreSavedIsNotEnglish() {
        let language = AppLanguage.chinese
        for key in LocalizationChrome.visibleTabKeys {
            XCTAssertTrue(
                LocalizationChrome.differsFromEnglish(key, language),
                "Chinese still shows English for \(key): \(L10n.string(key, language))"
            )
        }
    }

    func testJapaneseAndHindiHomeExploreSavedIsNotEnglish() {
        for language in [AppLanguage.japanese, .hindi, .tamil] {
            for key in LocalizationChrome.visibleTabKeys {
                XCTAssertTrue(
                    LocalizationChrome.differsFromEnglish(key, language),
                    "\(language.rawValue) still shows English for \(key): \(L10n.string(key, language))"
                )
            }
        }
    }

    func testOnamLessonCardUsesLocalizedTitleAndNote() throws {
        let pattern = try XCTUnwrap(PatternCatalog.pattern(id: "onam-pookalam"))
        XCTAssertEqual(pattern.localizedTitle(.english), "Onam Pookalam")
        XCTAssertEqual(pattern.localizedTitle(.chinese), "欧南节花毯")
        XCTAssertFalse(pattern.localizedNote(.chinese).contains("Pookalam is Kerala"))
        XCTAssertEqual(Festival.onam.localizedTitle(.chinese), "欧南节")
        XCTAssertEqual(PatternFamily.floral.localizedTitle(.chinese), "花卉")
        XCTAssertEqual(L10n.string("exploreCollections", .chinese), "探索合集")
        XCTAssertEqual(L10n.string("sectionTraditional", .chinese), "传统")
        XCTAssertEqual(L10n.string("searchHint", .chinese), "搜索点阵、连环、丰收节…")
    }

    func testSavedEmptyStateIsTranslated() {
        XCTAssertNotEqual(L10n.string("emptyGalleryTitle", .chinese), L10n.string("emptyGalleryTitle", .english))
        XCTAssertNotEqual(L10n.string("myCreations", .spanish), L10n.string("myCreations", .english))
        XCTAssertNotEqual(L10n.string("favorites", .french), L10n.string("favorites", .english))
    }

    func testPulliChipFormatIsLocalized() {
        let english = String(format: L10n.string("pulliNxN", .english), 13, 13)
        let chinese = String(format: L10n.string("pulliNxN", .chinese), 13, 13)
        XCTAssertTrue(english.lowercased().contains("pulli"))
        XCTAssertTrue(chinese.contains("普利"))
        XCTAssertFalse(chinese.lowercased().contains("pulli"))
    }

    func testEveryLanguageHasNonEnglishExploreCollections() {
        for language in AppLanguage.allCases where language != .english {
            XCTAssertNotEqual(
                L10n.string("exploreCollections", language),
                L10n.string("exploreCollections", .english),
                "\(language.rawValue) exploreCollections fell back to English"
            )
        }
    }
}
