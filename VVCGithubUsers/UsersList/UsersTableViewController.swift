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

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    tableView.register(UserItemTableViewCell.nib, forCellReuseIdentifier: UserItemTableViewCell.reuseIdentifierString)
    tableView.register(NotedUserItemTableViewCell.nib, forCellReuseIdentifier: NotedUserItemTableViewCell.reuseIdentifierString)


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
    return 60
  }


  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = viewModel.cellViewModels[indexPath.row].cellInstance(tableView: tableView, indexPath: indexPath)
    return cell
  }
}

