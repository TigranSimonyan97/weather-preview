//
//  WeatherGeneralInfoItemCellViewModel.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherGeneralInfoItemPresentationInfo {
    let topText: String
    let bottomText: String
    let hasBottomOffset: Bool
    
    init(topText: String, bottomText: String, hasBottomOffset: Bool = true) {
        self.topText = topText
        self.bottomText = bottomText
        self.hasBottomOffset = hasBottomOffset
    }
}

class WeatherGeneralInfoItemCellViewModel: ViewModel {
    let presentationInfo: BehaviorRelay<WeatherGeneralInfoItemPresentationInfo>
    
    init(presentationInfo: WeatherGeneralInfoItemPresentationInfo) {
        self.presentationInfo = BehaviorRelay(value: presentationInfo)
    }
}
