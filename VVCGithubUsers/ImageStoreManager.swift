//
//  ImageCacheManager.swift
//  VVCGithubUsers
//
//  Created by SCI-Viennarz on 8/20/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import Foundation
import UIKit

final class ImageStoreManager {
  public static let shared = ImageStoreManager()

  func saveToDisk(_ image: UIImage, fileName: String) {

    if let data = image.pngData() {
      let filename = getDocumentsDirectory().appendingPathComponent("\(fileName).png")
      try? data.write(to: filename)
    }

  }

  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }

  func getImageFromDisk(of fileName: String) -> UIImage? {
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
    if let dirPath = paths.first {
      let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(fileName).png")
      return UIImage(contentsOfFile: imageURL.path)
      // Do whatever you want with the image
    }
    return nil
  }

}
