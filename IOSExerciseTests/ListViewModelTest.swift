//
//  ListViewModelTest.swift
//  IOSExerciseTests
//
//  Created by Nimmi P on 05/10/20.
//  Copyright © 2020 Nimmi P. All rights reserved.
//

import XCTest
@testable import IOSExercise

class ListViewModelTest: XCTestCase {

    var tc: ListViewModel!
    var mockAPIService: MockApiService!
    
    override func setUpWithError() throws {
        super.setUp()
        mockAPIService = MockApiService()
        tc = ListViewModel(apiService: mockAPIService)
    }

    override func tearDownWithError() throws {
        tc = nil
        mockAPIService = nil
        super.tearDown()
    }
 

    func test_create_cell_view_model() {
        // Given
        let rows = StubGenerator().stubData()
        mockAPIService.completeRows = rows
        let expect = XCTestExpectation(description: "reload closure triggered")
        tc.reloadTableViewClosure = { () in
            expect.fulfill()
        }

        // When
        tc.initFetch()
        mockAPIService.fetchSuccess()

        //No of cell viewmodel <= no. of rows as nil data removed
        XCTAssertLessThanOrEqual(tc.numberOfCells, rows.count)
       
        // XCTAssert reload closure triggered
        wait(for: [expect], timeout: 1.0)

    }

    func test_loading_when_fetching() {

        //Given
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        tc.updateLoadingStatus = { [weak tc] in
            loadingStatus = tc!.isLoading
            expect.fulfill()
        }

        //when fetching
        tc.initFetch()

        // Assert
        XCTAssertTrue( loadingStatus )

        // When finished fetching
        mockAPIService!.fetchSuccess()
        XCTAssertFalse( loadingStatus )

        wait(for: [expect], timeout: 1.0)
    }

    func test_get_cell_view_model() {

        //Given a sut with fetched data
        goToFetchDataFinished()

        let indexPath = IndexPath(row: 1, section: 0)
        let testRow = mockAPIService.completeRows[indexPath.row]

        // When
        let vm = tc.getCellViewModel(at: indexPath)

        //Assert
        XCTAssertEqual( vm.rowtitle, testRow.rowtitle)

    }

}
extension ListViewModelTest {
    private func goToFetchDataFinished() {
        mockAPIService.completeRows = StubGenerator().stubData()
        tc.initFetch()
        mockAPIService.fetchSuccess()
    }
}

class MockApiService: APIServiceProtocol {
    
  
    var completeRows: [RowModel] = [RowModel]()
    var completeClosure: ((Bool, [RowModel], Error?) -> ())!
    
    func getJsonFromUrl(complete: @escaping (Bool, [RowModel], Error?) -> ()) {
           completeClosure = complete
    }
    
    func fetchSuccess() {
        completeClosure( true, completeRows, nil )
    }
    
    func fetchFail(error: Error?) {
        completeClosure( false, completeRows, error )
    }
    
}

class StubGenerator {
    func stubData() -> [RowModel] {
        if let path = Bundle.main.path(forResource: "file", ofType: "json") {
            
            do {
                
                let json = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                
                let rdata = try decoder.decode(Rows.self,from: json)
                return rdata.rows
                
            }catch let error {
                print("parse error: \(error.localizedDescription)")
            }
            
        }
        return [RowModel]()
    }
}
