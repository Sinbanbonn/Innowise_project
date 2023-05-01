//
//  ViewCellInfo.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/27/23.
//

import UIKit

class ViewCellInfo: UIViewController {
    var data: RepoModel? 
   
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var desriptLabel: UILabel!
    
    override func viewDidLoad() {
        linkLabel.text =  data?.htmlURL
        sourceLabel.text = data?.source
        authorLabel.text = data?.name
        titleLabel.text = data?.title
        desriptLabel.text = data?.description
        image.image = data?.image
    }

}
