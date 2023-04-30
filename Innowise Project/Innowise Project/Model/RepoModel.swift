import Foundation
import UIKit


struct RepoModel{
    let name: String
    let description: String
    let picture: String
    let from : String
    var image: UIImage?
 
    init(name: String, description: String, picture: String, from: String, image: UIImage? = nil) {
        self.name = name
        self.description = description
        self.picture = picture
        self.from = from
        self.image = image
    }
    
    
}

