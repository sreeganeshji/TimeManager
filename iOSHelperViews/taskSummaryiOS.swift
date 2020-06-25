//
//  TaskSummary.swift
//  TimeManager
//
//  Created by SreeGaneshji on 4/20/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct TaskSummaryiOS: View {
    var taskInd:Int
    
    @State var today:String = ""
    var format = DateFormatter()
    var displayFormat = DateFormatter()
    @EnvironmentObject var data:models
    @State var categoryInd:Int = 0
    
    
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
     
     func reset()
     {
        self.data.taskData[self.taskInd].timestamp[self.today] = TimeInterval(0)
     }
    func getName(_ taskInd:Int)->String
    {
        return self.data.categories[self.data.taskData[self.taskInd].categoryInd].name
    }
    
    func getColor(_ taskInd:Int)->Color
    {
        return self.data.categories[self.data.taskData[self.taskInd].categoryInd].color
    }
    var body: some View {
        NavigationView{
        Form{
            HStack{
                Text("Name:").bold()
                Spacer()
                TextField("Name", text: self.$data.taskData[self.taskInd].name)
            }
//                  HStack{
//                    Text("Category:").bold()
//
//                      Spacer()
//                    Text(getName(self.taskInd)).foregroundColor(getColor(self.taskInd))
//                  }
            
            
            Picker(selection: self.$categoryInd, label:  HStack{Text("Category:").bold()
  
            }) {
                
                ForEach(self.data.categories.indices,id:\.self)
                {
                    categoryInd in
                    HStack{
                        Image(systemName: "bookmark.fill").foregroundColor(self.data.categories[categoryInd].color)
                        Text(self.data.categories[categoryInd].name)
                    }
                .tag(categoryInd)
                }

            }
                   HStack{
                       Text("Today's time:").bold()
                    Spacer()
                       Text(giveTime(time: Int(self.data.taskData[self.taskInd].timestamp[self.today] ?? 0)))
                   Spacer()
                   Button(action: {self.reset()})
                   {
                       Text("Reset")
                   }
            }
            
            HStack{
                Text("Description").bold()
                Spacer()
//                Text(self.data.taskData[self.taskInd].description)
                TextField("", text: self.$data.taskData[self.taskInd].description)
            }
            
//                   Divider()
        }
        .navigationBarTitle(self.data.taskData[self.taskInd].name)
    .onAppear()
        {
             self.format.dateFormat = "MM_dd_yyyy"
            self.today = self.format.string(from: Date())
             self.displayFormat.dateFormat = "hh:MM:ss"
//            if (self.category.name != "")
//            {
//                self.data.taskData[self.taskInd].category = self.category
//            }
//            self.category = self.data.taskData[self.taskInd].category ?? models().nullCategory
            self.categoryInd = self.data.taskData[self.taskInd].categoryInd
        }
    .onDisappear()
        {
            self.data.taskData[self.taskInd].categoryInd = self.categoryInd
        }
            
        }
    }
}

struct TaskSummaryiOS_Previews: PreviewProvider {
    static var previews: some View {
        TaskSummaryiOS(taskInd: 0).environmentObject(models())
    }
}
