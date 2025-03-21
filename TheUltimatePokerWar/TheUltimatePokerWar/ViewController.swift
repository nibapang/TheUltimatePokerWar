//
//  ViewController.swift
//  TheUltimatePokerWar
//
//  Created by Sun on 2025/3/21.
//

import UIKit
import Reachability

class ViewController: UIViewController {
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    var reachability: Reachability?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        loadAdsDataIfNeeded()
        // Do any additional setup after loading the view.
    }
    // MARK: - Setup Methods
      private func setupActivityIndicator() {
          activityView.hidesWhenStopped = true
      }
      
      // MARK: - Ads Data Loading
      private func loadAdsDataIfNeeded() {
          // Check if ads data needs to be loaded
          guard uitimateNeedLoadAdBannData() else { return }
          setupReachabilityAndLoadData()
      }
     private func setupReachabilityAndLoadData() {
            do {
                reachability = try Reachability()
            } catch {
                print("Unable to create Reachability: \(error)")
                return
            }
            
            guard let reachability = reachability else { return }
        // If network is unavailable, start the notifier and wait for connectivity.
                if reachability.connection == .unavailable {
                    reachability.whenReachable = { [weak self] _ in
                        self?.stopReachabilityNotifier()
                        self?.postAppDeviceData()
                    }
                    reachability.whenUnreachable = { _ in
                        // Optionally handle unreachable state.
                    }
                    do {
                        try reachability.startNotifier()
                    } catch {
                        print("Unable to start notifier: \(error)")
                    }
                } else {
                    // Network is available, post the device data immediately.
                    postAppDeviceData()
                }
    }
    private func stopReachabilityNotifier() {
           reachability?.stopNotifier()
       }
    // MARK: - Networking
        private func postAppDeviceData() {
            activityView.startAnimating()
            
            guard let bundleId = Bundle.main.bundleIdentifier else {
                activityView.stopAnimating()
                return
            }
            
            let hostUrl = uitimateMainHostUrl()
            let endpoint = "https://open.mag\(hostUrl)/open/uitimatePostAppDeviceData"
            
            guard let url = URL(string: endpoint) else {
                print("Invalid URL: \(endpoint)")
                activityView.stopAnimating()
                return
          }
            var request = URLRequest(url: url)
               request.httpMethod = "POST"
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
               
               let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
               let parameters: [String: Any] = [
                   "appKey": "e4ff22b1744f41058fe7702afd23b2bd",
                   "appPackageId": bundleId,
                   "appVersion": appVersion
               ]
               
               do {
                   request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
               } catch {
                   print("Failed to serialize JSON:", error)
                   activityView.stopAnimating()
                   return
               }
               
               let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                   DispatchQueue.main.async {
                       self?.handlePostResponse(data: data, error: error)
                   }
               }
               task.resume()
    }
    private func handlePostResponse(data: Data?, error: Error?) {
           defer { activityView.stopAnimating() }
           
           guard let data = data, error == nil else {
               print("Request error:", error ?? "Unknown error")
               return
           }
           
           do {
               let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
               guard let resDic = jsonResponse as? [String: Any],
                     let dataDictionary = resDic["data"] as? [String: Any],
                     let adsData = dataDictionary["jsonObject"] as? [String],
                     !adsData.isEmpty else {
                   return
               }
               // Save ads data and show the ad view
               UserDefaults.standard.set(adsData, forKey: "ADSdatas")
               uitimateShowAdVsiew(adsData[0])
           } catch {
               print("Error parsing JSON response:", error)
           }
       }


}

