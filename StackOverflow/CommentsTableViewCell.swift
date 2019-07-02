import UIKit

class CommentsTableViewCell: UITableViewCell {

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
        contentView.addSubview(answerDetail)
        translatesAutoresizingMaskIntoConstraints = false
        addConstraintsAmongSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let answerDetail: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        return lbl
    }()

    func addConstraintsAmongSubviews() {
        NSLayoutConstraint.activate([

            answerDetail.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            answerDetail.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            answerDetail.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            answerDetail.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)

            ])
    }
}
