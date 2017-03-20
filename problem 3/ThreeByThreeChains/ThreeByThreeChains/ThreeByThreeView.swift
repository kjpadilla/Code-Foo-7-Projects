//
//  ThreeByThreeView.swift
//  ThreeByThreeChains
//
//  Created by Kristofer Jon Padilla on 2/27/17.
//  Copyright © 2017 kristoferpadilla. All rights reserved.
//

import UIKit

class ThreeByThreeView: UIView {
    /*
     ThreeByThreeView dynamically creates an N by N grid of UILabels that each display random
     integers in the range [0-9]. N is determined from the Global constant WIDTH that is
     defined at the top of the file ViewController.swift. The WIDTH global is initially set
     to 3 as required by the problem. However, WIDTH can be changed to any value >= 1 and the functions
     below will have no problem executing. However, as N gets larger the squares in the grid become
     smaller. If N is too large the UILabels will not be readable. It should also be noted that the
     functions in the swift file ThreeByThreeChainsCalculator.swift will also restrict the global WIDTH's upper bound.
     Usually it is impractical to exceed a WIDTH of 4.
    */
    
    
    private let N:CGFloat = CGFloat(WIDTH)  // WIDTH constant as a CGFloat type
    
    private var nLabels = [UILabel]()       // Stores the UILabels from
                                            // left to right starting in the upper left
    
    var nValues = Array(repeating: Array(repeating: Int(0), count: WIDTH), count:WIDTH) // Stores the integer value in each UILabel of the grid
                                                                                        // from left to right starting in the upper left
    
    
    
    /*
    This function's parameters are the width of the view and the height of the view.
    With this data an NxN grid is formed in the top half of the device's screen by dynamically
    creating UILabels. This function does not set any text values for the UILabels to display.
    */
    
    func createNxNDigits(_ wide: CGFloat, high: CGFloat)
    {
        var row:CGFloat = 1.0
        var col:CGFloat = 1.0
        while(row <= N)
        {
            col = 1.0
            while(col <= N)
            {
                let temp = UILabel()
                temp.bounds = CGRect(x: 0, y: 0, width: wide/N, height: high/(2*N))
                temp.center = CGPoint(x: wide*(2*col-1)/(N*2), y: high*(2*row-1)/(N*4))
                temp.text = "I"
                temp.textColor = UIColor.darkGray
                temp.backgroundColor = UIColor.lightGray
                temp.font = UIFont.systemFont(ofSize: 25)
                temp.textAlignment = .center
                self.addSubview(temp)
                col += 1.0
                nLabels.append(temp)
            }
            row += 1.0
        }
    }
    
    /* This function produces random integers in the range [0-9] and sets the
    text in each UILabel created by the previous function to one of these 
    random integer values.
 
    This function also contains an array named test that can be used to test any specific
    configuration of integers 0-9. To test a specific configuration first remove the comment 
    on variable test and on the second nested loop. You must also comment out the first nested
    for loop otherwise the program will crash!
    
    The values in the test array fill the NxN grid from left to right starting in the upper left
    hand corner. For example: if WIDTH = 3 and test = [1, 2, 3, 4, 5, 6, 7 ,8 ,9] the grid will be
    1 2 3
    4 5 6  
    7 8 9
    */
    func randomizeNxN()
    {
        var counter: Int = 0
        //var test = [1,2,3,4,5,6,7,8,9] //Only used for testing specific sets of integers.
        
        for i in 0..<WIDTH
        {
            for j in 0..<WIDTH
            {
                let temp = arc4random_uniform(10)
                nLabels[counter].text = String(temp)
                nValues[i][j] = Int(temp);
                counter += 1
            }
        }
        
        /* UNCOMMENT THE BELOW LOOPS ONLY TO USE THE TEST ARRAY.
         THE ABOVE LOOPS MUST ALSO BE COMMENTED OUT WHEN
         USING THE TEST ARRAY */
        
        /*for i in 0..<WIDTH
        {
            for j in 0..<WIDTH
            {
                let temp = test[i*WIDTH+j]
                nLabels[counter].text = String(temp)
                print("\(i) \(j)")
                nValues[i][j] = Int(temp);
                counter += 1
                print("\(nValues[i][j])")
            }
            
        }*/
    }
    
    

}
