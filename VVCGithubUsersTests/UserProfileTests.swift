//
//  UserProfileTests.swift
//  VVCGithubUsersTests
//
//  Created by SCI-Viennarz on 8/14/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import XCTest
import CoreData
@testable import VVCGithubUsers

class UserProfileTests: XCTestCase {
  var persistentContainer: NSPersistentContainer = {

     let container = NSPersistentContainer(name: "VVCGithubUsers")
     container.loadPersistentStores(completionHandler: { (storeDescription, error) in
       if let error = error as NSError? {

         fatalError("Unresolved error \(error), \(error.userInfo)")
       }
     })
     return container
   }()

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
    
    let jsonData: Data = jsonString.data(using: .utf8)!
    
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
      fatalError("Failed to retrieve managed object context")
    }

    let managedObjectContext = self.persistentContainer.viewContext
    let decoder = JSONDecoder()
    decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
    
    XCTAssertNoThrow(try decoder.decode(UserProfile.self, from: jsonData))
  }
  
  func testSaveNotes() {
    let notes = "Ryu ga waga teki wo kurau!"
    
    let p = ProfileViewModel(userName: "mojombo", id: 1)
    
    p.save(notes: notes) { (error) in
      XCTAssert(error == nil)
    }
  }
  
  func testCanUpdateUserHasNotes() {
    
    let p = ProfileViewModel(userName: "mojombo", id: 1)
    
    p.updateUserHasNotes { (error) in
      XCTAssert(error == nil)
    }
  }

}
