import Foundation

struct GitRep: Codable{
    
    let name :String
    let owner: GitOwner
    let description: String?
    
    enum CodingKeys: String , CodingKey{
        
        case name
        case owner
        case description
    }
}

struct GitOwner : Codable {
    let avatarUrl : String
    
    enum CodingKeys: String , CodingKey{
        
        case avatarUrl = "avatar_url"
    }
}

