//
//  FiatValue.swift
//  PlatformKit
//
//  Created by Chris Arriola on 1/17/19.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

import BigInt
import ToolKit

public struct FiatValue: Fiat, Hashable {
    
    /// The amount is the smallest unit of the currency (i.e. cents for USD)
    /// a.k.a. the minor value of the currency
    public let amount: BigInt
        
    /// The fiat currency
    public let currencyType: FiatCurrency
    
    public var value: FiatValue {
        self
    }
    
    public init(amount: BigInt, currency: FiatCurrency) {
        self.amount = amount
        self.currencyType = currency
    }
}

extension FiatValue {
    
    // MARK: - Conversion
    
    /// Converts this value into a corresponding CryptoValue given an exchange rate for a given currency
    ///
    /// - Parameters:
    ///   - exchangeRate: the cost of 1 unit of cryptoCurrency provided in FiatValue
    ///   - cryptoCurrency: the currency to convert to
    /// - Returns: the converted FiatValue in CryptoValue
    public func convertToCryptoValue(exchangeRate: FiatValue, cryptoCurrency: CryptoCurrency) -> CryptoValue {
        let conversionAmount = displayMajorValue / exchangeRate.displayMajorValue
        return CryptoValue.create(major: "\(conversionAmount)", currency: cryptoCurrency)!
    }
}

extension FiatValue: MoneyOperating {
    
    /// Creates a `FiatValue` from a provided amount in major units and currency code.
    ///
    /// - Parameters:
    ///   - value: the amount as a `Decimal`
    ///   - currency: the currency
    /// - Returns: the `FiatValue`
    public static func create(major value: Decimal, currency: FiatCurrency) -> FiatValue {
        let minorDecimal = value * pow(10, currency.maxDecimalPlaces)
        return create(minor: minorDecimal, currency: currency)
    }
    
    private static func create(minor value: Decimal, currency: FiatCurrency) -> FiatValue {
        let amount = BigInt(stringLiteral: "\(value.roundTo(places: 0))")
        return FiatValue(amount: amount, currency: currency)
    }
}

extension FiatValue {
    
    /// Calculates the value of `self` before a given percentage change
    /// e.g if the current value is `100` and the percentage of change is `10%`,
    /// the `percentageChange` expected value would be `0.1`.
    public func value(before percentageChange: Double) -> FiatValue {
        let percentageChange = percentageChange + 1
        guard percentageChange != 0 else {
            return .zero(currency: currencyType)
        }
        return .create(
            major: displayMajorValue / Decimal(percentageChange),
            currency: currencyType
        )
    }
}
