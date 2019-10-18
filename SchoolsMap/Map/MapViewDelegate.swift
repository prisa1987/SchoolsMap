import GoogleMaps

protocol MapViewDelegate: class {
    func cornerCoordinate(corner: Corner) -> CLLocationCoordinate2D
}

enum Corner {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}
