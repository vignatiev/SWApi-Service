//
//  DetailsViewController.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 24.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {
  @IBOutlet private var tableView: UITableView!
  
  private var rowItems = [DetailsViewModelRowItem]()
  
  private var viewModel: DetailsViewModelAdapter?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = LocalizedString.detailsTitle
    configureTableView()
    tableView.reloadData()
  }
  
  private func configureTableView() {
    tableView.register(DetailsTableViewCell.self)
    tableView.separatorStyle = .none
    tableView.delaysContentTouches = false
  }
  
  func configureWith(viewModel: DetailsViewModelAdapter) {
    self.viewModel = viewModel
    rowItems = viewModel.rowItems
  }
}

// MARK: - UITableViewDataSource

extension DetailsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rowItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let rowItem = rowItems[unsafeIndex: indexPath.row] else { return UITableViewCell() }
    let cell: DetailsTableViewCell = tableView.dequeue(forIndexPath: indexPath)
    
    switch rowItem {
    case let .header(title):
      cell.configureTitle(title)
    case let .attribute(title, value):
      cell.configureTitle(title, withValue: value)
    case let .linkedAttribute(title):
      cell.configureLinkedAttribute(value: title)
    }
    
    return cell
  }
}

// MARK: - UITableViewDelegate

extension DetailsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let rowItem = rowItems[unsafeIndex: indexPath.row] else { return }
    
    switch rowItem {
    case .linkedAttribute: tableView.deselectRow(at: indexPath, animated: true)
    default: tableView.deselectRow(at: indexPath, animated: false)
    }
    
    viewModel?.didSelectRowAt(index: indexPath)
  }
}

extension DetailsViewController {
  private func makeAlertError(title: String?, message: String) -> UIAlertController {
    let alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
    let okAction = UIAlertAction(title: LocalizedString.okButtonTitle, style: .default, handler: nil)
    alertController.addAction(okAction)
    return alertController
  }
  
  private func showErrorAlert(title: String?, message: String) {
    let controller = makeAlertError(title: title, message: message)
    present(controller, animated: true, completion: nil)
  }
}

// MARK: - StoryboardInstantiatable

extension DetailsViewController: StoryboardInstantiatable {
  static var storyboardName: String {
    return StoryboardName.main.description
  }
}

// MARK: DetailsConfigurable

protocol DetailsConfigurable: AnyObject {
  func configureWith(person: Person)
  func configureWith(planet: Planet)
}

extension DetailsViewController: DetailsConfigurable {
  func configureWith(person: Person) {
    let viewModel = PersonViewModelAdapter(model: person)
    viewModel.delegate = self
    configureWith(viewModel: viewModel)
  }
  
  func configureWith(planet: Planet) {
    let viewModel = PlanetViewModelAdapter(model: planet)
    viewModel.delegate = self
    configureWith(viewModel: viewModel)
  }
}

//
protocol DetailsViewModelAdapterDelegate: DetailsConfigurable {
  func openNewScreenWith(person: Person)
  func openNewScreenWith(planet: Planet)
  func showError(error: ApiError)
}

extension DetailsViewController: DetailsViewModelAdapterDelegate {
  func openNewScreenWith(person: Person) {
    let newViewController = DetailsViewController.instantiateFromStoryboard()
    newViewController.configureWith(person: person)
    navigationController?.pushViewController(newViewController, animated: true)
  }
  
  func openNewScreenWith(planet: Planet) {
    let newViewController = DetailsViewController.instantiateFromStoryboard()
    newViewController.configureWith(planet: planet)
    navigationController?.pushViewController(newViewController, animated: true)
  }
  
  func showError(error: ApiError) {
    showErrorAlert(title: nil, message: error.errorDescription)
  }
}
