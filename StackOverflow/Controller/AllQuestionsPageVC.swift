import UIKit
import RxSwift
import RxCocoa

class AllQuestionsPage: UIViewController {

    var tableView: UITableView!
    let cellIdentifier = "allQuestionCell"
    var allQuestions: GenericResponse<AllQuestionsItems>!
    var allQuestionPageViewModel: AllQuestionPageViewModel!
    weak var coordinator: MainCoordinator?

    let disposeBag = DisposeBag()

    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()

        allQuestionPageViewModel = AllQuestionPageViewModel()

        allQuestionPageViewModel.getAllQuestions()
            .subscribe(onNext: { [weak self] allQuestion in
                self?.allQuestions = allQuestion
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        }

    func setUpTableView() {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        let allQuestionPageView =  AllQuestionPageView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight/2))
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
        modalTransitionStyle = .flipHorizontal

        coordinator?.questionAnswer(qId: items[indexPath.row].questionId)
    }

}

