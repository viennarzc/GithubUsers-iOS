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

  func testSaveNotesWithLargeNumberOfCharacters() {
    let notes = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam suscipit sit amet dui sed fringilla. In malesuada placerat velit, vel tincidunt odio malesuada egestas. Praesent fringilla, elit vitae blandit fermentum, eros justo viverra lorem, eget convallis tortor sem vitae arcu. Ut a nulla bibendum, molestie tortor bibendum, porta metus. Maecenas interdum urna vel dictum placerat. Sed id odio vestibulum, dapibus nisl sed, euismod augue. Vivamus pellentesque volutpat metus, ac egestas erat facilisis sed. Ut sollicitudin varius nisi vel egestas. Ut vitae mauris velit. Praesent mauris velit, tristique at mi et, facilisis sollicitudin nulla. Sed nisi dolor, lobortis in justo et, mollis efficitur lacus.

        Sed iaculis euismod leo ut tempor. Cras neque diam, rhoncus ut dapibus at, semper efficitur neque. Mauris convallis, nunc in dapibus aliquet, enim lectus tincidunt metus, nec tristique lectus augue a velit. Cras nec sem quis urna pretium fermentum. Morbi dignissim libero pellentesque dictum elementum. Duis eu dignissim quam, sed sollicitudin urna. Donec ut arcu et erat malesuada vehicula sed vel ex. Duis nunc felis, laoreet in sem vitae, sagittis ornare odio. In hac habitasse platea dictumst. Sed eleifend sit amet lorem id consequat.

        Integer rhoncus finibus molestie. Vestibulum hendrerit dapibus turpis eget sollicitudin. Nunc at nunc maximus, malesuada neque et, eleifend ex. In facilisis condimentum enim at tempor. Vestibulum mollis felis nec nulla mollis, eu suscipit diam lobortis. Integer volutpat hendrerit justo vel porta. Vivamus eu porta diam. Aliquam mollis, sapien sit amet cursus eleifend, dolor urna placerat elit, in sagittis ipsum ipsum ut libero. Nunc et posuere sem. Mauris lacus erat, posuere ut bibendum non, tincidunt vel metus.

        Praesent tristique ex volutpat, porttitor orci a, finibus urna. Mauris vel ligula id nulla volutpat porta sit amet porta risus. Nulla facilisi. In hac habitasse platea dictumst. Aenean vestibulum dignissim dolor id interdum. Cras placerat nibh sit amet faucibus sollicitudin. Curabitur consectetur suscipit turpis, sed auctor nulla elementum at.

        Curabitur ultrices tincidunt auctor. Sed auctor ligula eget ipsum rutrum tristique. Donec id orci at eros iaculis convallis. Praesent placerat dolor sed porta tincidunt. Morbi bibendum, sem ac scelerisque porta, eros ipsum porta est, cursus iaculis libero eros eu odio. Integer vitae iaculis lacus. Nam tincidunt ultrices facilisis.

      """

    let p = ProfileViewModel(userName: "mojombo", id: 1)

    p.save(notes: notes) { (error) in
      XCTAssert(error == nil)
    }
  }

  func testSaveNotesInPrivateQueueConcurrency() {
    let notes = "Ryu ga waga teki wo kurau!"

    let p = ProfileViewModel(userName: "mojombo", id: 1)

    p.saveInPrivateQueue(notes: notes) { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
  }

  func testSaveNotesInPrivateQueueConcurrencyWithLargeNumberOfCharacters() {
    let notes = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam suscipit sit amet dui sed fringilla. In malesuada placerat velit, vel tincidunt odio malesuada egestas. Praesent fringilla, elit vitae blandit fermentum, eros justo viverra lorem, eget convallis tortor sem vitae arcu. Ut a nulla bibendum, molestie tortor bibendum, porta metus. Maecenas interdum urna vel dictum placerat. Sed id odio vestibulum, dapibus nisl sed, euismod augue. Vivamus pellentesque volutpat metus, ac egestas erat facilisis sed. Ut sollicitudin varius nisi vel egestas. Ut vitae mauris velit. Praesent mauris velit, tristique at mi et, facilisis sollicitudin nulla. Sed nisi dolor, lobortis in justo et, mollis efficitur lacus.

    Sed iaculis euismod leo ut tempor. Cras neque diam, rhoncus ut dapibus at, semper efficitur neque. Mauris convallis, nunc in dapibus aliquet, enim lectus tincidunt metus, nec tristique lectus augue a velit. Cras nec sem quis urna pretium fermentum. Morbi dignissim libero pellentesque dictum elementum. Duis eu dignissim quam, sed sollicitudin urna. Donec ut arcu et erat malesuada vehicula sed vel ex. Duis nunc felis, laoreet in sem vitae, sagittis ornare odio. In hac habitasse platea dictumst. Sed eleifend sit amet lorem id consequat.

    Integer rhoncus finibus molestie. Vestibulum hendrerit dapibus turpis eget sollicitudin. Nunc at nunc maximus, malesuada neque et, eleifend ex. In facilisis condimentum enim at tempor. Vestibulum mollis felis nec nulla mollis, eu suscipit diam lobortis. Integer volutpat hendrerit justo vel porta. Vivamus eu porta diam. Aliquam mollis, sapien sit amet cursus eleifend, dolor urna placerat elit, in sagittis ipsum ipsum ut libero. Nunc et posuere sem. Mauris lacus erat, posuere ut bibendum non, tincidunt vel metus.

    Praesent tristique ex volutpat, porttitor orci a, finibus urna. Mauris vel ligula id nulla volutpat porta sit amet porta risus. Nulla facilisi. In hac habitasse platea dictumst. Aenean vestibulum dignissim dolor id interdum. Cras placerat nibh sit amet faucibus sollicitudin. Curabitur consectetur suscipit turpis, sed auctor nulla elementum at.

    Curabitur ultrices tincidunt auctor. Sed auctor ligula eget ipsum rutrum tristique. Donec id orci at eros iaculis convallis. Praesent placerat dolor sed porta tincidunt. Morbi bibendum, sem ac scelerisque porta, eros ipsum porta est, cursus iaculis libero eros eu odio. Integer vitae iaculis lacus. Nam tincidunt ultrices facilisis.

  """

    let p = ProfileViewModel(userName: "mojombo", id: 1)

    p.saveInPrivateQueue(notes: notes) { (error) in
      XCTAssert(error == nil, error!.localizedDescription)
    }
  }

  func testMeasureSaveNotesPrivateQueueConcurrency() {
    let notes = "Ryu ga waga teki wo kurau!"

    let p = ProfileViewModel(userName: "mojombo", id: 1)

    measure {
      p.saveInPrivateQueue(notes: notes) { (error) in

      }
    }
  }

  func testMeasureSaveNotes() {
    let notes = "Ryu ga waga teki wo kurau!"

    let p = ProfileViewModel(userName: "mojombo", id: 1)

    measure {
      p.save(notes: notes) { (error) in

      }
    }
  }

  func testCanUpdateUserHasNotes() {

    let p = ProfileViewModel(userName: "mojombo", id: 1)

    p.updateUserHasNotes { (error) in
      XCTAssert(error == nil)
    }
  }

}
