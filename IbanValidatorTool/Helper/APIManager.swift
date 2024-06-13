//
//  APIManager.swift
//  IbanValidatorTool
//
//  Created by Sagar Moradia on 12/06/24.
//

import Foundation

enum CustomError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case invalidCertificate
    case network(Error?)
}

final class APIManager {
    
    static let shared = APIManager()
    private init() {}
    
    // Certificate for SSL Pinning (replace with actual certificate data)
    private let sslCertificateData: Data = """
            YOUR_CERTIFICATE_DATA_HERE
        """.data(using: .utf8)!
    
    // USING Async/Await
    func request<T: Decodable>(urlRequest: URLRequest) async throws -> T {
        
        // Perform SSL Pinning
        guard let certificateURL = Bundle.main.url(forResource: "server_cert", withExtension: "cer") else {
            print("Certificate not found")
            throw CustomError.invalidCertificate
        }
        
        // Create a URLSession with custom configuration for SSL pinning
        let sessionConfig = URLSessionConfiguration.default
        let pinnedCertificates = [certificateURL]
        let sslPinningValidator = SSLPinningValidator(certificates: pinnedCertificates)
        //sessionConfig.urlSessionDelegate = sslPinningValidator
        let session = URLSession(configuration: sessionConfig)
                        
        let (data, response) = try await session.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse,
              200 ... 299 ~= response.statusCode else { // Comparing Range from 200 to 299 with range operator
            throw CustomError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // USING Closure
    func validateIban(urlString: String, completion: @escaping IbanValidateResultHandler) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.invalidData))
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse,
                      response.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                do {
                    let validationResponse = try JSONDecoder().decode(IbanValidationResponse.self, from: data)
                    completion(.success(validationResponse))
                } catch {
                    completion(.failure(.network(error)))
                }
            }
        }.resume()
    }
}
