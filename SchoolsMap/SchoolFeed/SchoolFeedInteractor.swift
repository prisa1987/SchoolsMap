
import Foundation
import UIKit

class SchoolFeedInteractor {
    
    weak var schoolFeedPresenterDelegate: SchoolFeedPresenterDelegate?
    private lazy var repository = SchoolFeedRepositoryImplementation()
    private var schools = [School]()
    
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
                self?.schoolFeedPresenterDelegate?.didLoadSchools(schools: viewModels)
            }
            
        }
    }

}
