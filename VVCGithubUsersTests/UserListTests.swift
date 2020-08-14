//
//  UserListTests.swift
//  VVCGithubUsersTests
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import XCTest

@testable import VVCGithubUsers

class UserListTests: XCTestCase {

  func testRequestGithubUsersHasData() {
    NetworkManager.shared.fetchUsers { (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let users):
        XCTAssert(!users.isEmpty)

      }
    }
  }

  

}
