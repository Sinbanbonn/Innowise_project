//
//  ViewController.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/26/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
   
    var storage : [RepoModel] = []
    var filteredStorage = [RepoModel]()
    var service = RepoService()
    let searchController = UISearchController()
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var buttonPressed: UIButton!
    
    override func viewDidLoad(){
        
        tableView.delegate = self
        tableView.register(UINib(nibName: "RepoCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        loadTable()
        tableView.dataSource = self
        scroll.contentSize = tableView.contentSize
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        super.viewDidLoad()
        initSearchController()
        
    }
    
    private func fetchData(completion: @escaping ((Result<[GitRep], RequestError> , Result<BucketData , RequestError>)) -> Void) {
        Task(priority: .background) {
            async let resultGit =  service.getGitData()
            async let resulBit =  service.GetBibBucketData()
            let a = await (resultGit , resulBit)
            completion(a)
            
        }
    }
    
    
    func loadTable(completion: (() -> Void)? = nil){
        fetchData(){
            result1 , result2 in
            switch (result1 , result2){
            case (.success(let git) , .success(let bit)):
                var aser = self.fromDtoBitToArray(bitBucketData: bit)
                var gitStore = self.fromDtoGitToArray(gitData: git)
                self.storage += aser
                self.storage += gitStore
                Task{
                    for value in 0...self.storage.count - 1 {
                        async let a = self.loadImage(from: URL(string: self.storage[value].picture)!)
                        self.storage[value].image = try await a
                        
                        self.tableView.reloadData()
                    }
                    
                }
                
                self.tableView.reloadData()
                
                
                
            case (.failure(let error), _):
                self.showModal(title: "Error", message: error.customMessage)
            case (_, .failure(let error)):
                self.showModal(title: "Error", message: error.customMessage)
            }
        }
        
    }
    
    
    //засунуть в extension
    func fromDtoBitToArray(bitBucketData: BucketData)->[RepoModel]{
        var models : [RepoModel] = []
        for value in 0...(bitBucketData.values.count - 1){
            
            let name = bitBucketData.values[value].name
            let description = bitBucketData.values[value].description
            let picture =  bitBucketData.values[value].owner.links.avatar.href
            var image: UIImage?
            Task{
                image =  try await loadImage(from:URL(string: picture)!)
                
            }
            
            let model = RepoModel(name: name, description: description, picture: picture, from: "bit" , image: image)
            
            models.append(model)
        }
        
        return models}
    //засунуть в extension
    func fromDtoGitToArray(gitData: [GitRep])->[RepoModel]{
        var models : [RepoModel] = []
        for value in gitData{
            let name = value.name
            let description = value.description ?? ""
            let picture =  value.owner.avatarUrl
            var image: UIImage?
            Task{
                image =  try await loadImage(from:URL(string: picture)!)
                
            }
            
            let model = RepoModel(name: name, description: description, picture: picture, from: "git" , image: image)
            
            models.append(model)
        }
        return models
    }
    
    
    func loadImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
    
    
    private func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



extension ViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.isActive){
            return filteredStorage.count
        }
        return storage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ReusableCell" , for: indexPath) as! RepoCellTableViewCell
        if (searchController.isActive){
            
            print(filteredStorage)
            cell.nameLabel.text  = filteredStorage[indexPath.row].name
            cell.descriptionLabel.text = filteredStorage[indexPath.row].from
            
            cell.fromLabel.text = filteredStorage[indexPath.row].from
            if let img = filteredStorage[indexPath.row].image {
                cell.userImage.image = img
            }
            
        }else{
            cell.nameLabel.text  = storage[indexPath.row].name
            cell.descriptionLabel.text = storage[indexPath.row].from
            
            cell.fromLabel.text = storage[indexPath.row].from
            if let img = storage[indexPath.row].image {
                cell.userImage.image = img
            }
            
        }
        return cell}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "cellInfo", sender: storage[indexPath.row])
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellInfo" {
            let destinationVc = segue.destination as! ViewCellInfo
            destinationVc.data = sender as? RepoModel
        }
    }
    
}
extension ViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    func filterForSearch(searchString: String){
        filteredStorage  = storage.filter{ repoModel in
            if searchController.searchBar.text != ""{
                
                let searchNameMatch = repoModel.name.lowercased().contains(searchString.lowercased())
                let searchFromMatch = repoModel.from.lowercased().contains(searchString.lowercased())
                print()
                return searchNameMatch || searchFromMatch
            }
            return true
        }
        
        tableView.reloadData()
        
    }
    
    func initSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        print("Was called updateSearchResults")
        filterForSearch(searchString: searchText)
    }
}
