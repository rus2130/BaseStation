import Foundation



class LoadProvider {
    private let globalQueue = DispatchQueue(label: "LoadProviderQueue", qos: .userInteractive, attributes: .concurrent)
    
    
    public func load(technology: Technologies = .all, provider: Providers, region: String? = nil, completion: @escaping (_ provider: UIProvider)->()) {
        
        
        let group = DispatchGroup()
        
        var newBases: Int?
        
        
        let calc = Calculations()
        
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        let prepareProvider = Provider()
        
        calc.getLocalitiesCount(technology: technology, provider: provider) { count in
            prepareProvider.localitiesCount = count
            group.leave()
        }
        calc.getRegionsCount(technology: technology, provider: provider) { count in
            prepareProvider.regionsCount = count
            group.leave()
        }
        calc.getNewBases(technology: technology, provider: provider) { count in
            if count == 0 {
                newBases = nil
            } else {
                newBases = count
            }
            
            group.leave()
        }
        calc.getStationsCount(technology: technology, provider: provider) { count in
            prepareProvider.stationsCount = count
            group.leave()
        }
        
        database.fetchStations(technology: technology, provider: provider) { stat in
            if let stations = stat {
                prepareProvider.rruCount = calc.getRruCount(stations: stations)
                group.leave()
            }
        }
        
        prepareProvider.dateOfIssue = calc.getDateOfIssue(technology: technology, provider: provider)
        prepareProvider.provider = provider.rawValue
         
        group.notify(queue: globalQueue) {
            
            completion(UIProvider(providerStations: prepareProvider, newBases: newBases))
        }
    }
    //        database.fetchStations(technology: technology, provider: provider) { [self] stat in
    //            if let stations = stat {
    //
    //
    //                //prepareProvider.rruCount = calc.getRruCount(stations: stations)
    //
    //                group.notify(queue: globalQueue) {
    //
    //                }
    //
    //            }
    //
    //        }
    
    
}
