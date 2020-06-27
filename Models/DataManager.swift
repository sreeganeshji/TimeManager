//
//  DataManager.swift
//  TimeManager
//
//  Created by SreeGaneshji on 6/26/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import Foundation

class DataManager{
    
    init(fileName:String)
    {
        var fileURL = getPathURL()
        if(!FileManager.default.fileExists(atPath: fileURL.appendingPathComponent("data").path))
        {
            do{
            try FileManager.default.createDirectory(atPath: fileURL.appendingPathComponent("data").path, withIntermediateDirectories: true, attributes: nil)
            }
            catch{
                print(error)
            }
            
            fileURL = fileURL.appendingPathComponent("data/\(fileName).json")
            FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil)
        }
        else{
            print("file found")
        }
    
    }
    
func getPathURL()->URL{
    return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
}
    

func load<T:Codable>(_ filename:String) ->T?
{
    //declarations
    let data:Data
    
    //access the file
//    guard let file = Bundle.main.url(forResource: filename, withExtension: "")
//        else{
//            fatalError("File \(filename) not found")
//    }
    var filePathURL = getPathURL().appendingPathComponent("data")
    filePathURL = filePathURL.appendingPathComponent("\(filename).json")

    //load data
    do{
        data = try Data(contentsOf: filePathURL)
    }
    catch
    {
        print("couldn't load \(filename). exiting with error \(error)")
        
        return nil
    }
    
    //decode
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: Data(base64Encoded: data) ?? Data())
    }
    catch{
        print("Couldn't decode from \(filename). caught error \(error)")
        return nil
    }
}

func save <T:Codable>(_ filename:String,data:T)
{
    //declarations
    var fileURL = getPathURL().appendingPathComponent("data")
    fileURL = fileURL.appendingPathComponent("\(filename).json")
    
    var dataStr = ""
    do {
        let encoder = JSONEncoder()
        let json = try encoder.encode(data)
        dataStr = json.base64EncodedString()
    }
    catch{
        print("couldn't encode data. Error: \(error)")
    }
    
    do{
        try dataStr.write(to: fileURL, atomically: true, encoding: .utf8)
    }
    catch
    {
        fatalError("Couldn't save file. error \(error)")
    }
}
}
