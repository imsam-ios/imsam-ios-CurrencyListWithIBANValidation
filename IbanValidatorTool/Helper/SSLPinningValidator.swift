//
//  SSLPinningValidator.swift
//  IbanValidatorTool
//
//  Created by Sagar Moradia on 13/06/24.
//

import Foundation

// Custom URLSessionDelegate to handle SSL pinning
final class SSLPinningValidator: NSObject, URLSessionDelegate {
    
    let pinnedCertificates: [URL]
    
    init(certificates: [URL]) {
        self.pinnedCertificates = certificates
        super.init()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        // Create a credential using the pinned certificates
        let pinnedCertSet = Set(pinnedCertificates)
        let serverTrustCertCount = SecTrustGetCertificateCount(serverTrust)
        
        for index in 0..<serverTrustCertCount {
            if let serverCert = SecTrustCopyCertificateChain(serverTrust) {
                let serverCertData = SecCertificateCopyData(serverCert as! SecCertificate) as Data
//                if pinnedCertSet.contains(serverCertData) {
//                    let credential = URLCredential(trust: serverTrust)
//                    completionHandler(.useCredential, credential)
//                    return
//                }
            }
        }
        
        // No matching pinned certificate found
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
