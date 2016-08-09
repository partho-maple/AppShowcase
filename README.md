# AppShowcase (Objective-C)

Ever wanted a way of easily showing all your iOS applications to your app users ? AppShowcase does just that and helps you gain the attention you need to gain more app downloads. AppShowcase allows you to cross promote your iOS applications in all of your iOS applications.



##Features:

- [x] Supports the latest App Store API – No need to host any app images, info, data…. All data is downloaded live from Apple.
- [x] AppGallery can only show apps from developer accounts which are live on the App Store. If you are new developer and are still waiting for your first app to go live on the App Store, then AppGallery will only work once your first app has gone live.
- [x] AppGallery can be imported and used in any Storyboard or XIB based iOS application.
- [x] Super easy to implement into your new or existing iOS applications. 
- [x] Universal support: Supports iPhone, iPad and iPod Touch devices.
- [x] Social app sharing: Includes support for sharing via Facebook, Twitter and Email.
- [x] Works with iOS 8 and higher.
- [x] Easy to customise to your app design needs.
- [x] Gain more app downloads!


##Screenshot:

![MainScene](/Screenshot/MainScene.png?raw=true)  
![DetailScene](/Screenshot/DetailScene.png?raw=true)
![DetailScene02](/Screenshot/DetailScene.png?raw=true)


## Requirements

- iOS 8.0+ 
- Xcode 7+
- Swift 2.2+


## Usage

### Step One

- Import the following frameworks into your project
![Frameworks](/Screenshot/Frameworks.tiff?raw=true)

- The next thing you will need to do, is to import the AppShowcase code, UI and image files into your new or existing Xcode project. Open the AppShowcase folder and you will 'AppShowcase Files'. Import that folder into your project. Once you have imported the 'AppShowcase Files', you will need to import the required images into your “Images.xcassets” directory. folders must be imported into your Xcode project otherwise AppGallery will not function.
![Assets](/Screenshot/Assets.tiff?raw=true)


### Step Two

- AppShowcase downloads all its data directly from the App Store. So the next thing you will need to do is to set your developer name so that AppShowcase knows which applications to show. 

Open the ‘AppShowcaseView.h’ file.

- Edit the line of code called ‘DEV_NAME’ and replace ‘parthobiswas’ with your developer name.

```objective-c

// Replace 'parthobiswas' with your developer name. make sure your
// developer name is typed like the above with no spaces or capital letters.
#define DEV_NAME @"parthobiswas"

```

- The next thing you will need to do is to add a button/action/method/etc in your application which will open the AppGallery view.
Some developers like to add a ‘more apps’ button in the info page section of there apps. This is up to you. For the purposes of this
tutorial, we will be opening the AppGallery view with a simple IBAction like so:

```objective-c

-(IBAction)open_gallery {

    UIStoryboard *gallery = [UIStoryboard storyboardWithName:@"AppShowcase" bundle:nil];
    AppShowcaseView *view = [gallery instantiateInitialViewController];
    [self presentViewController:view animated:YES completion:nil];
}

```





