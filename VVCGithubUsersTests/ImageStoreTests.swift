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

  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

  func testCanSaveImage() {
    let image = UIImage(systemName: "person")
    
    ImageStoreManager.shared.saveToDisk(image!, fileName: "test")
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
