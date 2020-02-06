//
//  ViewController.swift
//  MAP19_ios_gcd
//
//  Created by David Svensson on 2020-02-06.
//  Copyright © 2020 David Svensson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var inactiveQueue : DispatchQueue?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // simpleQueue()
        // queuesWithPriority()
      //  concurrentQueue()
      //  inactiveQueue?.activate()
        
        fetchImage()
        
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //
    //        // loopen körs på main-thread och därmed blockar vårt UI
    //        for i in 0...10000000 {
    //            print("oj")
    //        }
    //
    //    }
    
    func simpleQueue() {
        
        let queue = DispatchQueue(label: "myQueue")
        
        // kommer köras på en egen tråd som har lägre prioritet
        queue.async {
            for i in 0...10 {
                print("🍏 \(i)")
            }
        }
        
        // körs på main-thread
        for i in 0...10 {
            print("🍊 \(i)")
        }
    }
    
    func queuesWithPriority() {
        let queue1 = DispatchQueue(label: "queue1", qos: .userInitiated)
        let queue2 = DispatchQueue(label: "queue2", qos: .utility)
        
        queue1.async {
            for i in 1...10 {
                print("🍎 \(i)")
            }
        }
        
        queue2.async {
            for i in 1...10 {
                print("🍏 \(i)")
            }
        }
        
        for i in 1...10 {
            print("🍊 \(i)")
        }
        
    }
    
    
    func concurrentQueue() {
        let queue = DispatchQueue(label: "queue", qos: .utility, attributes: [.initiallyInactive, .concurrent])
        
        inactiveQueue = queue
        
        queue.async {
            for i in 1...10 {
                print("🍎 \(i)")
            }
        }
        
        queue.async {
            for i in 1...10 {
                print("🍏 \(i)")
            }
        }
        
        for i in 1...10 {
            print("🍊 \(i)")
        }
    }
    
    func fetchImage() {
        
        // skapa ett url object utifron vår webadress
        guard let imageUrl = URL(string: "https://upload.wikimedia.org/wikipedia/commons/b/b9/Mittens_the_cat_of_wellington.jpg") else {return}
        
        
        // sätter vi igång nedladdningen av bilden via en URLSEssion
        // till den skickar vi med en funktion som skall köras när nedladdningen är klar
        URLSession(configuration: .default).dataTask(with: imageUrl, completionHandler: {
            (imageData, response, error) in
            
            if let data = imageData {
                print("Bild nedladdad 🍏")
                
                // för att interagera med vårt UI behöver vi vara på Huvud-tråden
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }).resume()
        
        print("nedladdning startad 🍎")
    }
}

