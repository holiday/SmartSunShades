//
//  SmartSunShadesCalculatorTests.swift
//  SmartSunShadesCalculatorTests
//
//  Created by Ramdeen, Rashaad on 5/24/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import XCTest
@testable import SmartSunShadesCalculator

class SmartSunShadesCalculatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPriceTableWidths() {
        let pt = PriceTable(fileName: "roller_shades_3", fileExtension: "csv")
        var highestWidth = pt.getHighestWidthIndex(108, widthFineInchIndex: 0)
        XCTAssertEqual(highestWidth, 14, "Highest index should be 14 for width 108")
        
        highestWidth = pt.getHighestWidthIndex(24, widthFineInchIndex:1)
        XCTAssertEqual(highestWidth, 2, "Highest index should be 2 for width 24 1/8")
        
        highestWidth = pt.getHighestWidthIndex(107, widthFineInchIndex:3)
        XCTAssertEqual(highestWidth, 14, "Highest index should be 13 for width 107 3/8")
        
        highestWidth = pt.getHighestWidthIndex(50, widthFineInchIndex:3)
        XCTAssertEqual(highestWidth, 6, "Highest index should be 6 for width 50 3/8")
    }
    
    func testPriceTableHeights() {
        let pt = PriceTable(fileName: "roller_shades_3", fileExtension: "csv")
        
        var highestHeight = pt.getHighestHeightIndex(52, heightFineInchIndex: 0)
        XCTAssertEqual(highestHeight, 4, "Highest index should be 14 for height 52")
        
        highestHeight = pt.getHighestHeightIndex(120, heightFineInchIndex: 1)
        XCTAssertEqual(highestHeight, 14, "Highest index should be 14 for height 120 1/8")
        
        highestHeight = pt.getHighestHeightIndex(115, heightFineInchIndex: 3)
        XCTAssertEqual(highestHeight, 14, "Highest index should be 14 for height 115 3/8")
        
        highestHeight = pt.getHighestHeightIndex(70, heightFineInchIndex: 3)
        XCTAssertEqual(highestHeight, 7, "Highest index should be 8 for height 70 3/8")
        
    }
    
    func testPriceTablePrices() {
        
        let pt = PriceTable(fileName: "roller_shades_3", fileExtension: "csv")
        
        var price = pt.getPrice(12, widthFineInchIndex: 0, height: 12, heightFineInchIndex: 0)
        XCTAssertEqual(price, 340.0)
        
        price = pt.getPrice(50, widthFineInchIndex: 3, height: 70, heightFineInchIndex: 2)
        XCTAssertEqual(price, 675.0)
        
        price = pt.getPrice(108, widthFineInchIndex: 3, height: 122, heightFineInchIndex: 2)
        XCTAssertEqual(price, 1795.0)
        
        price = pt.getPrice(72, widthFineInchIndex: 3, height: 72, heightFineInchIndex: 2)
        XCTAssertEqual(price, 1015.0)
        
    }
}
