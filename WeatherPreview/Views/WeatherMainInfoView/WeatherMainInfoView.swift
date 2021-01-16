//
//  WeatherMainInfoView.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherMainInfoView: UIView {
    
    var viewModel = WeatherMainInfoViewModel() {
        didSet {
            bind()
        }
    }

    private let disposeBag = DisposeBag()
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var weatherInfoLabel: UILabel!
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("WeatherMainInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    //MARK: - Binding
    private func bind() {
        viewModel.weatherResponse.bind { [ unowned self ] _ in
            cityNameLabel.text = viewModel.prepareCity()
            weatherInfoLabel.text = viewModel.prepareWeatherInfo()
            if let path = viewModel.prepareWeatherIconPath() {
                weatherIconImageView.loadImage(path: path)
            }
        }.disposed(by: disposeBag)
    }
}
