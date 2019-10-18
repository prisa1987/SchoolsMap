
import Foundation
import GoogleMaps

class MapPresenter {

    weak var viewDelegate: MapViewDelegate?
    
    func viewDidLoad() {
        let topLeftCoordinate = viewDelegate?.cornerCoordinate(corner: .topLeft)
        let topRightCoordinate = viewDelegate?.cornerCoordinate(corner: .topRight)
        let bottomLeftCoordinate = viewDelegate?.cornerCoordinate(corner: .bottomLeft)
        let bottomRightCoordinate = viewDelegate?.cornerCoordinate(corner: .bottomRight)
    }
}
