//
//  BaseView.swift
//  BaseExtension
//
//  Created by wade.hawk on 2018. 1. 21..
//

import UIKit
import RxSwift

open class BaseUICollectionViewCell: UICollectionViewCell {
    public var disposeBag = DisposeBag()
    deinit {
        log.verbose(type(of: self))
    }
}
open class BaseUITableViewCell: UITableViewCell {
    public var disposeBag = DisposeBag()
    public weak var insideEvent: PublishSubject<Any>? = nil
    
    deinit {
        log.verbose(type(of: self))
    }
}
open class BaseUICollectionReusableView: UICollectionReusableView {
    public var disposeBag = DisposeBag()
    deinit {
        log.verbose(type(of: self))
    }
}

open class BaseUIView: UIView {
    public var disposeBag = DisposeBag()
    deinit {
        log.verbose(type(of: self))
    }
}
