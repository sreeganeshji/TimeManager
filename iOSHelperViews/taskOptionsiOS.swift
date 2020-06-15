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
struct TaskOptionsiOS: View {
    @EnvironmentObject var data:models
    @State var edit:Bool = false
    @Environment(\.editMode) var mode
    var taskInd:Int

 
    
    var body: some View {
        NavigationView{
        Form{

            Section{
                if mode?.wrappedValue != .active{
                    TaskSummaryiOS(taskInd: self.taskInd).environmentObject(self.data)
//                    NavigationLink(destination:TaskEditiOS( taskInd: self.taskInd, activeView: self.$edit))
//                    {
//                        Text("Edit")
//                    }
//                    Button(action:{self.edit = true})
//                    {
//                        Text("Edit")
//                    }
                }
                else{
                    TaskEditiOS( taskInd: self.taskInd, activeView: self.$edit)
                    .environmentObject(self.data)
                }
            }


        }
        .navigationBarItems(trailing: EditButton())

        }
    }
}

struct TaskOptionsiOS_Previews: PreviewProvider {
    static var previews: some View {
        TaskOptionsiOS(taskInd: 0).environmentObject(models())
    }
}
