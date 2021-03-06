//
//  PersonalDetailsDelegate.swift
//  Blockchain
//
//  Created by Alex McGregor on 8/9/18.
//  Copyright © 2018 Blockchain Luxembourg S.A. All rights reserved.
//

import PlatformKit

protocol PersonalDetailsDelegate: class {
    func onSubmission(_ input: KYCUpdatePersonalDetailsRequest, completion: @escaping () -> Void)
}
