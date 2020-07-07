//
//  addTime.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/5/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct addTime: View {

    

        @EnvironmentObject var data:models
        
        @State var hr:Int = 3
        @State var min:Int = 0
        @State var sec:Int = 0
        
    //    init()
    //    {
    //        print("Initializer")
    //    }
        
        struct timeVal{
            var hr:Int
            var min:Int
            var sec:Int
            var totalSec:Int{
                return sec+min*60+hr*3600
            }
            mutating func setTime(totalSec:Int)
            {
                self.hr = 0
                self.min = 0
                self.sec = 0
                var sec = totalSec
                  var min = sec/60
                  let hr = min/60
                  sec %= 60
                  min %= 60
                self.sec = sec
                self.min = min
                self.hr = hr
            }
        }
        @State var timeState:timeVal = .init(hr: 0, min: 0, sec: 0)
        
        
        func updateTime(){
            if self.dateString != ""{
            self.data.taskData[self.taskInd].timestamp[self.dateString] = .init(Swift.min(self.timeState.totalSec,60*60*24))
            }
        }
        
    
    let taskInd:Int
    @State var format = DateFormatter()
    var displayFormat = DateFormatter()
    @State var dateSelect:Date = .init()
    @Binding var showSheet:Bool
    var dateString:String{
        return self.format.string(from: self.dateSelect)
    }

    
    
    var body: some View {
        VStack{
           
            DatePicker(selection: self.$dateSelect,displayedComponents:  .date, label: { Text("Date") })
            .labelsHidden()
           
            

            
                    GeometryReader{
                reader in
                     VStack{
                 
                    HStack{
                        Text("Hours").bold()
                        Spacer()
                        Text("Minutes").bold()
                        Spacer()
                        Text("Seconds").bold()
                    }.padding()
                        
                HStack
                    {
                        Picker(selection: self.$timeState.hr, label: Text("Hours"), content: {
                    ForEach(0...24,id: \.self){
                        hr in
                        Text(String(hr)).tag(hr)
                    }
                })
                    .labelsHidden()
                    .frame(width:reader.size.width/3)
                            .clipped()
                       

                        Picker(selection: self.$timeState.min, label: Text("min"), content: {
                    ForEach(0...60,id: \.self){
                        min in
                        Text(String(min)).tag(min)
                    }
                })
                .labelsHidden()
                        .frame(width:reader.size.width/3)
                            .clipped()
                
                
                        Picker(selection: self.$timeState.sec, label: Text("Seconds"), content: {
                    ForEach(0...60,id: \.self){
                        sec in
                        Text(String(sec)).tag(sec)
                    }
                })
                .labelsHidden()
                        .frame(width:reader.size.width/3)
                        .clipped()
                
            
                    }
                    
                }
                
            }
            .padding()
            
                    .onAppear(){
            //            self.data.pauseTasksAndSummary()
                        self.timeState.setTime(totalSec: Int(Swift.min(self.data.taskData[self.taskInd].timestamp[self.dateString] ?? 0, 60*60*24)))
                        print("initialized state")
                    
                    }
                    .onDisappear(){
                        self.updateTime()
            //            self.data.resumeTasksAndSummary()
                    }

            
            
        }
        .navigationBarTitle("Add Time")
        .navigationBarItems(trailing: Button(action:{
            self.updateTime()
            self.data.resumeTasksAndSummary()
            self.showSheet = false
           
        }){
            Text("Add")
        })
            .onAppear(){
                self.format.dateFormat = "MM_dd_yyyy"
                self.displayFormat.dateFormat = "MM/dd/yyyy"
//                self.dateSelect = self.format.date(from: self.data.today)!
        }
    }
}


//
//  selectHours.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/2/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

