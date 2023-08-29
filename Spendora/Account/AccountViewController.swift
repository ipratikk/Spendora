//
//  AccountViewController.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 12/05/23.
//

import UIKit
import Utilities
import RxCocoa
import RxSwift

protocol AccountPresentation {
    typealias Output = (
        user: Driver<AccountModel?>,
        dataSource: Driver<[[AccountItemModel]]>,
        countryCode: Driver<Country?>,
        isModified: Driver<Bool>
    )

    typealias Input = (
        imageTap: Driver<Void>,
        nameText: Driver<String>,
        emailText: Driver<String>,
        phoneText: Driver<String>,
        countryBtnTap: Driver<Void>,
        deleteAccount: Driver<Void>,
        signOut: Driver<Void>
    )

    typealias producer = (Input) -> AccountPresentation

    var output: Output { get }
    var input: Input { get }
}

public class AccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var user: AccountModel?

    var dataSource: [[AccountItemModel]] = []

    private let isModifiedRelay = BehaviorRelay<Bool>(value: false)

    private let imageTapRelay = PublishSubject<Void>()
    private lazy var imageTapDriver = imageTapRelay.asDriver(onErrorJustReturn: ())

    private let deleteAccountTapRelay = PublishSubject<Void>()
    private lazy var deleteAccountTapDriver = deleteAccountTapRelay.asDriver(onErrorJustReturn: ())

    private let signoutTapRelay = PublishSubject<Void>()
    private lazy var signoutTapDriver = signoutTapRelay.asDriver(onErrorJustReturn: ())

    private let nameTextRelay = PublishSubject<String>()
    private lazy var nameTextDriver = nameTextRelay.asDriver(onErrorJustReturn: "")

    private let emailTextRelay = PublishSubject<String>()
    private lazy var emailTextDriver = emailTextRelay.asDriver(onErrorJustReturn: "")

    private let phoneNumberTextRelay = PublishSubject<String>()
    private lazy var phoneNumberTextDriver = phoneNumberTextRelay.asDriver(onErrorJustReturn: "")

    private let phoneNumberIconTapRelay = PublishSubject<Void>()
    private lazy var phoneNumberIconTapDriver = phoneNumberIconTapRelay.asDriver(onErrorJustReturn: ())

    private let disposeBag = DisposeBag()

    private var presenter: AccountPresentation!
    var presenterProducer: ((AccountPresentation.Input) -> AccountPresentation)!

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addKeyboardNotification(with: tableView)
        setupBindings()
    }

    func setupUI() {
        view.backgroundColor = .primaryBackground
        setupTableView()
        setBackgroundImage(imageName: "abstractBG", forView: self.view)
    }

    func setupBindings() {
        presenter = presenterProducer((
            imageTap: imageTapDriver,
            nameText: nameTextDriver,
            emailText: emailTextDriver,
            phoneText: phoneNumberTextDriver,
            countryBtnTap: phoneNumberIconTapDriver,
            deleteAccount: deleteAccountTapDriver,
            signOut: signoutTapDriver
        ))

        presenter.output.countryCode
            .drive(onNext: { country in
                self.user?.country = country
            })
            .disposed(by: disposeBag)

        presenter.output.user
            .drive(onNext: { user in
                self.user = user
            })
            .disposed(by: disposeBag)

        presenter.output.dataSource
            .drive(onNext: { items in
                self.dataSource = items
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        presenter.output.isModified
            .drive(onNext: { isModified in
                self.isModifiedRelay.accept(isModified)
            })
            .disposed(by: disposeBag)
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isExclusiveTouch = true
        tableView.backgroundColor = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none

        let footerView = AccountFooterView.loadFromNib()
        footerView.configure()

            // Assign the footer view to the table view's tableFooterView property
        tableView.tableFooterView = footerView
        tableView.tableFooterView?.frame.size.height = 100

        tableView.addDefaultShadow()
        tableView.removeBottomShadow()

        tableView.registerCellNib(AccountDetailsTableViewCell.self)
        tableView.registerCellNib(AccountHeaderTableViewCell.self)
        tableView.registerCellNib(AccountButtonTableViewCell.self)
    }

    func setBackgroundImage(imageName: String, forView view: UIView) {
            // Create a UIImageView with the desired image
        let backgroundImage = UIImage(named: imageName)
        let backgroundImageView = UIImageView(image: backgroundImage)

            // Set the content mode to scale the image appropriately
        backgroundImageView.contentMode = .scaleAspectFill

            // Add the image view as a subview to the target view
        view.addSubview(backgroundImageView)

            // Set the frame of the image view to match the target view's bounds
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

            // Send the image view to the back so that it appears as the background
        view.sendSubviewToBack(backgroundImageView)
    }
}

extension AccountViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section][indexPath.row]
        switch model.itemType {
            case .signout, .delete:
                return setupButtonCell(for: indexPath)
            case .image:
                return setupHeaderCell(for: indexPath)
            default:
                return setupDetailCell(for: indexPath)

        }
    }

    func setupHeaderCell(for indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountHeaderTableViewCell.self)) as! AccountHeaderTableViewCell
        guard let user = user else { return cell }
        cell.configure(for: user, with: model)
        cell.imageTap.rx.tap
            .bind(to: imageTapRelay)
            .disposed(by: disposeBag)
        return cell
    }

    func setupButtonCell(for indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountButtonTableViewCell.self), for: indexPath) as! AccountButtonTableViewCell
        cell.configure(with: model)
        cell.selectionStyle = .none
        switch model.itemType {
            case .signout:
                cell.button.rx.tap.bind(to: signoutTapRelay)
                    .disposed(by: disposeBag)
            case .delete:
                cell.button.rx.tap.bind(to: deleteAccountTapRelay)
                    .disposed(by: disposeBag)
            default:
                break
        }
        return cell
    }

    func setupDetailCell(for indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountDetailsTableViewCell.self), for: indexPath) as! AccountDetailsTableViewCell
        guard let user = self.user else { return cell }
        cell.configure(for: user, with: model)
        cell.selectionStyle = .none
        switch model.itemType {
            case .name:
                cell.detailText.rx.text.orEmpty
                    .bind(to: nameTextRelay)
                    .disposed(by: disposeBag)
            case .email:
                cell.detailEmailText.rx.text.orEmpty
                    .bind(to: emailTextRelay)
                    .disposed(by: disposeBag)
            case .phone:
                cell.detailPhoneText.rx.text.orEmpty
                    .bind(to: phoneNumberTextRelay)
                    .disposed(by: disposeBag)
                cell.detailPhoneIcon.rx.tap
                    .bind(to: phoneNumberIconTapRelay)
                    .disposed(by: disposeBag)
            default:
                break
        }
        return cell
    }
}

extension AccountViewController: UITableViewDelegate, UIScrollViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0, indexPath.row == 0 {
            return 200
        }
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
