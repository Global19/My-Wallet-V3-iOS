//
//  StellarWalletAccountRepository.swift
//  StellarKit
//
//  Created by Alex McGregor on 11/13/18.
//  Copyright © 2018 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import PlatformKit
import RxSwift

public protocol StellarWalletAccountRepositoryAPI {
    var defaultAccount: StellarWalletAccount? { get }

    func initializeMetadataMaybe() -> Maybe<StellarWalletAccount>
    func loadKeyPair() -> Maybe<StellarKeyPair>
}

public class StellarWalletAccountRepository: StellarWalletAccountRepositoryAPI, WalletAccountRepositoryAPI, WalletAccountInitializer, KeyPairProviderAPI {
    public typealias Account = StellarWalletAccount
    public typealias Pair = StellarKeyPair
    public typealias WalletAccount = StellarWalletAccount

    private let bridge: StellarWalletBridgeAPI
    private let mnemonicAccessAPI: MnemonicAccessAPI
    private let deriver: StellarKeyPairDeriver = StellarKeyPairDeriver()
    
    init(bridge: StellarWalletBridgeAPI = resolve(),
         mnemonicAccessAPI: MnemonicAccessAPI = resolve()) {
        self.bridge = bridge
        self.mnemonicAccessAPI = mnemonicAccessAPI
    }
    
    public func initializeMetadataMaybe() -> Maybe<WalletAccount> {
        loadDefaultAccount().ifEmpty(
            switchTo: createAndSaveStellarAccount()
        )
    }
    
    /// The default `StellarWallet`, will be nil if it has not yet been initialized
    public var defaultAccount: StellarWalletAccount? {
        accounts().first
    }
    
    func accounts() -> [WalletAccount] {
        bridge.stellarWallets()
    }
    
    public func loadKeyPair() -> Maybe<Pair> {
        mnemonicAccessAPI
            .mnemonicPromptingIfNeeded
            .flatMap { [unowned self] mnemonic -> Maybe<Pair> in
                self.deriver.derive(input: StellarKeyDerivationInput(mnemonic: mnemonic)).maybe
            }
    }
    
    // MARK: Private
    
    private func loadDefaultAccount() -> Maybe<WalletAccount> {
        guard let defaultAccount = defaultAccount else {
            return Maybe.empty()
        }
        return Maybe.just(defaultAccount)
    }
    
    private func createAndSaveStellarAccount() -> Maybe<WalletAccount> {
        loadKeyPair()
            .flatMap(weak: self) { (self, keyPair) -> Maybe<Pair> in
                self.save(keyPair: keyPair)
                    .andThen(Maybe.just(keyPair))
            }
            .map { keyPair -> Account in
                Account(
                    index: 0,
                    publicKey: keyPair.accountID,
                    label: "My Stellar Wallet",
                    archived: false
                )
            }
    }

    private func save(keyPair: Pair) -> Completable {
        Completable.create(weak: self) { (self, observer) -> Disposable in
            self.bridge.save(
                keyPair: keyPair,
                label: "My Stellar Wallet",
                completion: { error in
                    switch error {
                    case .none:
                        observer(.completed)
                    case .some:
                        observer(.error(StellarAccountError.unableToSaveNewAccount))
                    }
                }
            )
            return Disposables.create()
        }
    }
}
