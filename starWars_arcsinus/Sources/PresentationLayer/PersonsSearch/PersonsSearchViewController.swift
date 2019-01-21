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
  
  private var viewModel: AnyObject?
  
  private let didSelectPerson = PublishRelay<Int>()
  private let disposeBag = DisposeBag()
  
  private var persons: [PersonsSearchViewModel.PersonViewModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.titleView = searchBar
    collectionView.register(PersonCollectionViewCell.self)
    pageControl.numberOfPages = 3
    configureWith(viewModel: PersonsSearchViewModel(model: PersonsSearchModel(personsStorage: PersonsLocalStorage.shared)))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    searchBar.sizeToFit()
    searchBar.becomeFirstResponder()
    let subViews = searchBar.allNestedSubviews()
    for view in subViews {
      if let textField = view as? UITextField {
        textField.backgroundColor = .gray
        textField.leftViewMode = .unlessEditing
        break
      }
    }
    searchBar.resignFirstResponder()
  }
  
  func configureWith(viewModel: PersonsSearchViewModel) {
    self.viewModel = viewModel
    
    let searchText = searchBar.rx.text.asObservable().filterNil()
    let input = PersonsSearchViewModel.Input(searchText: searchText,
                                             itemWasSelected: didSelectPerson.asObservable())
    let output = viewModel.transform(input: input)
    
    output.persons.drive(onNext: { [weak self] persons in
      self?.persons = persons
      self?.collectionView.reloadData()
    })
      .disposed(by: disposeBag)
  }
  
}

// MARK: - UICollectionViewDataSource
extension PersonsSearchViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return persons.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell: PersonCollectionViewCell = collectionView.dequeueCollectionCell(forIndexPath: indexPath)
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
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 2)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}
