//
//  WeatherCollectionViewCell.swift
//  RainCheck
//
//  Created by Николай Никитин on 10.07.2022.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

  //MARK: - Properties
  static let identifier = "WeatherCollectionViewCell"

  //MARK: - Outlets
  @IBOutlet private weak var iconImageView: UIImageView!
  @IBOutlet private weak var temperatureLabel: UILabel!

  //MARK: - Methods
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  static func nib() -> UINib {
    return UINib(nibName: "WeatherCollectionViewCell", bundle: nil)
  }

  func configure(with model: HourlyWeatherEntry) {
    self.temperatureLabel.text = "\(model.temperature)"
    self.iconImageView.contentMode = .scaleAspectFit
    self.iconImageView.image = UIImage(named: "clear")
  }
}
