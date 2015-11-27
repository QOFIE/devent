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
    let backCardTopMargin: CGFloat = 10
    
    
    @IBOutlet weak var cardStackView: UIView!
    @IBOutlet weak var nahButton: UIButton!
    @IBOutlet weak var yeahButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var backCard: Card?
    var frontCard: Card?
    
    var users: [User]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            }
            
            self.nameLabel.text = self.frontCard?.user.name
        })
        
        
    }
    
    func imageTapped(img: AnyObject)
    {
        let user3 = frontCard?.user.pfUser
        print("deneme")
        print(user3?.objectId)
        
        performSegueWithIdentifier("deneme5", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let edvc = segue.destinationViewController as? UINavigationController {
            
            let abcd = edvc.topViewController as? DiscoverProfilePage
            
            print("obtained the right vc")
            print(frontCard?.user.pfUser)
            
            let user3 = frontCard?.user.pfUser
            
            abcd!.user2 = user3!
            print(user3?.objectId)
            
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
    
    
    
    
    
    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(user: User) -> Card {
        let cardView = CardView()
        
        cardView.name = user.name
        user.getPhoto({
            image in
            cardView.image = image
        })
        
        let swipeView = SwipeView(frame: createCardFrame(frontCardTopMargin))
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
            self.nameLabel.text = self.backCard?.user.name
            frontCard = card
            UIView.animateWithDuration(0.2, animations: {
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
            })
        }
        
        if let card = self.popCard() {
            backCard = card
            backCard!.swipeView.frame = createCardFrame(backCardTopMargin)
            cardStackView.insertSubview(backCard!.swipeView, belowSubview: frontCard!.swipeView)
        }
    }
    
}


// MARK: SwipeViewDelegate
extension CardsViewController: SwipeViewDelegate {
    
    func swipedLeft() {
        print("left")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveSkip(frontCard.user)
            switchCards()
        }
    }
    
    func swipedRight() {
        print("right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveLike(frontCard.user)
            switchCards()
        }
    }
    
}

