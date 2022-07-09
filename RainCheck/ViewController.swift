//
//  ViewController.swift
//  RainCheck
//
//  Created by Николай Никитин on 06.07.2022.
//

import UIKit
import CoreLocation

struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let currently: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
    let offset: Float
}

struct CurrentWeather: Codable {
    let time: Int
    let summary: String
    let icon: String
    let nearestStormDistance: Int?
    let nearestStormBearing: Int?
    let precipIntensity: Double
    let precipProbability: Double
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}

struct DailyWeather: Codable {
    let summary: String
    let icon: String
    let data: [DailyWeatherEntry]
}

struct DailyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let sunriseTime: Int
    let sunsetTime: Int
    let moonPhase: Double
    let precipIntensity: Double
    let precipIntensityMax: Double
    let precipIntensityMaxTime: Int?
    let precipProbability: Double
    let precipType: String?
    let temperatureHigh: Double
    let temperatureHighTime: Int
    let temperatureLow: Double
    let temperatureLowTime: Int
    let apparentTemperatureHigh: Double
    let apparentTemperatureHighTime: Int
    let apparentTemperatureLow: Double
    let apparentTemperatureLowTime: Int
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windGustTime: Int
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let uvIndexTime: Int
    let visibility: Double
    let ozone: Double
    let temperatureMin: Double
    let temperatureMinTime: Int
    let temperatureMax: Double
    let temperatureMaxTime: Int
    let apparentTemperatureMin: Double
    let apparentTemperatureMinTime: Int
    let apparentTemperatureMax: Double
    let apparentTemperatureMaxTime: Int
}

struct HourlyWeather: Codable {
    let summary: String
    let icon: String
    let data: [HourlyWeatherEntry]
}

struct HourlyWeatherEntry: Codable {
    let time: Int
    let summary: String
    let icon: String
    let precipIntensity: Float
    let precipProbability: Double
    let precipType: String?
    let temperature: Double
    let apparentTemperature: Double
    let dewPoint: Double
    let humidity: Double
    let pressure: Double
    let windSpeed: Double
    let windGust: Double
    let windBearing: Int
    let cloudCover: Double
    let uvIndex: Int
    let visibility: Double
    let ozone: Double
}

class ViewController: UIViewController {

  //MARK: - Properties
  var models = [DailyWeatherEntry]()
  let locationManager = CLLocationManager()
  var currentLocation: CLLocation?
  var currentWeather: CurrentWeather?

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
  func requestWeatherForLocation() {
    guard let currentLocation = currentLocation else { return }
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
      DispatchQueue.main.async {
        self.table.reloadData()
        self.table.tableHeaderView = self.createTableHeader()
      }
    }.resume()
  }

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
}

//MARK: - TableView Delegate & DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
    cell.configure(with: models[indexPath.row])
    cell.backgroundColor = UIColor(red: 162/255.0, green: 217/255.0, blue: 245/255.0, alpha: 1.0)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }

}

