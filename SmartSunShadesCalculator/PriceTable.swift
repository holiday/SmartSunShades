//
//  PriceTable.swift
//  SmartSunShadesCalculator
//
//  Created by Ramdeen, Rashaad on 5/12/16.
//  Copyright © 2016 Ramdeen, Rashaad. All rights reserved.
//

import UIKit

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValidForRow(_ row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValidForRow(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}


open class PriceTable: NSObject {
    
    enum ParsingError: Error {
        case fileNotFound(String)
    }

//    var rows = Array<Array<Double>>()
    var widths = [Int]()
    var heights = [Int]()
    
    var matrix:Matrix!
    
    static var cachedMatrix:[String:Matrix] = [String:Matrix]()
    static var cachedWidths:[String:[Int]] = [String:[Int]]()
    static var cachedHeights:[String:[Int]] = [String:[Int]]()
    
    init(fileName:String, fileExtension:String) {
        super.init()
        
        if PriceTable.cachedMatrix.index(forKey: fileName) != nil {
            self.matrix = PriceTable.cachedMatrix[fileName]
            self.widths = PriceTable.cachedWidths[fileName]!
            self.heights = PriceTable.cachedHeights[fileName]!
            return
        }
        
        //Open the file using its name and extension
        let filePath = Bundle.main.path(forResource: fileName,ofType:fileExtension)
        
        do {
            
            if filePath == nil {
                throw ParsingError.fileNotFound("Unable to find file \(fileName).\(fileExtension)")
            }
            
            //Read the data from the file
            let data = try String(contentsOfFile: filePath!, encoding: String.Encoding.utf8)
            
            var rowsAsStrings:[String]?
            
            rowsAsStrings = data.components(separatedBy: "\r")
            
            self.generateArrayOfWidths(rowsAsStrings!)
            self.generateArrayOfHeights(rowsAsStrings!)
            
            self.createMatrix(rowsAsStrings!)
            self.generateMatrix(rowsAsStrings!)
            
            PriceTable.cachedMatrix[fileName] = self.matrix
            PriceTable.cachedWidths[fileName] = self.widths
            PriceTable.cachedHeights[fileName] = self.heights
            
            
        }catch ParsingError.fileNotFound{
            
            print("Unable to parse \(fileName).\(fileExtension), please select another category.")
            
            
            let alert  = UIAlertView(title: "File Not found", message: "Unable to find file \(fileName).\(fileExtension)", delegate: nil, cancelButtonTitle: "Cancel")
            alert.show()
            
        }catch {
            print("Unable to generate Price Table")
        }
        
    }
    
    func createMatrix(_ data:[String]) {
        let rows = data.count
        let cols = self.splitRowDouble(data[0]).count
        
        self.matrix = Matrix(rows:rows, columns: cols)
    }
    
    func generateMatrix(_ data:[String]) {
        var row = 0
        var col = 0
        for element in data {
            for price in self.splitRowDouble(element) {
                matrix![row, col] = price
                col += 1
            }
            row += 1
            col = 0
        }
    }
    
    func generateArrayOfWidths(_ data:[String]) {
        self.widths = self.splitRowInt(data[0])
    }
    
    func generateArrayOfHeights(_ data:[String]) {
        var number:Int
        for element in data {
            number = self.splitRowInt(element)[0]
            self.heights.append(number)
        }
    }
    
    func splitRowDouble(_ row:String) -> [Double] {
        let array = row.components(separatedBy: ",")
        var newArray = [Double]()
        for element in array {
            newArray.append((NumberFormatter().number(from: element)?.doubleValue)!)
        }
        
        return newArray
    }
    
    func splitRowInt(_ row:String) -> [Int] {
        let array = row.components(separatedBy: ",")
        var newArray = [Int]()
        var number:Int
        for element in array {
            number = (NumberFormatter().number(from: element)?.intValue)!
            newArray.append(number)
        }
        
        return newArray
    }
    
    func getHighestWidthIndex(_ width:Double, widthFineInchIndex:Int) -> Int {
        
        var returnIndex:Int = self.matrix.rows
        
        for i in 0...self.matrix.rows-1 {
            if self.matrix[0, i] >= width {
                if widthFineInchIndex > 0 && width == self.matrix[0, i] {
                    returnIndex = i+1
                    break
                }else{
                    returnIndex = i
                    break
                }
            }
        }
        
        if returnIndex >= self.matrix.rows-1 {
            return self.matrix.rows-1
        }
        
        return returnIndex
    }
    
    func getHighestHeightIndex(_ height:Double, heightFineInchIndex:Int) -> Int {
        
        var returnIndex:Int = self.matrix.columns
        
        for i in 0...self.matrix.columns-1 {
            if self.matrix[i, 0] >= height {
                if heightFineInchIndex > 0 && height == self.matrix[i,0] {
                    returnIndex = i+1
                    break
                }else{
                    returnIndex = i
                    break
                }
            }
        }
        
        if returnIndex >= self.matrix.columns-1 {
            return self.matrix.columns-1
        }
        
        return returnIndex
    }
    
    func getPrice(_ width:Double, widthFineInchIndex:Int, height:Double, heightFineInchIndex:Int) -> Double {
        
        return self.matrix[self.getHighestHeightIndex(height, heightFineInchIndex: heightFineInchIndex), self.getHighestWidthIndex(width, widthFineInchIndex: widthFineInchIndex)]
    }
    
}
