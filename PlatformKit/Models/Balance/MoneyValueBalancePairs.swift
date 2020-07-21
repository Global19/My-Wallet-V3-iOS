//
//  AssetFiatCryptoBalancePairs.swift
//  PlatformKit
//
//  Created by AlexM on 1/30/20.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

/// `MoneyValueBalancePairs` represents all the balances
/// for a given asset type. There are multiple `BalanceTypes`.
/// This allows for a total pairs that represents
/// the users balance across all `BalanceTypes`.
public struct MoneyValueBalancePairs: Equatable {
    
    /// The base currency type - either crypto or fiat
    public let baseCurrency: CurrencyType
    
    /// The quote currency type - either crypto or fiat
    public let quoteCurrency: CurrencyType
    
    public subscript(balanceType: BalanceType) -> MoneyValuePair {
        moneyPairs[balanceType]!
    }
    
    // MARK: - Services
    
    private var moneyPairs: [BalanceType: MoneyValuePair] = [:]
    
    // MARK: - Setup
    
    /// Expects to be initialized with the wallet (non-custodial balance),
    /// trading (simplebuy account) balance, and savings (interest) account balance.
    /// All the base currencies must be equal to each other, as well as quotes
    /// - Parameters:
    ///   - wallet: Wallet balance
    ///   - trading: Trading balance
    ///   - savings: Savings balance
    public init(wallet: MoneyValuePair,
                trading: MoneyValuePair,
                savings: MoneyValuePair) {
        guard wallet.base.currencyType == trading.base.currencyType,
            trading.base.currencyType == savings.base.currencyType else {
            fatalError("Mismatch in wallet/trading/savings base currency")
        }
        guard wallet.quote.currencyType == trading.quote.currencyType,
            trading.quote.currencyType == savings.quote.currencyType else {
            fatalError("Mismatch in wallet/trading/savings quote currency")
        }
        
        baseCurrency = trading.base.currencyType
        quoteCurrency = trading.quote.currencyType
        
        moneyPairs[.nonCustodial] = wallet
        moneyPairs[.custodial(.trading)] = trading
        moneyPairs[.custodial(.savings)] = savings
    }
}

public extension MoneyValueBalancePairs {
    
    /// The `MoneyValuePair` representing the total sum of bases and quotes
    /// across all `BalanceTypes`
    var total: MoneyValuePair {
        .init(base: base, quote: quote)
    }
    
    /// The total value for the base currency
    var base: MoneyValue {
        let total = moneyPairs.values.map { $0.base.amount }.reduce(0, +)
        return (try? MoneyValue(minor: total, currency: baseCurrency.code)) ?? .zero(baseCurrency)
    }
    
    /// The total value for the quote currency
    var quote: MoneyValue {
        let total = moneyPairs.values.map { $0.quote.amount }.reduce(0, +)
        return (try? MoneyValue(minor: total, currency: quoteCurrency.code)) ?? .zero(quoteCurrency)
    }
    
    /// `true` if `self` is zero.
    var isZero: Bool {
        base.isZero || quote.isZero
    }
}

extension MoneyValueBalancePairs: CustomDebugStringConvertible {
    public var debugDescription: String {
        moneyPairs
            .map { "\($0.key.description): \($0.value.debugDescription)" }
            .joined(separator: " | ")
    }
}