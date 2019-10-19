
import Foundation
import GoogleMaps

class SchoolFeedPresenter {

    weak var viewDelegate: SchoolFeedViewDelegate?
    
    let repository: SchoolFeedRepository = SchoolFeedRepositoryImplementation()
    
    private func loadSchools() {
        if let topLeftCoordinate = viewDelegate?.cornerCoordinate(corner: .topLeft),
            let bottomRightCoordinate = viewDelegate?.cornerCoordinate(corner: .bottomRight) {
            
            let coordinates = ["latitudeNorth": topLeftCoordinate.latitude,
                               "longitudeWest": topLeftCoordinate.longitude,
                               "latitudeSouth": bottomRightCoordinate.latitude,
                               "longitudeEast": bottomRightCoordinate.longitude]
            repository.getSchools(from: coordinates)
        }
    }
    
    func didChangeMapPosition() {
        loadSchools()
    }
}
