import Foundation
import SwiftUI


let database = Database()

class Model: ObservableObject {
    @Published public var uiProviders = [UIProvider]()
    @Published public var uiRegions = [UIRegion]()
    @Published public var uiLocalities = [UILocality]()
    @Published public var uiComparisonProviders = [UIComparisonProvider]()
    @Published public var uiComparisonLocalities = [UIComparisonLocality]()
    
    @Published public var uiBarTitle = "Downloading..."
    @Published public var uiBarTitleRegions = ""
    @Published public var uiBarTitleLocalities = ""
    @Published public var uiBarTitleComparison = "Україна"
    
    private var currentTechnology = Technologies.lte
    
    private var currentParsePage = 0
    private var endOfParsePage = 0
    
    private let globalQueue = DispatchQueue.global(qos: .userInteractive)
    
    private var array = [[String]]()
    private let databaseLock = NSLock()
    private var ifProvidersUpdate = false
    
    private let parseGroup = DispatchGroup()
    init() {
        // print(database.path)
        //database.reset()
        
        start()
        roman()
    }
    
    
    public func start() {
        if database.fetchStations(technology: .lte) == nil {
            loadProviders()
            parse(technology: "LTE-1800", threads: 6)
            parse(technology: "LTE-2600", threads: 6)
            parse(technology: "LTE-900", threads: 6)
            parse(technology: "GSM-1800", threads: 6)
            parse(technology: "GSM-900", threads: 6)
            parse(technology: "UMTS", threads: 6)
        } else {
            //checkUpdate()
            loadProviders()
        }
    }
    
    public func parse(technology: String, threads: Int) {
        for thread in 0..<threads {
            globalQueue.async(group: parseGroup) { [self] in
                let parser = Parser(technology: technology)
                let pages = parser.getPages()
                parseBarTitle(thread: thread, pages: pages)
                let pagesForThread = ParseHelper(pages: pages).getRangeForThreadParse(threads: threads, threadNumber: thread)
                
                for page in pagesForThread {
                    database.saveParsedArrayToStation(parsedArray: parser.parse(page: page))
                    parseBarTitle()
                    //  loadProviders()
                }
            }
        }
        parseGroup.notify(queue: globalQueue) { [self] in
            loadProviders()
            DispatchQueue.main.async {
                uiBarTitle = "LTE"
            }
        }
    }
    
    private func loadProviders() {
        
        
        let provGroup = DispatchGroup()
        
        DispatchQueue.main.async {
            self.uiBarTitle = self.currentTechnology.rawValue
        }
        provGroup.enter()
        provGroup.enter()
        provGroup.enter()
        
        var buf = [UIProvider]()
        for provider in [Providers.kyivstar, Providers.vodafone, Providers.lifecell] {
            let loadProvider = LoadProvider()
            loadProvider.load(technology: currentTechnology, provider: provider) { [self] uiProvider in
                DispatchQueue.main.async {
                    buf.append(uiProvider)
                    provGroup.leave()
                    objectWillChange.send()
                }
                
            }
        }
        provGroup.notify(queue: globalQueue) {
            buf.sort(by: { Int($0.stationsCount) ?? 0 > Int($1.stationsCount) ?? 0 })
            DispatchQueue.main.async {
                self.uiProviders = buf
                
            }
        }
        
    }
    public func createBlankRegions(array: [String]) {
        DispatchQueue.main.async { [self] in
            var testArray = [UIRegion]()
            for region in array.suffix(7) {
                let reg = UIRegion()
                reg.name = region
                testArray.append(reg)
            }
            uiRegions = testArray
        }
    }
    
    public func createBlankLocalities(array: [String]) {
        DispatchQueue.main.async { [self] in
            var testArray = [UILocality]()
            if array.count > 7 {
                for _ in 0..<7 {
                    testArray.append(UILocality())
                }
            } else {
                for _ in 0..<array.count - 1 {
                    testArray.append(UILocality())
                }
            }
            
            uiLocalities = testArray
        }
        
    }
    
    public func loadRegions(provider: String) {
        //  uiRegions = []
        globalQueue.async { [self] in
            database.list(technology: currentTechnology, provider: Providers(rawValue: provider)!) { [self] regs in
                if let regions = regs {
                    let regionsTest = regionsArray(regions)
                    createBlankRegions(array: regionsTest[0])
                    for regi in regionsTest {
                        LoadRegion().load(technology: currentTechnology, provider: Providers(rawValue: provider)!, regions: regi) { uiRegion in
                            DispatchQueue.main.async {
                                for region in uiRegion {
                                    if let index = uiRegions.firstIndex(of: region) {
                                        uiRegions[index] = region
                                    } else {
                                        uiRegions.append(region)
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func loadLocalities(provider: String, region: String) {
        database.list(technology: currentTechnology, provider: Providers(rawValue: provider)!, region: region.components(separatedBy: " ")[0], localities: true) { [self] locs in
            if let localities = locs {
                let localitiesTest = localitiesArray(localities)
                createBlankLocalities(array: localitiesTest[0])
                var index = 0
                for localityArray in localitiesTest {
                    LoadLocality().load(technology: currentTechnology, provider: Providers(rawValue: provider)!, region: region.components(separatedBy: " ")[0], localitiesArray: localityArray) { uiLocalitiesPrepared in
                        if let uiLocs = uiLocalitiesPrepared {
                            for uiLocality in uiLocs {
                                DispatchQueue.main.async {
                                    if index < uiLocalities.count {
                                        uiLocalities[index] = uiLocality
                                        index += 1
                                    } else {
                                        uiLocalities.append(uiLocality)
                                    }
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    public func loadComparisonProviders(region: String? = nil, locality: String? = nil) {
        let compGroup = DispatchGroup()
        
        var buf = [UIComparisonProvider]()
        compGroup.enter()
        database.listOfProviders(region: region, locality: locality) { list in
            for provider in list! {
                compGroup.enter()
                LoadComparison().load(provider: provider, region: region, locality: locality) { uiComparison in
                        buf.append(uiComparison)
                        compGroup.leave()
                }
            }
            compGroup.leave()
        }
        
        compGroup.notify(queue: globalQueue) {
            print("test")
            buf.sort(by: { Int($0.stationsCount) ?? 0 > Int($1.stationsCount) ?? 0 })
            DispatchQueue.main.async {
                self.uiComparisonProviders = buf
            }
        }
    }
    
    private func localitiesArray(_ regionsArray: [String]) -> [[String]] {
        var regions = [[String]]()
        
        var index = 0
        var regionsBuf = [String]()
        
        for region in regionsArray {
            if index < 40 {
                regionsBuf.append(region)
                index += 1
            } else {
                regionsBuf.append(region)
                regions.append(regionsBuf)
                regionsBuf = []
                index = 0
            }
        }
        if !regionsBuf.isEmpty {
            regions.append(regionsBuf)
            regionsBuf = []
        }
        return regions
    }
    
    private func regionsArray(_ regionsArray: [String]) -> [[String]] {
        var regions = [[String]]()
        
        var index = 0
        var regionsBuf = [String]()
        
        for region in regionsArray {
            if index < 4 {
                regionsBuf.append(region)
                index += 1
            } else {
                regionsBuf.append(region)
                regions.append(regionsBuf)
                regionsBuf = []
                index = 0
            }
        }
        if !regionsBuf.isEmpty {
            regions.append(regionsBuf)
            regionsBuf = []
        }
        return regions
    }
    
    
    public func loadComparisonLocalities(filter: String? = nil) {
        globalQueue.asyncAfter(wallDeadline: .now() + 1.0) {
        database.listLocalities(filterText: filter) { list in
            DispatchQueue.main.async { [self] in
                if let loc = list {
                    uiComparisonLocalities = loc.sorted(by: { $0.locality.lowercased().components(separatedBy: " ")[0] < $1.locality.lowercased().components(separatedBy: " ")[0] })
                } else {
                    uiComparisonLocalities = []
                }
            }
        }
        }
    }
    
    
    
    private func parseBarTitle(thread: Int? = nil, pages: Int? = nil) {
        if thread == 0 {
            if pages != nil {
                endOfParsePage += pages!
            }
        }
        if thread == nil {
            currentParsePage += 1
        }
        if endOfParsePage != 0 {
            let percentages = Int(Double(currentParsePage) / Double(endOfParsePage)*100)
            DispatchQueue.main.async { [self] in
                uiBarTitle = "Downloading... \(percentages)%"
            }
        }
    }
    
    public func technologyFilter(technology: Technologies) {
        currentTechnology = technology
        
        loadProviders()
    }
    
    public func sortRegions(type: SortOptions) {
        switch type {
        case .abc: uiRegions.sort(by: { $0.name.lowercased().components(separatedBy: " ")[0] < $1.name.lowercased().components(separatedBy: " ")[0] })
       
        case .bsCount: uiRegions.sort(by: { Int($0.stationsCount.components(separatedBy: " ")[0]) ?? 0 > Int($1.stationsCount.components(separatedBy: " ")[0]) ?? 0 })
        case .dateOfIssue: uiRegions.sort(by: { $0.dateOfIssue.toDate > $1.dateOfIssue.toDate })
        }
    }
    
    public func sortLocalities(type: SortOptions) {
        switch type {
        case .abc: uiLocalities.sort(by: { $0.name.lowercased().components(separatedBy: " ")[0] < $1.name.lowercased().components(separatedBy: " ")[0] })
        case .bsCount: uiLocalities.sort(by: { Int($0.stationsCount.components(separatedBy: " ")[0]) ?? 0 > Int($1.stationsCount.components(separatedBy: " ")[0]) ?? 0 })
        case .dateOfIssue: uiLocalities.sort(by: { $0.dateOfIssue.toDate > $1.dateOfIssue.toDate })
        }
    }
    
    private func checkUpdate() {
      let technologies: [Technologies] = [.lte1800, .umts, .gsm900, .lte2600, .lte900, .gsm1800,]
        globalQueue.async { [self] in
          for technology in technologies {
                database.date(technology: technology) { date in
                    if let parsedData = checkLatestDate(technology: technology) {
                        print(date.toString, print(parsedData.toString, technology.rawValue))
                        if date < parsedData {
                            database.reset(technology: technology) { isDeleted in
                                if isDeleted {
                                parse(technology: technology.rawValue, threads: 6)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    private func checkLatestDate(technology: Technologies) -> Date? {
        let parser = Parser(technology: technology.rawValue)
        let pages = parser.getPages()
        let date = parser.parse(page: pages).last?[1].toDate
        return date
    }
    
    
    private func roman() {
        let group = DispatchGroup()
        var sum = 0
        globalQueue.async { [self] in
            database.list() { regs in
                if let regions = regs {
                    for region in regions.sorted(by: { $0.lowercased().components(separatedBy: " ")[0] < $1.lowercased().components(separatedBy: " ")[0] }) {
                        
                        let localities = database.list(region: region, localities: true)
                            let loca = localities!.sorted(by: { Int($0.components(separatedBy: " ")[0]) ?? 0 > Int($1.components(separatedBy: " ")[0]) ?? 0 })
                         
                            for locality in loca {
                                let umtsBases = database.count(technology: .umts, region: region, locality: locality)!
                                let lteBases = database.count(technology: .lte, region: region, locality: locality)!

                                if umtsBases > lteBases {
                                   sum += umtsBases - lteBases
                                }
                                
                            }
                            
                        
                        
                        print(region, sum)
                        print("\n\n\n")
//                        let umtsBases = database.count(technology: .umts, region: region)!
//                        let lteBases = database.count(technology: .lte, region: region)!
//                        let difference = umtsBases - lteBases
//                        print(region)
//                        print("LTE: \(lteBases)")
//                        print("UMTS: \(umtsBases)")
//                        print("Баз без LTE: \(difference)")
                    }
                }
            }
        }
    }
    
}
