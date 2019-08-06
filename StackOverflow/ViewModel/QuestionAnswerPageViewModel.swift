import UIKit
import PromiseKit

class QuestionAnswerPageViewModel {

    let questionCellIdentifier = "questionCell"
    let answerCellIdentifier = "answerCell"

    let networkManager = NetworkManager()

    var questionData: GenericResponse<QuestionItems>!
    var answersData: Answers!

    func getQuestionAnswer(with questionId: Int, completion: @escaping() -> Void) {
        networkManager.getResponse(api: .question(id: questionId), as: GenericResponse<QuestionItems>.self)
            .then { [weak self] qData -> Promise<Answers> in
                guard let strongSelf = self else {
                    return UIViewController.brokenPromise()
                }
                strongSelf.questionData = qData
                return strongSelf.networkManager.getAnswersOfQuestion(with: questionId)
            } .done { [weak self] ansData in
                self?.answersData = ansData
                completion()
            } .catch { error in
                print("error: \(error.localizedDescription)")
        }
    }

}

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

    init(questionData: GenericResponse<QuestionItems>) {
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

struct AnswerCellViewModel {

    var answerDetail: String = ""

    var answeredViewEditedAnsweredLabel: String = ""
    var answeredViewUserName: String = ""
    var answeredViewImageUrlString: String = ""
    var answeredViewBadgesText: String = ""

    var editedViewEditedAnsweredLabel: String = ""
    var editedViewUserName: String = ""
    var editedViewImageUrlString: String = ""
    var editedViewBadgesText: String = ""

    init(answerData: Answers.Answer) {
        answerDetail = answerData.bodyMarkdown
        answeredViewEditedAnsweredLabel = "answered \(DateUtilities.getDate(answerData.creationDate))"
        answeredViewUserName = answerData.owner.displayName ?? ""
        answeredViewImageUrlString = answerData.owner.profileImage ?? ""
        let answeredViewBadgeCounts = answerData.owner.badgeCounts ?? BadgeCount(bronze: 0, silver: 0, gold: 0)
        answeredViewBadgesText = "\( answerData.owner.reputation ?? 0)\u{1F538}\(answeredViewBadgeCounts.gold)\u{1F539}\(answeredViewBadgeCounts.silver)\u{1F53A}\(answeredViewBadgeCounts.bronze)"

        if let lastEditor = answerData.lastEditor {
            editedViewEditedAnsweredLabel = "edited \(DateUtilities.getDate(answerData.lastEditDate ?? 0))"
            editedViewUserName = lastEditor.displayName ?? ""
            editedViewImageUrlString = lastEditor.profileImage ?? ""
            let editedViewBadgeCounts = lastEditor.badgeCounts ?? BadgeCount(bronze: 0, silver: 0, gold: 0)
            editedViewBadgesText = "\( lastEditor.reputation ?? 0)\u{1F538}\(editedViewBadgeCounts.gold)\u{1F539}\(editedViewBadgeCounts.silver)\u{1F53A}\(editedViewBadgeCounts.bronze)"
        }
    }
}

