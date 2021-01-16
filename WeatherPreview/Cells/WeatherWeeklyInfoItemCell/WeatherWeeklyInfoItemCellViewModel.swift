//
//  WeatherWeeklyInfoItemCellViewModel.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherWeeklyInfoItemCellViewModel : ViewModel {
        
    let minTemp: BehaviorRelay<Int>
    let maxTemp: BehaviorRelay<Int>
    let day: BehaviorRelay<Date>
    init(weatherInfo: WeatherInfo) {
        let temperature = weatherInfo.temperature
        let minTemp = Int(temperature.min)
        let maxTemp = Int(temperature.max)
        let day = DateConvertor.convertTimeIntervaleToDate(weatherInfo.date)
        
        self.minTemp = BehaviorRelay(value: minTemp)
        self.maxTemp = BehaviorRelay(value: maxTemp)
        self.day = BehaviorRelay(value: day)
    }
}
