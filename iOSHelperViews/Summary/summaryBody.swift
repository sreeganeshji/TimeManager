//
//  summaryBody.swift
//  TimeManager
//
//  Created by SreeGaneshji on 7/1/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct summaryBody: View {
    @EnvironmentObject var data:models
    @Binding var ShowTaskvsCategory:Bool
    
    var body: some View {
    
        VStack{
                    if(self.data.taskRecordArr.count == 0)
                            {
                                Spacer()
                                HStack{
                                    Spacer()
                                    Text("No tasks found").bold()
                                    Spacer()
                                }
                                Spacer()
                                 
                            }
           
    else{
            if(self.ShowTaskvsCategory)
            {
            
                taskSummary().environmentObject(self.data)
            

            }
        else{
                VStack{
                categorySummary().environmentObject(self.data)
                }

            }
        }
    }
}
}

struct summaryBody_Previews: PreviewProvider {
    static var previews: some View {
        summaryBody(ShowTaskvsCategory: .constant(true))
    }
}
