//
//  BackButtonView.swift
//  StackOverflow
//
//  Created by Tricon Infotech on 16/07/19.
//  Copyright © 2019 Tricon Infotech. All rights reserved.
//

import UIKit

class QuestioAnswerPageView {
    var tableView: UITableView
    var backButton: UIButton
    init(tableViewFrame: CGRect) {
        tableView = UITableView(frame: tableViewFrame, style: .plain)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension

        backButton = UIButton(frame: CGRect(x: 10, y: 20, width: 44, height: 44))
        backButton.setTitle("<-", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
        backButton.addTarget(nil, action: #selector(QuestionAnswerPageVC.backButtonPressed), for: .touchUpInside)
    }
}
