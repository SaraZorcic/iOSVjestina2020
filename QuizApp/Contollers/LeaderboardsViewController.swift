//
//  LeaderboardsViewController.swift
//  QuizApp
//
//  Created by sara on 22/06/2020.
//  Copyright © 2020 sara. All rights reserved.
//

import UIKit

class LeaderboardsViewController: UIViewController {
    var chosenQuizId:Int?
    override func viewDidLoad() {
          getLeaderBoard()
          super.viewDidLoad()
          }
    func getLeaderBoard(){
        print(chosenQuizId)
        let service = QuizServis()
        service.getLeaderBoards2(quizId: chosenQuizId!)
    }
}
