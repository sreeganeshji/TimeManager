//
//  categoryEditView.swift
//  timeManagerWatch WatchKit Extension
//
//  Created by SreeGaneshji on 4/18/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import SwiftUI

struct categoryEditView: View {
    @EnvironmentObject var data:models
    var index:Int
    
    func deleteAt(_ index:Int)
    {
        self.data.categories.remove(at: index)
    }
    
    var body: some View {
       
        ScrollView
            {
                
                VStack{
                    
                
                TextField("Name", text: self.$data.categories[self.index].name)
                
                Picker(selection: self.$data.categories[self.index].color, label: Text("Color")) {
                    
                 
                    ForEach(self.data.colors,id: \.self)
                    {
                        color in
                        Text(color.description).tag(color)
                        .accentColor(color)
                    }
                    
                }
                    
                    
                 
                    Button(action: {self.deleteAt(self.index)})
                    {
                        HStack
                            {
                                Text("Delete")
                                Spacer()
                                Image(systemName: "minus.circle.fill")
                        }
                    }
                    
                }
        }
        
    }
}

struct categoryEditView_Previews: PreviewProvider {
    static var previews: some View {
        categoryEditView(index: 2)
    }
}
