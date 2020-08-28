//
//  GameViewController.swift
//  GameOfLife
//
//  Created by John Kouris on 8/19/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var dataSource: [Cell] = []
    
    @IBOutlet var iteration: UILabel!
    @IBOutlet var speedPickerView: UIPickerView!
    
    var pickerData = [Double]()
    
    let pixelSize = 10
    let boardWidth = 25
    let boardHeight = 25
    var simulationSpeed: Double = 1.0
    var redSelection: CGFloat = 0
    var greenSelection: CGFloat = 0
    var blueSelection: CGFloat = 0
    
    var game: Game!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        speedPickerView.delegate = self
        speedPickerView.dataSource = self
        pickerData = [1.0, 0.5, 0.33]
        
        speedPickerView.selectRow(0, inComponent: 0, animated: true)
    }
    
    @IBAction func chooseColorTapped(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Enter a Color", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Enter red value here"
            textField.keyboardType = .numberPad
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter green value here"
            textField.keyboardType = .numberPad
        }
        
        ac.addTextField { (textField) in
            textField.placeholder = "Enter blue value here"
            textField.keyboardType = .numberPad
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // convert the text entered in each textField to a CGFloat which can be used to color the cells
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            guard let redEntry = ac.textFields![0].text, let greenEntry = ac.textFields![1].text, let blueEntry = ac.textFields![2].text else { return }
            self.redSelection = NumberFormatter().number(from: redEntry) as! CGFloat
            self.greenSelection = NumberFormatter().number(from: greenEntry) as! CGFloat
            self.blueSelection = NumberFormatter().number(from: blueEntry) as! CGFloat
        }))
        
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        iteration.isHidden = false
        game = Game(width: boardWidth, height: boardHeight)
        game.start(gameSpeed: simulationSpeed) { [weak self] state in
            self?.display(state)
        }
    }
    
    func display(_ state: GameState) {
        self.dataSource = state.cells
        collectionView.reloadData()
        self.iteration.text = String(game.iterationCount)
    }
    
    @IBAction func randomizeButtonTapped(_ sender: UIButton) {
        game.randomize()
    }
    
    @IBAction func stopTapped(_ sender: UIButton) {
        game.stop()
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        game.clear()
        dataSource.removeAll()
        collectionView.reloadData()
        iteration.text = "0"
    }
    
    @IBAction func preset1Tapped(_ sender: UIButton) {
        game.runPreset1()
    }
    
    @IBAction func preset2Tapped(_ sender: UIButton) {
        game.runPreset2()
    }
    
    @IBAction func preset3Tapped(_ sender: UIButton) {
        game.runPreset3()
    }
    
    @IBAction func preset4Tapped(_ sender: UIButton) {
        game.runPreset4()
    }
    
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        cell.configureWithState(dataSource[indexPath.item].isAlive, cellColor: UIColor(red: redSelection/255, green: greenSelection/255, blue: blueSelection/255, alpha: 1))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pixelSize, height: pixelSize)
    }
}

extension GameViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(pickerData[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerData[row])
        if pickerData[row] == 1.0 {
            simulationSpeed = 1.0
        } else if pickerData[row] == 0.5 {
            simulationSpeed = 0.5
        } else {
            simulationSpeed = 0.33
        }
    }
    
}
