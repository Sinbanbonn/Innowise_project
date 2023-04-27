import Foundation


struct Item: Decodable{
    let name: String
    let description : String
    let owner  : GitOwner
}

struct GitOwner : Decodable {
    let avatar_url : String
}

