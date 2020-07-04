//
//  taskRowiOS2.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/21/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct taskRowiOS2: View {
    var taskInd:Int
    @State var task:models.task = .init(myId: 0, name: "", description: "")
    @EnvironmentObject var data:models
    var format = DateFormatter()
    @Binding var selectedTaskInd:Int
    @Binding var showTaskOptions:Bool
    @Binding var showSheet:Bool
              
    
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
        Button(action:{
            self.selectedTaskInd = self.taskInd
            self.showTaskOptions = true
            self.showSheet = true
        }){
        HStack{
            if(self.taskInd < self.data.taskData.count)
            {
            Rectangle().frame(width:20)
                .foregroundColor(data.getColor(self.data.categories[self.data.taskData[self.taskInd].categoryInd].color ))
                VStack(alignment:.leading){
                Text(self.data.taskData[self.taskInd].name).bold()
                Text(self.data.taskData[self.taskInd].description)
            }
            Spacer()
                Text("\(self.giveTime(time:Int(self.data.taskData[self.taskInd].timestamp[self.data.today]?.magnitude ?? 0)))")
                .frame(width:80)
            
            Divider()
                Button(action:{
                     self.data.selectTask(taskInd: self.taskInd)
                })
                {
            if self.data.taskData[self.taskInd].selected
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
            }
            else{
                Text("Deleted")
            }
        }
        .contentShape(Rectangle())
//    .shadow(radius: 10)
        .onAppear()
            {
                self.format.dateFormat = "MM_dd_yyyy"
//                self.task = self.data.taskData[self.taskInd]

        }
        }
        
    }
}

struct taskRowiOS2_Previews: PreviewProvider {
    static var previews: some View {
        taskRowiOS2(taskInd: 0, selectedTaskInd: .constant(2), showTaskOptions: .constant(true), showSheet: .constant(true)).environmentObject(models())
    }
}
