
import UIKit
import GoogleMaps

class MapViewController: UIViewController, MapViewDelegate {
    
    var mapView: GMSMapView?
    
    let presenter = MapPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDelegate = self
        
        
        let camera = GMSCameraPosition.camera(
            withLatitude: 50.54126776718752,
            longitude: -0.1391464811950982,
            zoom: 7
        )
    
       let screenRect = UIScreen.main.bounds
       let screenWidth = screenRect.size.width
       let screenHeight = screenRect.size.height

        let frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        mapView = GMSMapView.map(withFrame: frame, camera: camera)
        view = mapView
        
        presenter.viewDidLoad()
    }
    
    private func pointInMap(corner: Corner) -> CGPoint? {
        guard let mapView = mapView else { return nil }
        
        switch corner {
        case .topLeft:
            return mapView.convert(CGPoint.zero, to: mapView)
        case .bottomRight:
            let point = CGPoint(x: mapView.frame.size.width, y: mapView.frame.size.height)
            return mapView.convert(point, to: mapView)
        }
    }
    
    // MARK: MapViewDelegate
    func cornerCoordinate(corner: Corner) -> CLLocationCoordinate2D {
        guard let mapView = mapView,
            let point = pointInMap(corner: corner)
            else { return CLLocationCoordinate2D.init() }
        
        let pointOfCoordinate = mapView.convert(point, to: mapView)
        return mapView.projection.coordinate(for: pointOfCoordinate)
    }

}
