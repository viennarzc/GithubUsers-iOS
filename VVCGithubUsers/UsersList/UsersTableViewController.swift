//
//  UsersTableViewController.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

  var viewModel = UsersTableViewModel()

  struct SegueIdentifier {
    static let profile = "goToProfile"
  }

  private var pendingRequestWorkItem: DispatchWorkItem?

  //MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    tableView.register(UserItemTableViewCell.nib, forCellReuseIdentifier: UserItemTableViewCell.reuseIdentifierString)
    tableView.register(NotedUserItemTableViewCell.nib, forCellReuseIdentifier: NotedUserItemTableViewCell.reuseIdentifierString)
    tableView.register(InvertedUserItemTableViewCell.nib, forCellReuseIdentifier: InvertedUserItemTableViewCell.reuseIdentifierString)

    tableView.separatorStyle = .none

    tableView.backgroundColor = .systemGray5

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    viewModel.fetchUsers { (error) in
      guard let error = error else {

        DispatchQueue.main.async {
          self.tableView.reloadData()
        }

        return

      }

      print(error)

    }
  }

  //MARK: - Segue


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == SegueIdentifier.profile,
      let destVC = segue.destination as? ProfileViewController,
      let _ = viewModel.selectedUser {

      destVC.viewModel = viewModel.profileViewModel

    }

  }

}

//MARK: - TableView DataSource and Delegate


extension UsersTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.cellViewModels.count
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }


  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }

  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

    if let visiblePaths = tableView.indexPathsForVisibleRows,
      visiblePaths.contains([0, viewModel.cellViewModels.count - 1]) {

      fetchMoreUsers(in: tableView)
    }

    showLoadingIndicator(in: tableView, indexPath: indexPath)

  }

  func fetchMoreUsers(in tableView: UITableView, delay: Int = 1000) {
    pendingRequestWorkItem?.cancel()

    let requestWorkItem = DispatchWorkItem { [weak self] in
      // last cell is partially or fully visible
      guard let s = self else { return }

      s.viewModel.fetchMoreUsers { (error) in
        if let error = error {
          print(error)

          return
        }

        DispatchQueue.main.async {
          tableView.reloadData()
        }

      }

    }

    pendingRequestWorkItem = requestWorkItem
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay), execute: requestWorkItem)
  }

  func showLoadingIndicator(in tableView: UITableView, indexPath: IndexPath) {

    let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
    if indexPath.row == lastRowIndex {

      let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
      spinner.startAnimating()
      spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

      tableView.tableFooterView = spinner
      tableView.tableFooterView?.isHidden = false

    }
  }

  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    viewModel.setSelectedUser(indexPath: indexPath)
    return indexPath
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: SegueIdentifier.profile, sender: self)
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = viewModel.cellViewModels[indexPath.row].cellInstance(tableView: tableView, indexPath: indexPath)

    return cell
  }
}

