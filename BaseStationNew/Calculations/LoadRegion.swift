//
//  LoadRegion.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 01.04.2021.
//

import Foundation

class LoadRegion {
    private let globalQueue = DispatchQueue(label: "LoadRegionQueue")
    private let group = DispatchGroup()
    
    public func load(technology: Technologies = .all, provider: Providers, regions: [String], locality: String? = nil,  completion: @escaping (_ Region: [UIRegion])->()) {
            var preparedRegions = [UIRegion]()
            let calc = Calculations()
            for region in regions {
                group.enter()
                group.enter()
                group.enter()
                group.enter()
                group.enter()
                var newBases: Int?
                let prepareRegion = Region()
                prepareRegion.name = region
                
                calc.getLocalitiesCount(technology: technology, provider: provider, region: region) { count in
                    prepareRegion.localitiesCount = count
                    self.group.leave()
                }
                calc.getNewBases(technology: technology, provider: provider, region: region) { count in
                    if count == 0 {
                        newBases = nil
                    } else {
                        newBases = count
                    }
                    self.group.leave()
                }
                globalQueue.async {
                    prepareRegion.dateOfIssue = calc.getDateOfIssue(technology: technology, provider: provider, region: region)
                    self.group.leave()
                }
                calc.getStationsCount(technology: technology, provider: provider, region: region) { count in
                    prepareRegion.stationsCount = count
                    self.group.leave()
                }
               
                
                database.fetchStations(technology: technology, provider: provider, region: region) { stat in
                    if let stations = stat {
                        prepareRegion.rruCount = calc.getRruCount(stations: stations)
                        self.group.leave()
                    }
                }
                
                //prepareRegion.localitiesCount = calc.getLocalitiesCount(technology: technology, provider: provider, region: region)
                //newBases = calc.getNewBases(technology: technology, provider: provider, region: region)
                
                //prepareRegion.stationsCount = calc.getStationsCount(technology: technology, provider: provider, region: region)
                group.wait()
                preparedRegions.append(UIRegion(regionStations: prepareRegion, newBases: newBases))
            }
            completion(preparedRegions)
        
    }
    
    //        database.fetchStations(technology: technology, provider: provider, region: region, regionsArray: regionsArray) { [self] stat in
    //            if let stations = stat {
    //                let regionsDict = Dictionary(grouping: stations, by: { $0.region })
    //                var preparesRegions = [UIRegion]()
    //
    //                for (region, regionStations) in regionsDict {
    //                    let prepareRegion = Region()
    //                    prepareRegion.name = region
    //                    prepareRegion.stationsCount = getStationsCount(stations: regionStations)
    //                    prepareRegion.rruCount = getRruCount(stations: regionStations)
    //                    prepareRegion.dateOfIssue = getDateOfIssue(stations: regionStations)
    //                    prepareRegion.localitiesCount = getLocalitiesCount(stations: regionStations)
    //                    preparesRegions.append(UIRegion(regionStations: prepareRegion, newBases: nil))
    //                }
    //
    //                completion(preparesRegions)
    //            }
    //            completion(nil)
    //
    //        }
    
//}
public func getStationsCount(stations: [Station]) -> Int {
    return stations.count
}

public func getRegionsCount(stations: [Station]) -> Int {
    return regionsString.count
}

public func getLocalitiesCount(stations: [Station]) -> Int {
    var count = 0
    let dict = Dictionary(grouping: stations, by: { $0.region })
    for (_, values) in dict {
        count += Set(values.compactMap({ $0.locality })).count
    }
    return count
}

public func getRruCount(stations: [Station]) -> [String: Int] {
    let rru = Dictionary(grouping: stations, by: { $0.rru })
    var dict = [String: Int]()
    for (key, value) in rru {
        dict[key] = value.count
    }
    return dict
    
    
}

public func getDateOfIssue(stations: [Station]) -> Date {
    if let date = stations.sorted(by: { $0.date > $1.date }).first?.date {
        return date
    } else {
        return Date()
    }
}
}

