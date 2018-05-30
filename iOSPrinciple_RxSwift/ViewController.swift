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
//        switchLatestTest()
//        mapTest()
//        flatMapTest()
//        flatMapLatestTest()
//        scanTest()
//        filterTest()
//        distinctUntilChangedTest()
//        elementAtTest()
//        singleTest()
//        takeTest()
//        takeLastTest()
//        takeWhileTest()
//        takeUntilTest()
//        skipWhileTest()
//        skipUntilTest()
//        toArrayTest()
//        reduceTest()
//        concatTest()
//        publishTest()
//        replayTest()
//        multicastTest()
//        catchErrorJustReturnTest()
//        catchErrorTest()
//        retryTest()
        debugTest()
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
    
//    通过传入一个函数闭包把原来的sequence转变为一个新的sequence的操作
    func mapTest() {
        let disposeBag = DisposeBag()
        Observable.of(1, 2, 3)
            .map { $0 * $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    flatMap有一次拆包动作
    func flatMapTest() {
        let disposeBag = DisposeBag()
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .flatMap { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
//    flatMapLatest 与 flatMap 的唯一区别是：flatMapLatest 只会接收最新的 value 事件
    func flatMapLatestTest() {
        let disposeBag = DisposeBag()
        
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        
        let variable = Variable(subject1)
        
        variable.asObservable()
            .flatMapLatest { $0 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
    }
    
//    scan就是给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作。
    func scanTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4, 5)
            .scan(0) { acum, elem in
                acum + elem
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    filter很好理解，就是过滤掉某些不符合要求的事件
    func filterTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(2, 30, 22, 5, 60, 3, 40 ,9)
            .filter {
                $0 > 10
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    distinctUntilChanged就是当下一个事件与前一个事件是不同事件的事件才进行处理操作
    func distinctUntilChangedTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 1, 1, 4)
            .distinctUntilChanged()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    elementAt只处理在指定位置的事件
    func elementAtTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4)
            .elementAt(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    找出在sequence只发出一次的事件，如果超过一个就会发出error错误
    func singleTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4)
            .single{ $0 == 2 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        Observable.of("A", "B", "C", "D")
            .single()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    take只处理前几个事件信号
    func takeTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4)
            .take(2)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    takeLast只处理后几个事件信号
    func takeLastTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(1, 2, 3, 4)
            .takeLast(1)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    takeWhile当条件满足的时候进行处理
    func takeWhileTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(2, 3, 4, 5, 6)
            .takeWhile { $0 < 4 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    takeUntil接收事件消息，直到另一个sequence发出事件消息的时候
    func takeUntilTest() {
        let disposeBag = DisposeBag()
        
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
        
        source
            .takeUntil(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
        
        //停止接收消息
        notifier.onNext("z")
        
        source.onNext("e")
        source.onNext("f")
        source.onNext("g")
    }
    
//    skipWhile取消前几个事件
    func skipWhileTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(2, 3, 4, 5, 6)
            .skipWhile { $0 < 4 }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    直到某个sequence发出了事件消息，才开始接收当前sequence发出的事件消息
    func skipUntilTest() {
        let disposeBag = DisposeBag()
        
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<Int>()
        
        source
            .skipUntil(notifier)
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        source.onNext(1)
        source.onNext(2)
        source.onNext(3)
        source.onNext(4)
        source.onNext(5)
        
        //开始接收消息
        notifier.onNext(0)
        
        source.onNext(6)
        source.onNext(7)
        source.onNext(8)
        
        //仍然接收消息
        notifier.onNext(0)
        
        source.onNext(9)
    }

//    将sequence转换成一个array，并转换成单一事件信号，然后结束
    func toArrayTest() {
        let disposeBag = DisposeBag()
        
        Observable.range(start: 1, count: 10)
            .toArray()
            .subscribe { print($0) }
            .disposed(by:disposeBag)
    }
    
//    用一个初始值，对事件数据进行累计操作。reduce接受一个初始值，和一个操作符号
    func reduceTest() {
        let disposeBag = DisposeBag()
        
        Observable.of(10, 100, 1000)
            .reduce(1, accumulator: +)
            .subscribe(onNext: { print($0) })
            .disposed(by:disposeBag)
    }
    
//    concat会把多个sequence和并为一个sequence，并且当前面一个sequence发出了completed事件，才会开始下一个sequence的事件。
    func concatTest() {
        let disposeBag = DisposeBag()
        
        let subject1 = BehaviorSubject(value: 1)
        let subject2 = BehaviorSubject(value: 2)
        
        let variable = Variable(subject1)
        variable.asObservable()
            .concat()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject2.onNext(2)
        subject1.onNext(1)
        subject1.onNext(1)
        subject1.onCompleted()
        
        variable.value = subject2
        subject2.onNext(2)
    }
    
    //    将一个正常的sequence转换成一个connectable sequence
    func publishTest() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .publish()
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { print("订阅1: \($0)") })
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { print("订阅2: \($0)") })
        }
    }
    
//    将一个正常的sequence转换成一个connectable sequence，然后和replaySubject相似，能接收到订阅之前的事件消息。
    func replayTest() {
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .replay(5)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { print("订阅1: \($0)") })
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { print("订阅2: \($0)") })
        }
    }
    
//    将一个正常的sequence转换成一个connectable sequence，并且通过特性的subject发送出去，比如PublishSubject，或者replaySubject，behaviorSubject等。不同的Subject会有不同的结果。
    func multicastTest() {
        //创建一个Subject（后面的multicast()方法中传入）
        let subject = PublishSubject<Int>()
        
        //这个Subject的订阅
        _ = subject
            .subscribe(onNext: { print("Subject: \($0)") })
        
        //每隔1秒钟发送1个事件
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .multicast(subject)
        
        //第一个订阅者（立刻开始订阅）
        _ = interval
            .subscribe(onNext: { print("订阅1: \($0)") })
        
        //相当于把事件消息推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅者（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext: { print("订阅2: \($0)") })
        }
    }
    
//    遇到error事件的时候，就return一个值，然后结束
    func catchErrorJustReturnTest() {
        let disposeBag = DisposeBag()
        
        let sequenceThatFails = PublishSubject<String>()
        
        sequenceThatFails
            .catchErrorJustReturn("错误")
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        sequenceThatFails.onNext("a")
        sequenceThatFails.onNext("b")
        sequenceThatFails.onNext("c")
        sequenceThatFails.onError(MyError.A)
        sequenceThatFails.onNext("d")
    }
    
//    捕获error进行处理，可以返回另一个sequence进行订阅
    func catchErrorTest() {
        let disposeBag = DisposeBag()
        
        let sequenceThatFails = PublishSubject<String>()
        let recoverySequence = Observable.of("1", "2", "3")
        
        sequenceThatFails
            .catchError {
                print("Error:", $0)
                return recoverySequence
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        sequenceThatFails.onNext("a")
        sequenceThatFails.onNext("b")
        sequenceThatFails.onNext("c")
        sequenceThatFails.onError(MyError.A)
        sequenceThatFails.onNext("d")
    }
    
//    遇见error事件可以进行重试，比如网络请求失败，可以进行重新连接
    func retryTest() {
        let disposeBag = DisposeBag()
        var count = 1
        
        let sequenceThatErrors = Observable<String>.create { observer in
            observer.onNext("a")
            observer.onNext("b")
            
            //让第一个订阅时发生错误
            if count == 1 {
                observer.onError(MyError.A)
                print("Error encountered")
                count += 1
            }
            
            observer.onNext("c")
            observer.onNext("d")
            observer.onCompleted()
            
            return Disposables.create()
        }
        
        sequenceThatErrors
            .retry(2)  //重试2次（参数为空则只重试一次）
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
//    打印所有的订阅, 事件和disposals
    func debugTest() {
        let disposeBag = DisposeBag()
        
        Observable.of("2", "3")
            .startWith("1")
            .debug()
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    // MARK:Function
    
    ///延迟执行
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - closure: 延迟执行的闭包
    public func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    // MARK:ENUM
    enum MyError: Error {
        case A
        case B
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
