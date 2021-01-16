//
//  Date+Time.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/16/21.
//

import Foundation

extension Date {
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let time = dateFormatter.string(from: self)
        return time
    }
}
