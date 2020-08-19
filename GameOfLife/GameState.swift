//
//  GameState.swift
//  GameOfLife
//
//  Created by John Kouris on 8/18/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

struct GameState {
    var cells: [Cell] = []
    
    subscript(index: Int) -> Cell {
        get {
            return cells[index]
        } set {
            cells[index] = newValue
        }
    }
}
