import Foundation

protocol EndpointType {
    var baseURL: URL? { get }
    var path: String { get }
}

enum SchoolsMapAPI {
    case map
}

extension SchoolsMapAPI: EndpointType {
    var baseURL: URL? {
        return URL(string: "https://ukschools.guide:3000/")
    }

    var path: String {
        switch self {
        case .map:
            return "map-demo"
        }
    }
}
