//
//  ViewCellInfo.swift
//  Innowise Project
//
//  Created by Андрей Логвинов on 4/27/23.
//

import UIKit

class ViewCellInfo: UIViewController {
    var data: RepoModel? 
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var desription: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        label.text = data?.name
        fromLabel.text = data?.from
        desription.text = data?.description
        image.image = data?.image
    }

}
