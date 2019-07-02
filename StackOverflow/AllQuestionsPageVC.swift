import UIKit

class AllQuestionsPage: UIViewController {

    var networkManager: NetworkManager!
    var tableView: UITableView!
    let cellIdentifier = "allQuestionCell"
    var allQuestions: AllQuestions!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        networkManager = NetworkManager()
        networkManager.getAllQuestions { data, error in
            guard error == nil else { return }
            self.allQuestions = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }

    func setUpTableView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        tableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllQuestionsTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
    }

}

extension AllQuestionsPage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let allQuestions = allQuestions else { return 0 }
        return allQuestions.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AllQuestionsTableViewCell
        // swiftlint:enable force_cast
        guard let allQuestions = allQuestions else { return cell}
        let items = allQuestions.items
        cell.questionTitle.text = items[indexPath.row].title
        cell.questionTag.text = items[indexPath.row].tags.joined(separator: ", ")
        cell.createdDate.text = Utility.getDate(items[indexPath.row].creationDate)
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
