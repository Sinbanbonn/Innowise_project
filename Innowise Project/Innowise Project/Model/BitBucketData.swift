import Foundation


struct BucketData: Decodable{
    let values : [Values]
}
struct Values: Decodable {
    let name : String
    let description : String
    let owner : Owner
}

struct Owner: Decodable {
    let display_name : String
    let links : Links
}

struct Links: Decodable {
    let avatar : Avatar
}

struct Avatar: Decodable {
    let href : String
}

