import UIKit

class QuestionTableViewCell: UITableViewCell {

    var comments: [Comment] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(questionTitle)
        contentView.addSubview(questionDetail)
        contentView.addSubview(editors)
        editors.addArrangedSubview(editedView)
        editors.addArrangedSubview(answeredView)
        contentView.addSubview(commentsStackView)
        translatesAutoresizingMaskIntoConstraints = false
        addConstraintsAmongSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let questionTitle: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()

    let questionDetail: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()

    let editedView = EditedAnsweredView(frame: CGRect(x: 0, y: 0, width: 220, height: 90))
    let answeredView = EditedAnsweredView(frame: CGRect(x: 0, y: 0, width: 220, height: 90))
    var commentsStackView = CommentsStackView(frame: CGRect.zero)

    let editors: UIStackView = {
       let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 10.0

       return stackView
    }()

    func addConstraintsAmongSubviews() {
        NSLayoutConstraint.activate([
            questionTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            questionTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            questionTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),

            questionDetail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            questionDetail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            questionDetail.topAnchor.constraint(equalTo: questionTitle.bottomAnchor, constant: 10),

            editors.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            editors.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            editors.topAnchor.constraint(equalTo: questionDetail.bottomAnchor, constant: 10),
            //editors.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            commentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            commentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            commentsStackView.topAnchor.constraint(equalTo: editors.bottomAnchor, constant: 10),
            commentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ])
    }

}
