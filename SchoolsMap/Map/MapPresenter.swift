
import Foundation
import GoogleMaps

class MapPresenter {

    weak var viewDelegate: MapViewDelegate?
    
    let repository: MapRepository = MapRepositoryImplementation()
    
    func viewDidLoad() {
        loadScholls()
    }
    
    func loadScholls() {
        if let topLeftCoordinate = viewDelegate?.cornerCoordinate(corner: .topLeft),
            let bottomRightCoordinate = viewDelegate?.cornerCoordinate(corner: .bottomRight) {
            
            let coordinates = ["latitudeNorth": topLeftCoordinate.latitude,
                               "longitudeWest": topLeftCoordinate.longitude,
                               "latitudeSouth": bottomRightCoordinate.latitude,
                               "longitudeEast": bottomRightCoordinate.longitude]
            repository.getSchools(from: coordinates)
        }
    }
    
    
}
