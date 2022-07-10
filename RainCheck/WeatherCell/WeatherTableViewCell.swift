//
//  WeatherTableViewCell.swift
//  RainCheck
//
//  Created by Николай Никитин on 06.07.2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

  //MARK: - Properties
  static let identifier = "WeatherTableViewCell"

  //MARK: - Outlets
  @IBOutlet private weak var dayLabel: UILabel!
  @IBOutlet private weak var highTemperatureLabel: UILabel!
  @IBOutlet private weak var lowTemperatureLabel: UILabel!
  @IBOutlet private weak var iconImageView: UIImageView!

  //MARK: - Methods
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  static func nib() -> UINib {
    return UINib(nibName: "WeatherTableViewCell", bundle: nil)
  }

  func configure(with model: DailyWeatherEntry) {
    self.lowTemperatureLabel.text = "\(Int(model.temperatureLow))°"
    self.highTemperatureLabel.text = "\(Int(model.temperatureHigh))°"
    self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.time)))
    self.iconImageView.contentMode = .scaleAspectFit
    let icon = model.icon.lowercased()
    if icon.contains("clear") {
      self.iconImageView.image = UIImage(named: "clear")
    } else if icon.contains("rain") {
      self.iconImageView.image = UIImage(named: "rain")
    } else {
      self.iconImageView.image = UIImage(named: "cloud")
    }
  }

  func getDayForDate(_ date: Date?) -> String {
    guard let inputDate = date else { return ""}
    let formatter = DateFormatter()
    formatter.locale = .current
    formatter.dateFormat = "EEE, MMM d, ''yy"
    return formatter.string(from: inputDate)
  }

}
