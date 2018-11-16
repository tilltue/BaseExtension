//
//  Reactive+Extension.swift
//  BaseExtension
//
//  Created by wade.hawk on 2017. 10. 9..
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - CompositeDisposable
extension CompositeDisposable {
    public func add(disposables: [Disposable]) {
        for disposable in disposables {
            _ = self.insert(disposable)
        }
    }
}

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

// MARK: - UIButton
extension Reactive where Base: UIButton {
    public var throttleTap: Observable<Void> {
        return self.tap.throttle(0.2, scheduler: MainScheduler.instance)
    }
}

// MARK: - UIBarButtonItem
extension Reactive where Base: UIBarButtonItem {
    public var throttleTap: Observable<Void> {
        return self.tap.throttle(0.2, scheduler: MainScheduler.instance)
    }
}

public enum KeyboardNotification {
    case willShow
    case didShow
    case willChangeFrame
    case willHide
    case didHide
    var name: NSNotification.Name {
        switch self {
        case .willShow:
            return UIResponder.keyboardWillShowNotification
        case .didShow:
            return UIResponder.keyboardDidShowNotification
        case .willChangeFrame:
            return UIResponder.keyboardWillChangeFrameNotification
        case .willHide:
            return UIResponder.keyboardWillHideNotification
        case .didHide:
            return UIResponder.keyboardDidHideNotification
        }
    }
}

// MARK: - NotificationCenter
extension Reactive where Base: NotificationCenter {
    public func keyboard(_ notification: KeyboardNotification) -> Observable<(begin: (CGRect,TimeInterval), end: (CGRect,TimeInterval))> {
        return self.notification(notification.name)
            .flatMap { event -> Observable<(begin: (CGRect,TimeInterval), end: (CGRect,TimeInterval))> in
                guard let userInfo = event.userInfo as? [String: AnyObject] else { return Observable.empty() }
                guard let begin = userInfo[UIResponder.keyboardFrameBeginUserInfoKey]?.cgRectValue, let end = userInfo[UIResponder.keyboardFrameEndUserInfoKey]?.cgRectValue, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return Observable.empty() }
                if begin.origin == end.origin { return Observable.empty() }
                return Observable.just((begin: (begin, duration), end: (end, duration)))
        }
    }
}
