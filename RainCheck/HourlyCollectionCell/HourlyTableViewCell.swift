//
//  HourlyTableViewCell.swift
//  RainCheck
//
//  Created by Николай Никитин on 06.07.2022.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

  //MARK: - Properties
  static let identifier = "HourlyTableViewCell"
  var models = [HourlyWeatherEntry]()

  //MARK: - Outlets
  @IBOutlet private weak var collectionView: UICollectionView!

  //MARK: - Methods
  override func awakeFromNib() {
    super.awakeFromNib()
    collectionView.register(WeatherCollectionViewCell.nib(), forCellWithReuseIdentifier: WeatherCollectionViewCell.identifier)
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  static func nib() -> UINib {
    return UINib(nibName: "HourlyTableViewCell", bundle: nil)
  }

  func configure(with models: [HourlyWeatherEntry]) {
    self.models = models
    collectionView.reloadData()
  }
}

//MARK: - CollectionView Protocols
extension HourlyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return models.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.identifier, for: indexPath) as! WeatherCollectionViewCell
    cell.configure(with: models[indexPath.row])
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: 100)
  }
}

