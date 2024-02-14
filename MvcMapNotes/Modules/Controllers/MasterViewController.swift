import UIKit

class MasterViewController: BaseCoordinatorModule<MasterModuleCompletion, Never> {
    private var model: MasterModel?
}

// MARK: - Initializators

extension MasterViewController {
    func initialize(model: MasterModel, view: MasterView) {
        self.model = model
        self.view = view

        configureNavigationItem()
    }
}

// MARK: - Configurators

extension MasterViewController {
    func configureNavigationItem() {
        let showDetailModuleItem = UIBarButtonItem(image: UIImage(systemName: "location.fill"),
                                                   style: .plain,
                                                   target: self,
                                                   action: #selector(onShowDetailModuleButtonItemTapped))
        navigationItem.rightBarButtonItem = showDetailModuleItem
        navigationItem.title = "Notes"
    }
}

// MARK: - Note

extension MasterViewController {
    func selectNote(id: Int) {
        completionSubject.send(.noteSelected(id: id))
    }

    func removeNote(id: Int) {
        model?.removeNote(id: id)
    }
}

// MARK: - Callbacks

extension MasterViewController {
    @objc private func onShowDetailModuleButtonItemTapped() {
        completionSubject.send(.showDetailModule)
    }
}
