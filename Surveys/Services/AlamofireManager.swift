//
//  AlamofireManager.swift
//  Surveys
//
//  Created by Le Quoc Anh on 6/17/21.
//

import Foundation
import Alamofire

protocol AlamofireManagerType {
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
    
    private init() {}
    
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
                   headers: request.headers)
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
                                
                                if error.responseCode == 401 {
                                    /// Handle automated update access token here.
                                    self?.refreshTokenRequest(onSucess: {
                                        self?.request(for: type, request: request, parameters: parameters, onSucess: onSucess, onError: onError)
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
        request(for: LoginResponse.self, request: refreshRequest, parameters: refreshRequest.parameters) { loginReposnse in
            KeychainManager.shared.set(value: loginReposnse.accessToken ?? "", for: KeychainKeys.accessToken)
            onSucess()
        } onError: { error in
            onError(error)
        }
    }
}
