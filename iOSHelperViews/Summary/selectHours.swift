//
//  selectHours.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/2/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct selectHours: View {
    @Binding var showSheet:Bool
    var dateString:String
    var dateDisplayString2:String{
        var tmpDate :String = .init()
        for i in dateString.indices{
            if dateString[i] == "_"{
                tmpDate.append("/")
            }
            else{
                tmpDate.append(dateString[i])
            }
        }
        return tmpDate
    }
    var dateDisplayString:String
    var taskInd:Int
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
    
    
    func updateTime()->String{
        self.data.taskData[self.taskInd].timestamp[self.dateString] = .init(Swift.min(self.timeState.totalSec,60*60*24))
        return "Hours"

    }
    
    var body: some View {

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
        .onAppear(){
//            self.data.pauseTasksAndSummary()
            self.timeState.setTime(totalSec: Int(Swift.min(self.data.taskData[self.taskInd].timestamp[self.dateString] ?? 0, 60*60*24)))
            print("initialized state")
        
        }
        .onDisappear(){
            self.updateTime()
//            self.data.resumeTasksAndSummary()
        }
        .navigationBarTitle("\(self.dateDisplayString)")
        .navigationBarItems(trailing: Button(action:{
            self.updateTime()
            self.data.resumeTasksAndSummary()
            self.showSheet = false
        }){
            Text("Done")
        })

    }
}

struct selectHours_Previews: PreviewProvider {
    static var previews: some View {
        selectHours(showSheet: .constant(true), dateString: "07_02_2020", dateDisplayString: "June 02 2020", taskInd: 0)
    }
}
