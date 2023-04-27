import Foundation
import UIKit


class RepoManager{
    static var models: [RepoModel] = []
     static func parseJson(_ data : Data ,_ url : String){
        let decoder = JSONDecoder()
        do{
            if url == K.bitBucket {
                let decodedData = try decoder.decode(BucketData.self, from: data)
                
                for value in 0...(decodedData.values.count - 1){
                    
                    let name = decodedData.values[value].name
                    let description = decodedData.values[value].description
                    let picture =  decodedData.values[value].owner.links.avatar.href
                    let a = RepoModel(name: name, description: description, picture: picture, from: "bitbucket")
                    models.append(a)
                    
                }
                
                
                
            }
            else if url == K.git{
                let decodedData = try decoder.decode( [Item].self,from: data)
                
                for value in decodedData {
                    let name = value.name
                    let description = value.description
                    let picture = value.owner.avatar_url
                    let a = RepoModel(name: name, description: description, picture: picture, from: "Git")
                    models.append(a)
                }
                
                
                
            }
          
            
            
        }
        catch{
            print(error)
        }
    }
    
    
    
    
    static func refToImage(_ reference : String) -> UIImage {
        
        let url = URL(string: reference)!
        guard let data = try? Data(contentsOf: url) else {return UIImage() }
        let image  = UIImage(data: data)
        return image!
        
    }
   
}
