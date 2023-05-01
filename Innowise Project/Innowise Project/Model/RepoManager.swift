////
////  RepoManager.swift
////  Innowise Project
////
////  Created by Андрей Логвинов on 5/1/23.
////
//
//import Foundation
//
//class RepoManager{
//    
//    func sortBy(storage: [RepoModel] , method: String)->[RepoModel]{
//        var defStorage = [RepoModel]()
//        switch method{
//        case "A - Z" :
//            defStorage = storage.sorted(by: {$0.title < $1.title})
//        case "Z - A" :
//            defStorage = storage.sorted(by: {$0.title > $1.title})
//        case "By Source":
//            defStorage = storage.sorted(by:  {$0.source <= $1.source })
//        case "Default" :
//            defStorage = storage
//        default:
//            defStorage = storage
//        }
//        return defStorage
//    }
//    
//    func filterForSearch(storage: [RepoModel] , searchMethod: String , searchString: String){
//        var filteredStorage  = storage.filter{ repoModel in
//            if searchController.searchBar.text != ""{
//                var searchMatch :Bool  = false
//                switch searchMethod{
//                case "By Name" :
//                    searchMatch = repoModel.name.lowercased().contains(searchString.lowercased())
//                case "By Title" :
//                    searchMatch = repoModel.title.lowercased().contains(searchString.lowercased())
//                    print("first")
//                case "By Source":
//                    searchMatch = repoModel.source.lowercased().contains(searchString.lowercased())
//                    print("second")
//                default:
//                    searchMatch = repoModel.title.lowercased().contains(searchString.lowercased())
//                    print("default")
//                }
//                
//                return searchMatch
//            }
//            return true
//        }
//        
//        //tableView.reloadData()
//        
//    }
//}
