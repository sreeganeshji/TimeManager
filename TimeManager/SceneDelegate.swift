//
//  SceneDelegate.swift
//  TimeManager
//
//  Created by SreeGaneshji on 4/20/20.
//  Copyright © 2020 SreeGaneshji. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    var dataManager:DataManager = .init(fileName:"tasks")
    
    var data = models()


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        data.taskData = dataManager.load("tasks") ?? [models.task( myId:1,name: "Workout", description: "Weight training", categoryInd:5,timestamp: ["04_20_2019":200,"05_20_2020":400,"03_12_2020":500]),models.task(myId:2,name: "Piano practice", description: "Western classical",categoryInd:6),models.task(myId:3,name: "Watching Youtube", description: "",categoryInd:3),models.task(myId:4,name: "Jogging", description: "",categoryInd:5),models.task(myId:5,name: "Party", description: "",categoryInd:4),models.task(myId:6,name: "Database Systems", description: "CS6400",categoryInd:2),models.task(myId:7,name: "Hiking", description: "",categoryInd:5),models.task(myId:8,name: "Dance", description: "Salsa",categoryInd:6),models.task(myId:9,name: "TV", description: "Movies",categoryInd:3)]
        data.categories = dataManager.load("categories") ?? [models.category("No category", "gray"),models.category("Work","blue"),models.category("Study","yellow"),models.category("Leisure","purple"),models.category("Socialize","green"),models.category("Fitness","Orange"),models.category("Hobby","pink")]

        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView().environmentObject(data)

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("will resign active")
        dataManager.save("tasks", data: data.taskData)
        dataManager.save("categories",data:data.categories)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("will enter foreground")
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("did enter background")
        dataManager.save("tasks", data: data.taskData)
        dataManager.save("categories", data: data.categories)
        
    }


}

