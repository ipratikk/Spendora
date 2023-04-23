//
//  CountryPickerViewController.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 20/04/23.
//

import UIKit
import RxSwift
import RxCocoa

enum AuthType {
    case signup
    case signin
}

protocol CountryPickerPresentation {

    typealias Input = (
        selectedCountry: Driver<Country?>,
        ()
    )

    typealias Output = (
        countries: Driver<[Country]>,
        ()
    )

    typealias Subviews = (
        noData: UIView?,
        ()
    )

    typealias producer = (Input) -> CountryPickerPresentation

    var input: Input { get }
    var output: Output { get }
    var subviews: Subviews { get }
}

class CountryPickerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var dataSource = CountryListModel()
    private var filteredData = CountryListModel()
    private var _tableViewDataSource = [String: [Country]]()
    private var _tableViewSectionsArray = [String]()
    private var selectedCountry: [Country] = []

    private var selectedCountryRelay = PublishSubject<Country?>()
    private lazy var selectedCountryDriver = selectedCountryRelay.asDriver(onErrorJustReturn: nil)

    private var presenter: CountryPickerPresentation!
    var presenterProducer: ((CountryPickerPresentation.Input) -> CountryPickerPresentation)!

    let disposeBag = DisposeBag()

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    func setupUI() {
        title = "Select Country"
        setupTableView()
        initSearchController()
    }

    func setupBindings() {
        let input = ( selectedCountry: selectedCountryDriver, ())
        presenter = presenterProducer(input)

        presenter.output.countries
            .drive(onNext:{ [weak self] countries in
                guard let sself = self else { return }
                sself.dataSource.countries = countries
                sself.filteredData = sself.dataSource
                sself.refreshTable()
            })
            .disposed(by: disposeBag)

        if let noDataView = presenter.subviews.noData {
            noDataView.frame = tableView.bounds
            tableView.backgroundView = noDataView
        }
    }

    func setupTableView() {
        tableView.registerCellNib(CountryTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }

    func initSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchBar.delegate = self
        definesPresentationContext = false
    }


    func refreshTable() {
        let filteredData = filteredData.getNameSortedDictionary()
        _tableViewDataSource = filteredData.dataSourceDictionary
        _tableViewSectionsArray = filteredData.sectionNamesArray
        DispatchQueue.main.async {
            self.tableView.backgroundView?.isHidden = self._tableViewSectionsArray.count != 0
            self.tableView.reloadData()
        }
    }
}

extension CountryPickerViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        filterForSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            // Dismiss keyboard and hide search bar
        searchBar.resignFirstResponder()
        searchController.isActive = false
    }

    func filterForSearchText(_ searchText: String) {
        var filteredCountries = dataSource.countries

        if !searchText.isEmpty {
            filteredCountries = filteredCountries.filter { country in
                return country.name.lowercased().contains(searchText.lowercased())
            }
        }
        filteredData.countries = filteredCountries
        refreshTable()
    }

}

extension CountryPickerViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return _tableViewSectionsArray.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return _tableViewSectionsArray
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tableViewDataSource[_tableViewSectionsArray[section]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        let country: Country! = _tableViewDataSource[_tableViewSectionsArray[indexPath.section]]?[indexPath.row]
        cell.setup(country: country)
        cell.setRowSelected(country.name == selectedCountry.first?.name, animated: true)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var country: Country! = _tableViewDataSource[_tableViewSectionsArray[indexPath.section]]?[indexPath.row]
        if let alreadySelectedIndex = findIndexPathForFirstMatchedRow() {
            updateSelected(alreadySelectedIndex, selected: false)
            updateSelected(indexPath, selected: true)
            refreshTable()
        } else {
            country.isSelected = true
            let cell = tableView.cellForRow(at: indexPath) as! CountryTableViewCell
            cell.setRowSelected(true, animated: true)
        }
        setSelectedCountry(country)
        searchController.searchBar.resignFirstResponder()
    }

    func updateSelected(_ indexPath: IndexPath, selected: Bool) {
        _tableViewDataSource[_tableViewSectionsArray[indexPath.section]]?[indexPath.row].isSelected = selected
        selectedCountryRelay.onNext(_tableViewDataSource[_tableViewSectionsArray[indexPath.section]]?[indexPath.row])
    }

    func setSelectedCountry(_ country: Country) {
        selectedCountry.removeAll()
        selectedCountry.append(country)
    }

    func findIndexPathForFirstMatchedRow() -> IndexPath? {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                let country: Country! = _tableViewDataSource[_tableViewSectionsArray[section]]?[row]
                if country.name == selectedCountry.first?.name {
                    return indexPath
                }
            }
        }
        return nil
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _tableViewSectionsArray[section]
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let sectionNumber = _tableViewSectionsArray.firstIndex(of: title) ?? 0
        tableView.scrollToRow(at: IndexPath(row: 0, section: sectionNumber), at: .top, animated: true)
        return sectionNumber
    }
}

extension CountryPickerViewController {
    func fetchCountryCodes(completion: @escaping (Result<[Country], Error>) -> Void) {
        do {
            let apiManager = try APIManager<[Country]>(fileName: "country_dial_info")
            let countryCodes = apiManager.data!
            completion(.success(countryCodes))
        } catch {
            completion(.failure(error))
        }
    }
}
