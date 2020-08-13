//
//  UserProfile.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/14/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
  let login: String
  let followers: Int
  let following: Int
  let avatarURL: String
  let name: String
  let company: String?
  let blog: String?
  
  enum CodingKeys: String, CodingKey {
    case login
    case following
    case followers
    case avatarURL = "avatar_url"
    case name
    case company
    case blog
  }
  
}
