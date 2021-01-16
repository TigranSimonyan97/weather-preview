//
//  WeatherViewModel.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import CoreLocation

typealias WeeklyInfoViewModelType = [SectionModel<String, WeatherWeeklyInfoItemCellViewModel>]
typealias GeneralInfoViewModelType = [SectionModel<String, WeatherGeneralInfoItemCellViewModel>]
class WeatherViewModel : ViewModel {
    let locationManager = LocationManager()
    let webClientManager = WebClientManager()
    
    let locationError = PublishSubject<LocationError>()
    let weatherFetchingError = PublishSubject<RequestError>()
    
    var weatherResponse = BehaviorRelay<WeatherResponse?>(value: nil)
    
    let mainInfoViewModel = BehaviorRelay<WeatherMainInfoViewModel?>(value: nil)
    let weeklyInfosViewModels : BehaviorRelay<WeeklyInfoViewModelType> = BehaviorRelay(value: [])
    let generalInfosViewModels : BehaviorRelay<GeneralInfoViewModelType> = BehaviorRelay(value: [])
    
    let storage = RealmStorage<WeatherResponseDataModel>()
    
    override func subscribe() {
        super.subscribe()
        locationManager.currentLocation.bind { [unowned self] (location) in
            guard let loc = location  else { return }
            fetchWeatherData(location: loc)
        }.disposed(by: disposeBag)
        
        weatherResponse.bind { [ weak self ] _ in
            DispatchQueue.main.async {
                self?.updatePresentationInfo()
            }
        }.disposed(by: disposeBag)
    }
    
    func prepareWeatherInfo() {
        do {
            try locationManager.determineCurrentLocation()
        } catch let error {
            let locationError = LocationError.map(error)
            self.locationError.onNext(locationError)
            prepareStoredData()
        }
    }
    
    private func fetchWeatherData(location: CLLocation) {
        webClientManager.loadWeather(for: location) { [weak self] (response, error) in
            if let err = error {
                self?.weatherFetchingError.onNext(err)
                
                return
            }
            if let response = response {
                self?.weatherResponse.accept(response)
                DispatchQueue.main.async {
                    self?.updateWeatherInfo(newInfo: response)
                }
            } else {
                DispatchQueue.main.async {
                    self?.prepareStoredData()
                    self?.weatherFetchingError.onNext(RequestError.emptyData)
                }
            }
        }
    }
    
    private func prepareStoredData() {
        let storedWeatherInfo = retrieveDataFromStorage()
        weatherResponse.accept(storedWeatherInfo)
    }
    
    private func updatePresentationInfo() {
        prepareMainInfoViewModel()
        prepareWeeklyInfoViewModels()
        prepareGeneralInfoViewModels()
    }
    
    private func prepareMainInfoViewModel() {
        guard let weatherResponse = self.weatherResponse.value else { return }
        let viewModel = WeatherMainInfoViewModel(weatherResponse: weatherResponse)
        mainInfoViewModel.accept(viewModel)
    }
    
    private func prepareWeeklyInfoViewModels() {
        guard let weatherResponse = self.weatherResponse.value else { return }
        
        let viewModels = weatherResponse.dailyWeather.map {WeatherWeeklyInfoItemCellViewModel(weatherInfo: $0) }
        let section = SectionModel(model: "Weekly Info", items: viewModels)
        weeklyInfosViewModels.accept([section])
    }
    
    private func prepareGeneralInfoViewModels() {
        var items = [WeatherGeneralInfoItemCellViewModel]()
        let sunriseAndSunset = configureSunriseAndSunset()
        let sunrisePresentationInfo = WeatherGeneralInfoItemPresentationInfo(topText: sunriseAndSunset.sunrise,
                                                                             bottomText: sunriseAndSunset.sunset)
        let sunriseViewModel = WeatherGeneralInfoItemCellViewModel(presentationInfo: sunrisePresentationInfo)
        items.append(sunriseViewModel)
        
        let cloudsAndWind = configureCloudsAndWind()
        let cloudPresentationInfo = WeatherGeneralInfoItemPresentationInfo(topText: cloudsAndWind.clouds,
                                                                           bottomText: cloudsAndWind.wind)
        let cloudViewModel = WeatherGeneralInfoItemCellViewModel(presentationInfo: cloudPresentationInfo)
        items.append(cloudViewModel)
        
        let humidityAndPressure = configureHumidityAndPressure()
        let humidityPresentationInfo = WeatherGeneralInfoItemPresentationInfo(topText: humidityAndPressure.humidity,
                                                                              bottomText: humidityAndPressure.pressure,
                                                                              hasBottomOffset: false)
        let humidityViewModel = WeatherGeneralInfoItemCellViewModel(presentationInfo: humidityPresentationInfo)
        items.append(humidityViewModel)
        
        let section = SectionModel(model: "General Info", items: items)
        generalInfosViewModels.accept([section])
    }
    
    private func configureSunriseAndSunset() -> (sunrise: String, sunset: String) {
        guard let weatherResponse = self.weatherResponse.value else { return ("", "")}
        let sunriseTimeInterval = weatherResponse.currentWeather.sunriseDate
        let sunriseDate = DateConvertor.convertTimeIntervaleToDate(sunriseTimeInterval)
        let sunriseTime = sunriseDate.time
        let sunrise = "Sunrise: \(sunriseTime)"
        
        let sunsetTimeInterval = weatherResponse.currentWeather.sunsetDate
        let sunsetDate = DateConvertor.convertTimeIntervaleToDate(sunsetTimeInterval)
        let sunsetTime = sunsetDate.time
        let sunset = "Sunset: \(sunsetTime)"
        return (sunrise, sunset)
    }
    
    private func configureCloudsAndWind() -> (clouds: String, wind: String) {
        guard let weatherResponse = self.weatherResponse.value else { return ("", "")}
        let cloudsPercent = weatherResponse.currentWeather.cloudsPercent
        let clouds = "Clouds: \(cloudsPercent)%"
        
        let windSpeed = weatherResponse.currentWeather.windSpeed
        let wind = "Wind speed: \(windSpeed)"
        return (clouds, wind)
    }
    
    private func configureHumidityAndPressure() -> (humidity: String, pressure: String) {
        guard let weatherResponse = self.weatherResponse.value else { return ("", "")}
        let humidityPercent = weatherResponse.currentWeather.humidity
        let humidity = "Humidity: \(humidityPercent)%"
        
        let pressure = weatherResponse.currentWeather.pressure
        let pressureText = "Pressure: \(pressure)hPa"
        return (humidity, pressureText)
    }
    
    //MARK: - Storage
    
    private func updateWeatherInfo(newInfo: WeatherResponse) {
        storage.removeAll()
        
        let weatherResponseDataModel = WeatherResponseDataModel(weatherResponse: newInfo)
        storage.insertEntity(weatherResponseDataModel)
    }
    
    private func retrieveDataFromStorage() -> WeatherResponse? {
        guard let dataModel = storage.getAll().first,
              let weatherResponse = WeatherResponse(weatherResponseDataModel: dataModel) else { return nil }
        
        return weatherResponse
    }
    
    deinit {
        print("WeatherViewModel deinited")
    }
}
