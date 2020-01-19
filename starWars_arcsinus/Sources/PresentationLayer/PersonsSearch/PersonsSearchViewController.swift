//
//  PersonsSearchViewController.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 19.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

final class PersonsSearchViewController: UIViewController {
  @IBOutlet private var collectionView: UICollectionView!
  @IBOutlet private var searchBar: UISearchBar!
  @IBOutlet private var pageControl: UIPageControl!
  @IBOutlet private var dataSourceLabel: UILabel!
  
  private lazy var typeToSearchView = TypeToSearchView.loadFromNib()
  private lazy var emptyResultView = EmptyResultView.loadFromNib()
  
  private var viewModel: AnyObject?
  
  private let didSelectPerson = PublishRelay<Int>()
  private let disposeBag = DisposeBag()
  
  private let persons = BehaviorRelay<[PersonsSearchViewModel.PersonViewModel]>(value: [])
  
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
    
    bindDataSource()
    bind()
  }
  
  private func bindViewWith<V>(viewModel: V)
    where V: ViewModelType,
    V.Input == PersonsSearchViewModel.Input, V.Output == PersonsSearchViewModel.Output {
    let searchText = searchBar.rx.text.asObservable().filterNil()
    let input = PersonsSearchViewModel.Input(searchText: searchText,
                                             itemWasSelected: didSelectPerson.asObservable())
    let output = viewModel.transform(input: input)
    
    output.persons
      .do(onNext: { [weak self] in
        self?.pageControl.numberOfPages = $0.endIndex
      })
      .asObservable()
      .bind(to: persons)
      .disposed(by: disposeBag)
    
    output.typeToSearchViewVisible.drive(typeToSearchView.rx.isVisible).disposed(by: disposeBag)
    output.collectionViewVisivble.drive(collectionView.rx.isVisible).disposed(by: disposeBag)
    output.pageControlVisivble.drive(pageControl.rx.isVisible).disposed(by: disposeBag)
    
    output.isEmptyResultViewVisible.drive(emptyResultView.rx.isVisible).disposed(by: disposeBag)
    
    output.isDataSourceLabelVisible.drive(dataSourceLabel.rx.isVisible).disposed(by: disposeBag)
    output.dataSource.drive(dataSourceLabel.rx.text).disposed(by: disposeBag)
    
    output.hideKeyboardAfterSearch
      .emit(onNext: { [weak self] in
        self?.hideKeyboard()
      })
      .disposed(by: disposeBag)
    
    output.showNetworkError
      .emit(onNext: { [weak self] message in
        self?.showErrorAlert(title: nil, message: message)
      })
      .disposed(by: disposeBag)
  }
  
  private func bindWith(moduleOutput: PersonsSearchModuleOutput) {
    // Биндинги для контроллера
    moduleOutput.showPersonDetails
      .emit(onNext: { person in
        let detailsViewController = DetailsViewController.instantiateFromStoryboard()
        detailsViewController.configureWith(person: person)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  private func bind() {
    collectionView.rx.itemSelected
      .map { $0.row }
      .bind(to: didSelectPerson)
      .disposed(by: disposeBag)
    
    collectionView.rx.contentOffset
      .map { Int($0.x / UIScreen.main.bounds.width) }
      .distinctUntilChanged()
      .bind(to: pageControl.rx.currentPage)
      .disposed(by: disposeBag)
  }
  
  private func bindDataSource() {
    persons.bind(to: collectionView.rx.items) { collectionView, item, person in
      let cell: PersonCollectionViewCell = collectionView.dequeue(forIndexPath: IndexPath(item: item, section: 0))
      cell.configureWith(viewModel: person)
      return cell
    }
    .disposed(by: disposeBag)
  }
  
  private func hideKeyboard() {
    searchBar.resignFirstResponder()
  }
}

// MARK: - Alerts

extension PersonsSearchViewController {
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

// MARK: - Initial UI Config

extension PersonsSearchViewController {
  private func configureUI() {
    navigationItem.titleView = searchBar
    
    setupAppearance(of: searchBar)
    
    collectionView.register(PersonCollectionViewCell.self)
    collectionView.delaysContentTouches = false
    collectionView.delegate = self
    
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
    view.addSubview(typeToSearchView)
    
    let constrains: [NSLayoutConstraint] = [
      typeToSearchView.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor),
      typeToSearchView.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
      typeToSearchView.heightAnchor.constraint(equalToConstant: 250),
      typeToSearchView.widthAnchor.constraint(equalToConstant: 225)
    ]
    NSLayoutConstraint.activate(constrains)
    typeToSearchView.isHidden = true
  }
  
  private func setupAppearance(of searchBar: UISearchBar) {
    searchBar.placeholder = LocalizedString.personSearchSearchBarPlaceholder
    searchBar.sizeToFit()
    searchBar.becomeFirstResponder()
    let subViews = searchBar.allNestedSubviews()
    for view in subViews {
      if let textField = view as? UITextField {
        textField.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        break
      }
    }
    searchBar.resignFirstResponder()
  }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PersonsSearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return collectionView.frame.size
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
