//
//  MovieListViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 11/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let mdb = PUTMDBService.init()

        mdb.popularMovies(sucessCompletion: { (page) in

            if let movie = page.results.first {
                mdb.image(fromMovie: movie, progressCompletion: { (image) in
                    
                }, errorCompletion: { (error) in
                    
                })
            }
            
        }) { (error) in

        }
    }
}
