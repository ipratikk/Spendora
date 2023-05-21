//
//  AccountViewController.swift
//  Account
//
//  Created by Goel, Pratik | RIEPL on 12/05/23.
//

import UIKit
import Utilities

public class AccountViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var user: FirebaseUser?

    var dataSource: [[AccountItemModel]] = []

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .primaryBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isExclusiveTouch = true
        tableView.backgroundColor = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.separatorStyle = .none

            // Create a footer view
        let footerView = AccountFooterView.loadFromNib()
        footerView.configure()

            // Assign the footer view to the table view's tableFooterView property
        tableView.tableFooterView = footerView
        tableView.tableFooterView?.frame.size.height = 100

        setBackgroundImage(imageName: "abstractBG", forView: self.view)
//        tableView.addDefaultShadow(to: [.top, .left, .right])
        tableView.addDefaultShadow()
        tableView.removeBottomShadow()

        tableView.registerCellNib(AccountDetailsTableViewCell.self)
        tableView.registerCellNib(AccountHeaderTableViewCell.self)
        tableView.registerCellNib(AccountButtonTableViewCell.self)

        addKeyboardNotification(with: tableView)

        AuthManager.shared.isLoggedIn(completion: { result in
            switch result {
                case .success(let user):
                    self.user = user
                    self.setupDataSource()
                case .failure:
                    ()
            }
        })
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


    func setupDataSource() {
        guard let user = user else { return }
        dataSource =
        [
            [
                AccountItemModel(user: user, itemType: .image),
                AccountItemModel(user: user, itemType: .name),
                AccountItemModel(user: user, itemType: .email),
                AccountItemModel(user: user, itemType: .phone)
            ],
            [
                AccountItemModel(user: user, itemType: .signout),
                AccountItemModel(user: user, itemType: .delete)
            ]
        ]
        tableView.reloadData()
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
        guard indexPath.section == 0, indexPath.row == 0 else {
            switch model.itemType {
                case .signout, .delete:
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountButtonTableViewCell.self), for: indexPath) as! AccountButtonTableViewCell
                    cell.configure(with: model)
                    cell.selectionStyle = .none
                    return cell
                default:
                    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountDetailsTableViewCell.self), for: indexPath) as! AccountDetailsTableViewCell
                    cell.configure(with: model)
                    cell.selectionStyle = .none
                    return cell
            }
        }
        let headerCell = tableView.dequeueReusableCell(withIdentifier: String(describing: AccountHeaderTableViewCell.self)) as! AccountHeaderTableViewCell
        headerCell.setup(with: model)
        return headerCell
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
