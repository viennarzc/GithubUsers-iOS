//
//  PersistenceManager.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/19/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager {
  public static let shared = PersistenceManager()
  
  struct EntityName {
    static let userProfile = String("\(UserProfile.self)")
    static let githubUser = String("\(GitHubUser.self)")
  }
  
  var persistentContainer: NSPersistentContainer = {

    let container = NSPersistentContainer(name: "VVCGithubUsers")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {

        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  func saveContext(forContext context: NSManagedObjectContext) {
      if context.hasChanges {
          context.performAndWait {
              do {
                  try context.save()
              } catch {
                  let nserror = error as NSError
                  print("Error when saving !!! \(nserror.localizedDescription)")
                  print("Callstack :")
                  for symbol: String in Thread.callStackSymbols {
                      print(" > \(symbol)")
                  }
              }
          }
      }
  }
  
  //private background thread
  func savePrivateContext(for context: NSManagedObjectContext) {
    let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    privateMOC.parent = context
    privateMOC.performAndWait {
        saveContext(forContext: privateMOC)
    }
    
    saveContext(forContext: context)
  }
  
  
  
  
}
