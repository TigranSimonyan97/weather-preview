//
//  AppDelegate.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupNavigator()

        return true
    }
    
    private func setupNavigator() {
        Navigator.set(window: &window)
        let viewModel = WeatherViewModel()
        Navigator(Storyboard.main).root(WeatherViewController.self,
                                        viewModel: viewModel)
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

