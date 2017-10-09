//
//  Reactive+Extension.swift
//  BaseExtension
//
//  Created by wade.hawk on 2017. 10. 9..
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - UIViewController
public enum ViewControllerState {
    case notloaded, hidden, hiding, showing, shown
}

extension Reactive where Base: UIViewController {
    public var viewWillAppear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewWillAppear(_:)))
    }
    public var viewDidAppear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidAppear(_:)))
    }
    public var viewDidDisappear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidDisappear(_:)))
    }
    public var viewWillDisappear: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewWillDisappear(_:)))
    }
    public var viewDidLayoutSubviews: Observable<[Any]> {
        return sentMessage(#selector(UIViewController.viewDidLayoutSubviews))
    }
    public var viewEvent: Observable<ViewControllerState> {
        let willAppear = viewWillAppear.map{ _ -> ViewControllerState in return .showing }
        let didAppear = viewDidAppear.map{ _ -> ViewControllerState in return .shown }
        let willDisappear = viewWillDisappear.map{ _ -> ViewControllerState in return .hiding }
        let didDisappear = viewDidDisappear.map{ _ -> ViewControllerState in return .hidden }
        return  Observable.of(willAppear,didAppear,willDisappear,didDisappear).merge()
    }
}

// MARK: - UIView
extension Reactive where Base: UIView {
    public var layoutSubviews: Observable<[Any]> {
        return sentMessage(#selector(UIView.layoutSubviews))
    }
}
