//
//  WeatherTableViewCell.swift
//  RainCheck
//
//  Created by Николай Никитин on 06.07.2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

  static let identifier = "WeatherTableViewCell"

  @IBOutlet private weak var dayLabel: UILabel!
  @IBOutlet private weak var highTemperatureLabel: UILabel!
  @IBOutlet private weak var lowTemperatureLabel: UILabel!
  @IBOutlet private weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
      backgroundColor = .gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

  static func nib() -> UINib {
    return UINib(nibName: "WeatherTableViewCell", bundle: nil)
  }

  func configure(with model: DailyWeatherEntry) {
    self.lowTemperatureLabel.text = "\(Int(model.temperatureLow))°"
    self.lowTemperatureLabel.text = "\(Int(model.temperatureHigh))°"
    self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.time)))
    self.iconImageView.image = UIImage(named: "clear")
  }

  func getDayForDate(_ date: Date?) -> String {
    guard let inputDate = date else { return ""}
    let formatter = DateFormatter()
    formatter.dateFormat = "ddd"
    return formatter.string(from: inputDate)
  }
    
}
