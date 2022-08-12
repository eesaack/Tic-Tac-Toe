//
//  Alerts.swift
//  Tic_Tac_ToeApp
//
//  Created by eesaack on 2022-06-30.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContent {
    static let humanWin    = AlertItem(title: Text("You go, winner!"),
                             message: Text("You are incredibly smart! You beat your own AI!"),
                             buttonTitle: Text("Hell ya!"))
    
    static let computerWin = AlertItem(title: Text("You lost, looser!"),
                             message: Text("You programmed a super AI!"),
                             buttonTitle: Text("Rematch!"))
    
    static let draw        = AlertItem(title: Text("Draw!"),
                             message: Text("What a battle of wits we have here...!"),
                             buttonTitle: Text("Try again!"))
}
