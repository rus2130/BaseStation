//
//  LoadLocality.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 01.04.2021.
//

import Foundation

class LoadLocality {
    private let globalQueue = DispatchQueue(label: "LoadLocalityQueue")
    
    public func load(technology: Technologies = .all, provider: Providers, region: String? = nil, locality: String? = nil, localitiesArray: [String], completion: @escaping (_ localities: [UILocality]?)->()) {
        
        database.fetchStations(technology: technology, provider: provider, region: region, localitiesArray: localitiesArray) { [self] stat in
           
            if let stations = stat {
                let localitiesDict = Dictionary(grouping: stations, by: { $0.locality })
                var prepareLocalities = [UILocality]()
                for (locality, localityStations) in localitiesDict {
                    let prepareLocality = Locality()
                    prepareLocality.name = locality
                    prepareLocality.stationsCount = getStationsCount(stations: localityStations)
                    prepareLocality.rruCount = getRruCount(stations: localityStations)
                    prepareLocality.dateOfIssue = getDateOfIssue(stations: localityStations)
                    
                    
                    prepareLocalities.append(UILocality(localityStations: prepareLocality, newBases: Calculations().getNewBases(stations: localityStations)))
                }

                completion(prepareLocalities)
            }
            completion(nil)
        }
       
    }
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
