//
//  ViewController.swift
//  iOSPrinciple_RxSwift
//
//  Created by WhatsXie on 2018/5/23.
//  Copyright © 2018年 WhatsXie. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        neverTest()
//        emptyTest()
//        justTest()
//        ofTest()
//        fromTest()
//        createTest()
//        rangeTest()
//        repeatElementTest()
//        generateTest()
//        deferredTest()
//        errorTest()
        doOnTest()
    }
    
//    创建一个sequence，不能发出任何事件信号
    func neverTest() {
        let disposeBag = DisposeBag()
        let neverSequence = Observable<Any>.never()
        
        neverSequence.subscribe { _ in
            print("This will never be printed")
            }.disposed(by: disposeBag)
    }
    
//    创建一个空的sequence,只能发出一个completed事件
    func emptyTest() {
        let disposeBag = DisposeBag()
        let neverSequence = Observable<Any>.empty()

        neverSequence.subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
    }
    
//    创建一个sequence只能发出一种特定的事件，能正常结束
    func justTest() {
        let disposeBag = DisposeBag()
        Observable.just("")
            .subscribe { event in
                print(event)
            }.disposed(by: disposeBag)
    }
    
//    创建一个sequence能发出很多种事件信号
    func ofTest() {
        let disposeBag = DisposeBag()
        Observable.of("", "", "", "")
            .subscribe(onNext: { element in
                print(element)
            }).disposed(by: disposeBag)
    }
    
//    从集合中创建sequence，例如数组，字典或者Set
    func fromTest() {
        let disposeBag = DisposeBag()
        Observable.from(["", "", "", ""])
            .subscribe(onNext: {
                print($0)
            }).disposed(by: disposeBag)
    }
    
//    自定义可观察的sequence
    func createTest() {
        let disposeBag = DisposeBag()
        let myJust = { (element: String) -> Observable<Any> in
            return Observable.create { observer in
                observer.on(.next(element))
                observer.on(.completed)
                return Disposables.create()
            }
        }
        myJust("").subscribe {
                print($0)
            }.disposed(by: disposeBag)
    }
    
//    创建一个sequence，他会发出这个范围中的从开始到结束的所有事件
    func rangeTest() {
        let disposeBag = DisposeBag()
        Observable.range(start: 1, count: 10).subscribe {
                print($0)
            }.disposed(by: disposeBag)
    }
    
//    创建一个sequence，发出特定的事件n次
    func repeatElementTest() {
        let disposeBag = DisposeBag()
        Observable.repeatElement("").take(3).subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
    }
    
//    创建一个可观察sequence，当初始化的条件为true的时候，他就会发出所对应的事件
    func generateTest() {
        let disposeBag = DisposeBag()
        Observable<Int>
            .generate(initialState: 1, condition: { $0 < 10 }, iterate: { $0 + 1 })
            .subscribe(onNext: { int in
                print("element:", int)
            })
            .disposed(by: disposeBag)
    }
    
//    为每一为订阅者observer创建一个新的可观察序列
    func deferredTest() {
        let disposeBag = DisposeBag()
        let ob = Observable<Int>.deferred { () -> Observable<Int> in
            let ob1 = Observable<Int>.create({ ov in
                ov.onNext(1)
                ov.onNext(2)
                ov.onCompleted()
                return Disposables.create()
            })
            return ob1
        }
        ob.subscribe(onNext: { int in
            print(int)
        }).disposed(by: disposeBag)
    }
    
//    创建一个可观察序列，但不发出任何正常的事件，只发出error事件并结束
    enum RxError: Error {
        case error
    }
    func errorTest() {
        let disposeBag = DisposeBag()
        Observable<Int>.error(RxError.error)
            .subscribe(onNext:{ element in
                print("error:", element)
            }, onError: { error in
                print("error:", error)
            }, onCompleted: {
                print("error completed")
            })
            .disposed(by: disposeBag)
    }
    
//    在直接onNext处理时候，先执行某个方法
    func doOnTest() {
        let disposeBag = DisposeBag()
        Observable.of("", "", "", "").do(onNext: {
            print("Intercepted:", $0)
        }, onError: {
            print("Intercepted error:", $0)
        }, onCompleted: {
            print("Completed")
        }).subscribe(onNext: {
            print($0)
        },onCompleted: {
            print("结束")
        }).disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

