//
//  GitHubUser.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/12/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation

struct GitHubUser: Codable {
  let login: String
  let id: Int
  let nodeID: String
  let avatarURL: String
  let gravatarID: String
  let url: String
  let htmlURL: String
  let followersURL: String
  let followingURL: String
  let gistsURL: String
  let starredURL: String
  let subscriptionsURL: String
  let organizationsURL: String
  let reposURL: String
  let eventsURL: String
  let receivedEventsURL: String
  let type: String
  let siteAdmin: Bool
  
  
  var hasNotes: Bool {
    notes != nil && notes != ""
  }
  
  var notes: String? {
    ""
  }

  enum CodingKeys: String, CodingKey {
    case login
    case id
    case nodeID = "node_id"
    case avatarURL = "avatar_url"
    case gravatarID = "gravatar_id"
    case url
    case htmlURL = "html_url"
    case followersURL = "followers_url"
    case followingURL = "following_url"
    case gistsURL = "gists_url"
    case starredURL = "starred_url"
    case subscriptionsURL = "subscriptions_url"
    case organizationsURL = "organizations_url"
    case reposURL = "repos_url"
    case eventsURL = "events_url"
    case receivedEventsURL = "received_events_url"
    case type
    case siteAdmin = "site_admin"
  }

}
