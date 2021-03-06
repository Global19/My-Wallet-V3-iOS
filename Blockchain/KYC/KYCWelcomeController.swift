//
//  KYCWelcomeController.swift
//  Blockchain
//
//  Created by Maurice A. on 7/9/18.
//  Copyright © 2018 Blockchain Luxembourg S.A. All rights reserved.
//

import UIKit

/// Welcome screen in KYC flow
final class KYCWelcomeController: KYCBaseViewController {

    // MARK: - IBOutlets

    @IBOutlet private var imageViewMain: UIImageView!
    @IBOutlet private var labelMain: UILabel!
    @IBOutlet private var labelTermsOfService: UILabel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: Factory

    override class func make(with coordinator: KYCCoordinator) -> KYCWelcomeController {
        let controller = makeFromStoryboard()
        controller.coordinator = coordinator
        controller.pageType = .welcome
        return controller
    }

    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = LocalizationConstants.KYC.welcome
        initMainView()
        initFooter()
    }

    // MARK: - Actions
    @IBAction func onCloseTapped(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }

    @IBAction private func onLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let text = labelTermsOfService.text else {
            return
        }
        if let tosRange = text.range(of: LocalizationConstants.tos),
            sender.didTapAttributedText(in: labelTermsOfService, range: NSRange(tosRange, in: text)) {
            UIApplication.shared.openWebView(
                url: Constants.Url.termsOfService,
                title: LocalizationConstants.tos,
                presentingViewController: self
            )
        }
        if let privacyPolicyRange = text.range(of: LocalizationConstants.privacyPolicy),
            sender.didTapAttributedText(in: labelTermsOfService, range: NSRange(privacyPolicyRange, in: text)) {
            UIApplication.shared.openWebView(
                url: Constants.Url.privacyPolicy,
                title: LocalizationConstants.privacyPolicy,
                presentingViewController: self
            )
        }
    }

    @IBAction private func primaryButtonTapped(_ sender: Any) {
        coordinator.handle(event: .nextPageFromPageType(pageType, nil))
    }

    // MARK: - Private Methods

    private func initMainView() {
        if coordinator.user?.isSunriverAirdropRegistered == true {
            labelMain.text = LocalizationConstants.KYC.welcomeMainTextSunRiverCampaign
            imageViewMain.image = #imageLiteral(resourceName: "Icon-Verified-Large")
        } else {
            labelMain.text = LocalizationConstants.KYC.welcomeMainText
            imageViewMain.image = #imageLiteral(resourceName: "Welcome")
        }
    }

    private func initFooter() {
        let font = UIFont(
            name: Constants.FontNames.montserratRegular,
            size: Constants.FontSizes.ExtraExtraExtraSmall
            ) ?? UIFont.systemFont(ofSize: Constants.FontSizes.ExtraExtraExtraSmall)
        let labelAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: UIColor.gray5
        ]
        let labelText = NSMutableAttributedString(
            string: String(
                format: LocalizationConstants.KYC.termsOfServiceAndPrivacyPolicyNotice,
                LocalizationConstants.tos,
                LocalizationConstants.privacyPolicy
            ),
            attributes: labelAttributes
        )
        labelText.addForegroundColor(UIColor.brandSecondary, to: LocalizationConstants.tos)
        labelText.addForegroundColor(UIColor.brandSecondary, to: LocalizationConstants.privacyPolicy)
        labelTermsOfService.attributedText = labelText
    }
}

extension UITapGestureRecognizer {

    /// Checks if the tap occurred inside a specified range within a UILabel.
    /// See: https://stackoverflow.com/a/35789589
    ///
    /// Warning: Does not work for labels with left-aligned text
    ///
    /// - Parameters:
    ///   - label: the UILabel
    ///   - range: the NSRange
    /// - Returns: true if the tap occurred within `range`, otherwise, false
    func didTapAttributedText(in label: UILabel, range: NSRange) -> Bool {
        guard let attributedText = label.attributedText else {
            return false
        }

        let textStorage = NSTextStorage(attributedString: attributedText)

        let layoutManager = NSLayoutManager()

        let textContainer = NSTextContainer(size: CGSize.zero)
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        layoutManager.addTextContainer(textContainer)

        textStorage.addLayoutManager(layoutManager)

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(
            x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
            y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y
        )
        let locationOfTouchInTextContainer = CGPoint(
            x: locationOfTouchInLabel.x - textContainerOffset.x,
            y: locationOfTouchInLabel.y - textContainerOffset.y
        )
        let indexOfCharacter = layoutManager.characterIndex(
            for: locationOfTouchInTextContainer,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )

        return NSLocationInRange(indexOfCharacter, range)
    }
}
