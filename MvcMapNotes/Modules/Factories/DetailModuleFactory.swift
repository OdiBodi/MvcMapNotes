struct DetailModuleFactory {
    func module() -> (model: DetailModel, controller: DetailViewController) {
        let model = DetailModel()
        let view = DetailView()
        let controller = DetailViewController()

        view.initialize(model: model, controller: controller)
        controller.initialize(model: model, view: view)

        return (model, controller)
    }
}
