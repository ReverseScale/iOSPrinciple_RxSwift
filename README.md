# iOSPrinciple_RxSwift
Principle RxSwift

> RxSwif 是 ReactiveX (http://reactivex.io/) 的 Swift 版本，也就是一个函数式响应编程的框架。

## 观察者模式
比如一个宝宝在睡觉，爸爸妈妈，爷爷奶奶总不能在那边一只看着吧？那样子太累了。他们该做啥事就做啥事呗，只要听到宝宝的哭声，他们就给宝宝喂奶就行了。这就是一个典型的观察者模式。宝宝是被观察者，爸爸妈妈等是观察者也称作订阅者，只要被观察者发出了某些事件比如宝宝哭声、叫声都是一个事件，通知到订阅者，订阅者们就可以做相应的处理工作。

## RxSwift 工作流程
RxSwift 把我们程序中每一个操作都看成一个事件，比如一个 TextField 中的文本改变，一个按钮被点击，或者一个网络请求结束等，每一个事件源就可以看成一个管道，也就是 sequence ，比如 TextField，当我们改变里面的文本的时候，这个 TextField 就会不断的发出事件，从他的这个 sequence 中不断的流出，我们只需要监听这个 sequence，每流出一个事件就做相应的处理。

同理，Button 也是一个 sequence，每点击一次就流出一个事件。也就是我们把每一步都想成是一个事件就好去理解 RxSwift 了。

## Observable 和 Observer
理解了观察者模式这两个概念就很好理解了，Observable 就是可被观察的，也就是我们说的宝宝，他也是事件源。而 Observer 就是我们的观察者，也就是当收到事件的时候去做某些处理的爸爸妈妈。观察者需要去订阅(subscribe)被观察者，才能收到 Observable 的事件通知消息。

* Observable ：👶
* Observer：💑
* subscribe：👪
* sequence：🏠

## 创建和订阅被观察者
下面创建被观察者其实就是创建一个Obserable的sequence，就是创建一个流，然后就可以被订阅subscribe，这样被观察者发出时间消失，我们就能做相应的处理。

## DisposeBag
DisposeBag其实就相当于iOS中的ARC似得，会在适当的时候销毁观察者，相当于内存管理者吧。

## subscribe
subscribe是订阅sequence发出的事件，比如next事件，error事件等。而subscribe(onNext:)是监听sequence发出的next事件中的element进行处理，他会忽略error和completed事件。相对应的还有subscribe(onError:) 和 subscribe(onCompleted:)

### never
Never就是创建一个sequence，但是不发出任何事件信号。

![](http://og1yl0w9z.bkt.clouddn.com/18-5-22/26220209.jpg)

```swift
let disposeBag = DisposeBag()
let neverSequence = Observable.never()
 
let neverSequenceSubscription = neverSequence.subscribe { _ in
		print("This will never be printed")
}.addDisposableTo(disposeBag)
```

什么都不打印…

### empty
empty就是创建一个空的sequence,只能发出一个completed事件

![](http://og1yl0w9z.bkt.clouddn.com/18-5-22/41244481.jpg)

```swift
let disposeBag = DisposeBag()
Observable.empty().subscribe { event in
		print(event)
}.addDisposableTo(disposeBag)
```

打印结果：

```
completed
```

### just
just是创建一个sequence只能发出一种特定的事件，能正常结束

```swift
let disposeBag = DisposeBag()
Observable.just("")
.subscribe { event in
		print(event)
}.addDisposableTo(disposeBag)
```

![](http://og1yl0w9z.bkt.clouddn.com/18-5-22/64996910.jpg)

打印结果：

```
next()
completed
```

### of
Of是创建一个sequence能发出很多种事件信号

```swift
let disposeBag = DisposeBag()
Observable.of("", "", "", "").subscribe(onNext: { element in
		print(element)
}).addDisposableTo(disposeBag)
```

如果把上面的onNext:去掉的话，结果会是这样子，也正好对应了我们subscribe中，subscribe只监听事件。

打印结果：

```
next()
next()
next()
next()
completed
```

### from
from就是从集合中创建sequence，例如数组，字典或者Set
```swift
let disposeBag = DisposeBag()
Observable.from(["", "", "", ""])
.subscribe(onNext: { print($0) })
.addDisposableTo(disposeBag)
```

### create
我们也可以自定义可观察的sequence，那就是使用create

![](http://og1yl0w9z.bkt.clouddn.com/18-5-22/21389836.jpg)

create操作符传入一个观察者observer，然后调用observer的onNext，onCompleted和onError方法。返回一个可观察的obserable序列。

```swift
let disposeBag = DisposeBag()
let myJust = { (element: String) -> Observable in
		return Observable.create { observer in
			observer.on(.next(element))
			observer.on(.completed)
			return Disposables.create()
		}
}
myJust("").subscribe { 
		print($0) 
}.addDisposableTo(disposeBag)
```

打印结果：

```
next()
completed
```

### range
range就是创建一个sequence，他会发出这个范围中的从开始到结束的所有事件

![](http://og1yl0w9z.bkt.clouddn.com/18-5-22/89687795.jpg)

```swift
let disposeBag = DisposeBag()
Observable.range(start: 1, count: 10).subscribe { print($0) }
.addDisposableTo(disposeBag)
```

打印结果：

```
next(1)
next(2)
next(3)
next(4)
next(5)
next(6)
next(7)
next(8)
next(9)
next(10)
completed
```

### repeatElement
创建一个sequence，发出特定的事件n次

![](http://og1yl0w9z.bkt.clouddn.com/18-5-22/52973405.jpg)

```swift
let disposeBag = DisposeBag()
Observable.repeatElement("").take(3).subscribe(onNext: { 
print($0) 
}).addDisposableTo(disposeBag)
```

### generate
generate是创建一个可观察sequence，当初始化的条件为true的时候，他就会发出所对应的事件

```swift
Observable<Int>
    .generate(initialState: 1, condition: { $0 < 10 }, iterate: { $0 + 1 })
    .subscribe(onNext: { int in
        print("element:", int)
    })
    .disposed(by: bag)
```

打印结果：

```
element: 1 
element: 2 
element: 3 
element: 4 
element: 5 
element: 6 
element: 7 
element: 8 
element: 9 
```

### deferred

deferred会为每一为订阅者observer创建一个新的可观察序列

![](http://og1yl0w9z.bkt.clouddn.com/18-5-22/5096719.jpg)

下面例子中每次进行subscribe的时候都会去创建一个新的deferredSequence，所以Emitting会打印两遍。

```swift
let disposeBag = DisposeBag()
var count = 1
let deferredSequence = Observable.deferred {
		print("Creating \(count)")
		count += 1
		return Observable.create { observer in
		print("Emitting...")
		observer.onNext("")
		observer.onNext("")
		observer.onNext("")
		return Disposables.create()
		}
}
deferredSequence.subscribe(onNext: { print($0) }).addDisposableTo(disposeBag)
deferredSequence.subscribe(onNext: { print($0) }).addDisposableTo(disposeBag)
```

运行结果：

```
Creating 1
Emitting...

Creating 2
Emitting...
```

### error
创建一个可观察序列，但不发出任何正常的事件，只发出error事件并结束

```
let disposeBag = DisposeBag()
Observable.error(TestError.test).subscribe { 
		print($0) 
}.addDisposableTo(disposeBag)
```

运行结果：

```
error(test)
```

### doOn

doOn我感觉就是在直接onNext处理时候，先执行某个方法，doOnNext( :)方法就是在subscribe(onNext:)前调用，doOnCompleted(:)就是在subscribe(onCompleted:)前面调用的。

```
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
}).addDisposableTo(disposeBag)
```

运行结果：

```
Intercepted: 
Intercepted: 
Intercepted: 
Intercepted: 
Completed
结束
```

## 学会使用Subjects
Subjet是observable和Observer之间的桥梁，一个Subject既是一个Obserable也是一个Observer，他既可以发出事件，也可以监听事件。

未完，码不动了..


