import UIKit
struct QuestionCellViewModel {
    var questionTitle: String = ""
    var questionDetail: String = ""

    var answeredViewEditedAnsweredLabel: String = ""
    var answeredViewUserName: String = ""
    var answeredViewImageUrlString: String = ""
    var answeredViewBadgesText: String = ""

    var editedViewEditedAnsweredLabel: String = ""
    var editedViewUserName: String = ""
    var editedViewImageUrlString: String = ""
    var editedViewBadgesText: String = ""

    init(questionData: Question) {
        if let item = questionData.items.first {
            questionTitle = item.title
            questionDetail = item.bodyMarkdown
            answeredViewEditedAnsweredLabel = "asked \(DateUtilities.getDate(item.creationDate))"
            answeredViewUserName = item.owner.displayName ?? ""
            answeredViewImageUrlString = item.owner.profileImage ?? ""
            let answeredViewBadgeCounts = item.owner.badgeCounts ?? BadgeCount(bronze: 0, silver: 0, gold: 0)
            answeredViewBadgesText = "\( item.owner.reputation ?? 0)\u{1F538}\(answeredViewBadgeCounts.gold)\u{1F539}\(answeredViewBadgeCounts.silver)\u{1F53A}\(answeredViewBadgeCounts.bronze)"

            if let lastEditor = item.lastEditor {
                editedViewEditedAnsweredLabel = "edited \(DateUtilities.getDate(item.lastActivityDate))"
                editedViewUserName = lastEditor.displayName ?? ""
                editedViewImageUrlString = lastEditor.profileImage ?? ""
                let editedViewBadgeCounts = lastEditor.badgeCounts ?? BadgeCount(bronze: 0, silver: 0, gold: 0)
                editedViewBadgesText = "\( lastEditor.reputation ?? 0)\u{1F538}\(editedViewBadgeCounts.gold)\u{1F539}\(editedViewBadgeCounts.silver)\u{1F53A}\(editedViewBadgeCounts.bronze)"
            }
        }
    }
}
