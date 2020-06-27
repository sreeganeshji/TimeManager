//
//  taskRow.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/18/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct taskRowiOS: View {
    var name:String
    var time:TimeInterval?
    @Binding var color:Color
    @Binding var isActive:Bool
    
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
            if(self.isActive)
            {
                Image(systemName: "play.fill")
                    .foregroundColor(color)
            }
            else{
//            RoundedRectangle(cornerRadius: 5).foregroundColor(color)
//                .frame(width:30)
                Image(systemName: "stop.fill")
                .foregroundColor(color)
            }
        
            
        }
        .contentShape(Rectangle())

//        .frame(height:30)
//        .padding()
//            .background(RoundedRectangle(cornerRadius: 10)
//            .foregroundColor(color)
//            .padding(.bottom, 10)
        
    }
}

struct taskRowIos_Previews: PreviewProvider {
    static var previews: some View {
        Group
            {
                taskRowiOS(name: "HW", time: .init(120),color: .constant(.black), isActive: .constant(true)).frame(height:40)
                taskRowiOS(name: "HW", time: .init(3600),color: .constant(.red), isActive: .constant(false)).frame(height:40)
        }
    }
}
