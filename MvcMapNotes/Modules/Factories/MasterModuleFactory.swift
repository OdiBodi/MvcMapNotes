struct MasterModuleFactory {
    func module() -> MasterViewController {
        let model = MasterModel()
        let view = MasterView()
        let controller = MasterViewController()

        view.initialize(model: model, controller: controller)
        controller.initialize(model: model, view: view)

        return controller
    }
}
