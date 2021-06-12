import Foundation
import Kanna

class Parser {
    
    
    private var html = ""
    private var technology = ""
    
    init(technology: String) {
        self.technology = technology
        //parse()
    }
    
    private func generateUrl(page: Int) -> URL? {
        let url = URL(string: "https://www.ucrf.gov.ua/ua/services/centralized-registries?permission_num=&region=&technology="
                        + "\(technology)"
                        + "&search=&per_page=200"
                        + "&page=\(page)")
        return url
    }
    
    public func getPages() -> Int {
        let doc = try! HTML(url: generateUrl(page: 1)!, encoding: .utf8)
        
        if let number = Int(doc.xpath("//html//body//div[1]//div//div//div//div//div//div//div//ul//li[12]//a").first!.text!) {
            return number
        } else {
            return 0
        }
    }
    
    
    func parse(page: Int) -> [[String]] {
        var parsedArray = [[String]]()
        var buffArray = [String]()
        var index = 0
        
        
        let doc = try! HTML(url: generateUrl(page: page)!, encoding: .utf8)
        for node in doc.xpath("//tbody//tr//td") {
            if index < 9 {
                buffArray.append(node.text!)
                index += 1
            } else {
                buffArray.append(node.text!)
                parsedArray.append(buffArray)
                buffArray = []
                index = 0
            }
        }
        print("[\(technology)]\t[\(page)] parsed")
        return parsedArray
    }
}
