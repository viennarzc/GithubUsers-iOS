//
//  ImageStoreTests.swift
//  VVCGithubUsersTests
//
//  Created by SCI-Viennarz on 8/20/20.
//  Copyright © 2020 VVC. All rights reserved.
//

import XCTest

@testable import VVCGithubUsers

class ImageStoreTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testCanSaveImage() {
    let image = UIImage(systemName: "person")
    
    ImageStoreManager.shared.saveToDisk(image!, fileName: "test")
  }
  
  func testImageExistsOnDisk() {
    saveImage()
    
    let fileName = "test"
    
    let result = ImageStoreManager.shared.checkImageOnDiskIfExists(with: fileName)
    XCTAssert(result)
  }
  
  func testCanGetImage() {
    saveImage()
    
    let image = ImageStoreManager.shared.getImageFromDisk(of: "test")
    XCTAssert(image != nil)
    
  }
  
  func saveImage() {
    let image = UIImage(systemName: "person")
    
    ImageStoreManager.shared.saveToDisk(image!, fileName: "test")
  }

}
