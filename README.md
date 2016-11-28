# SwiftUIScrollView.etc

##### 个人链接

* [个人博客](https://nslog-yuhaitao.github.io ) : 个人博客主页
* [iOS频道(iOSPD)](http://www.jianshu.com/collection/d76ac79331c6): 这是我个人整理的一个技术专题, 这里的文章都是比较有技术含量(不断更新)!
* 微信公众号 : 
  
<img src="http://upload-images.jianshu.io/upload_images/2248913-22bc242c26133c62.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" width = "200" height = "200" alt="微信公众号" align= "center" />

##### 功能部分:</br>

* 前言:图片轮播器在很多应用软件中都有应用,需要制作无限滚动的 ,下面贴上自己写的小Demo,能实现相关的功能。比如:实现轮播图滚动,图片点击放大,定时器暂停和继续等功能!
* 好了,直接看效果图吧:


![效果图](http://upload-images.jianshu.io/upload_images/2248913-476127e343ecf1a6.gif?imageMogr2/auto-orient/strip)



* 文章详细地址:[http://www.jianshu.com/p/170d66eaa5fd](http://www.jianshu.com/p/170d66eaa5fd)
* 敬请关注,代码将持续更新...

###### 一.创建scrollView
~~~
    func createScrollView() -> Void {
        scrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: SCRRENW, height: 200))//初始化
        scrollView.contentSize = CGSize.init(width:CGFloat(dataArr.count) * SCRRENW, height: 0)//滚动的大小
        scrollView.backgroundColor = UIColor.white//背景色
        scrollView.showsHorizontalScrollIndicator = false//去除水平滚动条
        scrollView.isPagingEnabled = true//单页
        scrollView.delegate = self//代理方法
        self.view.addSubview(scrollView)//添加到主视图上
        
        let sheight : CGFloat = scrollView.frame.size.height
        let sorigin : CGFloat = scrollView.frame.origin.y
        
        //初始化点控制
        page = UIPageControl.init(frame: CGRect.init(x:SCRRENW/2 - 50, y: sorigin + sheight - 20 , width: 100, height: 15))
        page.numberOfPages = dataArr.count//点控制数量
        page.currentPage = 0//当前所在页面
        page.pageIndicatorTintColor = UIColor.red//未选中颜色
        page.currentPageIndicatorTintColor = UIColor.green//当前选中颜色
        self.view.addSubview(page)//添加到主视图
    }
~~~

###### 二.创建时间控制器
~~~
    func addTimer() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerEvent), userInfo: nil, repeats: true)
        //多线程 UI IOS程序默认只有一个主线程，处理UI的只有主线程。如果拖动第二个UI，则第一个UI事件则会失效。
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
~~~

###### 三.滚动时所触发的方法
~~~
   //MARK: 实现轮播图首尾相连的显示
    func timerEvent() -> Void {
        let index : Int = Int (scrollView.contentOffset.x/SCRRENW)
        //print(index)
        if index >= 3 {
            page.currentPage = 0
            scrollView.contentOffset = CGPoint.init(x: 0, y: 0)
        }else{
            page.currentPage = index + 1
            scrollView.contentOffset = CGPoint.init(x: CGFloat(CGFloat(index+1)*SCRRENW), y: 0)
        }
    }
    
    //MARK: 实现UIScrollView代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let index : Int = Int (scrollView.contentOffset.x/SCRRENW)
        page.currentPage = index
    }
~~~