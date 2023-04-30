import Foundation


struct BucketData: Codable{
    let values : [Values]
    
    enum CodingKeys: String , CodingKey{
        case values
    }
}

struct Values: Codable {
    let title : String
    let description : String
    let owner : Owner
    let name : String?
    
    enum CodingKeys: String , CodingKey{
        case title = "name"
        case description
        case owner
        case name  = "nickname" 
    }
}

struct Owner: Codable {
    let dispName : String
    let links : Links
    
    enum CodingKeys: String , CodingKey{
        case dispName = "display_name"
        case links
    }
}

struct Links: Codable {
    let avatar : Avatar
    let html : HTML?
    enum CodingKeys: String , CodingKey{
        case avatar
        case html
    }
}

struct Avatar: Codable {
    let href : String
    
    enum CodingKeys: String , CodingKey{
        case href
    }
}

struct HTML: Codable{
    let href : String
    
    enum CodingKeys: String , CodingKey{
        case href
    }
}

