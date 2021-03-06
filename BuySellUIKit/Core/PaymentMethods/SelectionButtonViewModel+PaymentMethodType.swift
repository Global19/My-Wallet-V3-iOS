//
//  SelectionButtonViewModel+PaymentMethodType.swift
//  Blockchain
//
//  Created by Daniel Huri on 08/04/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import BuySellKit
import Localization
import PlatformKit
import PlatformUIKit

extension SelectionButtonViewModel {
    
    // MARK: - Types
    
    private typealias LocalizedString = LocalizationConstants.SimpleBuy.PaymentMethodSelectionScreen
    
    // MARK: - Setup
    
    convenience init(with paymentMethodType: PaymentMethodType?) {
        self.init()
        let leadingContent: SelectionButtonViewModel.LeadingContentType?
        let title: String
        let accessibilityContent: AccessibilityContent
        switch paymentMethodType {
        case .some(.suggested(let method)):
            switch method.type {
            case .card:
                leadingContent = .image(
                    .init(
                        name: "icon-card",
                        background: .lightBlueBackground,
                        offset: 4,
                        cornerRadius: .round,
                        size: .init(edge: 32)
                    )
                )
                title = LocalizedString.Types.cardTitle
            case .funds:
                leadingContent = .image(
                    .init(
                        name: "icon-deposit-cash",
                        background: .lightBlueBackground,
                        offset: 8,
                        cornerRadius: .round,
                        size: .init(edge: 32)
                    )
                )
                title = LocalizedString.DepositCash.title
            case .bankTransfer:
                fatalError("Bank transfer is not a valid payment method anymore")
            }
            subtitleRelay.accept("\(method.max.displayString) \(LocalizedString.Types.limitSubtitle)")
            accessibilityContent = AccessibilityContent(
                id: method.type.rawType.rawValue,
                label: title
            )
        case .some(.card(let data)):
            if let thumbnail = data.type.thumbnail {
                leadingContent = .image(
                    .init(
                        name: thumbnail,
                        background: .background,
                        offset: 0,
                        cornerRadius: .value(4),
                        size: .init(width: 32, height: 20)
                    )
                )
            } else {
                leadingContent = nil
            }
            title = data.label
            accessibilityContent = AccessibilityContent(
                id: title,
                label: title
            )
            let limit = "\(data.topLimitDisplayValue) \(LocalizedString.Types.limitSubtitle)"
            subtitleRelay.accept(limit)
        case .some(.account(let data)):
            leadingContent = .image(
                .init(
                    name: data.balance.baseCurrency.logoImageName,
                    background: .fiat,
                    offset: 4,
                    cornerRadius: .value(8),
                    size: .init(edge: 32)
                )
            )
            title = data.balance.baseCurrency.name
            subtitleRelay.accept("\(data.balance.base.toDisplayString(includeSymbol: true)) \(LocalizedString.Types.available)")
            accessibilityContent = AccessibilityContent(
                id: Accessibility.Identifier.SimpleBuy.BuyScreen.selectPaymentMethodLabel,
                label: title
            )
        case .none: // No preferred payment method type
            leadingContent = .image(
                .init(
                    name: "icon-plus",
                    background: .lightBlueBackground,
                    offset: 4,
                    cornerRadius: .round,
                    size: .init(edge: 32)
                )
            )
            title = LocalizedString.Types.selectCashOrCard
            subtitleRelay.accept(nil)
            accessibilityContent = AccessibilityContent(
                id: Accessibility.Identifier.SimpleBuy.BuyScreen.selectPaymentMethodLabel,
                label: title
            )
        }
        accessibilityContentRelay.accept(accessibilityContent)
        leadingContentTypeRelay.accept(leadingContent)
        titleRelay.accept(title)
    }
}

// MARK: - Array extension

extension Array where Element == SelectionButtonViewModel {
    init(with paymentMethods: [PaymentMethodType]) {
        self.init()
        append(contentsOf: paymentMethods.map { SelectionButtonViewModel(with: $0) })
    }
}
