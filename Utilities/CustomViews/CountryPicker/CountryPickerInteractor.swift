//
//  CountryPickerInteractor.swift
//  Spendora
//
//  Created by Goel, Pratik | RIEPL on 23/04/23.
//

import Foundation
import RxSwift
import RxCocoa

public class CountryPickerInteractor {

    private var countriesRelay = BehaviorRelay<[Country]>(value: [])
    public lazy var countriesList = countriesRelay.asDriver(onErrorJustReturn: [])

    private var selectedCountryRelay = PublishSubject<Country?>()
    public lazy var selectedCountry = selectedCountryRelay.asDriver(onErrorJustReturn: nil)

    public init() {
        fetchCountryCodes(completion: { result in
            switch result {
                case .success(let countries):
                    self.countriesRelay.accept(countries)
                case .failure(let error):
                    print(error.localizedDescription)
            }
        })
    }

    func fetchCountryCodes(completion: @escaping (Result<[Country], Error>) -> Void) {
        do {
            let apiManager = try APIManager<[Country]>(fileName: "country_dial_info")
            let countryCodes = apiManager.data!
            completion(.success(countryCodes))
        } catch {
            completion(.failure(error))
        }
    }

    public func setSelectedCountry(_ country: Country) {
        selectedCountryRelay.onNext(country)
    }

}
