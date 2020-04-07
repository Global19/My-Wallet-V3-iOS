//
//  LabeledButtonViewStyle.swift
//  PlatformUIKit
//
//  Created by Daniel Huri on 28/01/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

public struct LabeledButtonViewStyle {
    let backgroundColor: Color
    let font: UIFont
    let textColor: Color
    let cornerRadius: CGFloat
    let border: ButtonContent.Border
    init(backgroundColor: Color,
         font: UIFont,
         textColor: Color,
         cornerRadius: CGFloat = 8,
         border: ButtonContent.Border = .no) {
        self.backgroundColor = backgroundColor
        self.font = font
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.border = border
    }
}

extension LabeledButtonViewStyle {
    public static var currency: LabeledButtonViewStyle {
        return .init(
            backgroundColor: .lightBlueBackground,
            font: .mainSemibold(14),
            textColor: .secondary
        )
    }
    public static var currencyTooLow: LabeledButtonViewStyle {
        return .init(
            backgroundColor: .lightRedBackground,
            font: .mainSemibold(14),
            textColor: .negativePrice
        )
    }
    public static var currencyTooHigh: LabeledButtonViewStyle {
        return .currencyTooLow
    }
}
