//
//  DIKit.swift
//  PlatformKit
//
//  Created by Jack Pooley on 24/07/2020.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import DIKit
import NetworkKit
import ToolKit

extension DependencyContainer {

    // MARK: - PlatformKit Module

    public static var platformKit = module {
        
        // MARK: - Clients
        
        factory { SettingsClient() as SettingsClientAPI }
        
        factory { SwapClient() as SwapClientAPI }
        
        factory { GeneralInformationClient() as GeneralInformationClientAPI }
        
        factory { CustodialClient() as CustodialClientAPI }
        
        factory { () -> CustodyWithdrawalClientAPI in
            let custodialClient: CustodialClientAPI = DIKit.resolve()
            return custodialClient as CustodyWithdrawalClientAPI
        }
        
        factory { PriceClient() as PriceClientAPI }
        
        factory { UpdateWalletInformationClient() as UpdateWalletInformationClientAPI }
        
        factory { JWTClient() as JWTClientAPI }
        
        factory { KYCClient() as KYCClientAPI }

        factory { UserCreationClient() as UserCreationClientAPI }
        
        factory { NabuAuthenticationClient() as NabuAuthenticationClientAPI }
        
        // MARK: - Authentication
        
        single { NabuTokenStore() }

        single { NabuAuthenticationExecutor() as NabuAuthenticationExecutorAPI }

        factory { () -> NabuAuthenticationExecutorProvider in
            return { () -> NabuAuthenticationExecutorAPI in
                DIKit.resolve()
            }
        }
        
        factory { NabuAuthenticator() as AuthenticatorAPI }
        
        factory { JWTService() as JWTServiceAPI }
        
        // MARK: - Wallet
        
        factory { WalletNabuSynchronizerService() as WalletNabuSynchronizerServiceAPI }
        
        factory { () -> WalletRepositoryAPI in
            let walletRepositoryProvider: WalletRepositoryProvider = DIKit.resolve()
            return walletRepositoryProvider.repository as WalletRepositoryAPI
        }
        
        factory { () -> CredentialsRepositoryAPI in
            let repository: WalletRepositoryAPI = DIKit.resolve()
            return repository as CredentialsRepositoryAPI
        }
        
        factory { () -> NabuOfflineTokenRepositoryAPI in
            let repository: WalletRepositoryAPI = DIKit.resolve()
            return repository as NabuOfflineTokenRepositoryAPI
        }
        
        factory { () -> NabuAuthenticationExecutor.CredentialsRepository in
            let repository: WalletRepositoryAPI = DIKit.resolve()
            return repository as NabuAuthenticationExecutor.CredentialsRepository
        }
        
        // MARK: - Services

        single { EnabledCurrenciesService() as EnabledCurrenciesServiceAPI }
        
        factory { KYCServiceProvider() as KYCServiceProviderAPI }
        
        single { NabuUserService() as NabuUserServiceAPI }
        
        single { SettingsService() as CompleteSettingsServiceAPI }
        
        single { GeneralInformationService() as GeneralInformationServiceAPI }
        
        single { EmailVerificationService() as EmailVerificationServiceAPI }
        
        factory { SwapActivityService() as SwapActivityServiceAPI }

        single { () -> Coincore in
            Coincore(
                assetMap: [
                    .bitcoin: DIKit.resolve(tag: CryptoCurrency.bitcoin),
                    .bitcoinCash: DIKit.resolve(tag: CryptoCurrency.bitcoinCash),
                    .ethereum: DIKit.resolve(tag: CryptoCurrency.ethereum),
                    .stellar: DIKit.resolve(tag: CryptoCurrency.stellar),
                    .pax: DIKit.resolve(tag: CryptoCurrency.pax),
                    .tether: DIKit.resolve(tag: CryptoCurrency.tether)
                ]
            )
        }

        single { KYCTiersService() as KYCTiersServiceAPI }

        factory { CustodialFeatureFetcher() as CustodialFeatureFetching }

        single { () -> WalletOptionsAPI in
            WalletService()
        }

        factory { () -> MaintenanceServicing in
            let service: WalletOptionsAPI = DIKit.resolve()
            return service
        }

        factory { CredentialsStore() as CredentialsStoreAPI }

        factory { NSUbiquitousKeyValueStore.default as UbiquitousKeyValueStore }

        factory { WalletCryptoService() as WalletCryptoServiceAPI }

        factory { TradingBalanceService() as TradingBalanceServiceAPI }
    }
}
