
import UIKit

struct SchoolViewModel {
    let name: String
    let latitude: Double
    let longitude: Double
    
     init(name: String, latitude: Double, longitude: Double) {
          self.name = name
          self.latitude = latitude
          self.longitude = longitude
      }
}
