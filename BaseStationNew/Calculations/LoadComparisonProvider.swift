//
//  LoadComparisonProvider.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 05.04.2021.
//

import Foundation

class LoadComparison {
    private let globalQueue = DispatchQueue(label: "LoadLocalityQueue")
    private let group = DispatchGroup()
   
    
    public func load(technology: Technologies = .all, provider: Providers, region: String? = nil, locality: String? = nil, completion: @escaping (_ localities: UIComparisonProvider)->()) {
        let prepareComparisonProvider = ComparisonProvider()
        
        group.enter()
        group.enter()
        
        prepareComparisonProvider.provider = provider.rawValue
        
        database.count(technology: .all, provider: provider, region: region, locality: locality) { count in
            prepareComparisonProvider.stationsCount = count!
            self.group.leave()
        }
        
        database.count(technology: .lte, provider: provider, region: region, locality: locality) { count in
            prepareComparisonProvider.lteBasesCount = count!
            self.group.leave()
        }
        prepareComparisonProvider.lte2600BasesCount = database.count(technology: .lte2600, provider: provider, region: region, locality: locality)!
        prepareComparisonProvider.lte1800BasesCount = database.count(technology: .lte1800, provider: provider, region: region, locality: locality)!
        prepareComparisonProvider.lte900BasesCount = database.count(technology: .lte900, provider: provider, region: region, locality: locality)!
        
        database.count(technology: .umts, provider: provider, region: region, locality: locality) { count in
            prepareComparisonProvider.umtsBasesCount = count!
            prepareComparisonProvider.umts2100BasesCount = count!
        }
        
        database.count(technology: .gsm, provider: provider, region: region, locality: locality) { count in
            prepareComparisonProvider.gsmBasesCount = count!
        }
        prepareComparisonProvider.gsm900BasesCount = database.count(technology: .gsm900, provider: provider, region: region, locality: locality)!
        prepareComparisonProvider.gsm1800BasesCount = database.count(technology: .gsm1800, provider: provider, region: region, locality: locality)!
            
        completion(UIComparisonProvider(comparisonStations: prepareComparisonProvider))
        
        
    }
    
//    public func loadComparisonLocalities(filter: String) -> [UIComparisonLocality] {
//        
//    }
    
}
