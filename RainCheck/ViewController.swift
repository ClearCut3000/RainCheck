//
//  ViewController.swift
//  RainCheck
//
//  Created by Николай Никитин on 06.07.2022.
//

import UIKit
import CoreLocation

struct Weather {

}

class ViewController: UIViewController {

  //MARK: - Properties
  var models = [Weather]()
  let locationManager = CLLocationManager()
  var currentLocation: CLLocation?

  //MARK: - Outlets
  @IBOutlet private weak var table: UITableView!

//MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
    table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
    table.delegate = self
    table.dataSource = self
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupLocation()
  }

  //MARK: - Methods
  func requestWeatherForLocation() {
    guard let currentLocation = currentLocation else { return }
    let longitude = currentLocation.coordinate.longitude
    let latitude = currentLocation.coordinate.latitude
    let url = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/37.8267,-122.4233?exclude=[flags,minutely]"
    print("longitude: \(longitude)| latitude: \(latitude)")
  }
}

//MARK: - Location Management
extension ViewController: CLLocationManagerDelegate {
  func setupLocation() {
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if !locations.isEmpty, currentLocation == nil {
      currentLocation = locations.first
      locationManager.stopUpdatingLocation()
      requestWeatherForLocation()
    }
  }


}

//MARK: - TableView Delegate & DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }


}

