//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by John Kouris on 8/18/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import XCTest
@testable import GameOfLife

class GameOfLifeTests: XCTestCase {

    var game = Game(width: 3, height: 3)
    
    // A live square with two or three live neighbors survives (survival)
    func test_survival() {
        let twoAliveNeighboursGameState = GameState(cells: [Cell.makeDeadCell(), Cell.makeDeadCell(), Cell.makeDeadCell(),
                                                            Cell.makeLiveCell(), Cell.makeLiveCell(), Cell.makeLiveCell(),
                                                            Cell.makeDeadCell(), Cell.makeDeadCell(), Cell.makeDeadCell()])
        game.setInitialState(twoAliveNeighboursGameState)
        XCTAssertTrue(game.state(x: 1, y: 1))
        
        let threeAliveNeighboursGameState = GameState(cells: [Cell.makeDeadCell(), Cell.makeLiveCell(), Cell.makeDeadCell(),
                                                              Cell.makeDeadCell(), Cell.makeLiveCell(), Cell.makeLiveCell(),
                                                              Cell.makeDeadCell(), Cell.makeLiveCell(), Cell.makeDeadCell()])
        game.setInitialState(threeAliveNeighboursGameState)
        XCTAssertTrue(game.state(x: 1, y: 1))
    }
    
    func test_gliderState() {
        let gliderState = GameState(cells:[Cell.makeDeadCell(), Cell.makeLiveCell(), Cell.makeDeadCell(),
                                           Cell.makeDeadCell(), Cell.makeDeadCell(), Cell.makeDeadCell(),
                                           Cell.makeDeadCell(),  Cell.makeLiveCell(), Cell.makeDeadCell()])
        
        game.setInitialState(gliderState)
        
        XCTAssertEqual(game.iterate(), GameState(cells:[Cell.makeDeadCell(), Cell.makeDeadCell(), Cell.makeDeadCell(),
                                                        Cell.makeDeadCell(), Cell.makeDeadCell(), Cell.makeDeadCell(),
                                                        Cell.makeDeadCell(),Cell.makeDeadCell(),Cell.makeDeadCell()]))
    }
    
    //2. A dead square with exactly three live neighbors becomes a live cell (birth).
    func test_birth() {
        let deadCellState = GameState(cells:[Cell.makeLiveCell(), Cell.makeDeadCell(), Cell.makeDeadCell(),
                                             Cell.makeLiveCell(), Cell.makeLiveCell(), Cell.makeDeadCell(),
                                             Cell.makeDeadCell(), Cell.makeDeadCell(), Cell.makeDeadCell()])
        game.setInitialState(deadCellState)
        XCTAssertTrue(game.state(x: 1, y: 0))
    }
    
    //3. In all other cases a cell dies or remains dead. In the case that a live square has zero or one neighbor, it is said to die of loneliness; if it has more than three neighbors, it is said to die of overcrowding.
    func test_death() {
        let lonelyState = GameState(cells: [Cell.makeDeadCell(), Cell.makeDeadCell(), Cell.makeDeadCell(),
                                            Cell.makeDeadCell(), Cell.makeLiveCell(), Cell.makeDeadCell(),
                                            Cell.makeDeadCell(), Cell.makeDeadCell(), Cell.makeDeadCell()])
        game.setInitialState(lonelyState)
        XCTAssertEqual(false, game.state(x: 1, y: 1))
        
        let overcrowdingState = GameState(cells: [Cell.makeLiveCell(), Cell.makeLiveCell(), Cell.makeLiveCell(),
                                                  Cell.makeLiveCell(), Cell.makeLiveCell(), Cell.makeLiveCell(),
                                                  Cell.makeLiveCell(), Cell.makeLiveCell(), Cell.makeLiveCell()])
        game.setInitialState(overcrowdingState)
        XCTAssertEqual(false, game.state(x: 1, y: 1))
    }

}
