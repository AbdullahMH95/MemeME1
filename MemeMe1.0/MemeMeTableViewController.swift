//
//  MemeMeTableViewController.swift
//  MemeMe1.0
//
//  Created by Abdullah Al-Mahry on 30/11/2018.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeMeTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(goToMemeMeOne))
        //let appDelgate = UIApplication.shared.delegate as! AppDelegate
        //memes = appDelgate.memes
    }
    
    @objc func goToMemeMeOne() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let memeOne = storyBoard.instantiateViewController(withIdentifier: "MemeMeOne") as! ViewController
        self.present(memeOne, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeItem")!
        cell.textLabel?.text = memes[(indexPath as NSIndexPath).row].topText + "..." + memes[(indexPath as NSIndexPath).row].bottomText
        cell.imageView?.image = memes[(indexPath as NSIndexPath).row].memedImage
        print("Cell text?: " + memes[(indexPath as NSIndexPath).row].topText)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "SentMemeDetail") as! DetailMemeMeViewController
        let meme = memes[indexPath.row]
        controller.meme = meme
        navigationController?.pushViewController(controller, animated: true)
    }
}
