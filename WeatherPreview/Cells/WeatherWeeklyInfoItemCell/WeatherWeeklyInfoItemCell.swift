//
//  WeatherWeeklyInfoItemCell.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import UIKit

class WeatherWeeklyInfoItemCell: TableViewCell<WeatherWeeklyInfoItemCellViewModel> {

    @IBOutlet private weak var weekdayLabel: UILabel!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func bind(viewModel: WeatherWeeklyInfoItemCellViewModel) {
        viewModel.day.map { $0.weekdayName }.bind(to: weekdayLabel.rx.text).disposed(by: reusableDisposeBag)
        viewModel.minTemp.map { "\($0)" }.bind(to: minTemperatureLabel.rx.text).disposed(by: reusableDisposeBag)
        viewModel.maxTemp.map { "\($0)" }.bind(to: maxTemperatureLabel.rx.text).disposed(by: reusableDisposeBag)
        super.bind(viewModel: viewModel)
    }
}

private extension Date {
    var weekdayName: String {
        let weekday = Calendar.current.component(.weekday, from: self)
        let formatter = DateFormatter()
        let name = formatter.weekdaySymbols[weekday - 1]
        return name
    }
}
