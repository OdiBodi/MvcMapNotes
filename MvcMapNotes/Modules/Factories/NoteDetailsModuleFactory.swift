struct NoteDetailsModuleFactory {
    func module(note: NoteModel) -> NoteDetailsViewController {
        let model = NoteDetailsModel(color: note.color, text: note.text)
        let view = NoteDetailsView()
        let controller = NoteDetailsViewController()

        view.initialize(model: model, controller: controller)
        controller.initialize(model: model, view: view)

        return controller
    }
}
