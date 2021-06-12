import Foundation
import CoreData


class Database {
    private var persistentContainer = NSPersistentContainer(name: "StationsDatabase")
    
    public let fetchRequest = NSFetchRequest<Station>(entityName: "Station")
    
    private let context: NSManagedObjectContext
    
    public let path = "Documents Directory:  \(String(describing: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!))"
    
    private var stations = [Station]()
    
    private var containerLock = NSLock()
    
    private var lock = NSLock()
    
    
    init() {
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        self.context = self.persistentContainer.viewContext
    }
    
    public func fetchRequestBackground(completion: @escaping (_ stations:[Station]?) -> ()) {
        persistentContainer.performBackgroundTask { [self] (backgroundContext) in
            if let stations = try? backgroundContext.fetch(fetchRequest) as [Station] {
                if stations.isEmpty {
                    completion(nil)
                }
                completion(stations)
            } else {
                completion(nil)
            }
        }
    }
    
    private func getPersistentContainer() -> NSPersistentContainer {
        return self.persistentContainer
    }
    
    private func getContext() -> NSManagedObjectContext {
        return getPersistentContainer().viewContext
    }
    
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Not unique")
            }
        }
    }
    
    public func saveParsedArrayToStation(parsedArray: [[String]]) {
        persistentContainer.performBackgroundTask { backgroundContext in
            
            let mapper = ParsedArrayToCoreData()
            mapper.preparationBeforeSaving(parsedArray: parsedArray, context: backgroundContext)
            if backgroundContext.hasChanges {
                do {
                    try backgroundContext.save()
                    
                } catch {
                    backgroundContext.rollback()
                    print("Not unique")
                    
                }
            }
        }
    }
    public func fetchStations(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil, newBases: Bool = false, regionsArray: [String]? = nil, localitiesArray: [String]? = nil, completion: @escaping (_ stations: [Station]?)->()) {
        persistentContainer.performBackgroundTask { [self] backgroundContext in
            let currentFetchRequest = NSFetchRequest<Station>(entityName: "Station")
            
            currentFetchRequest.predicate = predicates(technology: technology, provider: provider, region: region, locality: locality, regionsArray: regionsArray, localitiesArray: localitiesArray)
            
            if let stations = try? backgroundContext.fetch(currentFetchRequest) as [Station] {
                if stations.isEmpty {
                    completion(nil)
                }
                completion(stations)
            } else {
                completion(nil)
            }
            
        }
    }
    
    public func fetchStations(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil) -> [Station]? {
        let currentFetchRequest = NSFetchRequest<Station>(entityName: "Station")
        
        currentFetchRequest.predicate = predicates(technology: technology, provider: provider, region: region, locality: locality)
        
        if let stations = try? context.fetch(currentFetchRequest) as [Station] {
            if stations.isEmpty {
                return nil
            }
            return stations
        } else {
            return nil
        }
    }
    
    
    public func count(regions: Bool = false, localities: Bool = false, technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil, newBases: Bool = false) -> Int? {
        var propertiesArray = [Any]()
        let fetchRequest1: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Station")
        
        if regions == true {
            
            propertiesArray.append("region")
        }
        if localities == true {
            propertiesArray.append("locality")
        }
        fetchRequest1.propertiesToFetch = propertiesArray
        fetchRequest1.returnsDistinctResults = true
        fetchRequest1.resultType = .dictionaryResultType
        
        fetchRequest1.predicate = predicates(technology: technology, provider: provider, region: region, locality: locality, newBases: newBases)
        
        if regions == true || localities == true {
            if let count = try? context.fetch(fetchRequest1) {
                
                return count.count
            } else {
                return nil
            }
        } else {
            
            if let count = try? context.count(for: fetchRequest1) {
                
                return count
            } else {
                return nil
            }
        }
    }
    
    public func count(regions: Bool = false, localities: Bool = false, technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil, newBases: Bool = false, completion: @escaping (_ count: Int?)->()) {
        persistentContainer.performBackgroundTask { [self] backgroundContext in
            var propertiesArray = [Any]()
            let fetchRequest1: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Station")
            
            if regions == true {
                propertiesArray.append("region")
            }
            if localities == true {
                propertiesArray.append("locality")
            }
            fetchRequest1.propertiesToFetch = propertiesArray
            fetchRequest1.returnsDistinctResults = true
            fetchRequest1.resultType = .dictionaryResultType
            
            fetchRequest1.predicate = predicates(technology: technology, provider: provider, region: region, locality: locality, newBases: newBases)
            
            if regions == true || localities == true {
                if let count = try? context.fetch(fetchRequest1) {
                    
                    completion(count.count)
                } else {
                    completion(nil)
                }
            } else {
                
                if let count = try? context.count(for: fetchRequest1) {
                    completion(count)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    
    private func predicates(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil, newBases: Bool = false, regionsArray: [String]? = nil, localitiesArray: [String]? = nil) -> NSCompoundPredicate {
        var predicatesArray = [NSPredicate]()
        
        if technology != .all { predicatesArray.append(NSPredicate(format: "technology CONTAINS %@", technology.rawValue)) }
        
        if provider != .all {  predicatesArray.append(NSPredicate(format: "freq = %@", provider.rawValue)) }
        
        if region != nil {  predicatesArray.append(NSPredicate(format: "region = %@", region!))  }
        
        if locality != nil { predicatesArray.append(NSPredicate(format: "locality = %@", locality!)) }
        
        if newBases == true {
            let startDate = Date().addingTimeInterval(-604800) as NSDate
            predicatesArray.append(NSPredicate(format: "date >= %@", startDate))
        }
        
        if regionsArray != nil { predicatesArray.append(predicateForRegions(array: regionsArray!)) }
        
        if localitiesArray != nil && region != nil { predicatesArray.append(predicateForLocalities(region: region!, array: localitiesArray!)) }
        
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: predicatesArray)
        
        return andPredicate
    }
    
    
    public func date(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil, completion: @escaping (_ date: Date)->()) {
        let fetchRequest1 = NSFetchRequest<Station>(entityName: "Station")
        let sdSortDate = NSSortDescriptor.init(key: "date", ascending: false)
        fetchRequest1.sortDescriptors = [sdSortDate]
        fetchRequest1.fetchLimit = 1
        fetchRequest1.predicate = predicates(technology: technology, provider: provider, region: region, locality: locality)
        if let date = try? context.fetch(fetchRequest1).first {
            completion(date.date)
        } else {
            completion(Date())
        }
    }
    
    public func listOfProviders(region: String? = nil, locality: String? = nil, completion: @escaping (_ providersList: [Providers]?)->()) {
        persistentContainer.performBackgroundTask { [self] backgroundContext in
            let fetchRequest1: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Station")
            var newRegion = region
            if (newRegion == "АР") {
                newRegion = "АР Крим"
            }
            fetchRequest1.predicate = predicates(region: newRegion, locality: locality)
            fetchRequest1.propertiesToFetch = ["freq"]
            fetchRequest1.returnsDistinctResults = true
            fetchRequest1.resultType = .dictionaryResultType
            
            if let stations = try? backgroundContext.fetch(fetchRequest1) as [NSDictionary] {
                if stations.isEmpty {
                    completion(nil)
                }
                var completionArray = [Providers]()
                    for key in stations {
                        let provider = Providers(rawValue: key.allValues[0] as! String) ?? .invalid
                        if provider != .invalid {
                        completionArray.append(provider)
                        }
                    }
                completion(completionArray)
                
                // completion(stations.count)
            } else {
                completion(nil)
            }
        }
    }
    
    public func list(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, localities: Bool? = false, completion: @escaping (_ list: [String]?)->()) {
        persistentContainer.performBackgroundTask { [self] backgroundContext in
            var propertiesArray = [Any]()
            let fetchRequest1: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Station")
            
            propertiesArray.append("region")
            
            if localities == true {
                propertiesArray.append("locality")
            }
            fetchRequest1.propertiesToFetch = propertiesArray
            fetchRequest1.returnsDistinctResults = true
            fetchRequest1.resultType = .dictionaryResultType
            let sdSortDate = NSSortDescriptor.init(key: "region", ascending: true)
            fetchRequest1.sortDescriptors = [sdSortDate]
            
            fetchRequest1.predicate = predicates(technology: technology, provider: provider, region: region)
            
            if let stations = try? backgroundContext.fetch(fetchRequest1) as [NSDictionary] {
                if stations.isEmpty {
                    completion(nil)
                }
                var completionArray = [String]()
                if !(localities ?? false) {
                    for key in stations {
                        completionArray.append(key.allValues[0] as! String)
                    }
                } else {
                    for key in stations {
                        completionArray.append(key.allValues[1] as! String)
                    }
                }
                completion(completionArray)
                // completion(stations.count)
            } else {
                completion(nil)
            }
        }
    }
    
    public func list(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, localities: Bool? = false) -> [String]? {
      
            var propertiesArray = [Any]()
            let fetchRequest1: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Station")
            
            propertiesArray.append("region")
            
            if localities == true {
                propertiesArray.append("locality")
            }
            fetchRequest1.propertiesToFetch = propertiesArray
            fetchRequest1.returnsDistinctResults = true
            fetchRequest1.resultType = .dictionaryResultType
            let sdSortDate = NSSortDescriptor.init(key: "region", ascending: true)
            fetchRequest1.sortDescriptors = [sdSortDate]
            
            fetchRequest1.predicate = predicates(technology: technology, provider: provider, region: region)
            
            if let stations = try? context.fetch(fetchRequest1) as [NSDictionary] {
                if stations.isEmpty {
                    return nil
                }
                var completionArray = [String]()
                if !(localities ?? false) {
                    for key in stations {
                        completionArray.append(key.allValues[0] as! String)
                    }
                } else {
                    for key in stations {
                        completionArray.append(key.allValues[1] as! String)
                    }
                }
                return completionArray
                // completion(stations.count)
            } else {
                return nil
            }
        
    }
    
    public func listLocalities(filterText: String? = nil, completion: @escaping (_ list: [UIComparisonLocality]?)->()) {
        persistentContainer.performBackgroundTask { backgroundContext in
            let fetchRequest1: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "Station")
        
            fetchRequest1.propertiesToFetch = ["region", "locality"]
            fetchRequest1.returnsDistinctResults = true
            fetchRequest1.resultType = .dictionaryResultType
            let sdSortDate = NSSortDescriptor.init(key: "locality", ascending: true)
            fetchRequest1.sortDescriptors = [sdSortDate]
          
            if let filter = filterText  {
                if filter != "" {
                fetchRequest1.predicate = NSPredicate(format: "locality BEGINSWITH %@", filter)
                }
            }
            
            if let stations = try? backgroundContext.fetch(fetchRequest1) as [NSDictionary] {
                if stations.isEmpty {
                    completion(nil)
                }
                var completionArray = [UIComparisonLocality]()
                    for key in stations {
                        let uiComparisonLocality = UIComparisonLocality(region: key.allValues[0] as! String, locality: key.allValues[1] as! String)
                        completionArray.append(uiComparisonLocality)
                    }
                completion(completionArray)
                
            } else {
                completion(nil)
            }
        }
    }
    
    
    public func predicateForRegions(array: [String]) -> NSCompoundPredicate {
        var predicatesArray = [NSPredicate]()
        
        for region in array {
            predicatesArray.append(NSPredicate(format: "region = %@", region))
        }
        
        return NSCompoundPredicate(type: .or, subpredicates: predicatesArray)
    }
    
    public func predicateForLocalities(region: String, array: [String]) -> NSCompoundPredicate {
        var predicatesArray = [NSPredicate]()
        
        for locality in array {
            predicatesArray.append(NSPredicate(format: "locality = %@", locality))
        }
        
        
        let test = NSCompoundPredicate(type: .or, subpredicates: predicatesArray)
        let test1 =  NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "region = %@", region)])
        
        return NSCompoundPredicate(type: .and, subpredicates: [test, test1])
    }
    
    
    public func reset(technology: Technologies? = nil) {
        do {
            if let tech = technology {
                fetchRequest.predicate = predicates(technology: tech)
            } else {
                fetchRequest.predicate = nil            }
            
            let items = try context.fetch(fetchRequest) as [Station]
            
            for item in items {
                context.delete(item)
            }
            try context.save()
        } catch {
            print("Core data reset error")
        }
    }
    
    public func reset(technology: Technologies? = nil, completion: @escaping (_ isDeleted: Bool)->()) {
        persistentContainer.performBackgroundTask { [self] backgroundContext in
        do {
            if let tech = technology {
                fetchRequest.predicate = predicates(technology: tech)
            } else {
                fetchRequest.predicate = nil            }
            
            let items = try backgroundContext.fetch(fetchRequest) as [Station]
            
            for item in items {
                backgroundContext.delete(item)
            }
            try backgroundContext.save()
            completion(true)
        } catch {
            completion(false)
            print("Core data reset error")
        }
    }
    }
    
}
