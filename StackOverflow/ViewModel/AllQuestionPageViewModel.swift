import UIKit
import PromiseKit
import RxSwift
import RxCocoa

class AllQuestionPageViewModel {

    func getAllQuestions() -> Observable<[AllQuestionsItems]> {
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
}
