//
//  ViewModelType.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

protocol ViewModelType: AnyObject {
  
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input) -> Output
  
}
