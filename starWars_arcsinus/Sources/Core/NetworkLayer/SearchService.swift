//
//  SearchService.swift
//  starWars_arcsinus
//
//  Created by Владислав Игнатьев on 21.01.2019.
//  Copyright © 2019 Владислав Игнатьев. All rights reserved.
//

import Alamofire
import ObjectMapper

final class SearchService {
  
  static let shared = SearchService()
  
  enum SearchResource: String {
    case films, people, planets, species, starships, vehicles
    
    var value: String {
      let suffix: String
      switch self {
      case .films: suffix = "films/"
      case .people: suffix = "people/"
      case .planets: suffix = "planets/"
      case .species: suffix = "species/"
      case .starships: suffix = "starships/"
      case .vehicles: suffix = "vehicles/"
      }
      return "api/" + suffix
    }
  }
  
  private init() { }
  
  func getInfoAboutPerson(withName name: String,
                          completion: @escaping(GenericResult<[Person], ApiError>) -> Void) {
    
    guard let url = makeUrl(withPath: SearchResource.people) else {
      let error = ApiError.clientError
      DispatchQueue.main.async {
        completion(GenericResult.failure(error))
      }
      return
    }
    let parameters: Parameters = ["search": name]
    
    AF.request(url, method: .get, parameters: parameters)
      .validate(statusCode: 200..<300)
      .responseJSON { response in
        
        let result: GenericResult<[Person], ApiError>
        
        switch response.result {
        case .success(let value):
          guard let searchResponse = try? Mapper<SearchResponse>().map(JSONObject: value) else {
            return
          }
          let persons = searchResponse.persons
          result = GenericResult.success(persons)
          completion(result)
          
        case .failure(_):
          // FIXME
          result = GenericResult.failure(ApiError.clientError)
          completion(result)
        }
    }
    
  }
  
  private func makeUrl(withPath path: SearchResource) -> URL? {
    let urlString = Constants.baseUrl + path.value
    return URL(string: urlString)
  }
  
}

enum ApiError: Error {
  case clientError
}
