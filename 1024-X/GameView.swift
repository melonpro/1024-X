//
//  GameView.swift
//  1024-X
//
//  Created by 赵大喵 on 14/11/24.
//  Copyright (c) 2014年 melonpro. All rights reserved.
//

import Foundation
import UIKit
struct NumLabels{
    var data = [UILabel]()
    var labeltemp = UILabel()
    init(){
        data = [UILabel](count:20,repeatedValue:labeltemp)
    }
    subscript(row: Int, col: Int) -> UILabel {
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
struct NumViews{

    var views = [UIView]()
    var viewtemp = UIView()
    
    init(){
        views = [UIView](count: 20, repeatedValue:viewtemp)
        
    }
    
    subscript(row: Int, col: Int) -> UIView {
        get {
            assert(row >= 0 && row <= 4)
            assert(col >= 0 && col <= 4)
            return views[row * 4 + col]
        }
        set {
            assert(row >= 0 && row <= 4)
            assert(col >= 0 && col <= 4)
            views[row * 4 + col] = newValue
        }
    }

}


class GameBoard: UIView {
    
    let tilePopStartScale: CGFloat = 0.1
    let tilePopMaxScale: CGFloat = 1.1
    let tilePopDelay: NSTimeInterval = 0.05
    let tileExpandTime: NSTimeInterval = 0.18
    let tileContractTime: NSTimeInterval = 0.08
    
    let tileMergeStartScale: CGFloat = 1.0
    let tileMergeExpandTime: NSTimeInterval = 0.08
    let tileMergeContractTime: NSTimeInterval = 0.08
    
    let perSquareSlideDuration: NSTimeInterval = 0.08
    var UpRecognizer :UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var DownRecognizer :UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var RightRecognizer :UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    var LeftRecognizer :UISwipeGestureRecognizer = UISwipeGestureRecognizer()
   
    var direction:Direction?
    var tileWidth:CGFloat = 60
    var paddingwidth :CGFloat = 50
    var paddingHeight : CGFloat = 120
   
    
    var coreSquareData:Square = Square()
    var numberView = NumViews()
    var numberLabel = NumLabels()
    var moves = [Direction]()
    var scorelabel:UILabel = UILabel()
    var bgview:UIView = UIView()
    var background:UIView = UIView()
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func initSwipRecognizer(){
        UpRecognizer.direction = UISwipeGestureRecognizerDirection.Up
        DownRecognizer.direction = UISwipeGestureRecognizerDirection.Down
        RightRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        LeftRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        UpRecognizer.addTarget(self, action: "handleSwip:")
        DownRecognizer.addTarget(self, action: "handleSwip:")
        RightRecognizer.addTarget(self, action: "handleSwip:")
        LeftRecognizer.addTarget(self, action: "handleSwip:")
        self.addGestureRecognizer(UpRecognizer)
        self.addGestureRecognizer(DownRecognizer)
        self.addGestureRecognizer(RightRecognizer)
        self.addGestureRecognizer(LeftRecognizer)
    }
    
    func handleSwip(recognizer:UISwipeGestureRecognizer){
        
        if(coreSquareData.userhasWon())
        {
            println("won")
            let alertView = UIAlertView()
            alertView.title = "Victory"
            alertView.message = "You won!"
            alertView.addButtonWithTitle("Cancel")
            alertView.show()

        }
        if(coreSquareData.userhasLost())
        {
            println("lost")
            let alertView = UIAlertView()
            alertView.title = "Defeat"
            alertView.message = "You lost..."
            alertView.addButtonWithTitle("Cancel")
            alertView.show()
        }
        switch(recognizer.direction){
        case  UISwipeGestureRecognizerDirection.Up:
            direction = Direction.Up
        case  UISwipeGestureRecognizerDirection.Down:
            direction = Direction.Down
            
        case  UISwipeGestureRecognizerDirection.Right:
            direction = Direction.Right
            
        case  UISwipeGestureRecognizerDirection.Left:
            direction = Direction.Left
            
        default:
            direction = nil
        }
        
        coreSquareData.moveCommander(direction!)
        moves.append(direction!)
        
        self.refreshView(direction!)
        
    }
    override init(frame:CGRect) {
        
        
        super.init(frame:frame)
//        self.layer.borderWidth = 2
//        self.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        paddingwidth = (self.frame.width - tileWidth*4 - 45) / 2
        
        background = UIImageView(image: UIImage(named: "background.png"))
        background.frame  = CGRectMake(0, 0, tileWidth * 4 + 80, tileWidth * 4 + 80)
        background.center = CGPointMake(self.frame.width / 2, paddingHeight + 25 + tileWidth * 2)
        self.addSubview(background)
        
        scorelabel = UILabel(frame: CGRectMake(0, 0, 180, 50))
        scorelabel.center = CGPointMake(self.frame.width/2, 60)
        scorelabel.text = "Score :\(coreSquareData.score)"
        scorelabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        scorelabel.layer.cornerRadius = 5
        scorelabel.layer.borderWidth = 2
        scorelabel.font = UIFont(name: "NearManga", size: 40)
        scorelabel.textAlignment = NSTextAlignment.Center

        self.addSubview(scorelabel)
        
        
        
        for i in 0..<7 {
            coreSquareData.addOne()
        }
        coreSquareData.printAll()
        self.initSwipRecognizer()
        
        for i in 0...3{
            for j in 0...3{
                
                
                let x = paddingwidth + CGFloat(i)*(tileWidth + 15)
                let y = paddingHeight + CGFloat(j)*(tileWidth + 15)
                var view:UIView = UIView(frame: CGRectMake(x, y, tileWidth, tileWidth))
                var label_temp:UILabel = UILabel(frame: CGRectMake(x, y, tileWidth, tileWidth))
                
            
                label_temp.text = "\(coreSquareData.board[j,i].value)"
                if(coreSquareData.board[j,i].value == 0)
                {
                    label_temp.text = " "
                    label_temp.layer.borderColor = UIColor.whiteColor().CGColor
                }
                else{
                 
                     label_temp.layer.borderColor = UIColor.lightGrayColor().CGColor
                }
                
                if(coreSquareData.board[j,i].newAdd == true){
                     label_temp.textColor = UIColor.redColor()
                }
                else{
                     label_temp.textColor = self.numberColor(coreSquareData.board[j,i].value)
                }
                
                 label_temp.backgroundColor = self.tileColor(coreSquareData.board[j,i].value)
                

               
//                self.imagePicker(j, j: i)

                label_temp.font = UIFont(name: "NearManga", size: 40)
               
                label_temp.layer.borderWidth = 2
                label_temp.layer.cornerRadius = 5
                label_temp.textAlignment = NSTextAlignment.Center
//                label_temp.backgroundColor = UIColor.whiteColor()()
                numberLabel[i,j] = label_temp
                numberView[i,j].addSubview(numberLabel[i,j])
                self.addSubview(numberView[i,j])
            }
            
        }
        
    }
    func refreshView(direction:Direction){
        var x,y:CGFloat
        
       
        
        for i in 0...3{
            for j in 0...3{
                
                let x = paddingwidth + CGFloat(i)*(tileWidth + 15)
                let y = paddingHeight + CGFloat(j)*(tileWidth + 15)
                var label = UILabel()
                
                
                numberLabel[i,j].text = "\(coreSquareData.board[j,i].value)"
                if(coreSquareData.board[j,i].value == 0)
                {
                    numberLabel[i,j].text = " "
                    numberLabel[i,j].layer.borderColor = UIColor.whiteColor().CGColor
                }
                else{
                     numberLabel[i,j].layer.borderColor = UIColor.lightGrayColor().CGColor
                }
                if(coreSquareData.board[j,i].newAdd == true){
                    numberLabel[i,j].textColor = UIColor.redColor()
                }
                else{
                    numberLabel[i,j].textColor = self.numberColor(coreSquareData.board[j,i].value)
                }


                numberLabel[i,j].font = UIFont(name: "NearManga", size: 40)
               
                numberLabel[i,j].layer.borderWidth = 2
                numberLabel[i,j].textAlignment = NSTextAlignment.Center
                numberLabel[i,j].layer.cornerRadius = 5
                numberLabel[i,j].backgroundColor = self.tileColor(coreSquareData.board[j,i].value)
                
                
                coreSquareData.board[j,i].newAdd = false
            }
            for i in 0...3{
                for j in 0...3{
                    if((coreSquareData.board[j,i].childValue != 0))
                    {
                        var (a,b) = coreSquareData.board[j,i].OriginPos1
                        var (u,v) = coreSquareData.board[j,i].OriginPos2
                    numberLabel[i,j].layer.setAffineTransform(CGAffineTransformMakeScale(self.tileMergeStartScale, self.tileMergeStartScale))
                        
                   
                    switch direction{
                        case .Down:
                            x = 0;y = -20
                        case .Up:
                            x = 0;y = +20
                        case .Left:
                            x = -20;y = 0
                        case .Right:
                            x = +20;y = 0
                        }
                    println("\(i),\(j)")
                    UIView.animateWithDuration(self.tileMergeExpandTime,
                        animations: { () -> Void in
                            self.numberLabel[i,j].layer.setAffineTransform(CGAffineTransformMakeScale(self.tilePopMaxScale, self.tilePopMaxScale))
//                            self.numberLabel[b,a].backgroundColor = UIColor.greenColor()
                            self.numberLabel[b,a].transform = CGAffineTransformMakeTranslation(x, y)
                            self.numberLabel[v,u].transform = CGAffineTransformMakeTranslation(x, y)
//                            self.numberLabel[v,u].backgroundColor = UIColor.greenColor()

                        },
                        
                        completion: { (finished: Bool) -> Void in
                            // Contract tile to original size
                            UIView.animateWithDuration(self.tileMergeContractTime,
                                animations: { () -> Void in
                                    self.numberLabel[i,j].layer.setAffineTransform(CGAffineTransformIdentity)})
                            if ( b != i && a != j)
                            {
                           self.numberLabel[b,a].alpha = 0
                            }
                            if ( v != i && u != j)
                            {
                            self.numberLabel[v,u].alpha = 0
                            }

                            
                            UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
                            
                            
                        })
                        self.numberLabel[b,a].transform = CGAffineTransformIdentity
                        self.numberLabel[v,u].transform = CGAffineTransformIdentity
                        
                        
                        self.numberLabel[v,u].alpha = 1
                         self.numberLabel[b,a].alpha = 1

                    }
                }

                
            }
             scorelabel.text = "Score :\(coreSquareData.score)"
            scorelabel.layer.borderColor = UIColor.lightGrayColor().CGColor
            scorelabel.layer.cornerRadius = 5
            scorelabel.layer.borderWidth = 2
            scorelabel.font = UIFont(name: "NearManga", size: 40)
            scorelabel.textAlignment = NSTextAlignment.Center

            self.resetData()
            
        }
    }
    
    func imagePicker(i:Int,j:Int){
        var value = self.coreSquareData.board[i,j].value
        switch value{
            case 2:
                self.numberLabel[i,j].backgroundColor = UIColor.yellowColor()

            default:
                self.numberLabel[i,j].backgroundColor = UIColor.whiteColor()

        }
        
    }
    func resetData(){
        for i in 0...3{
            for j in 0...3{
                coreSquareData.board[i,j].OriginPos1 = (i,j)
                coreSquareData.board[i,j].OriginPos2 = (-1,-1)
                coreSquareData.board[i,j].Position = (i,j)
                coreSquareData.board[i,j].childValue = 0
                
            }
        }

    }
    func tileColor(value: Int) -> UIColor {
        switch value {
        case 2:
            return UIColor(red: 238.0/255.0, green: 228.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        case 4:
            return UIColor(red: 237.0/255.0, green: 224.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        case 8:
            return UIColor(red: 242.0/255.0, green: 177.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        case 16:
            return UIColor(red: 245.0/255.0, green: 149.0/255.0, blue: 99.0/255.0, alpha: 1.0)
        case 32:
            return UIColor(red: 246.0/255.0, green: 124.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case 64:
            return UIColor(red: 246.0/255.0, green: 94.0/255.0, blue: 59.0/255.0, alpha: 1.0)
        case 128, 256, 512, 1024, 2048:
            return UIColor(red: 237.0/255.0, green: 207.0/255.0, blue: 114.0/255.0, alpha: 1.0)
        default:
            return UIColor.whiteColor()
        }
    }
    
    // Provide a numeral color for a given value
    func numberColor(value: Int) -> UIColor {
        switch value {
        case 2, 4:
            return UIColor(red: 119.0/255.0, green: 110.0/255.0, blue: 101.0/255.0, alpha: 1.0)
        default:
            return UIColor.whiteColor()
        }
    }

    
}