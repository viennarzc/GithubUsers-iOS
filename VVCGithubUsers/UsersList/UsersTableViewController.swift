//
//  UsersTableViewController.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    tableView.register(UserItemTableViewCell.nib, forCellReuseIdentifier: UserItemTableViewCell.reuseIdentifierString)
  }
  

}

//MARK: - TableView DataSource and Delegate


extension UsersTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
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
    let cell: UserItemTableViewCell
      = tableView.dequeueReusableCell(withIdentifier: UserItemTableViewCell.reuseIdentifierString, for: indexPath) as! UserItemTableViewCell

    return cell
  }
}

