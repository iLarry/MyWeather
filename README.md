#懒人Weather

##这个App能做什么
这个App通过定位获得地理位置信息，从网络抓取了天气信息，让使用者了解当前气象信息

##使用的第三方库
1. Alamofire	
2. SwiftyJSON	

##在制作这个APP的时候做了点什么
1. 使用类对抓取的气象信息进行封装
2. 进行了地理位置编码，第一步获取地理位置的经纬度，第二对对获得的经纬度进行地理位置信息反编码，获得省名和城市名
3. 使用Alamofire进行网络操作
4. 使用SwiftyJSON对网络操作返回的数据进行处理
5. 使用GCD进行UI的更新(在主线程)