//
//  SummaryiOS.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/21/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//
/*
 Need to represent the progress of the tasks and categories for daily, weekly, monthly and yearly basis for all the time.
 */

import SwiftUI


struct SummaryiOS: View {
    
    var format = DateFormatter()
    @EnvironmentObject var data:models
    @State var selection = 0
    @State var calComponent:Calendar.Component = .weekOfMonth
    @State var ShowTaskvsCategory = true
    @Binding var summaryRecord:SummaryDaemon
    let today = Date()

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
    
        NavigationView{
            VStack{
            Picker(selection: $calComponent, label: Text("Interval")) {
                Text("Day").tag(Calendar.Component.day)
                Text("Week").tag(Calendar.Component.weekOfMonth)
                Text("Month").tag(Calendar.Component.month)
                Text("Year").tag(Calendar.Component.year)
            }
            .onReceive([self.calComponent].publisher.first(), perform: { value in
//                print("updating View")
                self.summaryRecord.taskArr = self.data.taskData
                self.summaryRecord.categoryList = self.data.categories
                self.summaryRecord.update(dateComponent: self.calComponent, startDate: Date())})
            .pickerStyle(SegmentedPickerStyle())
            
                VStack{
                    if(self.summaryRecord.DayTaskRecord.count == 0)
                            {
                                Spacer()
//                                HStack(){
//                                    Spacer()
//                                Text("Loading...").bold()
//                                    Spacer()
//                                }
                                Spacer()
                            }
           
                            else{
                                if(self.ShowTaskvsCategory)
                                {
                                    VStack{
                                        List{
//                                HStack{
//                                    Spacer()
//                                    Text("Task breakdown").bold()
//                                    Spacer()
//                                }
                
                    HStack{
//                        Rectangle().frame(width:20)
//                            .foregroundColor(.gray)
                        Text("Task").bold()
                        Spacer()
                        Text("Time").bold()
                    }
                                            
                                            ForEach(self.summaryRecord.DayTaskRecord.indices,id:\.self)
            {
                ind in
             
                HStack{
                    Rectangle().frame(width:20)
                        .foregroundColor((self.data.taskData.count > ind) ? self.data.getColor(self.data.categories[self.summaryRecord.DayTaskRecord[ind].task.categoryInd].color) : .gray)
                    Text((self.data.taskData.count > ind) ? self.summaryRecord.DayTaskRecord[ind].task.name : "Deleted")
                    Spacer()
                    Text(self.giveTime(time: (self.data.taskData.count > ind) ? Int(self.summaryRecord.DayTaskRecord[ind].time) : 0))
                }

                }
                                }
                                }
                                }
                                else{
                                    VStack{
                                        List{
//                                HStack{
//                                    Spacer()
//                                    Text("Category breakdown").bold()
//                                    Spacer()
//                                }
                    
                    
                     HStack{
//                                Image(systemName: "bookmark.fill").frame(width:20)
//                                      .foregroundColor(.gray)
                                  Text("Category").bold()
                                  Spacer()
                                  Text("Time").bold()
                              }
                                            ForEach(self.summaryRecord.DayCatRecord.indices,id:\.self)
                              {
                                  ind in
                                
                                HStack{
                                    Image(systemName: "bookmark.fill")
                                        .foregroundColor(self.data.getColor(self.data.categories[self.summaryRecord.DayCatRecord[ind].categoryInd].color))
                                    Text(self.data.categories[self.summaryRecord.DayCatRecord[ind].categoryInd].name)
                                    Spacer()
                                    Text(self.giveTime(time:Int(self.summaryRecord.DayCatRecord[ind].time)))
                                }
                              }
        
                                        }
                                    }
                                }
                            }
                }
             
                Section{
                    Picker(selection: self.$ShowTaskvsCategory, label:Text("Choice"))
                    {
                        Text("Task").tag(true)
                        Text("Category").tag(false)
                    }
                .pickerStyle(SegmentedPickerStyle())
                }
                
            }
    .navigationBarTitle("Summary")
//        .navigationBarItems(trailing: Button(action:{
////            self.summaryRecord.refresh()
//        })
//        {
//            Text("Refresh")
//        })
        }
        .onAppear()
            {
                print("onAppear Summary")
                self.format.dateFormat = "MM_dd_yyyy"
                self.calComponent = .day
        }
    }
}

struct SummaryiOS_Previews: PreviewProvider {
    static var previews: some View {
        SummaryiOS(summaryRecord: .constant(.init())).environmentObject(models())
    }
}
