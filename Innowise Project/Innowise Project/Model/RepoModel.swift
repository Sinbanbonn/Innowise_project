import Foundation
import UIKit


struct RepoModel{
    let name : String
    let title: String
    let description: String
    let picture: String
    let source : String
    let htmlURL : String
    let type : String
    var image: UIImage?
    
    init(name: String, title: String, description: String, picture: String, source: String, htmlURL: String, type: String, image: UIImage? = nil) {
        self.name = name
        self.title = title
        self.description = description
        self.picture = picture
        self.source = source
        self.htmlURL = htmlURL
        self.type = type
        self.image = image
    }
 
   
    
    
}

