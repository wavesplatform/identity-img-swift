//
//  ViewController.swift
//  IdentityImg
//
//  Created by Prokofev Ruslan on 14/09/2018.
//  Copyright © 2018 Waves. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private let identity = Identity(options: Identity.defaultOptions)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

final class ImageCell: UITableViewCell {
    @IBOutlet var iconView: UIImageView!
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10000
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: ImageCell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
        let hash = randomString(length: Int(arc4random() % 1000))
        cell.iconView.image = identity.createImage(by: hash, size: cell.frame.size)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.width
    }
}

func randomString(length: Int) -> String {

    let letters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)

    var randomString = ""

    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }

    return randomString
}
