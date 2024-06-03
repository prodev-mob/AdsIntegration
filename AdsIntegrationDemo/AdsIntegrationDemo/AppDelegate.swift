//
//  AppDelegate.swift
//  AdsIntegrationDemo
//
//  Created by DREAMWORLD on 29/05/24.
//

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize the Google Mobile Ads SDK.
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // For Child Related Content in ads
//        GADMobileAds.sharedInstance().requestConfiguration.maxAdContentRating = GADMaxAdContentRating.general
//        GADMobileAds.sharedInstance().requestConfiguration.tag(forChildDirectedTreatment: true)

        return true
    }
}

