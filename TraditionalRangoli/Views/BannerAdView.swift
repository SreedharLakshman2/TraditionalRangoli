import GoogleMobileAds
import SwiftUI
import UIKit

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerHostView {
        let host = BannerHostView()
        host.banner.adUnitID = AdConfig.bannerAdUnitId
        host.banner.rootViewController = AdsManager.keyWindowRoot()
        return host
    }

    func updateUIView(_ uiView: BannerHostView, context: Context) {
        if uiView.banner.rootViewController == nil {
            uiView.banner.rootViewController = AdsManager.keyWindowRoot()
        }
    }
}

final class BannerHostView: UIView {
    let banner = GADBannerView(adSize: GADAdSizeBanner)
    private var lastWidth: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .clear
        banner.backgroundColor = .clear
        banner.translatesAutoresizingMaskIntoConstraints = false
        addSubview(banner)
        NSLayoutConstraint.activate([
            banner.topAnchor.constraint(equalTo: topAnchor),
            banner.centerXAnchor.constraint(equalTo: centerXAnchor),
            banner.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
            banner.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        guard width > 1, abs(width - lastWidth) > 1 else { return }
        lastWidth = width
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width)
        banner.adSize = adSize
        banner.rootViewController = AdsManager.keyWindowRoot()
        banner.load(GADRequest())
    }
}

struct AdBannerSlot: View {
    static var height: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 90 : 50
    }

    @EnvironmentObject private var ads: AdsManager

    var body: some View {
        ZStack {
            RangoliColor.ivory
            if ads.isReady {
                BannerAdView()
            }
        }
        .frame(height: Self.height)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(RangoliColor.gold.opacity(0.28))
                .frame(height: 0.5)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Advertisement")
    }
}
