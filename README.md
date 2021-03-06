SYGallery
=========

Pictures gallery to mimic iPhone app, allowing you to create a gallery grid, and a full picture view. Both are implemented as `UIView*`s to you will be able to display them and embed them anywhere.

The library is still under development to fix some memory management issues and slowness on old iPhone models.

Deprecated
==========

This is very easy to recreate using UICollectionView and depending on your needs iOS 8+ PhotosKit framework or SDWebImage.

As such this library is deprecated and will no longer be maintained. 

Read the code, share it, update it, fork it, it's all yours now. 

Please do not open an issue.


Features
========

### SYGalleryDataSource

Image sizes: 

- full size
- thumbnail

Image sources (possible to use all of them in a single gallery): 

- image data as `UIImage*`
- local image path as `NSString*`
- distant image as `NSString*`
- text as `NSString*`

`UITableView`-like delegate system

Section titles


### SYGalleryAppearence

#### Global settings
Thumbnails:

- sizes
- spacing


#### Per item settings
Text:

- color
- font

Spinner (activity indicator): enable/disable

Thumbnails:

- border color
- border size
- background color


### SYGalleryThumbViewActions

	- (void)gallery:(id<SYGalleryView>)gallery didTapOnItemAtIndexPath:(NSIndexPath*)indexPath;
	- (void)gallery:(id<SYGalleryView>)gallery changedEditStateTo:(BOOL)edit;

### SYGalleryFullViewActions

	- (void)gallery:(id<SYGalleryView>)gallery showedUpPictureAtIndexPath:(NSIndexPath*)indexPath;


ScreenShots
===========

<img src="https://github.com/dvkch/SYGallery/blob/master/Screenshots/Screenshot0.png?raw=true" style="width: 200px;"/>
<img src="https://github.com/dvkch/SYGallery/blob/master/Screenshots/Screenshot1.png?raw=true" style="width: 200px;"/>
<img src="https://github.com/dvkch/SYGallery/blob/master/Screenshots/Screenshot2.png?raw=true" style="width: 200px;"/>
<img src="https://github.com/dvkch/SYGallery/blob/master/Screenshots/Screenshot3.png?raw=true" style="width: 200px;"/>
<img src="https://github.com/dvkch/SYGallery/blob/master/Screenshots/Screenshot4.png?raw=true" style="width: 200px;"/>

License
=======

Free to use and redistribute, use at your own risk, and send me a postcard if you like it!