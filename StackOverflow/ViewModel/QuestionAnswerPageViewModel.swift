import UIKit
class QuestionAnswerPageViewModel {

    let questionAnswerPageView: QuestionAnswerPageView!
    let tableView: UITableView!

    let questionCellIdentifier = "questionCell"
    let answerCellIdentifier = "answerCell"

    init(vc: UIViewController) {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = vc.view.frame.width
        let displayHeight: CGFloat = vc.view.frame.height

        questionAnswerPageView = QuestionAnswerPageView(frame: CGRect(x: 0, y: barHeight/2, width: displayWidth, height: displayHeight - barHeight/2))

        tableView = questionAnswerPageView.tableView
        tableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: questionCellIdentifier)
        tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: answerCellIdentifier)
    }
}
