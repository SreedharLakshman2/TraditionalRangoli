import XCTest
@testable import TraditionalRangoli

final class ColorThemeTests: XCTestCase {
    override func tearDown() {
        CourtyardColorTheme.setCurrent(.ivoryCourtyard)
        super.tearDown()
    }

    func testAllThemesHaveDistinctPrimaryColors() {
        let primaries = CourtyardColorTheme.allCases.map(\.palette.primaryHex)
        XCTAssertEqual(Set(primaries).count, CourtyardColorTheme.allCases.count)
    }

    func testMidnightThemeUsesLightInkOnDarkPaper() {
        let midnight = CourtyardColorTheme.midnightIndigo.palette
        let ivory = CourtyardColorTheme.ivoryCourtyard.palette
        XCTAssertNotEqual(midnight.ivoryHex, ivory.ivoryHex)
        XCTAssertNotEqual(midnight.inkHex, ivory.inkHex)
        XCTAssertEqual(CourtyardColorTheme.midnightIndigo.colorScheme, .dark)
        XCTAssertEqual(CourtyardColorTheme.ivoryCourtyard.colorScheme, .light)
    }

    func testSelectingThemeUpdatesCurrentPalette() {
        CourtyardColorTheme.setCurrent(.keralaGreen)
        XCTAssertEqual(CourtyardColorTheme.current, .keralaGreen)
        XCTAssertEqual(CourtyardColorTheme.current.palette.primaryHex, CourtyardColorTheme.keralaGreen.palette.primaryHex)
        CourtyardColorTheme.setCurrent(.lotusBlush)
        XCTAssertEqual(CourtyardColorTheme.current.palette.primaryHex, CourtyardColorTheme.lotusBlush.palette.primaryHex)
    }

    func testThemeNamesAreLocalized() {
        XCTAssertEqual(CourtyardColorTheme.ivoryCourtyard.localizedTitle(.english), "Ivory courtyard")
        XCTAssertNotEqual(CourtyardColorTheme.midnightIndigo.localizedTitle(.chinese), CourtyardColorTheme.midnightIndigo.localizedTitle(.english))
        XCTAssertEqual(CourtyardColorTheme.allCases.count, 6)
    }

    func testEachThemePreviewUsesItsOwnInkOnIvory() {
        for theme in CourtyardColorTheme.allCases {
            XCTAssertNotEqual(
                theme.palette.inkHex,
                theme.palette.ivoryHex,
                "\(theme.rawValue) ink matches its ivory, so the picker label would vanish"
            )
        }
        XCTAssertNotEqual(
            CourtyardColorTheme.midnightIndigo.palette.inkHex,
            CourtyardColorTheme.ivoryCourtyard.palette.inkHex
        )
    }
}

final class LanguagePickerTests: XCTestCase {
    func testMonogramUsesNativeScript() {
        XCTAssertEqual(AppLanguage.tamil.monogram, "த")
        XCTAssertEqual(AppLanguage.chinese.monogram, "中")
        XCTAssertEqual(AppLanguage.english.monogram, "E")
        XCTAssertTrue(AppLanguage.hindi.nativeName.hasPrefix(AppLanguage.hindi.monogram))
    }

    func testIndianLanguagesLeadWithTamil() {
        XCTAssertEqual(AppLanguage.indianLanguages.first, .tamil)
        XCTAssertFalse(AppLanguage.worldLanguages.contains(.tamil))
        XCTAssertTrue(AppLanguage.worldLanguages.contains(.english))
    }

    func testDefaultAndLandingLanguageIsEnglish() {
        XCTAssertEqual(AppLanguage.worldLanguages.first, .english)
        XCTAssertEqual(AppLanguage.english.code, "en")
    }
}
