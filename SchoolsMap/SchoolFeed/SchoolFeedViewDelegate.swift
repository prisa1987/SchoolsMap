import GoogleMaps

protocol SchoolFeedViewDelegate: class {
    func cornerCoordinate(corner: Corner) -> CLLocationCoordinate2D
    func showShools(schools: [SchoolViewModel])
}

enum Corner {
    case topLeft
    case bottomRight
}
