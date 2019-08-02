import UIKit

class AllQuestionCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()

    var navigationController: UINavigationController

    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

    }

    func coordinate(qId: Int) {
        let vc = QuestionAnswerPageVC()
        vc.coordinator = self
        vc.questionId = qId
        vc.modalPresentationStyle = .popover
        vc.modalTransitionStyle = .flipHorizontal
        navigationController.pushViewController(vc, animated: true)
    }

}
