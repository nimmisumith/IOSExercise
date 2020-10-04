//
//  APIServiceTests.swift
//  IOSExerciseTests
//
//  Created by Nimmi P on 04/10/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import XCTest
@testable import IOSExercise

class APIServiceTests: XCTestCase {
    
    var tc: ApiCalls?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        tc = ApiCalls()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        tc = nil
        super.tearDown()
    }
    
    func test_getJsonFromUrl(){
        
        let tc = self.tc!
        
        let expect = XCTestExpectation(description: "callback")
        
        tc.getJsonFromUrl(complete: { (success, rows, error) in
            
            expect.fulfill()
            XCTAssertEqual(rows.count, 13)
            
            for row in rows{
                XCTAssertNotNil(row.rowtitle)
            }
            
        })
        
        wait(for: [expect], timeout: 6.0)
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
