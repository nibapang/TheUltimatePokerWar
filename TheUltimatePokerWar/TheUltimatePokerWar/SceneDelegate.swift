//
//  SceneDelegate.swift
//  TheUltimatePokerWar
//
//  Created by Sun on 2025/3/21.
//

import UIKit
import Adjust
import AppTrackingTransparency
class SceneDelegate: UIResponder, UIWindowSceneDelegate, AdjustDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        configureAdjust()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        Adjust.trackSubsessionStart()
        requestTrackingAuthorizationIfNeeded()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        Adjust.trackSubsessionEnd()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    private func configureAdjust() {
          let token = "1whg13xl1uv4"
          let environment = ADJEnvironmentProduction
          guard let adjustConfig = ADJConfig(appToken: token, environment: environment) else { return }
          adjustConfig.delegate = self
          adjustConfig.logLevel = ADJLogLevelVerbose
          Adjust.appDidLaunch(adjustConfig)
      }
      
      // MARK: - App Tracking Transparency

      private func requestTrackingAuthorizationIfNeeded() {
          // Delay the request slightly to ensure the app is active.
          DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
              if #available(iOS 14, *) {
                  ATTrackingManager.requestTrackingAuthorization { status in
                      // You can handle the authorization status if needed.
                  }
              }
          }
      }
     func adjustEventTrackingSucceeded(_ eventSuccessResponseData: ADJEventSuccess?) {
          print("adjustEventTrackingSucceeded")
      }
      
      func adjustEventTrackingFailed(_ eventFailureResponseData: ADJEventFailure?) {
          print("adjustEventTrackingFailed")
      }
      
      func adjustAttributionChanged(_ attribution: ADJAttribution?) {
          print("adjustAttributionChanged：\(attribution?.adid ?? "")")
      }

}

