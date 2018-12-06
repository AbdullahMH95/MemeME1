//
//  MemeMeCollectionViewController.swift
//  MemeMe1.0
//
//  Created by Abdullah Al-Mahry on 28/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeMeCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(goToMemeMeOne))
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    @objc func goToMemeMeOne() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let memeOne = storyBoard.instantiateViewController(withIdentifier: "MemeMeOne") as! ViewController
        self.present(memeOne, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeItem", for: indexPath) as! MemeMeCollectionViewCell
        cell.imageView?.image = memes[(indexPath as NSIndexPath).row].memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "SentMemeDetail") as! DetailMemeMeViewController
        let meme = memes[indexPath.row]
        controller.meme = meme
        navigationController?.pushViewController(controller, animated: true)
    }
    

}
