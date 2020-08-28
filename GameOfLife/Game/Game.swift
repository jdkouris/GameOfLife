//
//  Game.swift
//  GameOfLife
//
//  Created by John Kouris on 8/18/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

typealias GameStateObserver = ((GameState) -> Void)?

class Game {
    let width: Int
    let height: Int
    var currentState: GameState
    var iterationCount: Int
    var timer: Timer?
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.iterationCount = 0
        let cells = Array(repeating: Cell.makeDeadCell(), count: width * height)
        currentState = GameState(cells: cells)
    }
    
    // Set up the observer with a random pattern and start the timer which will update the view after each iteration
    func start(gameSpeed: Double, _ observer: GameStateObserver) {
        observer?(randomize())
        timer = Timer.scheduledTimer(withTimeInterval: gameSpeed, repeats: true) { _ in
            observer?(self.iterate())
        }
    }
    
    // Generate a random pattern of alive/dead cells
    @discardableResult
    func randomize() -> GameState {
        iterationCount = 0
        let maxItems = width * height - 1
        for point in 0...maxItems {
            currentState[point] = Cell.makeDeadCell()
        }
        
        let initialStatePoints = self.generateRandom(between: 0...maxItems, count: maxItems/8)
        
        for point in initialStatePoints {
            currentState[point] = Cell.makeLiveCell()
        }
        
        return self.currentState
    }
    
    // Stop the execution of the game by deactivating the timer
    @discardableResult
    func stop() -> GameState {
        timer?.invalidate()
        return self.currentState
    }
    
    // Clear the game board by removing points and deactivating the timer
    @discardableResult
    func clear() -> GameState {
        iterationCount = 0
        for point in 0...624 {
            currentState[point] = Cell.makeDeadCell()
        }
        
        timer?.invalidate()
        return self.currentState
    }
    
    // MARK: - Presets
    // Methods that run preset configurations on the game board
    
    @discardableResult
    func runPreset1() -> GameState {
        iterationCount = 0
        for point in 0...624 {
            currentState[point] = Cell.makeDeadCell()
        }
        
        for point in 0...24 {
            currentState[point] = Cell.makeLiveCell()
        }
        
        return self.currentState
    }
    
    @discardableResult
    func runPreset2() -> GameState {
        iterationCount = 0
        for point in 0...624 {
            currentState[point] = Cell.makeDeadCell()
        }
        
        for point in 0...200 {
            if point % 2 == 0 {
                currentState[point] = Cell.makeLiveCell()
            }
        }
        
        return self.currentState
    }
    
    @discardableResult
    func runPreset3() -> GameState {
        iterationCount = 0
        for point in 0...624 {
            currentState[point] = Cell.makeDeadCell()
        }
        
        for point in 300...600 {
            currentState[point] = Cell.makeLiveCell()
        }
        
        return self.currentState
    }
    
    @discardableResult
    func runPreset4() -> GameState {
        iterationCount = 0
        for point in 0...624 {
            currentState[point] = Cell.makeDeadCell()
        }
        
        for point in 0...624 {
            if point % 2 == 0 {
                currentState[point] = Cell.makeLiveCell()
            }
        }
        
        return self.currentState
    }
    
    // MARK: - Core Game Logic
    
    // Method that performs each iteration through the game and determines which cells are alive/dead in each subsequent game state
    func iterate() -> GameState {
        var nextState = currentState
        self.iterationCount += 1
        for i in 0...width - 1 {
            for j in 0...height - 1 {
                let positionInTheArray = j * width + i
                // check the cell at the given index and set the state of the cell (alive/dead)
                nextState[positionInTheArray] = Cell(isAlive: state(x: i, y: j))
            }
        }
        
        self.currentState = nextState
        return nextState
    }
    
    // Method that determines the state (alive/dead) of an individual cell at a given coordinate on the game board
    func state(x: Int, y: Int) -> Bool {
        let numberOfAliveNeighbours = aliveNeighborCountAt(x: x, y: y)
        let position = x + y*width
        
        // check the living status of the cell at the calculated position
        let wasPreviouslyAlive = currentState[position].isAlive
        if wasPreviouslyAlive {
            // if cell is alive and # of neighbours is 2 or 3, return true or false based on neighbour count
            return numberOfAliveNeighbours == 2 || numberOfAliveNeighbours == 3
        } else {
            // if cell is dead, return true or false based on whether or not it has 3 neighbours
            return numberOfAliveNeighbours == 3
        }
    }
    
    // Method that determines the number of living neighbours at a given coordinate on the game board
    func aliveNeighborCountAt(x: Int, y: Int) -> Int {
        var numberOfAliveNeighbours = 0
        for i in x-1...x+1 {
            for j in y-1...y+1 {
                // If current iteration is equal to the current cell, or i is larger than the game width, or i or j are negative, skip and run the j loop again
                if (i == x && y == j) || (i >= width) || (i < 0) || (j < 0) { continue }
                
                let index = j*width + i
                
                // check the index is 0 or greater, but less than the size of the game board
                guard index >= 0 && index < width*height else { continue }
                // check if the cell at the calculated index for the current game state is alive. If yes, add 1 to the number of alive neighbours
                if currentState[index].isAlive {
                    numberOfAliveNeighbours += 1
                }
            }
        }
        // return the count of alive neighbours for the given point
        return numberOfAliveNeighbours
    }
    
    // MARK: - Testing
    
    func setInitialState(_ state: GameState) {
        currentState = state
    }
    
    // MARK: - Helper Random Method
    
    private func generateRandom(between range: ClosedRange<Int>, count: Int) -> [Int] {
        return Array(0...count).map { _ in
            Int.random(in: range)
        }
    }
    
}
