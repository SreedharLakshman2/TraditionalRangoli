import GoogleMobileAds
import SwiftUI
import UIKit

struct BannerAdView: UIViewRepresentable {
    func makeUIView(context: Context) -> BannerHostView {
        let host = BannerHostView()
        host.banner.adUnitID = AdConfig.bannerAdUnitId
        host.banner.rootViewController = AdsManager.keyWindowRoot()
        host.banner.load(GADRequest())
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
            banner.heightAnchor.constraint(equalToConstant: AdBannerSlot.height)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct AdBannerSlot: View {
    static let height: CGFloat = 50

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
