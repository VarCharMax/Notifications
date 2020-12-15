import CoreData

struct PersistentHelper {
  static let persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Notifications")
    
    let containerUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.rjp.notifications")!
    let databaseUrl = containerUrl.appendingPathComponent("Notifications.sqlite")
    let description = NSPersistentStoreDescription(url: databaseUrl)
    container.persistentStoreDescriptions = [description]
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in

    })
    return container
  }()
}

