//
//  Core.swift
//  1024-X
//
//  Created by 赵大喵 on 14/11/20.
//  Copyright (c) 2014年 melonpro. All rights reserved.
//

import Foundation
import UIKit

enum Direction{
    case Up
    case Down
    case Left
    case Right
}


struct Piece {
    var value:Int = 0
    var Position:(Int,Int)
    var newAdd:Bool = false
    var OriginPos1:(Int,Int)
    var OriginPos2:(Int,Int)
    var childValue:Int
  
    init(){
        value = 0
        newAdd = false
        OriginPos1 = (-1,-1)
        OriginPos2 = (-1,-1)
        childValue = 0
        Position = (0,0)
        
    }
    
}
//4*4 二维数组
struct Board{
    
    var data = [Piece]()
    var temp = Piece()
    
    init(){
        data = [Piece](count: 20, repeatedValue:temp)
    }
    
    subscript(row: Int, col: Int) -> Piece {
        get {
            assert(row >= 0 && row <= 4)
            assert(col >= 0 && col <= 4)
            return data[row * 4 + col]
        }
        set {
            assert(row >= 0 && row <= 4)
            assert(col >= 0 && col <= 4)
            data[row * 4 + col] = newValue
        }
    }
}

//1024核心类
class Square{
    var score:Int = 0

    //存储4*4数据
    var board:Board = Board()
    
    //初始化
    init(){
        for i in 0..<4{
            for j in 0..<4{
                board[i,j].value = 0
                board[i,j].Position = (i,j)
            }
        }
        score = 0
    }
    
    
    
    
    //打印全部
    func printAll(){
        println("-------")
        for i in  0..<4{
            for j in 0..<4{
                print("\(board[i,j].value) ")
            }
            print("\n")
        }
        println("-------")
    }
    
    //是否满了
    func isFull() -> Bool{
        for i in 0..<4{
            for j in 0..<4{
                if(board[i,j].value == 0){
                    //println("square not full")
                    return false
                }
            }
        }
        println("square full now")
        return true
    }
    
    //随机添加一个
    func addOne() -> Bool {
        if(self.isFull()){
            return false
        }
        
        var (i,j) = self.getEmpty()
        var rand:Int = Int(arc4random_uniform(100))
        switch (rand % 2){
        
        case 0:
             board[i,j].value = 4
        default:
            board[i,j].value = 2
        }
        
        board[i,j].Position = (i,j)
        board[i,j].OriginPos1 = (i,j)
        
        board[i,j].childValue = 0
        return true
    }
    func add2One() -> Bool {
        if(self.isFull()){
            return false
        }
        
        
        var (i,j) = self.getEmpty()
        var rand:Int = Int(arc4random_uniform(100))
        switch (rand % 2){
            
        case 0:
            board[i,j].value = 4
        default:
            board[i,j].value = 2
        }
        board[i,j].newAdd = true
        board[i,j].Position = (i,j)
        board[i,j].OriginPos1 = (i,j)
        
        board[i,j].childValue = 0

        return true
    }
    
    //获取一个随机位置
    func getEmpty() -> (Int,Int) {
        var emptys: Array<(Int,Int)> = []
        for i in 0..<4{
            for j in 0..<4{
                if(board[i,j].value == 0){
                    emptys.append((i,j))
                }
            }
        }
        
        var rand:Int = Int(arc4random_uniform(100))
        return emptys[rand%(emptys.count)]
    }
    
    
    func move(direction:Direction) -> Bool{
    
        var moveCount:Int = 0
        switch direction
        {
        case .Up:
            
            println("_____________________")
            for i in  0..<4{
                for j in 0..<4{
                    print("\(board[i,j].value) (\(board[i,j].OriginPos1)-\(board[i,j].OriginPos2)#\(board[i,j].childValue)\t| ")
                }
                print("\n")
            }
            println("_____________________")
            for x in 0...3{
                for i in 0...3{
                    for j in 0...3{
                        if((board[i,j].value == 0) && (board[i+1,j].value != 0)){
                            board[i,j].value = board[i+1,j].value
                            board[i,j].OriginPos1 = board[i+1,j].OriginPos1
                            board[i,j].OriginPos2 = board[i+1,j].OriginPos2
                            board[i+1,j].OriginPos1 = (-1,-1)
                            board[i+1,j].OriginPos2 = (-1,-1)
                            board[i,j].childValue = board[i+1,j].childValue
                            board[i+1,j].childValue = 0
                            
                            board[i+1,j].value = 0
                        }
                    }
                }
            }
        for i in 0...3{
            for j in 0...3{
                if(board[i,j].value == board[i+1,j].value ){
                    board[i,j].value += board[i+1,j].value
                    score += board[i,j].value

                    board[i,j].OriginPos1 = board[i,j].OriginPos1
                    board[i,j].OriginPos2 = board[i+1,j].OriginPos1
                    board[i+1,j].OriginPos1 = (-1,-1)
                    board[i+1,j].OriginPos2 = (-1,-1)
                    board[i,j].childValue = board[i,j].value / 2
                    board[i+1,j].childValue = 0
                    board[i+1,j].value = 0

                    moveCount++
                }
            }
        }
        for i in 0...3{
            for j in 0...3{
                if((board[i,j].value == 0) && (board[i+1,j].value != 0)){
                    board[i,j].value = board[i+1,j].value
                    board[i,j].OriginPos2 = board[i+1,j].OriginPos2
                    board[i,j].OriginPos1 = board[i+1,j].OriginPos1
                    board[i+1,j].OriginPos1 = (-1,-1)
                    board[i+1,j].OriginPos2 = (-1,-1)
                    board[i,j].childValue = board[i+1,j].childValue
                    board[i+1,j].childValue = 0
                    board[i+1,j].value = 0
                }
            }
        }
            for i in  0..<4{
                for j in 0..<4{
                    print("\(board[i,j].value) (\(board[i,j].OriginPos1)-\(board[i,j].OriginPos2)#\(board[i,j].childValue)\t| ")
                }
                print("\n")
            }
             println("_____________________")

            return moveCount>0 ? true:false
        
        case .Down:
            println("_____________________")
            for i in  0..<4{
                for j in 0..<4{
                    print("\(board[i,j].value) (\(board[i,j].OriginPos1)-\(board[i,j].OriginPos2)#\(board[i,j].childValue)\t| ")
                }
                print("\n")
            }
            println("_____________________")
            for x in 0...3{
                for i in 0...3{
                    for j in 0...3{
                        if((board[3-i,3-j].value == 0)&&(3-i-1>=0)){
                        if(board[3-i,3-j].value != board[3-i-1,3-j].value){
                            board[3-i,3-j].value = board[3-i-1,3-j].value
                            board[3-i,3-j].OriginPos1 = board[3-i-1,3-j].OriginPos1
                            board[3-i,3-j].OriginPos2 = board[3-i-1,3-j].OriginPos2
                            board[3-i-1,3-j].OriginPos1 = (-1,-1)
                            board[3-i-1,3-j].OriginPos2 = (-1,-1)
                            board[3-i-1,3-j].value = 0
                        }
                    }
                }
            }
        }
        for i in 0...3{
            for j in 0...3{
                if((board[3-i,3-j].value != 0)&&(3-i-1>=0)&&(board[3-i,3-j].value == board[3-i-1,3-j].value)){
                    board[3-i,3-j].value += board[3-i-1,3-j].value
                     score += board[3-i,3-j].value
                    board[3-i-1,3-j].value = 0
                    board[3-i,3-j].OriginPos1 = board[3-i,3-j].OriginPos1
                    board[3-i,3-j].OriginPos2 = board[3-i-1,3-j].OriginPos1
                    board[3-i-1,3-j].OriginPos1 = (-1,-1)
                    board[3-i-1,3-j].OriginPos2 = (-1,-1)
                    board[3-i,3-j].childValue =  board[3-i,3-j].value / 2
                    board[3-i-1,3-j].childValue = 0
                   
                    moveCount++
                }
            }
        }
        for i in 0...3{
            for j in 0...3{
                if((board[3-i,3-j].value == 0)&&(3-i-1>=0)){
                    if(board[3-i,3-j].value != board[3-i-1,3-j].value)
                    {
                        board[3-i,3-j].value = board[3-i-1,3-j].value
                        board[3-i-1,3-j].value = 0
                        board[3-i,3-j].OriginPos2 = board[3-i-1,3-j].OriginPos2
                        board[3-i,3-j].OriginPos1 = board[3-i-1,3-j].OriginPos1
                        board[3-i-1,3-j].OriginPos1 = (-1,-1)
                        board[3-i-1,3-j].OriginPos2 = (-1,-1)
                        board[3-i,3-j].childValue =  board[3-i-1,3-j].childValue
                        board[3-i-1,3-j].childValue = 0
                    }
                }
                
            }
        }
            for i in  0..<4{
                for j in 0..<4{
                    print("\(board[i,j].value) (\(board[i,j].OriginPos1)-\(board[i,j].OriginPos2)#\(board[i,j].childValue)\t| ")
                }
                print("\n")
            }
            println("_____________________")

            return moveCount>0 ? true:false

        

        case .Left:
            println("_____________________")

            for i in  0..<4{
                for j in 0..<4{
                    print("\(board[i,j].value) (\(board[i,j].OriginPos1)-\(board[i,j].OriginPos2)#\(board[i,j].childValue)\t| ")
                }
                print("\n")
            }
             println("_____________________")
            for x in 0...3{
            for i in 0...3{
                for j in 0..<3{
                    if(board[i,j].value == 0 &&  board[i,j+1].value != 0){
                        board[i,j].value = board[i,j+1].value
                        board[i,j].OriginPos1 = board[i,j+1].OriginPos1
                        board[i,j].OriginPos2 = board[i,j+1].OriginPos2
                        board[i,j+1].OriginPos1 = (-1,-1)
                        board[i,j+1].OriginPos2 = (-1,-1)
                        board[i,j+1].value = 0
                    }
                }
            }
        }
        
        
        for i in 0...3{
            for j in 0..<3{
                if(board[i,j].value == board[i,j+1].value ){
                    board[i,j].value += board[i,j+1].value
                    score += board[i,j].value

                    board[i,j].OriginPos1 = board[i,j].OriginPos1
                    board[i,j].OriginPos2 = board[i,j+1].OriginPos1
                    board[i,j+1].OriginPos1 = (-1,-1)
                    board[i,j+1].OriginPos2 = (-1,-1)
                    board[i,j].childValue =  board[i,j].value / 2
                    board[i,j+1].childValue = 0
                    board[i,j+1].value = 0
                                     moveCount++
                    
                }
            }
        }
        for i in 0...3{
            for j in 0..<3{
                if(board[i,j].value == 0){
                    board[i,j].value = board[i,j+1].value
                    board[i,j].OriginPos2 = board[i,j+1].OriginPos2
                    board[i,j].OriginPos1 = board[i,j+1].OriginPos1
                    board[i,j+1].OriginPos1 = (-1,-1)
                    board[i,j+1].OriginPos2 = (-1,-1)
                    board[i,j].childValue =  board[i,j+1].childValue
                    board[i,j+1].childValue = 0

                    board[i,j+1].value = 0
                }
            }
        }
            
            for i in  0..<4{
                for j in 0..<4{
                    print("\(board[i,j].value) (\(board[i,j].OriginPos1)-\(board[i,j].OriginPos2)#\(board[i,j].childValue)\t| ")
                }
                print("\n")
            }
            println("_____________________")

            return moveCount>0 ? true:false

        
        case .Right:
             println("_____________________")
            for i in  0..<4{
                for j in 0..<4{
                    print("\(board[i,j].value) (\(board[i,j].OriginPos1)-\(board[i,j].OriginPos2)#\(board[i,j].childValue)\t| ")
                }
                print("\n")
            }
             println("_____________________")
            for x in 0...3{
                for i in 0...3{
                    for j in 0...3{
                        if((board[3-i,3-j].value == 0) && (3-j-1>=0) && (board[3-i,3-j-1].value != 0)){
                            if(board[3-i,3-j].value != board[3-i,3-j-1].value){
                                board[3-i,3-j].value = board[3-i,3-j-1].value
                                board[3-i,3-j].OriginPos1 = board[3-i,3-j-1].OriginPos1
                                board[3-i,3-j].OriginPos2 = board[3-i,3-j-1].OriginPos2
                                board[3-i,3-j-1].OriginPos1 = (-1,-1)
                                board[3-i,3-j-1].OriginPos2 = (-1,-1)
                                board[3-i,3-j-1].value = 0
                            }
                        }
                    }
                }
            }
            for i in 0...3{
                for j in 0...3{
                    if((board[3-i,3-j].value != 0)&&(3-j-1>=0)&&(board[3-i,3-j].value == board[3-i,3-j-1].value)){
                        board[3-i,3-j].value += board[3-i,3-j-1].value
                         score += board[3-i,3-j].value
                        board[3-i,3-j].OriginPos1 = board[3-i,3-j].OriginPos1
                        board[3-i,3-j].OriginPos2 = board[3-i,3-j-1].OriginPos1
                        board[3-i,3-j-1].OriginPos1 = (-1,-1)
                        board[3-i,3-j-1].OriginPos2 = (-1,-1)
                        board[3-i,3-j].childValue =  board[3-i,3-j].value/2
                        board[3-i,3-j-1].value = 0
                        board[3-i,3-j-1].childValue = 0
                        

                        moveCount++
                    }
                }
            }
            for i in 0...3{
                for j in 0...3{
                    if((board[3-i,3-j].value == 0)&&(3-j-1>=0)){
                        if(board[3-i,3-j].value != board[3-i,3-j-1].value)
                        {
                            board[3-i,3-j].value = board[3-i,3-j-1].value
                            board[3-i,3-j-1].value = 0
                            board[3-i,3-j].OriginPos2 = board[3-i,3-j-1].OriginPos2
                            board[3-i,3-j].OriginPos1 = board[3-i,3-j-1].OriginPos1
                            board[3-i,3-j-1].OriginPos1 = (-1,-1)
                            board[3-i,3-j-1].OriginPos2 = (-1,-1)
                            board[3-i,3-j].childValue =  board[3-i,3-j-1].childValue
                            board[3-i,3-j-1].childValue = 0
                        }
                    }
                    
                }
            }
            
            for i in  0..<4{
                for j in 0..<4{
                    print("\(board[i,j].value) (\(board[i,j].OriginPos1)-\(board[i,j].OriginPos2)#\(board[i,j].childValue)\t| ")
                }
                print("\n")
            }
            println("_____________________")
            
            
            return moveCount>0 ? true:false

        }
       
}
    
    func userhasWon() -> Bool{
        var userwon:Bool = false
        
        for i in 0...3{
            for j in 0...3{
                if (board[i,j].value >= 1024){
                 userwon = true
                }
            }
        }
        return userwon
        
    }
    
    func userhasLost() -> Bool{
        var userlost :Bool = false
        if (self.isFull() == false)
        {
            userlost = false
        }
        if (self.isFull() == true)
        {
        
            if (self.move(Direction.Up) == false && self.move(Direction.Down) == false && self.move(Direction.Left) == false && self.move(Direction.Right) == false)
            {
                userlost = true
                
                println("userhaslost")
            }
        }
        return userlost
    }
    
    func moveCommander(direction:Direction){
        
        switch direction{
        case .Down:
            println("down")
        case .Up:
            println("up")
        case .Left:
            println("left")
        case .Right:
            println("right")
        }
        
        var moveConditon:Bool = move(direction)
        if(moveConditon == false)
        {
            println("No Move")
            self.add2One()
        }
        if(moveConditon == true)
        {
            self.add2One()
            self.printAll()
            
//            for i in 0..<3{
//                for j in 0..<3{
//                    board[i,j].OriginPos1 = (i,j)
//                    board[i,j].OriginPos2 = (-1,-1)
//                    board[i,j].Position = (i,j)
//                    board[i,j].childValue = 0
//                    
//                }
//            }

        }
       
     
    }
}
