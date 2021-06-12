//
//  Test.swift
//  Base Station
//
//  Created by Ruslan Duda on 19.02.2021.
//

import Foundation


struct Calculations {
    
    
    public func getStationsCount(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil) -> Int {
        var count = database.count(technology: technology, provider: provider, region: region, locality: locality)
        if count == nil {
            count = 0
        }
        return count!
    }
    
    public func getLocalitiesCount(technology: Technologies, provider: Providers, region: String? = nil) -> Int {
        var count = database.count(regions: true, localities: true, technology: technology, provider: provider, region: region)
        
        if count == nil {
            count = 0
        }
        return count!
    }
    
    public func getDateOfIssue(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil) -> Date {
        var dat = Date()
        database.date(technology: technology, provider: provider, region: region, locality: locality) { date in
            dat = date
        }
        return dat
    }
    public func getRegionsCount(technology: Technologies = .all, provider: Providers = .all) -> Int  {
        var count =  database.count(regions: true, technology: technology, provider: provider)
        if count == nil {
            count = 0
        }
        return count!
    }
    
    public func getRruCount(stations: [Station]) -> [String: Int] {
        let rru = Dictionary(grouping: stations, by: { $0.rru })
        var dict = [String: Int]()
        for (key, value) in rru {
            dict[key] = value.count
        }
        return dict
    }
    
    public func getNewBases(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil) -> Int? {
        let count = database.count(technology: technology , provider: provider, region: region, locality: locality, newBases: true)
        if count == 0 {
            return nil
        }
        return count
    }
    
    public func getStationsCount(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil, completion: @escaping (_ count: Int)->()) {
        database.count(technology: technology, provider: provider, region: region, locality: locality) { count in
            completion(count!)
        }
    }
    
    public func getLocalitiesCount(technology: Technologies, provider: Providers, region: String? = nil, completion: @escaping (_ count: Int)->()) {
        database.count(regions: true, localities: true, technology: technology, provider: provider, region: region) { count in
            completion(count!)
        }
    }
    
    public func getNewBases(technology: Technologies = .all, provider: Providers = .all, region: String? = nil, locality: String? = nil, completion: @escaping (_ count: Int?)->()) {
        database.count(technology: technology , provider: provider, region: region, locality: locality, newBases: true) { count in
            
            completion(count)
        }
    }
    
    public func getNewBases(stations: [Station]) -> Int?  {
        let startDate = Date().addingTimeInterval(-604800)
        let stationsCount = stations.filter({ $0.date >= startDate }).count
        if stationsCount == 0 {
            return nil
        }
        return stationsCount
    }
    
    public func getRegionsCount(technology: Technologies = .all, provider: Providers = .all, completion: @escaping (_ count: Int)->())  {
        database.count(regions: true, technology: technology, provider: provider) { count in
          completion(count!)
        }
    }
    
    
    
}
