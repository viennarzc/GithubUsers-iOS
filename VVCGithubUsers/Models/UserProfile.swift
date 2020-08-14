//
//  UserProfile.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/14/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import CoreData

class UserProfile: NSManagedObject, Codable {
  @NSManaged var login: String
  @NSManaged var followers: Int
  @NSManaged var following: Int
  @NSManaged var avatarURL: String
  @NSManaged var name: String
  @NSManaged var company: String?
  @NSManaged var blog: String?

  enum CodingKeys: String, CodingKey {
    case login
    case following
    case followers
    case avatarURL = "avatar_url"
    case name
    case company
    case blog
  }

  // MARK: - Decodable
  required convenience init(from decoder: Decoder) throws {
    guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
      let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
      let entity = NSEntityDescription.entity(forEntityName: "UserProfile", in: managedObjectContext) else {
        fatalError("Failed to decode UserProfile")
    }

    self.init(entity: entity, insertInto: managedObjectContext)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.login = try container.decode(String.self, forKey: .login)
    self.following = try container.decode(Int.self, forKey: .following)
    self.followers = try container.decode(Int.self, forKey: .followers)
    self.avatarURL = try container.decode(String.self, forKey: .avatarURL)
    self.name = try container.decode(String.self, forKey: .name)
    self.company = try container.decodeIfPresent(String.self, forKey: .company)
    self.blog = try container.decodeIfPresent(String.self, forKey: .blog)

  }

  // MARK: - Encodable
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(login, forKey: .login)
    try container.encode(following, forKey: .following)
    try container.encode(followers, forKey: .followers)
    try container.encode(avatarURL, forKey: .avatarURL)
    try container.encode(name, forKey: .name)
    try container.encode(company, forKey: .company)
    try container.encode(blog, forKey: .blog)
  }

}
