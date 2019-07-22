import UIKit
class AllQuestionsPage: UIViewController {

    var tableView: UITableView!
    let cellIdentifier = "allQuestionCell"
    var allQuestions: AllQuestions!
    var allQuestionPageViewModel: AllQuestionPageViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()

        allQuestionPageViewModel = AllQuestionPageViewModel()

        allQuestionPageViewModel.getAllQuestions { [weak self] allQuestion in
            if let allQuest = allQuestion {
                self?.allQuestions = allQuest
                self?.tableView.reloadData()
            }
        }
    }

    func setUpTableView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        let allQuestionPageView =  AllQuestionPageView(frame: CGRect(x: 0, y: barHeight/2, width: displayWidth, height: displayHeight - barHeight/2))
        tableView = allQuestionPageView.tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllQuestionsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)
    }

}

extension AllQuestionsPage: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let allQuestions = allQuestions else { return 0 }
        return allQuestions.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AllQuestionsTableViewCell
        guard let allQuestions = allQuestions else { return cell }

        let cellData = allQuestionPageViewModel.questionCellItem(item: allQuestions.items[indexPath.row])
        cell.questionTitle.text = cellData.questionTitle
        cell.questionTag.text = cellData.questionTag
        cell.createdDate.text = cellData.createdDate
        cell.layoutIfNeeded()
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let allQuestions = allQuestions else { return }
        let items = allQuestions.items
        let questionAnswerpage = QuestionAnswerPageVC()
        questionAnswerpage.modalPresentationStyle = .popover
        questionAnswerpage.modalTransitionStyle = .flipHorizontal
        modalTransitionStyle = .flipHorizontal
        //present(questionAnswerpage, animated: true, completion: nil)
        questionAnswerpage.questionId = items[indexPath.row].questionId
        showDetailViewController(questionAnswerpage, sender: self)
    }

}
