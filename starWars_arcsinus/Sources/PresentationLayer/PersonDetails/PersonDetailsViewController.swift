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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(PersonDetailsTableViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
  }
  
  private func configureWith(rowItems: [RowItem]) {
    self.rowItems = rowItems
  }
  
  private enum RowItem {
    case header(String)
    case attribute(title: String, value: String)
  }
  
}

extension PersonDetailsViewController {
  
  func configureWith(person: Person) {
    let rowItems: [RowItem] = [
      .attribute(title: LocalizedString.name, value: person.name.uppercased()),
      .attribute(title: LocalizedString.height, value: String(person.height)),
      .attribute(title: LocalizedString.mass, value: person.mass),
      .attribute(title: LocalizedString.hairColor, value: person.hairColor.capitalized),
      .attribute(title: LocalizedString.skinColor, value: person.skinColor.capitalized),
      .attribute(title: LocalizedString.eyeColor, value: person.eyeColor.capitalized),
      .attribute(title: LocalizedString.birthYear, value: person.birthYear.uppercased()),
      .attribute(title: LocalizedString.gender, value: person.gender.capitalized)
    ]
    
    configureWith(rowItems: rowItems)
  }
  
}

// MARK: - UITableViewDataSource
extension PersonDetailsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rowItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let rowItem = rowItems[unsafeIndex: indexPath.row] else { return UITableViewCell() }
    let cell: PersonDetailsTableViewCell = tableView.dequeue(forIndexPath: indexPath)
    
    switch rowItem {
    case let .header(title): cell.configureTitle(title)
    case let .attribute(title, value): cell.configureTitle(title, withValue: value)
    }
    
    return cell
  }
  
}

// MARK: - UITableViewDelegate
extension PersonDetailsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
}

// MARK: - StoryboardInstantiatable
extension PersonDetailsViewController: StoryboardInstantiatable {
  
  static var storyboardName: String {
    return StoryboardName.main.description
  }
  
}
