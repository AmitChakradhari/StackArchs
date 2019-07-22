import UIKit
import PromiseKit

class AllQuestionPageViewModel {


    var allQuestions: AllQuestions!

    func getAllQuestions(completion: @escaping (AllQuestions?) -> Void) {

        let networkManager = NetworkManager()

        networkManager.getAllQuestions()
            .done { [weak self] allQuest in
                self?.allQuestions = allQuest
                completion(allQuest)
            }.catch { error in
                completion(nil)
        }

    }

    func questionCellItem(item: AllQuestions.AllItems) -> AllQuestionPageCellData {
        return AllQuestionPageCellData(questionTitle: item.title, questionTag: item.tags.joined(separator: ", "), createdDate: DateUtilities.getDate(item.creationDate))
    }

}

struct AllQuestionPageCellData {
    let questionTitle: String
    let questionTag: String
    let createdDate: String
    init(questionTitle: String, questionTag: String, createdDate: String) {
        self.questionTitle = questionTitle
        self.questionTag = questionTag
        self.createdDate = createdDate
    }
    
}
