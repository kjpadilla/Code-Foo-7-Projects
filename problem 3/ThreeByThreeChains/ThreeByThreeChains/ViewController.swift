//
//  ViewController.swift
//  ThreeByThreeChains
//
//  Created by Kristofer Jon Padilla 2/27/17.
//  Copyright © 2017 kristoferpadilla. All rights reserved.
//

import UIKit
let WIDTH = 3  // THIS GLOBAL DETERMINES THE WIDTH OF THE N BY N GRID. The program works well for WIDTH = 2 or 3.
               // When WIDTH > 3 the program will not complete in a practical amount of time if there are many possible
               // solution chains to the grid.

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
     /*
     
     ViewController first sets up the NxN grid by calling the appropriate functions
     in MainView, an instance of ThreeBythreeView. After this, all valid
     chains are determined by chainCalulator, an instance of ThreeByThreeChainsCalculator
     
     ViewController also sets up the cells in the UITableView that displays all of
     the solution chains to the NxN grid.
     
     This process will be repeated everytime the generate button is touched, excluding
     creating the NxN grid. The values of the grid are changed, but the same grid is
     used. 
     
     */
    
    
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    private let chainCalculator = ThreeByThreeChainsCalculator()

    @IBOutlet weak var MainView: ThreeByThreeView!
    
    
    /* Upon opening the app this function sets up the view and finds all solutions to the NxN grid. */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        MainView.createNxNDigits(view.bounds.width, high: view.bounds.height)
        MainView.randomizeNxN()
        chainCalculator.generateValidChains(nValues: MainView.nValues)
        
    }
    
    
    /* Sets the number of sections for the TableView. This returns the equivalent to the area of the NxN grid */
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return WIDTH * WIDTH
    }
    
    
    /* Sets the number of rows per section in the TableView by using data determined by chainCalulator */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return chainCalculator.rowsPerSection[section]
    }
    
    
    /*  Creates the cells in the TableView depending on the current section by using data determined by chainCalculator */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var stringValidChains = [String]()
        
        for itr in chainCalculator.validChainsPublic[indexPath.section]
        {
            stringValidChains.append("")
            for each in 0..<itr.count
            {
                stringValidChains[stringValidChains.count - 1] += String(itr[each])
                if (each < itr.count - 1)
                {
                    stringValidChains[stringValidChains.count - 1] += " + "
                }
                else
                {
                    stringValidChains[stringValidChains.count - 1] += " = " + String(WIDTH*WIDTH)
                }
            }
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "genericCell")
        cell.textLabel?.text = stringValidChains[indexPath.row]
        return cell
    }
    
    
    /* Gives each TableView section a title based on chains' starting cell number */
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Starts at Cell: " + String(section + 1)
    }
    
    
    
    @IBOutlet weak var TableOfSolutions: UITableView!
    
    
    /* When the generate button is pressed this function sets new values in the
     NxN grid and displays the solution chains for the new grid in the TableView */
    @IBAction func touchGenerate(_ sender: UIButton)
    {
        MainView.randomizeNxN()
        chainCalculator.generateValidChains(nValues: MainView.nValues)
        TableOfSolutions.reloadData()
    }

}

