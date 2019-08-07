import UIKit
import PromiseKit
import RxSwift
import RxCocoa

class AllQuestionPageViewModel {

    var allQuestions: GenericResponse<AllQuestionsItems>!

    func getAllQuestions() -> Observable<GenericResponse<AllQuestionsItems>> {
        let networkManager = NetworkManager()
        return networkManager.getResponse1(api: .allQuestions, as: GenericResponse<AllQuestionsItems>.self)
    }

    func questionCellItem(item: AllQuestionsItems) -> AllQuestionPageCellData {
        return AllQuestionPageCellData(questionTitle: item.title,
                                       questionTag: item.tags.joined(separator: ", "),
                                       createdDate: DateUtilities.getDate(item.creationDate))
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
