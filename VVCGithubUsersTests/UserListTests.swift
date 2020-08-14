//
//  UserListTests.swift
//  VVCGithubUsersTests
//
//  Created by SCI-Viennarz on 8/13/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import XCTest

@testable import VVCGithubUsers
import CoreData

class UserListTests: XCTestCase {
  
  var persistentContainer: NSPersistentContainer = {

     let container = NSPersistentContainer(name: "VVCGithubUsers")
     container.loadPersistentStores(completionHandler: { (storeDescription, error) in
       if let error = error as NSError? {

         fatalError("Unresolved error \(error), \(error.userInfo)")
       }
     })
     return container
   }()


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
  
  func testDecodingUserLists() throws {
    guard let path = Bundle.main.url(forResource: "users", withExtension: "json") else { return }

    
    guard let data = try? Data(contentsOf: path) else { return }
    
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext else {
      fatalError("Failed to retrieve managed object context")
    }

    let managedObjectContext = self.persistentContainer.viewContext
    let decoder = JSONDecoder()
    decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
    
    XCTAssertNoThrow(try decoder.decode([GitHubUser].self, from: data))
  }

  

}
