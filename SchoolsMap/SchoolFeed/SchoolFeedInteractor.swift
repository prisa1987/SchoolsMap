
import Foundation
import UIKit

protocol SchoolFeedPresenterDelegate: class {
     func didLoadSchools(shools: [SchoolViewModel])
}

class SchoolFeedInteractor {
    
    var schools = [School]()
    
    weak var schoolFeedPresenterDelegate: SchoolFeedPresenterDelegate?
    let repository: SchoolFeedRepository = SchoolFeedRepositoryImplementation()
    
    func loadSchools(coordinates: [String: Double]) {
        repository.getSchools(from: coordinates) { [weak self] schools in
            
            var viewModels = [SchoolViewModel]()
            for school in schools {
                let viewModel = SchoolViewModel(name: school.name,
                                                latitude: school.latitude,
                                                longitude: school.longitude)
                viewModels.append(viewModel)
            }
            
            DispatchQueue.main.async {
                self?.schoolFeedPresenterDelegate?.didLoadSchools(shools: viewModels)
            }
            
        }
    }

}
