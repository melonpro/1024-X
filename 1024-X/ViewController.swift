//
//  ViewController.swift
//  1024-X
//
//  Created by 赵大喵 on 14/11/20.
//  Copyright (c) 2014年 melonpro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var game = GameBoard(frame: self.view.frame)
        game.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        self.view.addSubview(game)
        
        
              // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

