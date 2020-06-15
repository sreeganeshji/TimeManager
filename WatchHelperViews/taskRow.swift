//
//  taskRow.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/18/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct taskRow: View {
    var name:String
    var time:TimeInterval?
    var color:Color
    
    func giveTime(time:Int)->String
    {
        var sec = time
        var min = sec/60
        let hr = min/60
        sec %= 60
        min %= 60
        if (hr>0){
            return ("\(hr):\(min):\(sec)")
        }
        else if(min>0)
        {
            return ("\(min):\(sec)")
        }
        
        return ("\(sec)")
        
    }
    
    var body: some View {
       


        HStack{
            
            Text(name)
            Spacer()
            Text("\(self.giveTime(time:Int(time?.magnitude ?? 0)))")
            
        }
        .contentShape(Rectangle())
        
//        .frame(height:30)
//        .padding()
//            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(color))
//            .padding(.bottom, 10)
        
    }
}

struct taskRow_Previews: PreviewProvider {
    static var previews: some View {
        Group
            {
                taskRow(name: "HW", time: .init(120),color: .blue)
                taskRow(name: "HW", time: .init(3600),color: .red)
        }
    }
}
