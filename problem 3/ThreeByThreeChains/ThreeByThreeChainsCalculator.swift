//
//  ThreeByThreeChainsCalculator.swift
//  ThreeByThreeChains
//
//  Created by Kristofer Jon Padilla 3/2/17.
//  Copyright © 2017 kristoferpadilla. All rights reserved.
//

import Foundation

class ThreeByThreeChainsCalculator
{
    
    /* ThreeByThreeChainsCalculator first determines all chains that add to the area of the grid, are
     at least grid width + 1, use adjacent cells, and do not repeat previously used cells. After all of these
     chains are found then any repeat chains are removed. This data is stored differently
     in various variables to be shared publically in ViewController.swift
    */
    
    private let area = WIDTH * WIDTH
    private var checked = Array(repeating: Array(repeating: Bool(false), count: WIDTH), count:WIDTH)
    private var directions = [[Bool]]()
    private var numberOfChainsStartingAt = Array(repeating: 0, count: WIDTH*WIDTH)
    public var validChainsPublic = [[[Int]]]()
    
    
    /* returns an array of ints that each represent how many solutions start at a particular cell.
     For example: rowsPerSection[3] will return the number of chains that start at the
     fourth cell in the grid */
    public var rowsPerSection: [Int]
    {
        get
        {
            return numberOfChainsStartingAt
        }
    }
    
    
    /* This functions generates all chains including duplicates. The duplicates are removed at the end of this function
     by calling the function finalValidation. The valid chains are placed in the validChainsPublic array for access by 
     ViewController. The number of chains starting at each particular cell are stored in the array numberOfChainsStartingAt.
     This is also stored for access by ViewController. */
    func generateValidChains(nValues: [[Int]])
    {
        var chain = [Int]()
        var chainSum = 0
        var currentPoint = (currentI: 0, currentJ: 0)
        var validPoint = (validI: 0, validJ: 0)
        var validChains = [[Int]]()
        var validChainsTuples = [[(Int, Int)]]()
        var validChainsValue = [Int]()
        var ChainsTuples = [(prevI: -1, prevJ: -1)]
        
        numberOfChainsStartingAt = Array(repeating: 0, count: WIDTH*WIDTH) //Needs to be reset when called again
        
        for i in 0..<WIDTH
        {
            for j in 0..<WIDTH
            {
                currentPoint.currentI = i
                currentPoint.currentJ = j
                validPoint = (i,j)
                chainSum += nValues[currentPoint.currentI][currentPoint.currentJ]
                chain.append(nValues[currentPoint.currentI][currentPoint.currentJ])
                ChainsTuples.append((currentPoint.currentI, currentPoint.currentJ))
                checked[currentPoint.currentI][currentPoint.currentJ] = true
                createDirectionArray()

                while(validPoint != (-1, -1))
                {
                    validPoint = findAdjacentValue(i: currentPoint.currentI, j: currentPoint.currentJ, nValues: nValues, maxValue: area-chainSum, chainElementNum: chain.count - 1)
                    if (validPoint == (-1,-1))
                    {

                        
                        if(chain.count >= WIDTH - 1 && chainSum == area)//n-1 == gridwidth -1
                        {
                            if (validChainsValue.isEmpty || chain.count != ChainsTuples.count - 1 || validChains.last![0] != chain[0] || (validChainsValue.last! != calculateChainValue(ChainsTuples: ChainsTuples)))
                            {
                                validChains.append(chain)
                                validChainsValue.append(calculateChainValue(ChainsTuples: ChainsTuples))
                                validChainsTuples.append(ChainsTuples)
                                validChainsTuples[validChainsTuples.count - 1].removeFirst()
                            }
                            else
                            {
                                //duplicate
                            }
                        }
                        chainSum -= nValues[currentPoint.currentI][currentPoint.currentJ]

                        checked[currentPoint.currentI][currentPoint.currentJ] = false
                        ChainsTuples.removeLast()
                        currentPoint.currentI = ChainsTuples.last!.0
                        currentPoint.currentJ = ChainsTuples.last!.1
                        chain.removeLast()
                        validPoint = (currentPoint.currentI, currentPoint.currentJ)

                        removeDirectionArray()
                    }
                    else
                    {
                        currentPoint.currentI = validPoint.validI
                        currentPoint.currentJ = validPoint.validJ
                        ChainsTuples.append((currentPoint.currentI, currentPoint.currentJ))
                        checked[currentPoint.currentI][currentPoint.currentJ] = true
                        chain.append(nValues[currentPoint.currentI][currentPoint.currentJ])
                        chainSum += nValues[currentPoint.currentI][currentPoint.currentJ]
                        createDirectionArray()
                    }
                }
            }
        }
        
        finalValidation(validChains: &validChains, validChainsValue: &validChainsValue, validChainsTuples: &validChainsTuples)
        setValidChainsPublic(validChains: &validChains)
        
        print("valid chain tuples \(validChainsTuples)")
        //print("number of chains at \(numberOfChainsStartingAt)")
        //print("valid chains public \(validChainsPublic)")
    }
    
    
    /* This function searches for a valid adjacent cell to add to the chain of the cell that calls it.
     If a valid cell is found then a tuple is returned that represents that particular cell.
     Otherwise, the tuple (-1,-1) is returned. */
    func findAdjacentValue(i: Int, j: Int, nValues: [[Int]], maxValue: Int, chainElementNum: Int) -> (Int,Int)
    {
        var found = false
        var num = 0
        var validI = -1
        var validJ = -1 //validI and validJ stay -1 if a valid point is not found
        
        while (!found && num != 8)
        {
            switch num
            {
            case 0:
                if (isValidPoint(i: i - 1, j: j) && !directions[chainElementNum][num] && nValues[i-1][j] <= maxValue)
                {
                    found = true
                    validI = i-1
                    validJ = j
                    setCheckedDirections(chainElementNum: chainElementNum, maxDirection: num)
                }
            case 1:
                if (isValidPoint(i: i - 1, j: j+1) && !directions[chainElementNum][num] && nValues[i-1][j+1] <= maxValue)
                {
                    found = true
                    validI = i-1
                    validJ = j+1
                    setCheckedDirections(chainElementNum: chainElementNum, maxDirection: num)
                }
            case 2:
                if (isValidPoint(i: i, j: j + 1) && !directions[chainElementNum][num] && nValues[i][j+1] <= maxValue)
                {
                    found = true
                    validI = i
                    validJ = j+1
                    setCheckedDirections(chainElementNum: chainElementNum, maxDirection: num)
                }
            case 3:
                if (isValidPoint(i: i + 1, j: j + 1) && !directions[chainElementNum][num] && nValues[i+1][j+1] <= maxValue)
                {
                    found = true
                    validI = i + 1
                    validJ = j + 1
                    setCheckedDirections(chainElementNum: chainElementNum, maxDirection: num)
                }
            case 4:
                if (isValidPoint(i: i + 1, j: j) && !directions[chainElementNum][num] && nValues[i+1][j] <= maxValue)
                {
                    found = true
                    validI = i + 1
                    validJ = j
                    setCheckedDirections(chainElementNum: chainElementNum, maxDirection: num)
                }
            case 5:
                if (isValidPoint(i: i + 1, j: j - 1) && !directions[chainElementNum][num] && nValues[i+1][j-1] <= maxValue)
                {
                    found = true
                    validI = i + 1
                    validJ = j - 1
                    setCheckedDirections(chainElementNum: chainElementNum, maxDirection: num)
                }
            case 6:
                if (isValidPoint(i: i, j: j-1) && !directions[chainElementNum][num] && nValues[i][j-1] <= maxValue)
                {
                    found = true
                    validI = i
                    validJ = j-1
                    setCheckedDirections(chainElementNum: chainElementNum, maxDirection: num)
                }
            case 7:
                if (isValidPoint(i: i - 1, j: j-1) && !directions[chainElementNum][num] && nValues[i-1][j-1] <= maxValue)
                {
                    found = true
                    validI = i-1
                    validJ = j-1
                    setCheckedDirections(chainElementNum: chainElementNum, maxDirection: num)
                }
            default:
                print("Direction value is out of range")
            }
            num += 1
            if (num == 8)
            {
                setCheckedDirections(chainElementNum: chainElementNum, maxDirection: num - 1)
            }
        }
        
        return (validI, validJ)
    }
    
    
    /* Sets an integer for every chain that is usally unique to a particular chain. If
     two chains have this same value there is a possibility they are duplicates.
     If these values are not the same, it is impossible for the chains to be duplicates
     of each other */
    func calculateChainValue(ChainsTuples: [(Int,Int)]) -> Int
    {
        var sum = 0
        
        for itr in 1..<ChainsTuples.count
        {
            sum += ChainsTuples[itr].0 * WIDTH + ChainsTuples[itr].1 + 1
        }
        
        sum *= (ChainsTuples.count - 1)
        
        return sum
    }
    
    
    /* Creates a direction array for the particular cell.
     The array values are set to false if the corresponding direction has not been checked for a valid move.
     If the direction has been checked from the cell it is set true.
     
     Example: if we are checking the third cell in a chain and the north and northeast vdirections have been examined
     then we would have directions[2] = [1,1,0,0,0,0,0,0] */
    func createDirectionArray()
    {
        directions.append(Array(repeating: Bool(false), count: 8))
    }
    
    
    /*  After checking all directions from a particular cell, the cells direction array is removed. */
    func removeDirectionArray()
    {
        directions.removeLast()
    }
    
    
    /* This function checks if an adjacent value exists and if the value does exist
     the function also makes sure the value was not used earlier in the chain. If both
     conditions pass this function returns true. */
    func isValidPoint(i: Int, j: Int) -> Bool
    {
        if (i >= 0 && i <= (WIDTH-1) && j >= 0 && j <= (WIDTH-1) && !checked[i][j])
        {
            return true
        }
        else
        {
            return false
            
        }
    }
    
    
    /* Changes the value in the directions array to true. This value represents that the current cell
     has checked the particular direction set to true. */
    func setCheckedDirections(chainElementNum: Int, maxDirection: Int)
    {
        for itr in 0..<maxDirection+1
        {
            directions[chainElementNum][itr] = true
        }
    }
    
    
    /* This function removes all of the duplicate chains. Each chain has a list of tuples associated with it. If
     any other chain has the same set of tuples it is then removed from the list of validChains. 
     To improve the algorithm's efficiency a special value is given to each chain. If these values are different,
     there is no chance the chains are the same. If these values are the same, it is possible these chains are the same
     and they need to be checked for being a duplicate This function also stores the number of chains starting at each
     cell and stores them into the array numberOfChainsStartingAt for use by viewController */
    func finalValidation (validChains: inout [[Int]], validChainsValue: inout [Int], validChainsTuples: inout [[(Int,Int)]])
    {
        var invalidLastTuple = [(Int, Int)]()
        var invalidIndicies = [Int]()
        var removeTuples = [[Int]]()
        
        for i in 0..<validChainsValue.count
        {
            print("validating... \(i+1) of \(validChainsValue.count)")
            if (!invalidLastTuple.contains(where: {$0 == validChainsTuples[i].first!})) //If we dont have the first tuple as an invalid last value, then add it.
            {invalidLastTuple.append(validChainsTuples[i].first!)}
            for j in i+1..<validChainsValue.count
            {
    
                if(!invalidIndicies.contains(j) && validChainsValue[i] == validChainsValue[j] && validChains[i][0] == validChains[j][0] && validChains[i].count == validChains[j].count)
                {
                    invalidIndicies.append(j)
                    removeTuples.append(validChains[j])
                }
                   
                else if (!invalidIndicies.contains(j) && invalidLastTuple.contains(where: {$0 == validChainsTuples[j].last!}))
                {
                    invalidIndicies.append(j)
                    removeTuples.append(validChains[j])
                }
                else if (!invalidIndicies.contains(j) && validChainsTuples[i].count == validChainsTuples[j].count && validChainsValue[i] == validChainsValue[j])
                {
                    var duplicate: Bool = true //Bool to represent if the two are the same or not
                    
                    for itr in validChainsTuples[i]
                    {
                        if (!validChainsTuples[j].contains(where: {$0 == itr}))
                        {
                            duplicate = false
                        }
                    }
                    if (duplicate)
                    {
                        invalidIndicies.append(j)
                        removeTuples.append(validChains[j])
                    }
                }
            }
        }
        
        //Final clean up for those that have final indicies AFTER them selves
        
        
        invalidIndicies.sort()
        

        
        for i in 0..<invalidIndicies.count
        {
            validChains.remove(at: invalidIndicies[i] - i)
            validChainsTuples.remove(at: invalidIndicies[i] - i)
            validChainsValue.remove(at: invalidIndicies[i] - i)
        }
        
        for itr in validChainsTuples
        {
            numberOfChainsStartingAt[itr[0].0*WIDTH+itr[0].1] += 1
        }
        
        //print("These are the valid chain values \(validChainsValue)")
        
    }

    
    /* This function places all of the valid chains in an array for access by viewController */
    func setValidChainsPublic(validChains: inout [[Int]])
    {
        var validChainsPublicTemp = [[[Int]]]()
        
        var temp = [[Int]]()
        
        for num in 0..<numberOfChainsStartingAt.count
        {
            for _ in 0..<numberOfChainsStartingAt[num]
            {
                temp.append(validChains.first!)
                validChains.removeFirst()
            }
            validChainsPublicTemp.append(temp)
            temp.removeAll()
        }
        
        validChainsPublic = validChainsPublicTemp
    }
}
