//
//  MileStoneEditViewController.swift
//  IssueTracker
//
//  Created by 최동규 on 2020/11/12.
//

import UIKit

protocol MileStoneEditViewControllerDelegate: class {
    func mileStoneChanged(_ mileStoneEditViewController: MileStoneEditViewController)
}

final class MileStoneEditViewController: DimmedViewController {
    
    private let editingView: MileStoneEditingView = MileStoneEditingView()
    private let useCase: MileStoneUseCaseType
    private var mileStone: MileStone  {
        didSet {
            editingView.update(with: mileStone)
        }
    }
    weak var delegate: MileStoneEditViewControllerDelegate?
    
    init(useCase: MileStoneUseCaseType, mileStone: MileStone) {
        self.useCase = useCase
        self.mileStone = mileStone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init?(coder: NSCoder) is not supported.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editingView.delegate = self
        addContentView(editingView)
        editingView.update(with: mileStone)
    }
}

extension MileStoneEditViewController: EditingViewDelegate {
    func closeButtonDidTouchUp(_ editingView: EditingView) {
        dismissWithAnimation()
    }
    
    func resetButtonDidTouchUp(_ editingView: EditingView) {
        guard let editingView = editingView as? MileStoneEditingView else { return }
        editingView.titleTextField.text = ""
        editingView.duedateTextField.text = nil
        editingView.descriptionTextField.text = nil
    }
    
    func saveButtonDidTouchUp(_ editingView: EditingView) {
        useCase.save(mileStone: mileStone) { [weak self] error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let error = error else {
                    self.dismissWithAnimation()
                    self.delegate?.mileStoneChanged(self)
                    return
                }
                self.alert(message: error.localizedDescription)
            }
        }
    }
}
extension MileStoneEditViewController: MileStoneEditingViewDelegate {
    func titleChanged(_ mileStoneEditingView: MileStoneEditingView, value: String) {
        mileStone.title = value
    }
    
    func descriptionChanged(_ mileStoneEditingView: MileStoneEditingView, value: String) {
        mileStone.description = value
    }
    
    func duedateChanged(_ mileStoneEditingView: MileStoneEditingView, value: String) {
        mileStone.duedate = value
    }
}
