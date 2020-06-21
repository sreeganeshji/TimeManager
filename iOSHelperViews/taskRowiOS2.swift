//
//  taskRowiOS2.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/21/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct taskRowiOS2: View {
    @Binding var task:models.task
    @EnvironmentObject var data:models
    @State var today:String = ""
    var format = DateFormatter()
    
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
            Rectangle().frame(width:20)
                .foregroundColor(task.category?.color ?? .gray)
            Spacer()
            VStack{
                Text(task.name).bold()
                Text(task.description)
                
            }
            Spacer()
            Text("\(self.giveTime(time:Int(task.timestamp[self.today]?.magnitude ?? 0)))")
                .frame(width:80)
            
            Divider()

            if self.task.selected
            {
                Image(systemName: "stop.fill")
                    .foregroundColor(.red)
                .padding()
                    .frame(width:50)
            }
            else{
                Image(systemName: "play.fill")
                    .foregroundColor(.green)
                .padding()
                    .frame(width:50)
            }
           
            
        }
        .contentShape(Rectangle())
//    .shadow(radius: 10)
        .onAppear()
            {
                self.format.dateFormat = "MM_dd_yyyy"
                self.today = self.format.string(from:Date())
        }
        
    }
}

struct taskRowiOS2_Previews: PreviewProvider {
    static var previews: some View {
        taskRowiOS2(task: .constant(models.task(id: 1, name: "stuff", description: "need to do stuff"))).frame(height:40).environmentObject(models())
    }
}
