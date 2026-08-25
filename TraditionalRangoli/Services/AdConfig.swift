import Foundation

enum AdConfig {
    /// Traditional Rangoli iOS app in AdMob. Also set as `GADApplicationIdentifier` in Info.plist.
    static let productionAppID = "ca-app-pub-9471606055191983~6904521909"

    static let productionBannerAdUnitId = "ca-app-pub-9471606055191983/3317515164"
    static let productionInterstitialAdUnitId = "ca-app-pub-9471606055191983/3843244299"

    static let testBannerAdUnitId = "ca-app-pub-3940256099942544/2934735716"
    static let testInterstitialAdUnitId = "ca-app-pub-3940256099942544/4411468910"

    /// Debug/Simulator uses Google sample units so the AdMob account is not flagged.
    static var bannerAdUnitId: String {
        #if DEBUG
        testBannerAdUnitId
        #else
        productionBannerAdUnitId
        #endif
    }

    static var interstitialAdUnitId: String {
        #if DEBUG
        testInterstitialAdUnitId
        #else
        productionInterstitialAdUnitId
        #endif
    }
}
