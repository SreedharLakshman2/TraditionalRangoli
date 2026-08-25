import StoreKit
import UIKit

/// Asks for an App Store rating after real drawing, using Apple's in-app review dialog.
/// Apple still limits how often the dialog can appear (about three times a year).
@MainActor
enum ReviewPrompt {
    private static let firstUseKey = "rangoli.firstUse"
    private static let lastPromptKey = "rangoli.lastReviewPrompt"
    private static let promptCountKey = "rangoli.reviewPromptCount"
    private static let completedKey = "rangoli.lifetimeRangoliForReview"

    private static let minCompletedRangolis = 2
    private static let minDaysBetweenPrompts = 60
    private static let maxPromptsWeAttempt = 3

    private static var isAsking = false

    static func recordFirstUseIfNeeded() {
        guard UserDefaults.standard.object(forKey: firstUseKey) == nil else { return }
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: firstUseKey)
    }

    static func recordRangoliCompleted() {
        recordFirstUseIfNeeded()
        let total = UserDefaults.standard.integer(forKey: completedKey) + 1
        UserDefaults.standard.set(total, forKey: completedKey)
    }

    static func askIfAppropriate(delay: TimeInterval = 1.2) {
        guard !ScreenshotLaunch.isActive else { return }
        guard !isAsking else { return }
        guard isEligible else { return }
        isAsking = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            defer { isAsking = false }
            guard isEligible else { return }
            requestReview()
            let count = UserDefaults.standard.integer(forKey: promptCountKey) + 1
            UserDefaults.standard.set(count, forKey: promptCountKey)
        }
    }

    static func requestReview() {
        guard !ScreenshotLaunch.isActive else { return }
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let scene = scenes.first(where: { $0.activationState == .foregroundActive }) ?? scenes.first
        guard let scene else { return }
        if #available(iOS 18.0, *) {
            AppStore.requestReview(in: scene)
        } else {
            SKStoreReviewController.requestReview(in: scene)
        }
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: lastPromptKey)
    }

    private static var isEligible: Bool {
        recordFirstUseIfNeeded()
        guard UserDefaults.standard.integer(forKey: promptCountKey) < maxPromptsWeAttempt else { return false }
        guard UserDefaults.standard.integer(forKey: completedKey) >= minCompletedRangolis else { return false }

        let lastPrompt = UserDefaults.standard.double(forKey: lastPromptKey)
        if lastPrompt > 0 {
            let daysSince = (Date().timeIntervalSince1970 - lastPrompt) / 86_400
            guard daysSince >= Double(minDaysBetweenPrompts) else { return false }
        }
        return true
    }
}
