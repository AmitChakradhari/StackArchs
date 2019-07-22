import UIKit
import PromiseKit

class QuestionAnswerPageViewModel {

    let questionCellIdentifier = "questionCell"
    let answerCellIdentifier = "answerCell"

    let networkManager = NetworkManager()

    var questionData: Question!
    var answersData: Answers!

    func getQuestionAnswer(with questionId: Int, completion: @escaping() -> Void) {
        networkManager.getQuestion(with: questionId)
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


