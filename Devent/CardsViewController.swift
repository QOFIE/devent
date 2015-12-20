//
//  CardsViewController.swift
//  Devent
//
//  Created by Erman Sefer on 25/10/15.
//  Copyright © 2015 ES. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {
    
    struct Card {
        let cardView: CardView
        let swipeView: SwipeView
        let user: User
    }
    
    let frontCardTopMargin: CGFloat = 0
    let frontCardLeftMargin: CGFloat = 10
    let backCardTopMargin: CGFloat = 10
    let backCardLeftMargin: CGFloat = 0
    
    
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var cardStackView: UIView!
    @IBOutlet weak var nahButton: UIButton!
    @IBOutlet weak var yeahButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var backCard: Card?
    var frontCard: Card?
    var nameAge: String?

    
    var users: [User]?
    var i: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //
        
        frontCard?.cardView.removeFromSuperview()
        backCard?.cardView.removeFromSuperview()
        backCard?.swipeView.removeFromSuperview()

        cardStackView.backgroundColor = UIColor.clearColor()
        nahButton.setImage(UIImage(named: "nah-button-pressed"), forState: .Highlighted)
        yeahButton.setImage(UIImage(named: "yeah-button-pressed"), forState: .Highlighted)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        cardStackView.addGestureRecognizer(tapGestureRecognizer)
        
        fetchUnviewedUsers({
            returnUsers in
            self.users = returnUsers
            
            if let card = self.popCard() {
                self.frontCard = card
                self.cardStackView.addSubview(self.frontCard!.swipeView)
            }
            
            if let card = self.popCard() {
                self.backCard = card
                self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin, leftMargin: self.backCardLeftMargin)
                self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
                self.nameAgeLabel.hidden = false
            }
            
            if (self.frontCard != nil) {
            self.nameAge = self.frontCard!.user.name + ", " + self.frontCard!.user.age
            
            self.nameAgeLabel.text = self.nameAge
            }
            self.nameLabel.text = ""
        })
        
    }
    
    override func viewDidAppear(animated: Bool) {
       // self.viewDidLoad()
        
        let genderInterestedIn = PFUser.currentUser()?.objectForKey("genderInterestedIn") as? String
        let gender = PFUser.currentUser()?.objectForKey("gender") as? String
        
        if (genderInterestedIn == nil ||  gender == nil) {
            
            let alertController = DBAlertController(title: "Missing Information", message: "Please choose  gender and gender interested in from Edit Profile Page to view other user profiles!", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Go to Profile Page", style: .Destructive, handler: { action in self.performSegueWithIdentifier("noGenderInterestedSeque", sender: self) }))
            alertController.show()
        }
  
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    func imageTapped(img: AnyObject)
    {
        performSegueWithIdentifier("deneme5", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let edvc = segue.destinationViewController as? UINavigationController {
            let abcd = edvc.topViewController as? DiscoverProfilePage
            let user3 = frontCard?.user.pfUser
            abcd!.user2 = user3!
        }
    }

    @IBAction func nahButtonPressed(sender: UIButton) {
        if let card = frontCard {
            card.swipeView.swipeDirection(.Left)
             }
    }
    
    @IBAction func yeahButtonPressed(sender: UIButton) {
        if let card = frontCard {
             card.swipeView.swipeDirection(.Right)
            }
        
    }

    private func createCardFrame(topMargin: CGFloat, leftMargin: CGFloat) -> CGRect {
        return CGRect(x: leftMargin, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(user: User) -> Card {
        let cardView = CardView()
        
        //cardView.name = user.name
        cardView.name = ""
        user.getPhoto({
            image in
            cardView.image = image
        })
        
        let swipeView = SwipeView(frame: createCardFrame(frontCardTopMargin, leftMargin: frontCardLeftMargin))
        swipeView.delegate = self
        swipeView.innerView = cardView
        return Card(cardView: cardView, swipeView: swipeView, user: user)
    }
    
    private func popCard() -> Card? {
        if users != nil && users?.count > 0 {
            return createCard(users!.removeLast())
        }
        return nil
    }
    
    private func switchCards() {
        if let card = backCard {
            print("1")
            self.nameLabel.text = ""
            self.nameAge = self.backCard!.user.name + ", " + self.backCard!.user.age
            self.nameAgeLabel.text = self.nameAge

            frontCard = card
            UIView.animateWithDuration(0.2, animations: {
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin, leftMargin: self.frontCardLeftMargin)
            })
        }
        
        if let card = self.popCard() {
            print("3")
            backCard = card
            backCard!.swipeView.frame = createCardFrame(backCardTopMargin, leftMargin: backCardLeftMargin)
            cardStackView.insertSubview(backCard!.swipeView, belowSubview: frontCard!.swipeView)
        }
        else {
        i++
            if (i == 2){
            self.nameAgeLabel.hidden = true
            }
        }
        
    }
    
    @IBAction func unwindToMCardsVC(segue: UIStoryboardSegue) {
        // do nothing
    }
    
}


// MARK: SwipeViewDelegate
extension CardsViewController: SwipeViewDelegate {
    
    func swipedLeft() {
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveSkip(frontCard.user)
            switchCards()
            
        }
    }
    
    func swipedRight() {
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveLike(frontCard.user)
            switchCards()

        }
    }
    
}

