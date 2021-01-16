//
//  WeatherViewController.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import UIKit

class WeatherViewController: ViewController<WeatherViewModel> {

    lazy var weeklyInfoDataSource = DataSourceCreator.reloadTableViewDataSource(WeatherWeeklyInfoItemCell.self)
    lazy var generalInfoDataSource = DataSourceCreator.reloadTableViewDataSource(WeatherGeneralInfoItemCell.self)

    @IBOutlet private weak var mainInfoView: WeatherMainInfoView!
    @IBOutlet private weak var weeklyInfoTableView: UITableView!
    @IBOutlet private weak var generalInfoTableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet private weak var weeklyInfoTableViewHeightContraint: NSLayoutConstraint!
    @IBOutlet private weak var generalInfoTableViewHeightContraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.prepareWeatherInfo()
        configureNavigationBarUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTableViewHeight()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateTableViewHeight()
    }
    
    private func configureNavigationBarUI() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .brandNavigationBar
        navigationController?.navigationBar.titleTextAttributes  = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func updateTableViewHeight() {
        weeklyInfoTableViewHeightContraint.constant = weeklyInfoTableView.contentSize.height
        generalInfoTableViewHeightContraint.constant = generalInfoTableView.contentSize.height
        view.layoutIfNeeded()
    }
    
    // MARK: - Binding
    override func bind(viewModel: WeatherViewModel) {
        super.bind(viewModel: viewModel)
        bindActivityIndicator()
        bindMainView()
        bindWeeklyInfoTableView()
        bindGeneralInfoTableView()
    }
    
    private func bindActivityIndicator() {
        viewModel.weatherResponse
            .map { $0 == nil }
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func bindMainView() {
        viewModel.mainInfoViewModel.bind { [unowned self] (mainInfoViewModel) in
            if let viewModel = mainInfoViewModel {
                mainInfoView.viewModel = viewModel
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindWeeklyInfoTableView() {
        viewModel.weeklyInfosViewModels
            .bind(to: weeklyInfoTableView.rx.items(dataSource: weeklyInfoDataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindGeneralInfoTableView() {
        viewModel.generalInfosViewModels
            .bind(to: generalInfoTableView.rx.items(dataSource: generalInfoDataSource))
            .disposed(by: disposeBag)
    }
    
    private func bindLocationError() {
        viewModel.locationError.bind { [ unowned self ] error in
            switch error {
            case .missingAuthorization:
                showAuthorizationAlert()
            case .other(_):
                showAlertMessage(with: "Failed to determinate your current location.\nYour data can be outdated")
            }
        }.disposed(by: disposeBag)
    }
    
    private func showAuthorizationAlert() {
        let alertController = UIAlertController(title: "Location Authorization Failed",
                                                message: "Please enable your location settings.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let openAction = UIAlertAction(title: "Open", style: .default) { [ unowned self ]_ in
            openSettings()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(openAction)

        present(alertController, animated: true, completion: nil)
    }
    
    private func openSettings() {
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    private func bindWeatherFetchingError() {
        viewModel.weatherFetchingError.bind { [ unowned self] _ in
            showAlertMessage(with: "Weather info fetching failed.\nYour data can be outdated")
        }.disposed(by: disposeBag)
    }
}
