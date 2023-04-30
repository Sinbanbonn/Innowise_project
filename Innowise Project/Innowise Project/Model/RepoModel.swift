import Foundation
import UIKit


struct RepoModel{
    let name: String
    let description: String
    let picture: String
    let source : String
    var image: UIImage?
 
    init(name: String, description: String, picture: String, source: String, image: UIImage? = nil) {
        self.name = name
        self.description = description
        self.picture = picture
        self.source = source
        self.image = image
    }
    
    
}

