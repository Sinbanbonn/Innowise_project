import Foundation

struct GitRep: Codable{
    
    let title :String
    let owner: GitOwner
    let description: String?
    let htmlUrl: String
    
    
    enum CodingKeys: String , CodingKey{
        
        case title = "name"
        case owner
        case description
        case htmlUrl = "html_url"
    }
}

struct GitOwner : Codable {
    let avatarUrl : String
    let name : String?
    let type : String
    enum CodingKeys: String , CodingKey{
        case avatarUrl = "avatar_url"
        case name = "login"
        case type
    }
}

