<p align="left">

<img src="https://raw.githubusercontent.com/Cookiezby/YiIndex/master/images/logo@2x.png" alt="YiIndex" title="YiIndex" width="370"/>

</p>

A new way for searching chinese name in addressbook, using the pinyin of the name to generate the index, and then you can search the name without typing any word.

<img src="sample.gif" width="300" height="533" />


## Usage

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    // names: your name in addressbook
    let yiView = YiView(frame: view.bounds, names: names, level:2)
    view.addSubview(yiView)
}
```

## License

YiIndex is released under the MIT license. See LICENSE for details.
