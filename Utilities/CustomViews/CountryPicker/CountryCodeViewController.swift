//
//  CountryCodeViewController.swift
//  Utilities
//
//  Created by Goel, Pratik | RIEPL on 20/04/23.
//

import UIKit

public class CountryCodeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var dataSource = CountryListModel()
    private var filteredData = CountryListModel()
    private var _tableViewDataSource = [String: [Country]]()
    private var _tableViewSectionsArray = [String]()
    private var selectedCountry: [Country] = []


    let searchController = UISearchController(searchResultsController: nil)

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select Country"
        tableView.registerCellNib(CountryTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        fetchCountryCodes { [weak self] result in
            guard let sself = self else { return }
            switch result {
                case .success(let countries):
                    sself.dataSource.countries = countries
                    sself.filteredData = sself.dataSource
                    sself.refreshTable()
                case .failure(let error):
                    print("Error fetching countries: \(error.localizedDescription)")
            }
        }
        initSearchController()
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
            self.tableView.reloadData()
        }
    }

}

extension CountryCodeViewController: UISearchBarDelegate, UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        filterForSearchText(searchText)
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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

extension CountryCodeViewController: UITableViewDataSource, UITableViewDelegate {

    public func numberOfSections(in tableView: UITableView) -> Int {
        return _tableViewSectionsArray.count
    }

    public func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return _tableViewSectionsArray
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tableViewDataSource[_tableViewSectionsArray[section]]?.count ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as! CountryTableViewCell
        let country: Country! = _tableViewDataSource[_tableViewSectionsArray[indexPath.section]]?[indexPath.row]
        cell.setup(country: country)
        cell.setRowSelected(country.name == selectedCountry.first?.name, animated: true)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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


    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return _tableViewSectionsArray[section]
    }

    public func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        let sectionNumber = _tableViewSectionsArray.firstIndex(of: title) ?? 0
        tableView.scrollToRow(at: IndexPath(row: 0, section: sectionNumber), at: .top, animated: true)
        return sectionNumber
    }
}

extension CountryCodeViewController {
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
