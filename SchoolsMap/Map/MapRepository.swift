
import Foundation

class MapRepository {
    
    let mapServices = MapServices()
    
    func getSchools(from coordinates: [String:Double]) {
         let jsonData = try? JSONSerialization.data(withJSONObject: coordinates, options: .prettyPrinted)
        mapServices.performNetworkTask(endpoint: .map,
                                       type: [School].self,
                                       httpMethod: .POST,
                                       body: jsonData) { (response) in
                                           print(response)
                                       }
                                       
    }
}
