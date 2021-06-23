//
//  AlamofireManager.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/17/21.
//

import Foundation
import Alamofire

enum ServiceEror: Int, Error {
    case invalidClient = 400
    case invalidToken = 401
    case invalidGrant = 403
    case invalidParam = 404
}

protocol AlamofireManagerType {
    func request<RequestType: BaseTarget,
                 ParamType: Encodable>(request: RequestType,
                                       parameters: ParamType?,
                                       onSucess: @escaping (() -> Void),
                                       onError: @escaping ((Error) -> Void))
    
    func request<RequestType: BaseTarget,
                 ParamType: Encodable,
                 Output: Decodable>(for type: Output.Type,
                                    request: RequestType,
                                    parameters: ParamType?,
                                    onSucess: @escaping ((Output) -> Void),
                                    onError: @escaping ((Error) -> Void))
    
    func authenticateRequest<RequestType: BaseAuthenticateTarget,
                             ParamType: Encodable,
                             Output: Decodable>(for type: Output.Type,
                                                request: RequestType,
                                                parameters: ParamType?,
                                                onSucess: @escaping ((Output) -> Void),
                                                onError: @escaping ((Error) -> Void))
}

final class AlamofireManager: AlamofireManagerType {
    static let shared = AlamofireManager()
    
    private let retryLimit = 5
    private let invalidTokenLimit = 10
    private var invalidTokenCount = 0
    
    private init() {}
    
    func request<RequestType: BaseTarget,
                 ParamType: Encodable>(request: RequestType,
                                       parameters: ParamType?,
                                       onSucess: @escaping (() -> Void),
                                       onError: @escaping ((Error) -> Void)) {
        #if DEBUG
        AlamofireManager.debugRequest(with: request)
        #endif
        AF.request(request.fullUrl,
                   method: request.httpMethod,
                   parameters: parameters,
                   encoder: request.parameterEncoder,
                   headers: request.headers)
            .validate()
            .responseData(queue: DispatchQueue.global(qos: .userInitiated),
                          completionHandler: { response in
                            switch response.result {
                            case .success(_):
                                onSucess()
                            case .failure(let error):
                                #if DEBUG
                                AlamofireManager.debugError(error)
                                #endif
                                onError(error)
                            }
                          })
    }
    
    func request<RequestType: BaseTarget,
                 ParamType: Encodable,
                 Output: Decodable>(for type: Output.Type,
                                    request: RequestType,
                                    parameters: ParamType?,
                                    onSucess: @escaping ((Output) -> Void),
                                    onError: @escaping ((Error) -> Void)) {
        #if DEBUG
        AlamofireManager.debugRequest(with: request)
        #endif
        AF.request(request.fullUrl,
                   method: request.httpMethod,
                   parameters: parameters,
                   encoder: request.parameterEncoder,
                   headers: request.headers)
            .validate()
            .responseData(queue: DispatchQueue.global(qos: .userInitiated),
                          completionHandler: { response in
                            switch response.result {
                            case .success(let data):
                                do {
                                    let obj = try JSONDecoder().decode(Output.self, from: data)
                                    onSucess(obj)
                                } catch let error {
                                    onError(error)
                                }
                            case .failure(let error):
                                #if DEBUG
                                AlamofireManager.debugError(error)
                                #endif
                                onError(error)
                            }
                          })
    }
    
    func authenticateRequest<RequestType: BaseAuthenticateTarget,
                             ParamType: Encodable,
                             Output: Decodable>(for type: Output.Type,
                                                request: RequestType,
                                                parameters: ParamType?,
                                                onSucess: @escaping ((Output) -> Void),
                                                onError: @escaping ((Error) -> Void)) {
        #if DEBUG
        AlamofireManager.debugRequest(with: request)
        #endif
        AF.request(request.fullUrl,
                   method: request.httpMethod,
                   parameters: parameters,
                   encoder: request.parameterEncoder,
                   headers: request.headers,
                   interceptor: self)
            .cacheResponse(using: ResponseCacher.cache)
            .validate()
            .responseData(queue: DispatchQueue.global(qos: .userInitiated),
                          completionHandler: { [weak self] response in
                            switch response.result {
                            case .success(let data):
                                do {
                                    let obj = try JSONDecoder().decode(Output.self, from: data)
                                    onSucess(obj)
                                } catch let error {
                                    onError(error)
                                }
                            case .failure(let error):
                                #if DEBUG
                                AlamofireManager.debugError(error)
                                #endif
                                
                                if response.response?.statusCode == ServiceEror.invalidToken.rawValue {
                                    /// Handle automated update access token here.
                                    self?.refreshTokenRequest(onSucess: {
                                        self?.authenticateRequest(for: type, request: request, parameters: parameters, onSucess: onSucess, onError: onError)
                                    }, onError: { refreshTokenError in
                                        #if DEBUG
                                        AlamofireManager.debugError(refreshTokenError)
                                        #endif
                                        onError(error)
                                    })
                                } else {
                                    onError(error)
                                }
                            }
                          })
    }
}

// MARK: - Private functions
extension AlamofireManager {
    static private func debugRequest<Request: BaseTarget>(with urlRequest: Request) {
        let details: [String] = [
            "path: \(urlRequest.path)",
            "method: \(urlRequest.httpMethod.rawValue)",
            "allHTTPHeaderFields: \(urlRequest.headers)",
            "body: \(String(describing: urlRequest.parameters))"
        ]
        let detail: String = details.joined(separator: ", ")
        print(#file, #function, "\n")
        print("Request: {url: \(urlRequest.fullUrl)}")
        print("Request Detail: {\(detail)}")
    }
    
    static private func debugError(_ error: Error) {
        if let afError = error as? AFError {
            print("Status Code: \(afError.responseCode ?? 0)")
        }
    }
    
    private func refreshTokenRequest(onSucess: @escaping () -> Void, onError: @escaping  ((Error) -> Void)) {
        let refreshRequest = LoginTargets.RefreshToken()
        request(for: LoginResponse.self, request: refreshRequest, parameters: refreshRequest.parameters) { [weak self] loginReposnse in
            self?.updateNewAccessToken(accessToken: loginReposnse.accessToken ?? "")
            self?.invalidTokenCount = 0
            onSucess()
        } onError: { [weak self] error in
            self?.invalidTokenCount = 0
            onError(error)
        }
    }
    
    private func updateNewAccessToken(accessToken: String) {
        print(">>>: refresh token after \(invalidTokenCount) times invalid token")
        KeychainManager.shared.set(value: accessToken, for: KeychainKeys.accessToken)
    }
}

// MARK: - RequestRetrier
extension AlamofireManager: RequestInterceptor {
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print(">>> retryCount: \(request.retryCount)")
        if request.retryCount < retryLimit,
           shouldRetry(response: request.response, error: error) {
            completion(.retry)
        } else {
            completion(.doNotRetryWithError(error))
        }
    }
    
    func shouldRetry(response: HTTPURLResponse?, error: Error) -> Bool {
        guard response?.statusCode == ServiceEror.invalidToken.rawValue else {
            return true
        }
        print(">>> invalidTokenCount: \(invalidTokenCount)")
        if invalidTokenCount < invalidTokenLimit {
            invalidTokenCount += 1
            return true
        } else {
            return false
        }
    }
}
