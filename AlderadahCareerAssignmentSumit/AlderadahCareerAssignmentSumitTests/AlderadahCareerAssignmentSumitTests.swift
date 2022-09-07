//
//  AlderadahCareerAssignmentSumitTests.swift
//  AlderadahCareerAssignmentSumitTests
//
//  Created by Technology on 03/09/22.
//

import XCTest
@testable import AlderadahCareerAssignmentSumit

class AlderadahCareerAssignmentSumitTests: XCTestCase {
    var sut: Application!
    let networkMonitor = NetworkMonitor.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        try super.setUpWithError()
        
        sut = Application.init(id: "2", userId: "3", email: "xyz@yopmail.com", firstName: "Me", lastName: "Test", mobile: "2233445566", resumeFilePath: nil, resumeScore: "9", status: "1", linkedInURL: nil, githubURL: nil, otherURL: nil, jobId: "3412", fileAccountId: nil, fileId: nil, fileUniquifier: nil, systemStatus: "1", skills: "[\"QA\",\"Flutter\",\"ReactNative\",\"Technical Manager\",\"Java\",\"Android\",\"DevOps\",\"NodeJS\"]", resumeFileName: nil, createdAt: "2022-09-06T09:16:08.740Z")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        sut = nil
        try super.tearDownWithError()
                
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testResumeScore() {
      // given
        let guess = sut.getScore()

      // when
        let statusInt = Application.getStatusIntValue(score: guess)

      // then
        XCTAssertEqual(Int(sut.resumeScore), guess, "Score computed and assigned to application is wrong")
        XCTAssertEqual(Int(sut.systemStatus), statusInt, "status assigned to appication is wrong")

    }
    
    func testStatusForBestAssignment() {
        let score = 18
        
        let statusInt = Application.getStatusIntValue(score: score)
        let appStatus = ApplicationStatus.init(rawValue: statusInt)
        
        XCTAssertEqual(ApplicationStatus.BestAccepted, appStatus, "Status is wrongly interpretted")

    }
    
    func testStatusForSelectedAssignment() {
                
        let score = 14
        
        let statusInt = Application.getStatusIntValue(score: score)
        let appStatus = ApplicationStatus.init(rawValue: statusInt)
        
        XCTAssertEqual(ApplicationStatus.Accepted, appStatus, "Status is wrongly interpretted")

    }
    
    func testStatusForAppliedAssignment() {
        let score = 9
        
        let statusInt = Application.getStatusIntValue(score: score)
        let appStatus = ApplicationStatus.init(rawValue: statusInt)
        
        XCTAssertEqual(ApplicationStatus.Applied, appStatus, "Status is wrongly interpretted")

    }
    
    func testStatusForRejectedAssignment() {
        let score = 2
        
        let statusInt = Application.getStatusIntValue(score: score)
        let appStatus = ApplicationStatus.init(rawValue: statusInt)
        
        XCTAssertEqual(ApplicationStatus.Rejected, appStatus, "Status is wrongly interpretted")

    }
    
    func testUpload() throws {
      try XCTSkipUnless(
        networkMonitor.isReachable,
        "Network connectivity needed for this test."
      )

        // given
        let filledData = sut.getDictionary()
        let skills = sut.getSkillsArray()
        let resumeInfo = sut.getResumeInfo()
        
        let promise = expectation(description: "Completion handler invoked")
        var responseErrorString: String?
        var app: Application?
        
        //Wehn
        WebRequests.addApplication(dataInfo: filledData, resumeInfo: resumeInfo, skills: skills) { rapp, errorString in
            responseErrorString = errorString
            app = rapp
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)

        // then
        XCTAssertNil(responseErrorString)
        XCTAssertNotNil(app)
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
