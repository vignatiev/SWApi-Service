//
//  PersonDetailsViewController.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class PersonDetailsViewController: UIViewController {
  
  @IBOutlet private var tableView: UITableView!
  
  private var rowItems = [RowItem]()
  
  private func configureWith(rowItems: [RowItem]) {
    self.rowItems = rowItems
     tableView.reloadData()
  }
  
  private enum RowItem {
    case header(String)
    // case subHeader(String) если надо
    case attribute(title: String, value: String) // например Цвет глаз: зеленый
    case linkedAtrribute(title: String, value: String) /* например Мир: Tatooine (во view отображается другим цветом
     или у ячейки disclosureIndicator.) */
  }
  
}

// MARK: - UITableViewDataSource
extension PersonDetailsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let rowItem = rowItems[unsafeIndex: indexPath.row] else { return UITableViewCell() }
    
    switch rowItem {
    case let .header(title): return UITableViewCell()
    case let .attribute(title, value): return UITableViewCell()
    case let .linkedAtrribute(title, value): return UITableViewCell()
    }
    
  }
  
}

extension PersonDetailsViewController {
  
  func configureWith(person: Person) {
    let rowItems: [RowItem] = [
      .attribute(title: "Name", value: person.name),
      .attribute(title: "Height", value: String(person.height)),
      .attribute(title: "Mass", value: person.mass),
      .attribute(title: "HairColor", value: person.hairColor),
      .attribute(title: "SkinColor", value: person.skinColor),
      .attribute(title: "EyeColor", value: person.eyeColor),
      .attribute(title: "BirthYear", value: person.birthYear),
      .attribute(title: "Gender", value: person.gender)
      // .linkedAtrribute(title: "Homeworld", value:)
    ]
    
    configureWith(rowItems: rowItems)
  }
  
}

// MARK: - StoryboardInstantiatable
extension PersonDetailsViewController: StoryboardInstantiatable {
  
  static var storyboardName: String {
    return StoryboardNamed.main.description
  }
  
}
