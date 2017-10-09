//
//  BaseViewController.swift
//  BaseExtension
//
//  Created by wade.hawk on 2017. 10. 9..
//

import Foundation
import RxSwift
import RxCocoa

protocol BaseViewControllerType: class {
    var disposeBag: DisposeBag { get }
    var viewControllerState: Variable<ViewControllerState> { get }
    var statusBarStyle: UIStatusBarStyle { get }
}

open class BaseViewController: UIViewController, BaseViewControllerType {
    var disposeBag = DisposeBag()
    var compositeDisposable = CompositeDisposable()
    let viewControllerState = Variable<ViewControllerState>(.notloaded)
    var statusBarStyle: UIStatusBarStyle { get { return .default } }
    deinit {
        self.compositeDisposable.dispose()
        log.verbose(type(of: self))
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllerState.value = .hidden
        self.rx.viewEvent.subscribe(onNext:{ [weak self] state in
            self?.viewControllerState.value = state
        }).disposed(by: disposeBag)
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
}
