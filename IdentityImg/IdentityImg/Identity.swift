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
        let size: CGSize
        let bgColor: UIColor
        let mainColor: UIColor
        let nanColor: UIColor
        let rows: Int
        let cells: Int
        let isRandomColor: Bool
        let mainStep: Float
        let nanStep: Float
        let mainLen: Float
        let nanLen: Float
        let bgStep: Float
        let bgLen: Float
    }
}

extension Identity.Options {

    static var defaultOptions: Identity.Options = {

        let options: Identity.Options = .init(size: CGSize(width: 90, height: 90),
                                              bgColor: .red,
                                              mainColor: .black,
                                              nanColor: .red,
                                              rows: 9,
                                              cells: 9,
                                              isRandomColor: true,
                                              mainStep: 4,
                                              nanStep: 4,
                                              mainLen: 1.5,
                                              nanLen: 3,
                                              bgStep: 3,
                                              bgLen: 4)
        return options
//        size: 90,
//        bgColor: '#bfbfbf',
//        nanColor: '#EFB66C',
//        mainColor: '#1C3D29',
//        rows: 9,
//        cells: 9,
//        randomColor: true,
//        mainStep: 4,
//        nanStep: 5,
//        mainLen: 1.5,
//        nanLen: 3,
//        bgStep: 3,
//        bgLen: 4
    }()
}

fileprivate extension String {

    func symbol(by index: Int) -> String? {
        guard index < self.count else { return nil }
        let index = self.index(self.startIndex, offsetBy: index)
        return String(self[index])
    }
}

final class Identity {

    private let hash: String
    private let options: Options
    private let hashMatrix: [[Int]]

    init(hash: String, options: Options) {
        self.options = options

        let data = Identity.fillMatrix(hash: hash, options: options)
        self.hash = data.hash
        self.hashMatrix = data.hashMatrix

        Identity.hashToColor(hash: hash, step: options.bgStep, length: 5)
    }

    private static func fillMatrix(hash: String, options: Options) -> (hashMatrix:  [[Int]], hash: String) {

        var i = 0
        var hashMatrix: Array<Array<Int>> = Array<Array<Int>>(repeating: Array<Int>(repeating: 0, count: options.rows), count: options.cells);
        var newHash = hash

        for x  in 0..<options.cells {
            for y in 0..<options.rows {

                if  newHash.symbol(by: i) == nil {
                    newHash += hash
                }

                let newSymbol = newHash.symbol(by: i) ?? ""
                hashMatrix[x][y] = Int(newSymbol, radix: 30) ?? 0
                i += 1
            }
        }

        return (hashMatrix: hashMatrix, hash: newHash)
    }

    private static func hashToColor(hash: String, step: Float, length: Int) {

        var symbols: [String] = hash.map { String($0) }
        var color: [String] = []

        repeat {

            let normalizedLength = min(symbols.count, length)
            let newSymbols = Array(symbols[0..<normalizedLength])
            color.append(contentsOf: newSymbols)

            symbols = Array(symbols[normalizedLength..<symbols.count])
        } while symbols.count > 0

        color.reduce(into: <#T##Result#>, <#T##updateAccumulatingResult: (inout Result, String) throws -> ()##(inout Result, String) throws -> ()#>)
    }




//            const parse = (part: string) => {
//            const arr = part.split('');
//            const tmp = [];
//            do {
//            tmp.push(arr.splice(0, length));
//            } while (arr.length);
//            return tmp.reduce((r, i) => Math.min(r + parseInt(i, 36), 255), 0);
//            };
//            const color = [];
//            for (let i = 0; i < 3; i++) {
//            color.push(hash.slice(Math.round(-(7 / length) - length * 3 - step * i), hash.length - step * i));
//            }
//            return `rgb(${color.map(parse).join()})`;
//    }

}

// class Identity {
//

//
//
//    constructor(hash: string, options: Partial<IOptions>) {
//    options = { ...Identity.defaultOptions, ...(options || {}) };
//    if (options.randomColor) {
//    options.bgColor = Identity.hashToColor(hash, options.bgStep, options.bgLen);
//    options.mainColor = Identity.hashToColor(hash, options.mainStep, options.mainLen);
//    options.nanColor = Identity.hashToColor(hash, options.nanLen, options.nanStep);
//    }
//    this.hash = hash;
//    this.options = options as IOptions;
//    this.canvas = document.createElement('CANVAS') as HTMLCanvasElement;
//    this.ctx = this.canvas.getContext('2d');
//    this.canvas.width = this.options.size;
//    this.canvas.height = this.options.size;
//
//    this.hashMatrix = [];
//    this._fillMatrix(hash);
//    }
//
//    public getImage() {
//    const w = this.options.size / this.options.cells;
//    const h = this.options.size / this.options.rows;
//
//    for (let row = 0; row < this.options.rows; row++) {
//    for (let cell = 0; cell < this.options.cells; cell++) {
//    this._addCell(cell, row, w, h);
//    }
//    }
//
//    return this.canvas.toDataURL('image/png');
//    }
//
//    private _addCell(x, y, w, h) {
//    const color = this._getColors(x, y);
//    if (!color) {
//    this._addRect(x, y, w, h, this.options.bgColor);
//    }
//
//    this._addRect(x, y, w, h, color);
//    }
//
//    private _addRect(x, y, w, h, color) {
//    this.ctx.fillStyle = color;
//    this.ctx.beginPath();
//    this.ctx.rect(x * w - 0.5, y * h - 0.5, w + 0.5, h + 0.5);
//    this.ctx.fill();
//    this.ctx.closePath();
//    }
//
//    private _getColors(x, y): string {
//    if (x < this.options.cells / 2) {
//    return isNaN(this.hashMatrix[x][y]) ? this.options.nanColor : this.hashMatrix[x][y] % 2 ? this.options.mainColor : null;
//    } else {
//    return this._getColors(this.options.cells - 1 - x, y);
//    }
//    }
//
//    private _fillMatrix(hash) {
//    let i = 0;
//    for (let x = 0; x < this.options.cells; x++) {
//    this.hashMatrix[x] = [];
//    for (let y = 0; y < this.options.rows; y++) {
//    if (this.hash[i] == null) {
//    this.hash += hash;
//    }
//    this.hashMatrix[x][y] = parseInt(this.hash[i], 30);
//    i++;
//    }
//    }
//    }
//
//    private static hashToColor(hash: string, step: number, length: number) {
//    const parse = (part: string) => {
//    const arr = part.split('');
//    const tmp = [];
//    do {
//    tmp.push(arr.splice(0, length));
//    } while (arr.length);
//    return tmp.reduce((r, i) => Math.min(r + parseInt(i, 36), 255), 0);
//    };
//    const color = [];
//    for (let i = 0; i < 3; i++) {
//    color.push(hash.slice(Math.round(-(7 / length) - length * 3 - step * i), hash.length - step * i));
//    }
//    return `rgb(${color.map(parse).join()})`;
//    }
//
//    public static defaultOptions: IOptions = {
//    size: 90,
//    bgColor: '#bfbfbf',
//    nanColor: '#EFB66C',
//    mainColor: '#1C3D29',
//    rows: 9,
//    cells: 9,
//    randomColor: true,
//    mainStep: 4,
//    nanStep: 5,
//    mainLen: 1.5,
//    nanLen: 3,
//    bgStep: 3,
//    bgLen: 4
//    }
//
// }
//
// export function config(options: Partial<IOptions>): void {
//    Identity.defaultOptions = { ...Identity.defaultOptions, ...options };
// }
//
// export function create(hash: string, options: Partial<IOptions>): string {
//    return new Identity(hash, options).getImage();
// }
//
// export interface IOptions {
//    size: number;
//    bgColor: string;
//    mainColor: string;
//    nanColor: string;
//    rows: number;
//    cells: number;
//    randomColor: boolean;
//    mainStep: number;
//    nanStep: number;
//    mainLen: number;
//    nanLen: number;
//    bgStep: number;
//    bgLen: number;
// }
