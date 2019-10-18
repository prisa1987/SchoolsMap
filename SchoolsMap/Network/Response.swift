
import Foundation

struct Response {
    fileprivate var data: Data
    init(data: Data) {
        self.data = data
    }
}

extension Response {
    public func decode<T: Codable>(_ type: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch _ {
            return nil
        }
    }
}
