//
//  Seed.swift
//  HDWalletKit
//
//  Created by Jack on 16/08/2019.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import CommonCryptoKit
import LibWally

public struct Seed: HexRepresentable {
    
    public let data: Data
    
    public init(data: Data) {
        self.data = data
    }
    
}
