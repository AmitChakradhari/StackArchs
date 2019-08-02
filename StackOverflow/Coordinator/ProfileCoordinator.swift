import UIKit

class ProfileCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = [Coordinator]()

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        
    }


}
