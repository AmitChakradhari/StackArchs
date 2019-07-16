import UIKit

class QuestionAnswerPageView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.frame = frame
        addSubview(tableView)
        addSubview(backButton)
        bringSubviewToFront(backButton)
        addConstraintsAmongSubviews()
    }
    let tableView : UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    let backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 10, y: 20, width: 44, height: 44))
        button.setTitle("<-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(nil, action: #selector(QuestionAnswerPageVC.backButtonPressed), for: .touchUpInside)
        return button
    }()

    func addConstraintsAmongSubviews() {
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 10)

            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
