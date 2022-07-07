//
//  ViewController.swift
//  RainCheck
//
//  Created by Николай Никитин on 06.07.2022.
//

import UIKit

struct Weather {

}

class ViewController: UIViewController {

  @IBOutlet private weak var table: UITableView!

  var models = [Weather]()

  override func viewDidLoad() {
    super.viewDidLoad()
    table.delegate = self
    table.dataSource = self
  }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return UITableViewCell()
  }


}

