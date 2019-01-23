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
                          completion: @escaping(GenericResult<[Person], ApiError>) -> Void) -> DataRequest {
    let url = makeUrl(withPath: SearchResource.people)!
    let parameters: Parameters = ["search": name]
    
    let sessionManager = Alamofire.Session.default
    sessionManager.sessionConfiguration.timeoutIntervalForRequest = 10
    sessionManager.sessionConfiguration.timeoutIntervalForResource = 10
    
    let request = sessionManager.request(url, method: .get, parameters: parameters)
      .validate(statusCode: 200..<300)
      .responseJSON { [weak self] response in
        guard let self = self else {
          return
        }
        
        let result: GenericResult<[Person], ApiError>
        
        switch response.result {
        case .success(let value):
          guard let searchResponse = try? Mapper<SearchResponse>().map(JSONObject: value) else {
            return
          }
          let persons = searchResponse.persons
          result = GenericResult.success(persons)
          
        case .failure(let error):
          // FIXME: handle all errors
          result = self.responseFailureResult(response: response, error: error)
        }
        completion(result)
    }
    
    return request
  }
  
  func makeUrl(withPath path: SearchResource) -> URL? {
    let urlString = Constants.baseUrl + path.value
    return URL(string: urlString)
  }
  
  private func responseFailureResult<A>(response: DataResponse<Any>, error: Error) -> GenericResult<A, ApiError> {
    let apiError: ApiError
    if let statusCode = response.response?.statusCode {
      switch statusCode {
      case 401, 403: apiError = .authorizationError
      case 500...599: apiError = .serverError(underlyingError: error)
      case 400...499: apiError = .clientError(underlyingError: error)
      default:
        // Другие http коды воспринимаем как serverError
        apiError = .serverError(underlyingError: error)
      }
    } else {
      let errorCode = error._code
      switch errorCode {
      case -1: apiError = .unknownError(underlyingError: error)
      default: apiError = .networkError(underlyingError: error)
      }
    }
    
    return .failure(apiError)
  }
  
  enum Errors: Error {
    case invalidUrl
  }
  
}

enum ApiError: Error, LocalizedError {
  
  case authorizationError // http коды 401, 403
  case clientError(underlyingError: Error) // 400-е http коды
  case serverError(underlyingError: Error) // 500-е http коды
  
  case networkError(underlyingError: Error)
  case mappingError(underlyingError: Error)
  case unknownError(underlyingError: Error?)
  
  var errorDescription: String? {
    switch self {
    case .clientError: return "Произошла ошибка при обращении к серверу"
    case .authorizationError: return "Произошла ошибка авторизации"
    case .mappingError: return "Произошла ошибка при оьработке данных, полученных от сервера"
    case .serverError: return "Во время выполнения запроса произошла ошибка сервера"
    case .networkError: return "Нет соединения с интернетом или очень низкая скорость подключения"
    case .unknownError: return "Произошла неизвестная ошибка сети"
    }
  }
  
}
