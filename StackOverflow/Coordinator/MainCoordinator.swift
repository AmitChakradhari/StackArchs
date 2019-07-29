import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()

    var navigationController: UINavigationController
    init(navController: UINavigationController) {
        self.navigationController = navController
    }

    func start() {
        let vc = AllQuestionsPage()
        navigationController.pushViewController(vc, animated: true)
    }


}
