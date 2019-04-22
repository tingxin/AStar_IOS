# Find path on image with A-Star algorithm
you can get more detail about a-star algothm form 
http://www.gamedev.net/page/resources/_/technical/artificial-intelligence/a-pathfinding-for-beginners-r2003

# How to use
1.Tap on the screen at some place to create the start point

2.Tap on the Screen again at some place to create the end point

3.Press "search" button

# use yourself map
you can use you map to replace the defaule map. it is better to use simple color map.
you need make sure that the layout size of the image-map in view is the real size of image and make the
simple drawing view has the same size as the image-map. please also make the simple drawing view cover 
the image map just right.

use yourself wall color to instead of the demo wall color
  
    self.pathFinder=[[TXPathFinder alloc] initWithMap:self.imgMap.image wallColor:[UIColor redColor]];





