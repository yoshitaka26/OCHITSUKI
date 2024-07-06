//
//  AdBannerView.swift
//  OCHITSUKI
//
//  Created by Yoshitaka Tanaka on 2024/07/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import GoogleMobileAds

// https://qiita.com/yoshitaka/items/51327962c4799a820237

struct AdBannerView: View {
    var body: some View {
        BannerView()
    }
}

struct BannerView: UIViewControllerRepresentable {
    @State private var viewWidth: CGFloat = .zero
    private let bannerView = GADBannerView()
    private let adUnitID = Bundle.main.object(forInfoDictionaryKey: "AdMobSettingViewBannerAdUnitId") as? String


    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerViewController = BannerViewController()
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = bannerViewController
        bannerViewController.view.addSubview(bannerView)
        // Tell the bannerViewController to update our Coordinator when the ad width changes.
        bannerViewController.delegate = context.coordinator

        return bannerViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else { return }

        // Request a banner ad with the updated viewWidth.
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, BannerViewControllerWidthDelegate, GADBannerViewDelegate {
        let parent: BannerView

        init(_ parent: BannerView) {
            self.parent = parent
        }

        // MARK: - BannerViewControllerWidthDelegate methods
        func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat) {
            // Pass the viewWidth from Coordinator to BannerView.
            parent.viewWidth = width
        }


        // MARK: - GADBannerViewDelegate methods
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }

        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("\(#function) error called")
        }

        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }

        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }

        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }

        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            print("\(#function) called")
        }
    }
}

// Delegate methods for receiving width update messages.
protocol BannerViewControllerWidthDelegate: AnyObject {
    func bannerViewController(_ bannerViewController: BannerViewController, didUpdate width: CGFloat)
}

class BannerViewController: UIViewController {
    weak var delegate: BannerViewControllerWidthDelegate?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Tell the delegate the initial ad width.
        delegate?.bannerViewController(
            self, didUpdate: view.frame.inset(by: view.safeAreaInsets).size.width)
    }

    override func viewWillTransition(
        to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    ) {
        coordinator.animate { _ in
            // do nothing
        } completion: { _ in
            // Notify the delegate of ad width changes.
            self.delegate?.bannerViewController(
                self, didUpdate: self.view.frame.inset(by: self.view.safeAreaInsets).size.width)
        }
    }
}

#Preview {
    AdBannerView()
}
