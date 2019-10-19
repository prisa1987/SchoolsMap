

import UIKit

class SchoolCell: UITableViewCell {
    
    @IBOutlet weak var schoolName: UILabel!
    
    static let identifier: String = "SchoolCell"

    func configure(school: SchoolViewModel) {
        schoolName.text = school.name
    }
    
}

