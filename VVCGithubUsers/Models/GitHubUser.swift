//
//  GitHubUser.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import CoreData

class GitHubUser: NSManagedObject, Codable {
  @NSManaged var login: String
  @NSManaged var id: Int64
  @NSManaged var avatarURL: String
  @NSManaged var type: String
  @NSManaged var siteAdmin: Bool
  @NSManaged var hasNotes: Bool
  
  enum CodingKeys: String, CodingKey {
    case login
    case id
    case avatarURL = "avatar_url"
    case type
    case siteAdmin = "site_admin"

  }

  // MARK: - Decodable
  required convenience init(from decoder: Decoder) throws {
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
      let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
      let entity = NSEntityDescription.entity(forEntityName: "GitHubUser", in: managedObjectContext) else {
        fatalError("Failed to decode GitHubUser")
    }

    self.init(entity: entity, insertInto: managedObjectContext)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.login = try container.decode(String.self, forKey: .login)
    self.id = try container.decode(Int64.self, forKey: .id)
    self.avatarURL = try container.decode(String.self, forKey: .avatarURL)
    self.type = try container.decode(String.self, forKey: .type)
    self.siteAdmin = try container.decode(Bool.self, forKey: .siteAdmin)

  }

  // MARK: - Encodable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(login, forKey: .login)
    try container.encode(id, forKey: .id)
    try container.encode(avatarURL, forKey: .avatarURL)
    try container.encode(type, forKey: .type)
    try container.encode(siteAdmin, forKey: .siteAdmin)

  }

}

public extension CodingUserInfoKey {
  // Helper property to retrieve the Core Data managed object context
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}
