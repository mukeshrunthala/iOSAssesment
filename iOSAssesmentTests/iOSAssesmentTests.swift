//
//  iOSAssesmentTests.swift
//  iOSAssesmentTests
//
//  Created by Mukesh Sharma on 28/02/22.
//

import XCTest
@testable import iOSAssesment

class iOSAssesmentTests: XCTestCase {

    var landingVC : LandingViewController!
    var navigationController : UINavigationController!
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        landingVC = storyboard.instantiateViewController(
            withIdentifier: "LandingViewController")
        as? LandingViewController
        
        navigationController = UINavigationController(rootViewController: landingVC)
        navigationController.loadViewIfNeeded()
        landingVC.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
    }
    func testSearchBarAvailable() {
         XCTAssertNotNil(landingVC.searchBar)
     }
     
     func testShouldSetSearchBarDelegate() {
         XCTAssertNotNil(landingVC.searchBar.delegate)
     }
    func testShouldSetTableViewDelegate() {
        XCTAssertNotNil(landingVC.tableView.delegate)
    }
}

