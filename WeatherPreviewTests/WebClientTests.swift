//
//  WebClientTests.swift
//  WeatherPreviewTests
//
//  Created by Tigran Simonyan on 1/16/21.
//

import XCTest
import CoreLocation

@testable import WeatherPreview

class WebClientTests: XCTestCase {
    
    private var sut: WebClientManager!
    private let location = CLLocation(latitude: 40.18393833042108, longitude: 44.514135413751)
    override func setUp() {
        sut = WebClientManager()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testDefineTrainingProgram() {
        let promise = expectation(description: "Completion handler invoked")
        var responseError: Error?
        var response: WeatherResponse?
        
        sut.loadWeather(for: location) { (resp, error) in
            responseError = error
            response = resp
            
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError, "Occured error during progrsm request")
        XCTAssertNotNil(response, "Response is nil")
    }
}
