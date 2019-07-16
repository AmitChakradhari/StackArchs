//
//  AllQuestionsPageView.swift
//  StackOverflow
//
//  Created by Tricon Infotech on 16/07/19.
//  Copyright © 2019 Tricon Infotech. All rights reserved.
//

import UIKit
class AllQuestionPageView {
    var tableView: UITableView

    init(tableViewFrame: CGRect) {
        tableView = UITableView(frame: tableViewFrame, style: .plain)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }
}
