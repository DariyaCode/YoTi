//
//  AppDelegate.swift
//  YoTi
//
//  Created by Dariya Gecher on 16.03.2023.
//

import UIKit
import CoreData
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        let data = Data()
        data.name = "Dariya"
        data.age = 18
        
        do{
            let realm = try Realm()
            try realm.write{
                realm.add(data)
            }
        } catch {
            print("Error installation new Realm, \(error)")
        }
        
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication){
        self.saveContext()
    }
    
    //MARK: - CoreData stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

