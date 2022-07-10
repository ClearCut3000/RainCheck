//
//  ViewController.swift
//  RainCheck
//
//  Created by Николай Никитин on 06.07.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

  //MARK: - Properties
  var models = [DailyWeatherEntry]()
  let locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var currentWeather: CurrentWeather?
  var hourlyModels = [HourlyWeatherEntry]()
  var currentPlacemark: CLPlacemark?

  //MARK: - Outlets
  @IBOutlet private weak var table: UITableView!

  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    table.register(HourlyTableViewCell.nib(), forCellReuseIdentifier: HourlyTableViewCell.identifier)
    table.register(WeatherTableViewCell.nib(), forCellReuseIdentifier: WeatherTableViewCell.identifier)
    table.delegate = self
    table.dataSource = self
    table.backgroundColor = UIColor(red: 162/255.0, green: 217/255.0, blue: 245/255.0, alpha: 1.0)
    view.backgroundColor = UIColor(red: 162/255.0, green: 217/255.0, blue: 245/255.0, alpha: 1.0)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setupLocation()
  }

  //MARK: - Methods
  /// API-call method
  func requestWeatherForLocation() {
    guard let currentLocation = currentLocation else { return }
    nameCurrentLocation(with: currentLocation)
    let longitude = currentLocation.coordinate.longitude
    let latitude = currentLocation.coordinate.latitude
    print("longitude: \(longitude)| latitude: \(latitude)")
    let url = "https://api.darksky.net/forecast/ddcc4ebb2a7c9930b90d9e59bda0ba7a/\(latitude),\(longitude)?&units=si&exclude=[flags,minutely]"
    URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
      guard let data = data, error == nil else {
        print("Failed to get data witout error's - \(String(describing: error))")
        return
      }
      var json: WeatherResponse?
      do {
        json = try JSONDecoder().decode(WeatherResponse.self, from: data)
      } catch {
        print("Decoding error - \(error)")
      }
      guard let result = json else { return }
      let entries = result.daily.data
      self.models.append(contentsOf: entries)
      let current = result.currently
      self.currentWeather = current
      self.hourlyModels = result.hourly.data
      DispatchQueue.main.async {
        self.table.reloadData()
        self.table.tableHeaderView = self.createTableHeader()
      }
    }.resume()
  }

  /// Method for creating table header view
  private func createTableHeader() -> UIView {
    let headerView = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.frame.size.width,
                                          height: view.frame.size.width))
    headerView.backgroundColor = UIColor(red: 162/255.0, green: 217/255.0, blue: 245/255.0, alpha: 1.0)
    let locationLabel = UILabel(frame: CGRect(x: 10,
                                              y: 10,
                                              width: view.frame.size.width - 20,
                                              height: headerView.frame.size.height / 5))
    let summaryLabel = UILabel(frame: CGRect(x: 10,
                                             y: 20 + locationLabel.frame.size.height,
                                             width: view.frame.size.width - 20,
                                             height: headerView.frame.size.height / 5))
    let temperatureLabel = UILabel(frame: CGRect(x: 10,
                                                 y: 20 + locationLabel.frame.size.height + summaryLabel.frame.size.height,
                                                 width: view.frame.size.width - 20,
                                                 height: headerView.frame.size.height / 2))

    headerView.addSubview(locationLabel)
    headerView.addSubview(summaryLabel)
    headerView.addSubview(temperatureLabel)

    locationLabel.textAlignment = .center
    summaryLabel.textAlignment = .center
    temperatureLabel.textAlignment = .center
    temperatureLabel.font = UIFont(name: "Helvetica-Bold", size: 32)

    guard let currentWeather = self.currentWeather else { return UIView() }
    temperatureLabel.text = "\(currentWeather.temperature)°"
    summaryLabel.text = currentWeather.summary

    locationLabel.numberOfLines = 2
    locationLabel.font = UIFont(name: "Helvetica-Bold", size: 30)
    if let country = currentPlacemark?.country,
       let locality = currentPlacemark?.locality {
      DispatchQueue.main.async {
        locationLabel.text =  "\(country) \n\(locality)"
      }
    }
    return headerView
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

  func nameCurrentLocation(with location: CLLocation) {
    let geoCoder = CLGeocoder()
    geoCoder.reverseGeocodeLocation(location) { placemarks, error in
      guard let placemarks = placemarks, error == nil else { return }
      print("Get current placemark!")
      self.currentPlacemark = placemarks[0]
    }
  }
}

//MARK: - TableView Delegate & DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      // one ell that is collectionTableViewCell
      return 1
    }
    return models.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
      cell.configure(with: hourlyModels)
      cell.backgroundColor = UIColor(red: 162/255.0, green: 217/255.0, blue: 245/255.0, alpha: 1.0)
      return cell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
    cell.configure(with: models[indexPath.row])
    cell.backgroundColor = UIColor(red: 162/255.0, green: 217/255.0, blue: 245/255.0, alpha: 1.0)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

}

