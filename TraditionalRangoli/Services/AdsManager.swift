import AppTrackingTransparency
import Foundation
import GoogleMobileAds
import UIKit

@MainActor
final class AdsManager: NSObject, ObservableObject, GADFullScreenContentDelegate {
    static let shared = AdsManager()

    @Published var isReady = false

    private var interstitial: GADInterstitialAd?
    private var didBootstrap = false
    private var isLoadingInterstitial = false
    private var lastInterstitialAt: Date?
    private let interstitialCooldown: TimeInterval = 45

    func bootstrap() {
        guard !didBootstrap else { return }
        didBootstrap = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.requestTrackingThenStart()
        }
    }

    func onAppBecameActive() {
        guard didBootstrap else { return }
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            requestTrackingThenStart()
        }
    }

    private func requestTrackingThenStart() {
        ATTrackingManager.requestTrackingAuthorization { _ in
            Task { @MainActor in
                self.startAds()
            }
        }
    }

    private func startAds() {
        GADMobileAds.sharedInstance().start { [weak self] _ in
            Task { @MainActor in
                self?.isReady = true
                self?.preloadInterstitial()
            }
        }
    }

    func preloadInterstitial() {
        guard !isLoadingInterstitial, interstitial == nil else { return }
        isLoadingInterstitial = true
        GADInterstitialAd.load(withAdUnitID: AdConfig.interstitialAdUnitId, request: GADRequest()) { [weak self] ad, _ in
            Task { @MainActor in
                self?.isLoadingInterstitial = false
                ad?.fullScreenContentDelegate = self
                self?.interstitial = ad
            }
        }
    }

    /// Full-screen ad after a rangoli is finished. Celebration stays on screen first.
    func showInterstitialAfterRangoli(delay: TimeInterval = 1.15) {
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            self.showInterstitialIfAvailable()
        }
    }

    func showInterstitialIfAvailable() {
        if let last = lastInterstitialAt, Date().timeIntervalSince(last) < interstitialCooldown {
            preloadInterstitial()
            return
        }
        guard let interstitial, let root = Self.keyWindowRoot() else {
            preloadInterstitial()
            return
        }
        lastInterstitialAt = Date()
        interstitial.present(fromRootViewController: root)
        self.interstitial = nil
    }

    nonisolated func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        Task { @MainActor in
            self.interstitial = nil
            self.preloadInterstitial()
        }
    }

    nonisolated func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        Task { @MainActor in
            self.interstitial = nil
            self.preloadInterstitial()
        }
    }

    static func keyWindowRoot() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let window = scenes.flatMap(\.windows).first(where: \.isKeyWindow) ?? scenes.first?.windows.first
        var controller = window?.rootViewController
        while let presented = controller?.presentedViewController {
            controller = presented
        }
        return controller
    }
}
