//
//  ViewController.swift
//  AdsIntegrationDemo
//
//  Created by DREAMWORLD on 29/05/24.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var bannerAdView: UIView!
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd?
    var rewardedAd: GADRewardedAd?

    var bannerAdUnitId = "your_banner_ad_unit_id" // Change your ad app_id from Info.Plist
    
    var interstitialAdUnitId = "your_interstitial_ad_unit_id" // Change your ad app_id from Info.Plist
    
    var rewardAdUnitId = "your_reward_ad_unit_id" // Change your ad app_id from Info.Plist

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup Banner ads
        setUpAndLoadBannerAds()
        
        // Setup Interstitial ads
        loadInterstitialAds()
        
        // Setup Reward ads
        setUpRewardAds()
    }
    
    // Setup Banner ads
    func setUpAndLoadBannerAds() {
        let viewWidth = bannerAdView.frame.inset(by: bannerAdView.safeAreaInsets).width
        
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView = GADBannerView(adSize: adaptiveSize)
        
        bannerView.adUnitID = bannerAdUnitId
        bannerView.delegate = self

        bannerView.load(GADRequest())

        addBannerViewToView(bannerView)
    }
    
    // Setup Reward ads
    func setUpRewardAds() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: rewardAdUnitId, //"ca-app-pub-4405190563487771/1656584332"
                         request: request,
                         completionHandler: { ad, error in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                return
            }
            self.rewardedAd = ad
            print("Rewarded ad loaded.")
            self.rewardedAd?.fullScreenContentDelegate = self
        })
    }
    
    // Setup Interstitial ads
    func loadInterstitialAds() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: interstitialAdUnitId /*"ca-app-pub-4405190563487771/7949356482"*/,
                               request: request,
                               completionHandler: { ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
        })
    }
    
    // Add Banner view to view(where you want to show)
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerAdView.addSubview(bannerView)
        bannerAdView.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: bannerAdView.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: bannerAdView,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
    
    // Show Reward ads
    func showRewardAd() {
      guard let ad = rewardedAd else {
        return print("Ad wasn't ready.")
      }

      // The UIViewController parameter is an optional.
      ad.present(fromRootViewController: nil) {
        let reward = ad.adReward
        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
        // TODO: Reward the user.
      }
    }
    
    //MARK: - IBActions
    @IBAction func btnInterstitialAds_Clk(_ sender: UIButton) {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    
    @IBAction func btnRewardAds_Clk(_ sender: UIButton) {
        showRewardAd()
    }

    @IBAction func btnNativeAds_Clk(_ sender: UIButton) {
        
    }

}

//MARK: - Banner ads delegates
extension ViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("bannerViewDidReceiveAd")
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
          bannerView.alpha = 1
        })
        addBannerViewToView(bannerView)
    }

    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
      print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
      print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("bannerViewDidDismissScreen")
    }
}

//MARK: - Interstitial ads & Rewarded ads delegates
extension ViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
        loadInterstitialAds()
        setUpRewardAds()
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadInterstitialAds()
        setUpRewardAds()
      print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        setUpRewardAds()
      print("Ad did dismiss full screen content.")
    }
}
