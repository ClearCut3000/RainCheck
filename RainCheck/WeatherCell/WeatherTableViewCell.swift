//
//  WeatherTableViewCell.swift
//  RainCheck
//
//  Created by Николай Никитин on 06.07.2022.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

  static let identifier = "WeatherTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

  static func nib() -> UINib {
    return UINib(nibName: "WeatherTableViewCell", bundle: nil)
  }
    
}
