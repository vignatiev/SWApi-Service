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
  
  private var sessions: [ObjectIdentifier: Session] = [:]
  
  enum SearchResource: String {
    case people, planets
    
    var value: String {
      let suffix: String
      switch self {
      case .people: suffix = "people/"
      case .planets: suffix = "planets/"
      }
      return "api/" + suffix
    }
    
  }
  
  private init() { }
  
  @discardableResult
  func getPerson(withName name: String,
                 completion: @escaping(Result<[Person], ApiError>) -> Void) -> DataRequest {
    let url = makeUrl(withPath: SearchResource.people)!
    let parameters: Parameters = ["search": name]
    
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 5
    configuration.timeoutIntervalForResource = 5
    
    let session = Alamofire.Session(configuration: configuration)
    addSession(session)
    
    let request = session.request(url, method: .get, parameters: parameters)
      .validate(statusCode: 200..<300)
      .responseJSON { [weak self] response in
        guard let self = self else {
          return
        }
        
        self.removeSession(session)
        
        let result: Result<[Person], ApiError>
        
        switch response.result {
        case .success(let value):
          guard let searchResponse = Mapper<PersonsSearchResponse>().map(JSONObject: value) else {
            return
          }
          let persons = searchResponse.persons
          result = Result.success(persons!)
          
        case .failure(let error):
          result = self.responseFailureResult(response: response, error: error)
        }
        completion(result)
    }
    
    return request
  }
  
  private func addSession(_ session: Session) {
    sessions[ObjectIdentifier(session)] = session
  }
  
  private func removeSession(_ session: Session) {
    sessions[ObjectIdentifier(session)] = nil
  }
  
  @discardableResult
  func getPlanet(withUrl url: URL,
                 completion: @escaping(Result<Planet, ApiError>) -> Void) -> DataRequest {
    
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 5
    configuration.timeoutIntervalForResource = 5
    
    let session = Alamofire.Session(configuration: configuration)
    addSession(session)
    
    let request = session.request(url, method: .get)
      .validate(statusCode: 200..<300)
      .responseJSON { [weak self] response in
        guard let self = self else {
          return
        }
        
        self.removeSession(session)
        
        let result: Result<Planet, ApiError>
        
        switch response.result {
        case .success(let value):
          guard let planet = Mapper<Planet>().map(JSONObject: value) else {
            return
          }
          result = Result.success(planet)
        case .failure(let error):
          result = self.responseFailureResult(response: response, error: error)
        }
        completion(result)
    }
    
    return request
  }
  
  private func makeUrl(withPath path: SearchResource) -> URL? {
    let urlString = Constants.baseUrl + path.value
    return URL(string: urlString)
  }
  
  private func responseFailureResult<A>(response: DataResponse<Any>, error: Error) -> Result<A, ApiError> {
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
  
  /// Api error description
  var errorDescription: String {
    switch self {
    case .clientError: return LocalizedString.errorsClientError
    case .authorizationError: return LocalizedString.errorsAuthError
    case .mappingError: return LocalizedString.errorsMappingError
    case .serverError: return LocalizedString.errorsServerError
    case .networkError: return LocalizedString.errorsNetworkError
    case .unknownError: return LocalizedString.errorsUnknownError
    }
  }
  
}
