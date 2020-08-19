//
//  FiatAccount.swift
//  PlatformKit
//
//  Created by Paulo on 03/08/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import Foundation

public protocol FiatAccount : SingleAccount {
    var fiatCurrency: String { get }
}