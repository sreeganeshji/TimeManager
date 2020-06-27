//
//  Settings.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/18/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct SettingsiOS: View {
    @EnvironmentObject var data:models
    @State var originalConcurrentState = false
    @State var activeView:Binding<Bool>

    var body: some View {
        Form{
  
        Section
            {
                Toggle(isOn: self.$data.concurrentTasks) {
                    Text("Concurrent tasks")
                }

            }

//            Section{
//
//                Button(action:{
//                    self.activeView.wrappedValue = false
//                })
//                {
//                    Text("Done")
//                }
//            }
        
        }
        .onDisappear(perform: {
        print("Disappering")
                          if !self.data.concurrentTasks && (self.originalConcurrentState != self.data.concurrentTasks)
                          {
                          for i in 0...self.data.taskData.count-1
                          {
                              self.data.taskData[i].selected = false
                            self.data.taskData[i].lastChanged = nil
                          }
                          }
                      })

    .onAppear(perform: {
        print("on Appear")
        self.originalConcurrentState = self.data.concurrentTasks
    })

    .navigationBarTitle("Settings")
    }
}

struct SettingsiOS_Previews: PreviewProvider {
    static var previews: some View {
        SettingsiOS(activeView: .constant(false)).environmentObject(models())
    }
}
