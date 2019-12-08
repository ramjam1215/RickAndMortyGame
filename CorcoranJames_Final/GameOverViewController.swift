//
//  GameOverViewController.swift
//  CorcoranJames_Final
//
//  Created by Jimmy Corcoran on 3/15/19.
//  Copyright © 2019 Jimmy Corcoran. All rights reserved.
//

import UIKit

class Rating
{
    var description: String;
    
    init(with rating: String)
    {
        self.description = rating;
    }
        
}


let gRatings =
[
    Rating(with: "Even Jerry could have done better than that, Morty."),
    
    Rating(with: "For crying out loud Morty, *Belches* do I have to do everything? We are going to Alpha Betri. You better hope we don't find any Numbericons."),
    
    Rating(with: "Not bad Moooorty.... almost as good as a Meeseeks."),
    
    Rating(with: "*Belches* well look who got a one-way ticket to Morty's Mind-Blowers Vault.")
];

class GameOverViewController: UIViewController
{

    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var sReview: UILabel!;
    
    func checkandSet()
    {
        var rank:Int = 0;
        
       
        //0 - 19
        if (score < 20)
        {
            rank = 0;
        }
        
        //20 - 29
        else if (score >= 20 && score < 30)
        {
            rank = 1;
        }
        
        //20 - 49
        else if (score >= 30 && score < 50)
        {
            rank = 2;
        }
            
        //50 and above
        else
        {
            rank = 3;
        }
        
        self.sReview.text = gRatings[rank].description;
        
    }
    
    @IBAction func resetGstate(_ sender: UIButton)
    {
        print("Score was \(score) and Timer was \(timer)");
        score = 0;
        timer = 30;
        print("Score is set to \(score) and Timer is set to \(timer)");
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        self.scoreLabel.text = "Your Score: \(score)";
        
        checkandSet();
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
