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
//        doOnTest()
//        publishSubjectTest()
//        behaviorSubjectTest()
//        replaySubjectTest()
//        variableTest()
//        startWithTest()
//        mergeTest()
//        zipTest()
//        combineLatestTest()
        switchLatestTest()
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
    
//    订阅PublishSubject，你只能接收到订阅他之后发生的事件
    func publishSubjectTest() {
        let disposeBag = DisposeBag()
        let subject = PublishSubject<String>()
        
        subject.onNext("111")
        
        subject.subscribe(onNext: { string in
            print("第1次订阅：", string)
        }, onCompleted:{
            print("第1次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        subject.onNext("222")
        
        subject.subscribe(onNext: { string in
            print("第2次订阅：", string)
        }, onCompleted:{
            print("第2次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        subject.onNext("333")
        
        subject.onCompleted()
        
        subject.onNext("444")
        
        subject.subscribe(onNext: { string in
            print("第3次订阅：", string)
        }, onCompleted:{
            print("第3次订阅：onCompleted")
        }).disposed(by: disposeBag)
    }
    
//    订阅BehaviorSubject，你会接受到订阅之前的最后一个事件
    func behaviorSubjectTest() {
        let disposeBag = DisposeBag()
        
        let subject = BehaviorSubject(value: "111")
        
        subject.subscribe { event in
            print("第1次订阅：", event)
            }.disposed(by: disposeBag)
        
        subject.onNext("222")
        
        subject.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        subject.subscribe { event in
            print("第2次订阅：", event)
            }.disposed(by: disposeBag)
    }
    
    func replaySubjectTest() {
        let disposeBag = DisposeBag()
        
        //创建一个bufferSize为2的ReplaySubject
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        //连续发送3个next事件
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        //第1次订阅subject
        subject.subscribe { event in
            print("第1次订阅：", event)
            }.disposed(by: disposeBag)
        
        //再发送1个next事件
        subject.onNext("444")
        
        //第2次订阅subject
        subject.subscribe { event in
            print("第2次订阅：", event)
            }.disposed(by: disposeBag)
        
        //让subject结束
        subject.onCompleted()
        
        //第3次订阅subject
        subject.subscribe { event in
            print("第3次订阅：", event)
            }.disposed(by: disposeBag)
    }
    
    func variableTest() {
        let disposeBag = DisposeBag()
        
        //创建一个初始值为111的Variable
        let variable = Variable("111")
        
        //修改value值
        variable.value = "222"
        
        //第1次订阅
        variable.asObservable().subscribe {
            print("第1次订阅：", $0)
            }.disposed(by: disposeBag)
        
        //修改value值
        variable.value = "333"
        
        //第2次订阅
        variable.asObservable().subscribe {
            print("第2次订阅：", $0)
            }.disposed(by: disposeBag)
        
        //修改value值
        variable.value = "444"
    }
    
//    在发出事件消息之前，先发出某个特定的事件消息
    func startWithTest() {
        let disposeBag = DisposeBag()
        
        Observable.of("2", "3")
            .startWith("1")
            .subscribe(onNext: { print($0) })
            .disposed(by:disposeBag)
    }
    
//    合并两个Observable流合成单个Observable流
    func mergeTest(){
        let disposeBag = DisposeBag()
        
        let subject1 = PublishSubject<Any>()
        let subject2 = PublishSubject<Any>()
        
        Observable.of(subject1, subject2)
            .merge()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("️")
        subject1.onNext("️")
        subject2.onNext("①")
        subject2.onNext("②")
        subject1.onNext("")
        subject2.onNext("③")
    }
    
//    绑定超过最多不超过8个的Observable流，结合在一起处理
    func zipTest() {
        let disposeBag = DisposeBag()
        let stringSubject = PublishSubject<Any>()
        let intSubject = PublishSubject<Any>()
//        将stringSubject和intSubject压缩到一起共同处理
        Observable.zip(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        stringSubject.onNext("️")
        stringSubject.onNext("️")
        
        intSubject.onNext(1)
        intSubject.onNext(2)
        
        stringSubject.onNext("")
        intSubject.onNext(3)
    }
    
//    绑定超过最多不超过8个的Observable流，结合在一起处理
    func combineLatestTest() {
        let disposeBag = DisposeBag()
        
        let stringSubject = PublishSubject<Any>()
        let intSubject = PublishSubject<Any>()
        
        Observable.combineLatest(stringSubject, intSubject) { stringElement, intElement in
            "\(stringElement) \(intElement)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        stringSubject.onNext("️")
        
        stringSubject.onNext("️")
        intSubject.onNext(1)
        
        intSubject.onNext(2)
        
        stringSubject.onNext("")
    }
    
//    switchLatest可以对事件流进行转换
    func switchLatestTest() {
        let disposeBag = DisposeBag()
        let subject1 = BehaviorSubject(value: "⚽️")
        let subject2 = BehaviorSubject(value: "")

        let variable = Variable(subject1)
        
        variable.asObservable()
            .switchLatest()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("")
        subject1.onNext("")
        
        variable.value = subject2
        
        subject1.onNext("⚾️")
        
        subject2.onNext("")
        variable.value = subject1
        subject2.onNext("Mary")
        subject1.onNext("Bobo")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

