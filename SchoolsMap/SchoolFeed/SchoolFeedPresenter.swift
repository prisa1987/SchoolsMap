
import Foundation
import GoogleMaps

class SchoolFeedPresenter {

    weak var viewDelegate: SchoolFeedViewDelegate?
    
    let interactor: SchoolFeedInteractor = SchoolFeedInteractor()
    private (set) var schoolViewModels = [SchoolViewModel]()
    
    func viewDidLoad() {
        interactor.schoolFeedPresenterDelegate = self
    }

    private func loadSchools() {
        if let topLeftCoordinate = viewDelegate?.cornerCoordinate(corner: .topLeft),
            let bottomRightCoordinate = viewDelegate?.cornerCoordinate(corner: .bottomRight) {
            
            let coordinates = ["latitudeNorth": topLeftCoordinate.latitude,
                               "longitudeWest": topLeftCoordinate.longitude,
                               "latitudeSouth": bottomRightCoordinate.latitude,
                               "longitudeEast": bottomRightCoordinate.longitude]
            interactor.loadSchools(coordinates: coordinates)
        }
    }
    
    func didChangeMapPosition() {
        loadSchools()
    }
    
}

// MARK: SchoolFeedPresenterDelegate
extension SchoolFeedPresenter: SchoolFeedPresenterDelegate {
    func didLoadSchools(schools: [SchoolViewModel]) {
        self.schoolViewModels = schools
        viewDelegate?.showSchools(schoolViewModels: schools)
    }
    
}
