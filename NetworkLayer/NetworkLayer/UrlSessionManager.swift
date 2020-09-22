//
//  ApiClient.swift
//  RssReader
//
//  Created by vladislav on 20.09.2020.
//  Copyright © 2020 vladislav. All rights reserved.
//

import Foundation

public class UrlSessionManager: ApiManager {
    
    public init() {
    }
    
    public func request(_ urlConvertable: URLConvertible, completion: @escaping(Swift.Result<Data, ApiError>) -> Void) {
        do {
            let url = try urlConvertable.asURL()
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let jsonData = data else {
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 403:
                            completion(Result.failure(ApiError.forbidden))
                        case 404:
                            completion(Result.failure(ApiError.notFound))
                        case 409:
                            completion(Result.failure(ApiError.conflict))
                        case 500:
                            completion(Result.failure(ApiError.internalServerError))
                        default:
                            completion(Result.failure(ApiError.unknown))
                        }
                    }
                    return
                }
                completion(Result.success(jsonData))
            }.resume()
        } catch ApiError.invalidUrl {
            completion(Result.failure(ApiError.invalidUrl))
        } catch {
        }
    }
    
    public func request<T: Decodable> (_ urlConvertible: URLRequestConvertible, completion: @escaping(Swift.Result<T, ApiError>) -> Void) {
        do {
            let request = try urlConvertible.asURLRequest()
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let jsonData = data else {
                    if let httpResponse = response as? HTTPURLResponse {
                        switch httpResponse.statusCode {
                        case 403:
                            completion(Result.failure(ApiError.forbidden))
                        case 404:
                            completion(Result.failure(ApiError.notFound))
                        case 409:
                            completion(Result.failure(ApiError.conflict))
                        case 500:
                            completion(Result.failure(ApiError.internalServerError))
                        default:
                            completion(Result.failure(ApiError.unknown))
                        }
                    }
                    return
                }
                guard let finalData = try? JSONDecoder().decode(T.self, from: jsonData) else {
                    completion(Result.failure(ApiError.unknown))
                    return
                }
                completion(Result.success(finalData))
            }.resume()
        } catch ApiError.invalidUrl {
            completion(Result.failure(ApiError.invalidUrl))
        } catch {
        }
    }
    
    public func getImage(url: URL, completion: @escaping(Swift.Result<Data, ApiError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let imageData = data else {
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 403:
                        completion(Result.failure(ApiError.forbidden))
                    case 404:
                        completion(Result.failure(ApiError.notFound))
                    case 409:
                        completion(Result.failure(ApiError.conflict))
                    case 500:
                        completion(Result.failure(ApiError.internalServerError))
                    default:
                        completion(Result.failure(ApiError.unknown))
                    }
                }
                return
            }
            completion(Result.success(imageData))
        }.resume()
    }
}
