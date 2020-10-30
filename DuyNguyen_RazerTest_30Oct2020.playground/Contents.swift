/*
 In a future world there is a fruit tree. The tree have branches. The branches can be extended to
 other branches. The tree can have 2 types of fruits, apples and oranges.
 Every branch can have multiple branches extended from it and can have fruits as well.
 1. Develop program that can model the tree below
 2. Search the tree for the following
 a. Count how many oranges
 b. Count how many apples
 c. Return the branch that has the largest amount of fruits on it
 3. Return the color of any of the first fruits you find on the tree
*/

import Foundation

protocol Fruit {
    var color: String? { get }
}

class Apple: Fruit {
    var color: String? {
        return "red"
    }
}

class Orange: Fruit {
    var color: String? {
        return "orange"
    }
}

//this class represent a tree branch
class TreeNode {
    //use id to identify tree branch
    var id: Int = 0
    //use Optional because it might be not have any branches
    var branches: [TreeNode]? = nil
    //use Optional because it might be not have any fruits
    var fruits: [Fruit]? = nil
    
    init(id: Int, branches: [TreeNode]?, fruits: [Fruit]?) {
        self.id = id
        self.branches = branches
        self.fruits = fruits
    }
    
    //using DFS
    func totalNumberOfFruits<T: Fruit>(type: T.Type) -> Int {
        var sum = numberOfFruits(type: type)
        if let branches = branches {
            for branch in branches {
                sum += branch.totalNumberOfFruits(type: type)
            }
        }
        return sum
    }
    
    func firstAvailableFruitColor() -> String? {
        return firstAvailableFruit()?.color
    }
    
    //using BFS
    //note:
    //- this function only return the first branch that has largest amount of fruit, in case there are multiple brahces
    //- if all branches don't have any fruits it will return `nil`
    func branchHasLargestAmountOfFruits() -> TreeNode? {
        //assume node is the branch has largest amount
        var branchHasLargestAmount: TreeNode? = nil
        var maxAmount = 0
        
        var queue: [TreeNode] = []
        //enqueue first item as root node
        queue.append(self)
        
        while queue.count != 0 {
            //get next item in queue
            if let treeNode = queue.first {
                if let fruitCount = treeNode.fruits?.count {
                    if fruitCount > maxAmount {
                        maxAmount = fruitCount
                        branchHasLargestAmount = treeNode
                    }
                }
                
                if let branches = treeNode.branches {
                    queue.append(contentsOf: branches)
                }
                
                //remove item from queue
                queue.removeFirst()
            }
        }
        return branchHasLargestAmount
    }
    
    //MARK: - Private
    private func numberOfFruits<T: Fruit>(type: T.Type) -> Int {
        if let fruits = fruits {
            return fruits.filter( { $0 is T } ).count
        }
        return 0
    }
    
    //using BFS
    private func firstAvailableFruit() -> Fruit? {
        var queue: [TreeNode] = []
        //enqueue first item as root node
        queue.append(self)
        
        while queue.count != 0 {
            //get next item in queue
            if let treeNode = queue.first {
                if let firstFruit = treeNode.fruits?.first {
                    return firstFruit
                }
                
                //enqueue child branches to continue searching
                if let branches = treeNode.branches {
                    queue.append(contentsOf: branches)
                }
                
                //remove item from queue
                queue.removeFirst()
            }
        }
        return nil
    }
}

extension TreeNode: CustomStringConvertible {
    public var description: String { return "TreeNode id: \(id)" }
}



//initiate the tree
let leftBranch = TreeNode(id: 1, branches: nil, fruits: [Orange()])
let middleBranch = TreeNode(id: 2, branches: nil, fruits: nil)
let rightBranch = TreeNode(id: 3, branches: [TreeNode(id: 4, branches: nil, fruits: nil),
                                      TreeNode(id: 5, branches: [
                                        TreeNode(id: 7, branches: nil, fruits: [Orange()]),
                                        TreeNode(id: 8, branches: nil, fruits: [Apple()])], fruits: nil),
                                      TreeNode(id: 6, branches: nil, fruits: [Apple()])], fruits: [Orange(), Apple()])
let rootTree = TreeNode(id: 0, branches: [leftBranch, middleBranch, rightBranch], fruits: nil)


//Outputs

print("How many oranges: \(rootTree.totalNumberOfFruits(type: Orange.self))")

print("How many apples: \(rootTree.totalNumberOfFruits(type: Apple.self))")

if let colorOfFirstFruitFound = rootTree.firstAvailableFruitColor() {
    print("First fruit on this tree has color: \(colorOfFirstFruitFound)")
} else {
    print("Could not find any fruit on this tree")
}

if let branchHasLargestAmountOfFruits = rootTree.branchHasLargestAmountOfFruits() {
    print("The first branch that has largest amount of fruit on this tree is: \(branchHasLargestAmountOfFruits)")
} else {
    print("Could not find any branch that has largest amount of fruit on this tree")
}


