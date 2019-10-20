
import UIKit
import GoogleMaps

class SchoolFeedViewController: BaseViewController {

    @IBOutlet weak var schoolsTableView: UITableView!
    @IBOutlet weak var mapView: UIView!
    
    private var gmsMapView: GMSMapView?
    private var schoolViewModels: [SchoolViewModel] = []
    
    private let locationManager = CLLocationManager()
    private let presenter = SchoolFeedPresenter()
    private var schoolMarkers = [GMSMarker]()
    private let mapZoom: Float = 16
    private let defualtCoordinate = CLLocationCoordinate2D(latitude: 51.52771,
                                                           longitude: -0.140616)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDelegate = self
        presenter.viewDidLoad()
        setupMap()
        setupSchoolFeed()
    }
    
    private func setupMap() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.activityType = .automotiveNavigation
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
   
        let camera = GMSCameraPosition.camera(
            withLatitude: defualtCoordinate.latitude,
            longitude: defualtCoordinate.longitude,
            zoom: mapZoom
        )
        
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        
        let viewWithOutNav =  UIScreen.main.bounds.height - (self.navigationController?.navigationBar.frame.height ?? 0)
        let screenHeight: CGFloat = (viewWithOutNav * 2) / 3

        let frame = CGRect(x: 0,
                           y: 0,
                           width: screenWidth,
                           height: screenHeight)

        let gmsMapView = GMSMapView.map(withFrame: frame, camera: camera)
        gmsMapView.translatesAutoresizingMaskIntoConstraints = false
        gmsMapView.delegate = self
        gmsMapView.isMyLocationEnabled = true
        
        mapView.addSubview(gmsMapView)
        gmsMapView.translatesAutoresizingMaskIntoConstraints = false
        gmsMapView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor).isActive = true
        gmsMapView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor).isActive = true
        gmsMapView.topAnchor.constraint(equalTo: mapView.topAnchor).isActive = true
        gmsMapView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: screenHeight).isActive = true
        
        self.gmsMapView = gmsMapView
        self.gmsMapView?.isHidden  = true
        self.gmsMapView?.settings.myLocationButton = true
    }
    
    private func setupSchoolFeed() {
        schoolsTableView.delegate = self
        schoolsTableView.dataSource = self
        
        schoolsTableView.register(UINib(nibName: SchoolCell.identifier, bundle: nil),
                                  forCellReuseIdentifier: SchoolCell.identifier)

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
    
    private func selectedMarkerImage() -> UIImage {
        return GMSMarker.markerImage(with: .green)
    }
    
    private func unselectedMarkerImage() -> UIImage {
        return GMSMarker.markerImage(with: .red)
    }
    
}

// MARK: SchoolFeedViewDelegate
extension SchoolFeedViewController: SchoolFeedViewDelegate  {
    
    func cornerCoordinate(corner: Corner) -> CLLocationCoordinate2D {
        guard let mapContentView = gmsMapView,
            let point = pointInMap(corner: corner)
            else { return CLLocationCoordinate2D.init() }
        
        let pointOfCoordinate = mapView.convert(point, to: mapView)
        return mapContentView.projection.coordinate(for: pointOfCoordinate)
    }
    
    func showSchools(schoolViewModels: [SchoolViewModel]) {
        schoolsTableView.reloadData()
        gmsMapView?.clear()
        schoolMarkers = []
        
        for school in schoolViewModels {
            let latitude = school.latitude
            let longitude = school.longitude
            let marker = GMSMarker()
            marker.title = school.name
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.map = gmsMapView
            
            schoolMarkers.append(marker)
        }
    }
}

// MARK: GMSMapViewDelegate
extension SchoolFeedViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        presenter.didChangeMapPosition()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        marker.icon = selectedMarkerImage()
        mapView.selectedMarker = marker
        return true
    }

    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        marker.icon = unselectedMarkerImage()
    }
}

// MARK: CLLocationManagerDelegate
extension SchoolFeedViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location: CLLocation = locations.last else { return }

        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: mapZoom)

        gmsMapView?.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            gmsMapView?.isHidden = false
            manager.startUpdatingLocation()
        default:
            gmsMapView?.isHidden = false
        }
    }

}

// MARK: UITableViewDelegate
extension SchoolFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        for marker in schoolMarkers {
            marker.icon = unselectedMarkerImage()
        }
        
        let selectedMarker = schoolMarkers[indexPath.row]
        selectedMarker.icon = selectedMarkerImage()
        gmsMapView?.selectedMarker = selectedMarker
    }
    
}

// MARK: UITableViewDataSource
extension SchoolFeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.schoolViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SchoolCell.identifier) as? SchoolCell
        cell?.configure(school: presenter.schoolViewModels[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
}
