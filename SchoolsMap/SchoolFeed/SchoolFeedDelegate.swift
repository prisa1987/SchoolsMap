import GoogleMaps

protocol SchoolFeedViewDelegate: class {
    func cornerCoordinate(corner: Corner) -> CLLocationCoordinate2D
    func showSchools(schoolViewModels: [SchoolViewModel])
}

protocol SchoolFeedPresenterDelegate: class {
     func didLoadSchools(schools: [SchoolViewModel])
}

enum Corner {
    case topLeft
    case bottomRight
}
