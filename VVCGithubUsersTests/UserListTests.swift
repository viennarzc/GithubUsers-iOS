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

  func testDecodingUserProfile() throws {
    let jsonString = """
      {
        "login": "mojombo",
        "id": 1,
        "node_id": "MDQ6VXNlcjE=",
        "avatar_url": "https://avatars0.githubusercontent.com/u/1?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/mojombo",
        "html_url": "https://github.com/mojombo",
        "followers_url": "https://api.github.com/users/mojombo/followers",
        "following_url": "https://api.github.com/users/mojombo/following{/other_user}",
        "gists_url": "https://api.github.com/users/mojombo/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/mojombo/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/mojombo/subscriptions",
        "organizations_url": "https://api.github.com/users/mojombo/orgs",
        "repos_url": "https://api.github.com/users/mojombo/repos",
        "events_url": "https://api.github.com/users/mojombo/events{/privacy}",
        "received_events_url": "https://api.github.com/users/mojombo/received_events",
        "type": "User",
        "site_admin": false,
        "name": "Tom Preston-Werner",
        "company": null,
        "blog": "http://tom.preston-werner.com",
        "location": "San Francisco",
        "email": null,
        "hireable": null,
        "bio": null,
        "twitter_username": null,
        "public_repos": 62,
        "public_gists": 62,
        "followers": 22074,
        "following": 11,
        "created_at": "2007-10-20T05:24:19Z",
        "updated_at": "2020-08-04T22:12:46Z"
      }

    """
    


    /// When the Data initializer is throwing an error, the test will fail.
    let jsonData: Data = jsonString.data(using: .utf8)!

    /// The `XCTAssertNoThrow` can be used to get extra context about the throw
    XCTAssertNoThrow(try JSONDecoder().decode(UserProfile.self, from: jsonData))
  }

}
