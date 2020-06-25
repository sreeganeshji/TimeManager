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
    
     @Published var categories:[category]
    
     struct task:Equatable, Hashable
     {
        
        /*
         * name
         * category
         * timestamps
         *
         */
        var lastChanged:TimeInterval?
        var myId:Int
        var name:String
        var description:String
        var categoryInd:Int = 0 //0 is uncategorized
        var timestamp:[String:TimeInterval] = .init()
//            ["":TimeInterval()]
        var selected:Bool = false // if the current task is ON
        
    }
    
    struct category:Equatable, Hashable {
        var name:String
        var color:Color
        
        init(_ name:String, _ color:Color = .orange) {
            self.name = name
            self.color = color
        }
 
    }
    
    var today:String = ""
    
    var colors:[Color] = [.blue,.red,.orange,.pink,.purple,.yellow]
    
    
    @Published var concurrentTasks:Bool = false
    
    @Published var taskData:[task]

    init()
    {
        categories = [category("No category", .gray),category("Work"),category("Study"),category("Play"),category("Socialize")]
        taskData = [task( myId:1,name: "CS6515", description: "Study that", categoryInd:0),task(myId:2,name: "analog work", description: "run simulation",categoryInd:1)]
        
    }
}
