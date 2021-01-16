//
//  Storyboard.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/16/21.
//

import Foundation

enum Storyboard: StoryboardInstanceType {
    
    case main

    var name: String {
        switch self {
        case .main: return "Main"
        }
    }
}
