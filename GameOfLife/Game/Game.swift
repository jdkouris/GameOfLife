//
//  Game.swift
//  GameOfLife
//
//  Created by John Kouris on 8/18/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import Foundation

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
    
    func addStateObserver(gameSpeed: Double, _ observer: GameStateObserver) {
        observer?(generateRandomState())
        timer = Timer.scheduledTimer(withTimeInterval: gameSpeed, repeats: true) { _ in
            observer?(self.iterate())
        }
    }
    
    func removeStateObserver() {
        NotificationCenter.default.removeObserver(GameStateObserver.self)
    }
    
    func randomize() {
        self.generateRandomState()
    }
    
    func stop() {
        self.generateStopState()
    }
    
    func clear() {
        self.generateClearedState()
    }
    
    func runPreset1() {
        self.generatePreset1State()
    }
    
    func runPreset2() {
        self.generatePreset2State()
    }
    
    func runPreset3() {
        self.generatePreset3State()
    }
    
    func runPreset4() {
        self.generatePreset4State()
    }
    
    func iterate() -> GameState {
        var nextState = currentState
        self.iterationCount += 1
        for i in 0...width - 1 {
            for j in 0...height - 1 {
                let positionInTheArray = j * width + i
                nextState[positionInTheArray] = Cell(isAlive: state(x: i, y: j))
            }
        }
        
        self.currentState = nextState
        return nextState
    }
    
    func state(x: Int, y: Int) -> Bool {
        let numberOfAliveNeighbours = aliveNeighborCountAt(x: x, y: y)
        let position = x + y*width
        
        let wasPreviouslyAlive = currentState[position].isAlive
        if wasPreviouslyAlive {
            return numberOfAliveNeighbours == 2 || numberOfAliveNeighbours == 3
        } else {
            return numberOfAliveNeighbours == 3
        }
    }
    
    func aliveNeighborCountAt(x: Int, y: Int) -> Int {
        var numberOfAliveNeighbours = 0
        for i in x-1...x+1 {
            for j in y-1...y+1 {
                if (i == x && y == j) || (i >= width) || (i < 0) || (j < 0) { continue }
                
                let index = j*width + i
                
                guard index >= 0 && index < width*height else { continue }
                if currentState[index].isAlive {
                    numberOfAliveNeighbours += 1
                }
            }
        }
        return numberOfAliveNeighbours
    }
    
    // Need this for testing
    func setInitialState(_ state: GameState) {
        currentState = state
    }
    
    @discardableResult
    func generateRandomState() -> GameState {
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
    
    @discardableResult
    func generateStopState() -> GameState {
        timer?.invalidate()
        return self.currentState
    }
    
    @discardableResult
    func generateClearedState() -> GameState {
        for point in 0...624 {
            currentState[point] = Cell.makeDeadCell()
        }
        timer?.invalidate()
        return self.currentState
    }
    
    @discardableResult
    func generatePreset1State() -> GameState {
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
    func generatePreset2State() -> GameState {
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
    func generatePreset3State() -> GameState {
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
    func generatePreset4State() -> GameState {
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
    
    private func generateRandom(between range: ClosedRange<Int>, count: Int) -> [Int] {
        return Array(0...count).map { _ in
            Int.random(in: range)
        }
    }
    
}
