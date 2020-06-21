//
//  deleteTasks.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/18/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct deleteTasks: View {
    @EnvironmentObject var data:models
    
    init()
    {

    }
    
    func deleteTask(_ index:Int)
    {
        self.data.taskData.remove(at: index)
    }
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach($data.taskData.wrappedValue.indices,id: \.self)
                                     {
                                         index in
                                         
                                         Button(action:{self.deleteTask(index)})
                                         {
                                            HStack{
                                            Text(self.data.taskData[index].name)
                                            Spacer()
                                            Image(systemName: "minus.circle.fill")
                                            }
                                             
                                         }
                                           
                                        
                                     }
                                        
            }
        }
    .navigationBarTitle("Delete tasks")
    }
}

struct deleteTasks_Previews: PreviewProvider {
    static var previews: some View {
        deleteTasks()
    }
}
