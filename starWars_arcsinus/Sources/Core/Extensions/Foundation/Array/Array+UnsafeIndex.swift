//
//  Array+UnsafeIndex.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

extension Array {
  
  subscript(unsafeIndex index: Index) -> Iterator.Element? {
    guard indices.contains(index) else {
      return nil
    }
    return self[index]
  }
  
}

