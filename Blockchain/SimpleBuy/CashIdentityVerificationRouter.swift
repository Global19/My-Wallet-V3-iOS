//
//  CashIdentityVerificationRouter.swift
//  Blockchain
//
//  Created by Alex McGregor on 7/13/20.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import PlatformUIKit
import RxRelay
import RxSwift

final class CashIdentityVerificationRouter {
    
    private weak var topMostViewControllerProvider: TopMostViewControllerProviding!
    
    init(topMostViewControllerProvider: TopMostViewControllerProviding = resolve()) {
        self.topMostViewControllerProvider = topMostViewControllerProvider
    }
    
    func dismiss(startKYC: Bool = false) {
        topMostViewControllerProvider.topMostViewController?.dismiss(animated: true, completion: {
            guard startKYC else { return }
            KYCCoordinator.shared.start()
        })
    }
}
