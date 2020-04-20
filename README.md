# LFDeveloperKit
Developer Kits for app testing or adjustment written in pure Objective-C
由Objective-C编写的iOSAPP开发者工具合集

# Features

## 1. Developer identities manager | 开发者身份管理

Add developer identity to your app, with custom identifier, make these account expose more debug info.
方便开发者储存开发者身份的管理器,使用归档的方式储存开发者对象,可以配合一定的判断逻辑授予一些用户开发者权限,方便进行调试

## 2. Object description | 实例对象描述输出

Log object's method, properties & ivars
可以输出实例对象的方法,属性和成员变量

## 3. Re-enclosure of the runtime method swizzles | 对runtime方法调换的再封装

Swizzle methods more smoothly
用更简便的语法实现全局方法替换

## 4. customizable CrashHook | 可自定义的防崩溃

work with developer identities manager, decide which crash you'd like to hook, ie: NSArray, NSString, NSDictionary, out put crash logs for you to operate
需要和开发者身份管理一起使用,可设置字符串,数组和字典防崩溃,同时输出崩溃信息.

## 5. DeallocCallBack | 实例释放回调

Use block as callBack instead of implement dealloc method when object was freed.
用Block语法来实现实例释放回调而不需要重新实现dealloc方法

## 6. ObjectHook | 针对实例的方法调换

Instance based method swizzle, only works on one object instead of all hooked objects in one class
可以针对一个实例进行方法调换,而不是针对整个类的所有对象.

## 7. BlockBasedKVOCallBack | 通过Block来执行KVO回调

Use block based kvo call back instead of observe value for keypath method
可以通过Block简单地对实例属性进行KVO观察.