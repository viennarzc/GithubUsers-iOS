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
    
    if checkImageOnDiskIfExists(with: fileName) {
      return
    }
    
    if let data = image.jpegData(compressionQuality: 0.5) {
      let fileURL = getDocumentsDirectory().appendingPathComponent("\(fileName).png")

      do {
        try data.write(to: fileURL)
      } catch let error {
        print("Error saving with error", error )
      }
    }

  }

  private func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  func checkImageOnDiskIfExists(with fileName: String) -> Bool {
    let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
    let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
    let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
    if let dirPath = paths.first {
      let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("\(fileName).png")
      return (UIImage(contentsOfFile: imageURL.path) != nil)
      // Do whatever you want with the image
    }
    return false
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
