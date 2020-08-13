//
//  UserProfileTests.swift
//  VVCGithubUsersTests
//
//  Created by SCI-Viennarz on 8/14/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import XCTest
@testable import VVCGithubUsers

class UserProfileTests: XCTestCase {

  func testFetchUserProfileHasData() {
    NetworkManager.shared.fetchUser(with: "mojombo") { (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let user):
        XCTAssertNotNil(user)
      }
    }
  }

}
