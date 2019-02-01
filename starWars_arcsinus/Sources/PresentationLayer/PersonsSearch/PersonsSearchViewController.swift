//
//  PersonsSearchViewController.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 19.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class PersonsSearchViewController: UIViewController {
  
  @IBOutlet private var collectionView: UICollectionView!
  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var pageControl: UIPageControl!
  @IBOutlet private var dataSourceLabel: UILabel!
  
  private let typeToSearchView = TypeToSearchView.loadFromNib()
  private let emptyResultView = EmptyResultView.loadFromNib()
  
  private var viewModel: AnyObject?
  
  private let didSelectPerson = PublishRelay<Int>()
  private let disposeBag = DisposeBag()
  
  private var persons: [PersonsSearchViewModel.PersonViewModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureUI()
    
    let model = PersonsSearchModel(personsStorage: PersonsLocalStorage.shared)
    let viewModel = PersonsSearchViewModel(model: model)
    
    configureWith(viewModel: viewModel)
  }
  
  func configureWith(viewModel: PersonsSearchViewModel) {
    self.viewModel = viewModel
    
    bindViewWith(viewModel: viewModel)
    bindWith(moduleOutput: viewModel)
  }
  
  private func bindViewWith<V>(viewModel: V)
    where V: ViewModelType, V.Input == PersonsSearchViewModel.Input, V.Output == PersonsSearchViewModel.Output {
      
      let searchText = searchBar.rx.text.asObservable().filterNil()
      let input = PersonsSearchViewModel.Input(searchText: searchText,
                                               itemWasSelected: didSelectPerson.asObservable())
      let output = viewModel.transform(input: input)
      
      output.persons
        .drive(onNext: { [weak self] persons in
          
          self?.pageControl.numberOfPages = persons.count
          self?.persons = persons
          self?.collectionView.reloadData()
        })
        .disposed(by: disposeBag)
      
      output.typeToSearchViewVisible.drive(typeToSearchView.rx.isVisible).disposed(by: disposeBag)
      output.collectionViewVisivble.drive(collectionView.rx.isVisible).disposed(by: disposeBag)
      output.pageControlVisivble.drive(pageControl.rx.isVisible).disposed(by: disposeBag)
      
      output.isEmptyResultViewVisible.drive(emptyResultView.rx.isVisible).disposed(by: disposeBag)
      
      output.isDataSourceLabelVisible.drive(dataSourceLabel.rx.isVisible).disposed(by: disposeBag)
      output.dataSource.drive(dataSourceLabel.rx.text).disposed(by: disposeBag)
      
      output.hideKeyboardAfterSearch.emit(onNext: { [weak self] in
        self?.hideKeyboard()
      }).disposed(by: disposeBag)
      
      output.showNetworkError.emit(onNext: { message in
        self.showErrorAlert(title: nil, message: message)
      }).disposed(by: disposeBag)
  }
  
  private func bindWith(moduleOutput: PersonsSearchModuleOutput) {
    // Биндинги для контроллера
    moduleOutput.showPersonDetails
      .emit(onNext: { person in
        let detailsViewController = DetailsViewController.instantiateFromStoryboard()
        detailsViewController.configureWith(person: person)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
      }).disposed(by: disposeBag)
  }
  
  private func hideKeyboard() {
    searchBar.resignFirstResponder()
  }
  
}

extension PersonsSearchViewController {
  // MARK: Alerts
  
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

extension PersonsSearchViewController {
  // MARK: Initial UI Config
  
  private func configureUI() {
    navigationItem.titleView = searchBar
    
    setupAppearance(of: searchBar)
    
    collectionView.register(PersonCollectionViewCell.self)
    collectionView.delaysContentTouches = false
    
    addToViewHierarchy(typeToSearchView)
    addToViewHierarchy(emptyResultView)
  }
  
  private func addToViewHierarchy(_ typeToSearchView: TypeToSearchView) {
    view.addSubview(typeToSearchView)
    
    let constrains: [NSLayoutConstraint] = [
      typeToSearchView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
      typeToSearchView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
      typeToSearchView.heightAnchor.constraint(equalToConstant: 100),
      typeToSearchView.widthAnchor.constraint(equalToConstant: 200)
    ]
    NSLayoutConstraint.activate(constrains)
    typeToSearchView.isHidden = true
  }
  
  private func addToViewHierarchy(_ typeToSearchView: EmptyResultView) {
    view.addSubview(emptyResultView)
    
    let constrains: [NSLayoutConstraint] = [
      emptyResultView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
      emptyResultView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
      emptyResultView.heightAnchor.constraint(equalToConstant: 250),
      emptyResultView.widthAnchor.constraint(equalToConstant: 225)
    ]
    NSLayoutConstraint.activate(constrains)
    emptyResultView.isHidden = true
  }
  
  private func setupAppearance(of searchBar: UISearchBar) {
    searchBar.placeholder = LocalizedString.personSearchSearchBarPlaceholder
    searchBar.sizeToFit()
    searchBar.becomeFirstResponder()
    let subViews = searchBar.allNestedSubviews()
    for view in subViews {
      if let textField = view as? UITextField {
        textField.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        textField.leftViewMode = .unlessEditing
        break
      }
    }
    searchBar.resignFirstResponder()
  }
  
}

extension PersonsSearchViewController {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentPage = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
    pageControl.currentPage = currentPage
  }
  
}

// MARK: - UICollectionViewDataSource
extension PersonsSearchViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return persons.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: PersonCollectionViewCell = collectionView.dequeue(forIndexPath: indexPath)
    let person = persons[indexPath.row]
    cell.configureWith(viewModel: person)
    return cell
  }
  
}

// MARK: - UICollectionViewDelegate
extension PersonsSearchViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    didSelectPerson.accept(indexPath.row)
  }
  
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PersonsSearchViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}
