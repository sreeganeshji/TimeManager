//
//  models.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/13/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import Foundation
import SwiftUI

class models: ObservableObject
{
    
    var categories:[category]
    
     struct task:Equatable, Hashable
     {
        
        /*
         * name
         * category
         * timestamps
         *
         */
        var lastChanged:TimeInterval?
        var id:Int
        var name:String
        var description:String
        var category:category
        var timestamp:[String:TimeInterval] = ["":TimeInterval()]
        var selected:Bool = false // if the current task is ON
        
    }
    
    struct category:Equatable, Hashable {
        var name:String
        var color:Color
        
        init(_ name:String) {
            self.name = name
            self.color = .accentColor
        }
        
    }
    
    var today:String = ""
    
    var colors:[Color] = [.blue,.red,.orange,.pink,.purple,.yellow]
    
    
    @Published var concurrentTasks:Bool = false
    
    @Published var taskData:[task]
    init()
    {
        categories = [category("Work"),category("Study"),category("Play"),category("Socialize")]
        taskData = [task( id:1,name: "CS6515", description: "Study that", category: category("Study")),task(id:2,name: "analog work", description: "run simulation", category: category("Work"))]

    }
}
