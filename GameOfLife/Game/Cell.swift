//
//  Cell.swift
//  GameOfLife
//
//  Created by John Kouris on 8/18/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

struct Cell {
    var isAlive = false
    
    static func makeDeadCell() -> Cell {
        return Cell(isAlive: false)
    }
    
    static func makeLiveCell() -> Cell {
        return Cell(isAlive: true)
    }
}
