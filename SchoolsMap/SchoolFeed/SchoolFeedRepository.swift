
import Foundation

protocol SchoolFeedRepository {
    func getSchools(from coordinates: [String:Double],
                    completion: ((_ schools: [School]) -> Void)?)
}

class SchoolFeedRepositoryImplementation: SchoolFeedRepository {
    
    private lazy var mapServices = MapServices()
    
    func getSchools(from coordinates: [String:Double],
                    completion: ((_ schools: [School]) -> Void)?) {
        let jsonData = try? JSONSerialization.data(withJSONObject: coordinates, options: .prettyPrinted)
        mapServices.performNetworkTask(endpoint: .map,
                                       type: [School].self,
                                       httpMethod: .POST,
                                       body: jsonData) { (response) in completion?(response) }
    }
}
