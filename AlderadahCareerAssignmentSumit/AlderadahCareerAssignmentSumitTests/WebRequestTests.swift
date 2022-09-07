//
//  WebRequestTests.swift
//  AlderadahCareerAssignmentSumitTests
//
//  Created by Technology on 07/09/22.
//

import XCTest
@testable import AlderadahCareerAssignmentSumit

class WebRequestTests: XCTestCase {
    let networkMonitor = NetworkMonitor.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }
    
    func testGetApplications() throws {
      try XCTSkipUnless(
        networkMonitor.isReachable,
        "Network connectivity needed for this test."
      )

        // given
        let promise = expectation(description: "Completion handler invoked")
        var responseErrorString: String?
        var app: ApplicationList?
        
        //When
        let askedCount = 10
        WebRequests.getApplications(page: 1, count: askedCount) { rapp, errorString in
            responseErrorString = errorString
            app = rapp
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseErrorString)
        XCTAssertNotNil(app)
        XCTAssertLessThanOrEqual(app!.items.count, askedCount, "We received less than or equal to count")

    }
    
    func testFileUpload() throws {
        try XCTSkipUnless(
          networkMonitor.isReachable,
          "Network connectivity needed for this test."
        )

          // given
        let promise = expectation(description: "Completion handler invoked")
        var responseErrorString: String?
        var upload: UploadFile?
          
        let testBundle = Bundle(for: type(of: self))
        guard let fileUrl = testBundle.url(forResource: "test", withExtension: "pdf")
          else { fatalError() }

        let data = try Data(contentsOf: fileUrl)
        let fileName = fileUrl.lastPathComponent
//            let fileExtension = url.pathExtension
        let mimetype = fileUrl.mimeType()
        
        //when
        WebRequests.uploadResumeFile(fileURL: fileUrl, fileData: data, fileName: fileName, mimeType: mimetype) { uploadF, errorString in
            responseErrorString = errorString
            upload = uploadF
            promise.fulfill()
        }
          
        wait(for: [promise], timeout: 10)
        // then
        XCTAssertNil(responseErrorString)
        XCTAssertNotNil(upload)
        XCTAssertNotNil(upload?.fileUrl)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
