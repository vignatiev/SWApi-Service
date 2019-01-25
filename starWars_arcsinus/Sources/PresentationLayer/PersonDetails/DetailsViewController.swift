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
  
  private var rowItems = [RowItem]()
  
  private var viewModel: DetailsViewModelAdapter?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = LocalizedString.detailsTitle
    configureTableView()
  }
  
  private func configureTableView() {
    tableView.register(DetailsTableViewCell.self)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    tableView.delaysContentTouches = false
  }
  
  func configureWith(viewModel: DetailsViewModelAdapter) {
    loadViewIfNeeded()
    
    self.viewModel = viewModel
    self.rowItems = viewModel.rowItems
    
    tableView.reloadData()
  }
  
  enum RowItem {
    case header(String)
    case attribute(title: String, value: String)
    case linkedAttribute(title: String)
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
    case let .header(title): cell.configureTitle(title)
    case let .attribute(title, value): cell.configureTitle(title, withValue: value)
    case let .linkedAttribute(title): cell.configureLinkedAttribute(value: title)
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
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
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

// MARK: - Adapters
protocol DetailsViewModelAdapter {
  
  var delegate: DetailsViewModelAdapterDelegate? { get set }
  var rowItems: [DetailsViewController.RowItem] { get }
  
  func didSelectRowAt(index: IndexPath)
  
}

final class PersonViewModelAdapter: DetailsViewModelAdapter {
  typealias Model = Person
  
  private let searchService = SearchService.shared
  private let person: Person
  
  weak var delegate: DetailsViewModelAdapterDelegate?
  let rowItems: [DetailsViewController.RowItem]
  
  init(model: Person) {
    let rowItems: [DetailsViewController.RowItem] = [
      .attribute(title: LocalizedString.name, value: model.name.uppercased()),
      .attribute(title: LocalizedString.height, value: String(model.height)),
      .attribute(title: LocalizedString.mass, value: model.mass),
      .attribute(title: LocalizedString.hairColor, value: model.hairColor.capitalized),
      .attribute(title: LocalizedString.skinColor, value: model.skinColor.capitalized),
      .attribute(title: LocalizedString.eyeColor, value: model.eyeColor.capitalized),
      .attribute(title: LocalizedString.birthYear, value: model.birthYear.uppercased()),
      .attribute(title: LocalizedString.gender, value: model.gender.capitalized),
      .linkedAttribute(title: LocalizedString.homeworld)
    ]
    
    self.rowItems = rowItems
    self.person = model
  }
  
  func didSelectRowAt(index: IndexPath) {
    switch index.row {
    case 8:
      searchService.getPlanet(withUrl: person.homeWorldURL) { [weak self] result in
        switch result {
        case .success(let planet):
          self?.delegate?.openNewScreenWith(planet: planet)
        case .failure(let error):
          self?.delegate?.showError(error: error)
        }
      }
    default: break
    }
  }
  
}

final class PlanetViewModelAdapter: DetailsViewModelAdapter {
  
  typealias Model = Planet
  
  weak var delegate: DetailsViewModelAdapterDelegate?
  let rowItems: [DetailsViewController.RowItem]
  
  init(model: Planet) {
    let rowItems: [DetailsViewController.RowItem] = [
      .attribute(title: LocalizedString.name, value: model.name.uppercased()),
      .attribute(title: LocalizedString.rotationPeriod, value: model.rotationPeriod.uppercased()),
      .attribute(title: LocalizedString.orbitalPeriod, value: model.orbitalPeriod.uppercased()),
      .attribute(title: LocalizedString.diameter, value: model.diameter.uppercased()),
      .attribute(title: LocalizedString.climate, value: model.climate.uppercased()),
      .attribute(title: LocalizedString.gravity, value: model.gravity.uppercased()),
      .attribute(title: LocalizedString.terrain, value: model.terrain.uppercased()),
      .attribute(title: LocalizedString.surfaceWater, value: model.surfaceWater.uppercased()),
      .attribute(title: LocalizedString.population, value: model.population.uppercased())
    ]
    
    self.rowItems = rowItems
  }
  
  func didSelectRowAt(index: IndexPath) {
  }
  
}
