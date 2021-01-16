//
//  WeatherGeneralInfoItemCell.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import UIKit

class WeatherGeneralInfoItemCell: TableViewCell<WeatherGeneralInfoItemCellViewModel> {

    @IBOutlet private weak var topLabel: UILabel!
    @IBOutlet private weak var bottomLabel: UILabel!
    @IBOutlet private weak var stackViewBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func bind(viewModel: WeatherGeneralInfoItemCellViewModel) {
        viewModel.presentationInfo.bind { [unowned self ] (presentationInfo) in
            topLabel.text = presentationInfo.topText
            bottomLabel.text = presentationInfo.bottomText
            if presentationInfo.hasBottomOffset {
                stackViewBottomConstraint.constant = 15
            }
        }.disposed(by: reusableDisposeBag)
        
        super.bind(viewModel: viewModel)
    }

    
}
