//
//  ObjectMapper+Map.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import ObjectMapper

extension ObjectMapper.Map {
  
  func intFromString(_ key: String,
                     file: StaticString = #file,
                     function: StaticString = #function,
                     line: UInt = #line) throws -> Int {
    let stringVal: String = try value(key)
    guard let intValue = Int(stringVal) else {
      let reason = "Can't map int from string: \(stringVal)"
      throw MapError(key: key, currentValue: stringVal, reason: reason,
                     file: file, function: function, line: line)
    }
    return intValue
  }
  
  /** stringIfNotEmpty - Для случаев, когда ожидается НЕпустая строка.
   Отсутствие значения по ключу расценивается как пустая строка, и соответственно ошибка */
  func stringIfNotEmpty(_ key: String,
                        file: StaticString = #file,
                        function: StaticString = #function,
                        line: UInt = #line) throws -> String {
    let currentValue: String? = try? self.value(key)
    
    guard let value = currentValue, value.isNotEmpty else {
      throw MapError(key: key, currentValue: currentValue, reason: "Mapping: stringIfNotEmptyOrNil error",
                     file: file, function: function, line: line)
    }
    
    return value
  }
  
  /** compactMapArray
   Возвращает массив объектов, которые удалось замапить
   Т.е Если какие-то объекты в Json'e оказались невалдиными, то они пропускаются
   
   По указанному ключу должен быть массив типа [String: Any]. Это нужно для понимания того, что по ключу есть
   массив (например пустой). Отсутствие значения по ключу означет, что пришел некорректный Json
   
   Использовать нужно вдумчиво. Например в заказе если не замапилась хоть 1 позиция, то весь заказ
   тоже не должен мапиться. Т.е, например, для маппинга массива позиций этот метод не подходит
   
   > Стандартный метод ObjectMapper throw'ит ошибку, если хоть 1 элемент в массиве не замапился
   */
  func compactMapArray<T>(_ key: String,
                          file: StaticString = #file,
                          function: StaticString = #function,
                          line: UInt = #line) throws -> [T] where T: ImmutableMappable {
    let currentValue = JSON[key]
    guard let jsonArray = currentValue as? [[String: Any]] else {
      throw MapError(key: key, currentValue: currentValue, reason: "Cannot cast to '[[String: Any]]'",
                     file: file, function: function, line: line)
    }
    
    let objects = jsonArray.map { (try? T(JSON: $0)) }.compactMap { $0 }
    return objects
  }
  
  /** compactMapArrayOrEmpty
   Возвращает массив объектов, которые удалось замапить
   Т.е Если какие-то объекты в Json'e оказались невалидными, то они пропускаются
   
   Если по указанному ключу нет значения, это расценивается как пустой массив.
   
   > Стандартный метод ObjectMapper throw'ит ошибку, если хоть 1 элемент в массиве не замапился
   */
  func compactMapArrayOrEmpty<T>(_ key: String,
                                 file: StaticString = #file,
                                 function: StaticString = #function,
                                 line: UInt = #line) throws -> [T] where T: ImmutableMappable {
    let currentValue = JSON[key]
    guard currentValue != nil else {
      return [] // Отсутствие значения по ключу расцениваем как пустой массив
    }
    
    guard let jsonArray = currentValue as? [[String: Any]] else {
      throw MapError(key: key, currentValue: currentValue, reason: "Cannot cast to '[[String: Any]]'",
                     file: file, function: function, line: line)
    }
    
    let objects = jsonArray.map { (try? T(JSON: $0)) }.compactMap { $0 }
    return objects
  }
  
}
