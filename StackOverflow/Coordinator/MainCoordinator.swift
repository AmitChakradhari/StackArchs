import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators: [Coordinator] = [Coordinator]()

    var navigationController: UINavigationController
    init(navController: UINavigationController) {
        self.navigationController = navController
    }


    func start() {
        navigationController.delegate = self
        let vc = AllQuestionsPage()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }

    func questionAnswer(qId: Int) {
        let vc = QuestionAnswerPageVC()
        vc.coordinator = self
        vc.questionId = qId
        vc.modalPresentationStyle = .popover
        vc.modalTransitionStyle = .flipHorizontal
        navigationController.pushViewController(vc, animated: true)
    }

    func dismissViewController() {
        navigationController.popViewController(animated: true)
    }

}
