//
//  TaskOptions.swift
//  TimeManager
//
//  Created by SreeGaneshji on 4/20/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI
/*
 edit
 Name
 reset
 Category
 */
struct TaskOptions: View {
    @EnvironmentObject var data:models
    @State var edit:Bool = false
    var taskInd:Int

 
    
    var body: some View {
        ScrollView{
            VStack{
               
                if !edit{
                    TaskSummary(taskInd: self.taskInd).environmentObject(self.data)
                    Button(action:{self.edit = true})
                    {
                        Text("Edit")
                    }
                }
                else{
//                    deleteTasks().environmentObject(self.data)
                    TaskEdit(taskInd: self.taskInd).environmentObject(self.data)
                    Button(action:{self.edit = false})
                    {
                        Text("Done")
                    }
                }       
                
                }
        }
    .navigationBarTitle("Done")
        
    }
}

struct TaskOptions_Previews: PreviewProvider {
    static var previews: some View {
        TaskOptions(taskInd: 0).environmentObject(models())
    }
}
