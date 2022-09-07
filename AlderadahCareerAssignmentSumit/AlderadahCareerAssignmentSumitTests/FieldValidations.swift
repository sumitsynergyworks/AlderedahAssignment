//
//  FieldValidations.swift
//  AlderadahCareerAssignmentSumitTests
//
//  Created by Technology on 07/09/22.
//

import XCTest
@testable import AlderadahCareerAssignmentSumit

class FieldValidations: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLoginPageFieldsValidations() throws {
        let vc = StoryboardControllerIds.appStoryboard().instantiateViewController(identifier: LoginVC.identifier()) as! LoginVC
        vc.loadViewIfNeeded() // Make sure text field is loaded
        let email = "test"
        let efield = vc._emailTF
        efield?.text = email
        // Call through field.delegate, not through vc
        efield!.delegate?.textFieldDidEndEditing?(efield!)

        XCTAssertNotEqual(efield?.text, email, "Taking Non Email as well")
        XCTAssertTrue(vc._passwordTF.isSecureTextEntry, "Not secured")
    }
    
    func testSignUpFieldsValidations() throws {
        let vc = StoryboardControllerIds.appStoryboard().instantiateViewController(identifier: SignupVC.identifier()) as! SignupVC
        vc.loadViewIfNeeded() // Make sure text field is loaded
        let email = "test"
        let efield = vc._emailTF
        efield?.text = email
        // Call through field.delegate, not through vc
        efield!.delegate?.textFieldDidEndEditing?(efield!)

        XCTAssertNotEqual(efield?.text, email, "Taking Non Email as well")
        XCTAssertTrue(vc._passwordTF.isSecureTextEntry, "Not secured")
    }
    
    func testStringValidationForNameEmailPhoneNumberURL() throws {
        let invalidphoneNumber = "123sd323"
        let validphoneNumber = "9876543210"
        
        let validAlphaChars = "asfsdA"
        let invalidAlphaChars = "asfsdA234"
        
        let validEmailId = "xyz@yopmail.com"
        let invalidEmailId = "xyz"
        
        let validURL = "https://www.google.com"
        let invalidURL = "coms"
        
        XCTAssertTrue(validphoneNumber.isValidPhone(), "Not validating correct phone")
        XCTAssertFalse(invalidphoneNumber.isValidPhone(), "Validating wrong phones")
        
        XCTAssertTrue(validAlphaChars.isOnlyalpha(), "Not validating correct alpha values")
        XCTAssertFalse(invalidAlphaChars.isOnlyalpha(), "Validating wrong alpha")

        XCTAssertTrue(validEmailId.isValidEmailID(), "Not validating correct Email")
        XCTAssertFalse(invalidEmailId.isValidEmailID(), "Validating wrong Email")

        XCTAssertTrue(validURL.isValidURL(), "Not validating correct URL")
        XCTAssertFalse(invalidURL.isValidURL(), "Validating wrong URL")

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
