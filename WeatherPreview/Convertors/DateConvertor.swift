//
//  DateConvertor.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import Foundation

class DateConvertor {
    class func convertTimeIntervaleToDate(_ interval: Int) -> Date {
        let timeInterval = TimeInterval(interval)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
}
