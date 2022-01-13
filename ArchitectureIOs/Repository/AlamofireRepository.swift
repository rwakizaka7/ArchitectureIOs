//
//  AlamofireRepository.swift
//  ArchitectureIOs
//
//  Created by 脇坂亮汰 on 2022/01/14.
//

import Foundation
import Alamofire

typealias AFR = AlamofireRepository

class AlamofireRepository {
    static func request(_ convertible: URLConvertible,
                        method: HTTPMethod = .get,
                        parameters: Parameters = [:],
                        headers: HTTPHeaders = [:],
                        completionHandler: @escaping (AFDataResponse<Data>) -> Void) {
        
        AF.request(convertible, method: method, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData {
                response in
                
                var _response: String = ""
                var _error: String = ""
                
                switch response.result {
                case .success(let data):
                    _response = String(data: data, encoding: .utf8) ?? ""
                case .failure(let error):
                    _error = error.errorDescription ?? ""
                }
                
                print("API戻り >>> url=\(convertible) method=\(method) parameters=\(parameters) "
                      + "headers=\(headers) response=\(_response) error=\(_error)")
                
                completionHandler(response)
            }
    }
}
