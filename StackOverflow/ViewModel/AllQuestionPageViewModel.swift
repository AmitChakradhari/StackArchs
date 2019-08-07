import UIKit
import PromiseKit
import RxSwift
import RxCocoa

class AllQuestionPageViewModel {

    var allQuestions: GenericResponse<AllQuestionsItems>!

    func getAllQuestions() -> Observable<GenericResponse<AllQuestionsItems>> {

        return Observable.create { observer -> Disposable in

            let networkManager = NetworkManager()

            networkManager.getResponse(api: .allQuestions, as: GenericResponse<AllQuestionsItems>.self)
                .done { [weak self] allQuest in
                    self?.allQuestions = allQuest
                    observer.onNext(allQuest)
                }.catch { error in
                    observer.onError(error)
            }
            return Disposables.create()
        }
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
