//
//  AccountPresenter.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 24/05/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Utilities
import SVProgressHUD

public final class AccountPresenter: AccountPresentation {
    let output: Output

    let input: Input

    public typealias UseCases = (
        output: (
            countries: Driver<[Country]>,
            selectedCountry: Driver<Country?>
        ),
        input: (
            setSelectedCountry: (_ dial_code: String) -> Void,
            ()
        )
    )

    private let disposeBag = DisposeBag()

    init(input: Input, router: AccountRouter, useCases: UseCases) {
        self.input = input
        self.output = type(of: self).output(with: input, useCases: useCases)
        process(input, with: router, useCases: useCases)
    }
}

private extension AccountPresenter {

    static let staticDisposeBag = DisposeBag()

    private static func output(with input: Input, useCases: UseCases) -> Output {

        var account: AccountModel?
        let accountRelay = PublishSubject<AccountModel?>()
        AuthManager.shared.isLoggedIn { result in
            switch result {
                case .success(let user):
                    if let phone = user.phoneNumberString {
                        let dial_code = String(phone.prefix(phone.count - 10))
                        useCases.input.setSelectedCountry(phone)
                    }
                    account = AccountModel(
                        name: user.displayNameString ?? "",
                        imageURL: user.photoURLString,
                        email: user.emailString ?? "",
                        phone: user.phoneNumberString ?? ""
                    )
                case .failure(let error):
                    ()
            }
        }
        useCases.output.selectedCountry
            .drive(onNext: { country in
                account?.country = country
                accountRelay.onNext(account)
            })
            .disposed(by: staticDisposeBag)

        let dataSource =
        [
            [
                AccountItemModel(.image),
                AccountItemModel(.name),
                AccountItemModel(.email),
                AccountItemModel(.phone)
            ],
            [
                AccountItemModel(.signout),
                AccountItemModel(.delete)
            ]
        ]
        let dataSourceDriver = Driver.just(dataSource)

        return (
            user: accountRelay.asDriver(onErrorJustReturn: nil),
            dataSource: dataSourceDriver,
            countryCode: useCases.output.selectedCountry,
            isModified: Driver.just(false)
        )
    }

    private func process(_ input: Input, with router: AccountRouter, useCases: UseCases) {
        ()
    }
}
