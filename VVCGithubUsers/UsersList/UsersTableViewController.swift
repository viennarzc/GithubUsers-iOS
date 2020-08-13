//
//  UsersTableViewController.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
  
  var githubUsers: [GitHubUser] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
    NetworkManager.shared.fetchUsers { (users, error) in
      
      if let error = error {
        print(error)
        return
      }
      
      if let users = users {
        self.githubUsers = users
        
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }

      }
      
    }
    
    tableView.register(UserItemTableViewCell.nib, forCellReuseIdentifier: UserItemTableViewCell.reuseIdentifierString)
  }
  

}

//MARK: - TableView DataSource and Delegate


extension UsersTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return githubUsers.count
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
    
    cell.userNameLabel.text = githubUsers[indexPath.row].login

    return cell
  }
}

