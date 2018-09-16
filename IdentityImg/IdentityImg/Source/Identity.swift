//
//  Identity.swift
//  IdentityImg
//
//  Created by Prokofev Ruslan on 14/09/2018.
//  Copyright © 2018 Waves. All rights reserved.
//

import Foundation
import UIKit

extension Identity {

    struct Options {
        enum Palette {
            case randomColor
            case colors(background: UIColor, main: UIColor, hollow: UIColor)
        }

        struct Range {
            let step: Float
            let length: Float
        }

        struct Size {
            let cells: Int
            let rows: Int
        }

        let grid: Size
        let palette: Palette
        let mainRange: Range
        let hollowRange: Range
        let backgroundRange: Range
    }

    static var defaultOptions: Identity.Options = {

        let options: Identity.Options = .init(grid: .init(cells: 8, rows: 8),
                                              palette: .randomColor,
                                              mainRange: Identity.Options.Range(step: 4, length: 1.5),
                                              hollowRange: Identity.Options.Range(step: 5, length: 3),
                                              backgroundRange: Identity.Options.Range(step: 3, length: 4))
        return options
    }()
}

public final class Identity {

    fileprivate typealias Matrix = [[Int?]]
    fileprivate typealias Colors = (background: UIColor, main: UIColor, hollow: UIColor)

    private let options: Options
    init(options: Options) {
        self.options = options
    }

    public func createImage(by hash: String, size: CGSize) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(size, true, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }

        let grid = options.grid
        let colors = Identity.colors(from: options, hash: hash)
        let matrix = Identity.matrix(from: hash, grid: grid)
        let w: CGFloat = size.width / CGFloat(grid.cells)
        let h: CGFloat = size.height / CGFloat(grid.rows)

        for row in 0..<grid.rows {
            for cell in 0..<grid.cells {

                let color = Identity.color(by: CGPoint(x: cell, y: row), matrix: matrix, colors: colors)
                let x = CGFloat(cell) * w - 0.5
                let y = CGFloat(row) * h - 0.5

                let frame = CGRect(x: x, y: y, width: w + 0.5, height: h + 0.5)

                draw(by: frame, color: color, context: context)
            }
        }

        let myImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return myImage
    }

    private func draw(by rect: CGRect, color: UIColor, context: CGContext) {

        context.setFillColor(color.cgColor)
        context.addRect(rect)
        context.fill(rect)
    }
}

// MARK: Method for create Matrix

extension Identity {
    private static func matrix(from hash: String, grid: Options.Size) -> Matrix {

        var i = 0
        var hashMatrix: Matrix = .init(repeating: .init(repeating: nil, count: grid.rows), count: grid.cells)
        var newHash = hash

        for x in 0..<grid.cells {
            for y in 0..<grid.rows {

                if newHash.symbol(by: i) == nil {
                    newHash += hash
                }

                if let newSymbol = newHash.symbol(by: i) {
                    hashMatrix[x][y] = Int(newSymbol, radix: 30)
                } else {
                    hashMatrix[x][y] = nil
                }
                i += 1
            }
        }

        return hashMatrix
    }
}

// MARK: Methods for colors

extension Identity {

    private static func color(from hash: String, range: Options.Range) -> UIColor {
        let symbols: [String] = hash.map { String($0) }
        var colors = Array<CGFloat>(repeating: 0, count: 3)

        let length = range.length
        let step = range.step

        for i in 0..<3 {

            let begin = Int(round(-(7 / length) - length * 3 - step * Float(i)))
            let end = hash.count - Int(step * Float(i))

            let symbolsForColor = symbols.slice(beginIndex: begin, endIndex: end)
            colors[i] = CGFloat(colorValue(from: symbolsForColor, length: length))
        }

        return UIColor(red: colors[0] / 255,
                       green: colors[1] / 255,
                       blue: colors[2] / 255,
                       alpha: 1)
    }

    private static func colorValue(from symbols: [String], length: Float) -> Int {

        var newSymbols = symbols
        var color: [[String]] = .init()
        repeat {

            let normalizedLength = min(newSymbols.count, Int(length))
            let symbols = Array(newSymbols[0..<normalizedLength])
            color.append(symbols)

            newSymbols = Array(newSymbols[normalizedLength..<newSymbols.count])

        } while newSymbols.count > 0

        let reduce = color.reduce(into: 0) { r, symbols in
            let symbol = symbols.first ?? ""
            let value = min(r + (Int(symbol, radix: 36) ?? 0), 255)
            r = max(value, 0)
        }

        return reduce
    }

    private static func colors(from options: Options, hash: String) -> Colors {

        var backgroundColor: UIColor!
        var mainColor: UIColor!
        var hollowColor: UIColor!

        switch options.palette {
        case .randomColor:
            backgroundColor = Identity.color(from: hash, range: options.backgroundRange)
            mainColor = Identity.color(from: hash, range: options.mainRange)
            hollowColor = Identity.color(from: hash, range: options.hollowRange)

        case .colors(let background, let main, let hollow):
            backgroundColor = background
            mainColor = main
            hollowColor = hollow
        }

        return (background: backgroundColor,
                main: mainColor,
                hollow: hollowColor)
    }

    private static func color(by point: CGPoint, matrix: Matrix, colors: Colors) -> UIColor {

        if point.x < (CGFloat(matrix.count) / 2.0) {

            var cellIndex = max(0, matrix.count - 1)
            cellIndex = max(min(cellIndex, Int(point.x)), 0)

            var rowIndex = max(0, matrix[cellIndex].count - 1)
            rowIndex = max(min(rowIndex, Int(point.y)), 0)

            if let value = matrix[cellIndex][rowIndex] {
                if value % 2 != 0 {
                    return colors.main
                } else {
                    return colors.background
                }
            } else {
                return colors.hollow
            }
        } else {
            return color(by: CGPoint(x: CGFloat(matrix.count) - 1.0 - point.x, y: point.y),
                         matrix: matrix,
                         colors: colors)
        }
    }
}
