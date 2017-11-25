//
//  String+Crypto.swift
//  Marvel
//
//  Created by Emil Marashliev on 10/29/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import Foundation

extension String {

    func md5() -> String {
        let stringData = self.data(using:.utf8)!
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digestData.withUnsafeMutableBytes { digestBytes in
            stringData.withUnsafeBytes { stringBytes in
                CC_MD5(stringBytes, CC_LONG(stringData.count), digestBytes)
            }
        }

        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
