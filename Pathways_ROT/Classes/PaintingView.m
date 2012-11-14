
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <ImageIO/ImageIO.h>

#import "PathwaysAppDelegate.h"

#import "PaintingView.h"
#import "Brush.h"

#define DEGREES_TO_RADIANS(x)(M_PI * x / 180.0)

static CGImageRef brushImage =nil;

@interface PaintingView (private)

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@implementation PaintingView

@synthesize undoManager,BrushOpacity;
@synthesize  location;
@synthesize  previousLocation;
@synthesize viewController;
@synthesize context;
@synthesize  brush;
@synthesize previousTimeStamp;
@synthesize currentTimeStamp;

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

+(void)initialize
{
	brushImage = [UIImage imageNamed:@"Particle_copy.png"].CGImage;
}

- (void)createGLTexture:(GLuint *)texName fromCGImage:(CGImageRef)img
{
	GLubyte *spriteData = NULL;
	CGContextRef spriteContext;
	GLuint imgW, imgH, texW, texH;
	
	imgW = CGImageGetWidth(img);
	imgH = CGImageGetHeight(img);
	
	// Find smallest possible powers of 2 for our texture dimensions
	for (texW = 1; texW < imgW; texW *= 2) ;
	for (texH = 1; texH < imgH; texH *= 2) ;
	
	// Allocated memory needed for the bitmap context
	spriteData = (GLubyte *) calloc(texH, texW * 4);
	// Uses the bitmatp creation function provided by the Core Graphics framework. 
	spriteContext = CGBitmapContextCreate(spriteData, texW, texH, 8, texW * 4, CGImageGetColorSpace(img), kCGImageAlphaPremultipliedLast);
	
	// Translate and scale the context to draw the image upside-down (conflict in flipped-ness between GL textures and CG contexts)
	CGContextTranslateCTM(spriteContext, 0., texH);
	CGContextScaleCTM(spriteContext, 1., -1.);
		
	CGFloat flt=BrushOpacity/10;
	CGContextSetAlpha(spriteContext,flt);
	// After you create the context, you can draw the sprite image to the context.
	CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, imgW, imgH), img);
	// You don't need the context at this point, so you need to release it to avoid memory leaks.
	CGContextRelease(spriteContext);
	
	// Use OpenGL ES to generate a name for the texture.
	glGenTextures(2, texName);
	// Bind the texture name. 
	glBindTexture(GL_TEXTURE_2D, *texName);
	// Speidfy a 2D texture image, provideing the a pointer to the image data in memory
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, texW, texH, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
	// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	
	// Enable use of the texture
	glEnable(GL_TEXTURE_2D);
	// Set a blending function to use
	glBlendFunc(GL_SRC_ALPHA,GL_ONE);
	//glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	// Enable blending
	glEnable(GL_BLEND);
	
	free(spriteData);
}

-(void)loadComponents{
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	
	eaglLayer.opaque = YES;
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
	
	if (!context)
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	
	if (!context || ![EAGLContext setCurrentContext:context]) {
		[self release];
		return ;
	}
	
	[self loadTextual];
	
	GLuint width, height;
	
	width = CGImageGetWidth(brushImage);
	height = CGImageGetHeight(brushImage);
	
	// Set the view's scale factor
	self.contentScaleFactor = 1.0;
	
	// Setup OpenGL states
	glMatrixMode(GL_PROJECTION);
	CGRect frame = self.bounds;
	CGFloat scale = self.contentScaleFactor;
	// Setup the view port in Pixels
	glOrthof(0, frame.size.width * scale, 0, frame.size.height * scale, -1, 1);
	glViewport(0, 0, frame.size.width * scale, frame.size.height * scale);
	glMatrixMode(GL_MODELVIEW);
	
	glDisable(GL_DITHER);
	
	// Set a Vertix Mode type
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	// Set a blending function appropriate for premultiplied alpha pixel data
	glEnable(GL_BLEND);
	//glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glBlendFunc(GL_DST_COLOR, GL_ONE_MINUS_SRC_ALPHA); 
	
	glEnable(GL_POINT_SPRITE_OES);
	glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
	
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_COMBINE);
	glTexEnvi(GL_TEXTURE_ENV, GL_OPERAND0_RGB, GL_SRC_ALPHA);
	
	glPointSize(width / kBrushScale);
	
	self.backgroundColor = [UIColor clearColor];
}

-(void)loadTextual
{
	[self createGLTexture:&bgTexture fromCGImage:brushImage];
}

- (id)initWithFrame:(CGRect)frame {
	
    self = [super initWithFrame:frame];
	
    if (self)
	{
		BrushOpacity = .4;
		[self loadComponents];
	}
	return self;
}
- (id)initWithCoder:(NSCoder*)coder {
	
    self = [super initWithCoder:coder];
    
	if (self)
	{
		BrushOpacity = .4;
		[self loadComponents];
	}
	return self;
}

-(void)layoutSubviews
{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	
}

- (BOOL)createFramebuffer
{
	
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	// This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	// allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	
	// For this sample, we also need a depth buffer, so we'll create and attach one via another renderbuffer.
	glGenRenderbuffersOES(2, &depthRenderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
	glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	
	
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}

// Clean up any buffers we have allocated.
- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}
- (void) dealloc
{
	if([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	
	[context release];
	[super dealloc];
}
- (void) erase
{
	[EAGLContext setCurrentContext:context];

	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glClearColor(0.0, 0.0, 0.0, 0.0);
	glClear(GL_COLOR_BUFFER_BIT);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

-(IBAction)setBrush:(Brush*)aBrush
{
	if (aBrush != nil) {
		brush = aBrush;		
	}
	
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	
	const CGFloat *components = CGColorGetComponents(brush.brushColor.CGColor);
	glColor4f(components[0]	* kBrushOpacity, components[1] * kBrushOpacity,  components[2]	* kBrushOpacity,  components[3]*kBrushOpacity);
	
	glClearColor(0,0,0,0);
	
	GLuint width;
	width = CGImageGetWidth(brushImage);
	
	glPointSize((width/ kBrushScale)*[brush.brushSize intValue]/4);
}

void drawSmoothLine(CGPoint *pos1, CGPoint *pos2, float width)
{
    GLfloat lineVertices[12], curc[4]; 
    GLint   ir, ig, ib, ia;
    CGPoint dir, tan;
    
    dir.x = pos2->x - pos1->x;
    dir.y = pos2->y - pos1->y;
    float len = sqrtf(dir.x*dir.x+dir.y*dir.y);
    if(len<0.00001)
        return;
    dir.x = dir.x/len;
    dir.y = dir.y/len;
    tan.x = -width*dir.y;
    tan.y = width*dir.x;
    
    lineVertices[0] = pos1->x + tan.x;
    lineVertices[1] = pos1->y + tan.y;
    lineVertices[2] = pos2->x + tan.x;
    lineVertices[3] = pos2->y + tan.y;
    lineVertices[4] = pos1->x;
    lineVertices[5] = pos1->y;
    lineVertices[6] = pos2->x;
    lineVertices[7] = pos2->y;
    lineVertices[8] = pos1->x - tan.x;
    lineVertices[9] = pos1->y - tan.y;
    lineVertices[10] = pos2->x - tan.x;
    lineVertices[11] = pos2->y - tan.y;
    
    glGetFloatv(GL_CURRENT_COLOR, curc);
    ir = 255.0*curc[0];
    ig = 255.0*curc[1];
    ib = 255.0*curc[2];
    ia = 255.0*curc[3];
    const GLubyte lineColors[] = {
        ir, ig, ib, 0,
        ir, ig, ib, 0,
        ir, ig, ib, ia,
        ir, ig, ib, ia,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
    };
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_COLOR_ARRAY);
    glVertexPointer(2, GL_FLOAT, 0, lineVertices);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, lineColors);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 6);
    glDisableClientState(GL_COLOR_ARRAY);
}

void drawSmoothPointAt(CGPoint *pos, float width)
{
    GLfloat pntVertices[2*6], curc[4]; 
    GLint   ir, ig, ib, ia;
    
    pntVertices[0] = pos->x;
    pntVertices[1] = pos->y;
    pntVertices[2] = pos->x - width;
    pntVertices[3] = pos->y - width;
    pntVertices[4] = pos->x - width;
    pntVertices[5] = pos->y + width;
    pntVertices[6] = pos->x + width;
    pntVertices[7] = pos->y + width;
    pntVertices[8] = pos->x + width;
    pntVertices[9] = pos->y - width;
    pntVertices[10] = pos->x - width;
    pntVertices[11] = pos->y - width;
    
    glGetFloatv(GL_CURRENT_COLOR, curc);
    ir = 255.0*curc[0];
    ig = 255.0*curc[1];
    ib = 255.0*curc[2];
    ia = 255.0*curc[3];
    const GLubyte pntColors[] = {
        ir, ig, ib, ia,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
        ir, ig, ib, 0,
    };
    
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, pntColors);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 6);
}

float findAngle(CGPoint pt1, CGPoint pt2)
{
	float angle = atan2(pt1.y - pt2.y, pt1.x - pt2.x) * (180 / M_PI);
	angle = angle < 0 ? angle + 360 : angle;
	
	return angle;
}

float findDistance(CGPoint start, CGPoint end)
{
	float dist = ceilf(sqrtf((end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)));
	
	return dist;
}

CGPoint findPoint(CGPoint pt, float angle, float distance)
{
	float x = distance * cos(angle * (M_PI/180));
	float y = distance * sin(angle * (M_PI/180));
	
	return CGPointMake(x, y);
}

CGPoint drawBezier(CGPoint origin, CGPoint control, CGPoint destination, int segments)
{
	CGPoint vertices[segments/2];
	CGPoint midPoint;
	glDisable(GL_TEXTURE_2D);
	float x, y;
	
	float t = 0.0;
	for(int i = 0; i < (segments/2); i++)
	{
		x = pow(1 - t, 2) * origin.x + 2.0 * (1 - t) * t * control.x + t * t * destination.x;
		y = pow(1 - t, 2) * origin.y + 2.0 * (1 - t) * t * control.y + t * t * destination.y;
		vertices[i] = CGPointMake(x, y);
		t += 1.0 / (segments);
		
	}
	//windowHeight is the height of you drawing canvas.
	midPoint = CGPointMake(x, y);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glDrawArrays(GL_POINTS, 0, segments/2);
	return midPoint;
}

void genCosineInterpolation(CGPoint *points, unsigned num, unsigned segments, CGPoint *vertices)
{
    float dt = 1.f/(float)segments;
    int count = 0;
	
    for (int i=0; i<(num-1); i++) {
        CGPoint y1, y2;
		
        y1 = points[i];
        y2 = points[i+1];
		
        vertices[count] = y1;
        count++;
		
        for (float mu=dt; mu<1.f; mu += dt) {
            float mu2 = (1-cos(mu*3.1459f))/2.f;
			
            vertices[count] = CGPointMake(y1.x*(1.f-mu2)+y2.x*mu2, y1.y*(1.f-mu2)+y2.y*mu2);
            count++;
        }
    }
	
    vertices[count] = points[num-1];
}

int q(unsigned $t,unsigned p0,unsigned p1,unsigned p2,unsigned p3)
{
	return ((2*p1 + (-p0+p2)*$t + (2*p0 - 5*p1 + 4*p2 - p3)*$t*$t + (-p0+3*p1-3*p2+p3)*$t*$t*$t))/2 ;
}

double secondDegreePoint(double s ,double m1 ,double m2 ,double e, double t)
{
    return  pow(1 - t, 2) * m1 + 2.0 * (1 - t) * t * m2 + t * t * e;
}

double thirdDegreePoint(double s ,double m1 ,double m2 ,double e, double t)
{
    return  pow(1 - t, 3) * s + 3.0 * pow(1 - t, 2) * t * m1 + 3.0 * (1 - t) * pow(t, 2) * m2 + pow(t, 3) * e;
}
float dt = 0.0;
double totalcount = 0;

- (void) renderLineFromPoint:(CGPoint)s midPoint:(CGPoint)m1 midPoint2:(CGPoint)m2 toPoint:(CGPoint)e
{
    totalcount++;
    [EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
    static CGPoint*		vertexBuffer = NULL;
	static NSUInteger	vertexMax = 64;
	NSUInteger			vertexCount = 0,
	count;
    
    CGFloat scale = self.contentScaleFactor;
	s.x *= scale;
	s.y *= scale;
	e.x *= scale;
	e.y *= scale;
    
    vertexCount = 0;
    
    srandom(1111);
    
    if(vertexBuffer == NULL)
		vertexBuffer = malloc(vertexMax * 2 * sizeof(CGPoint));
    
    count = MAX((findDistance(s, e) / kBrushPixelStep), 1);
        
    float t = dt;
    
    /*==============================Third Degree - Drawing=============================    */
	
    t = 0.0;
    
    for(int i = 0; i < count; ++i)
	{
        if(vertexCount == vertexMax)
		{
            vertexMax = 2 * vertexMax;
            vertexBuffer = realloc(vertexBuffer, vertexMax * 2 * sizeof(CGPoint));
        }
        
        float x = thirdDegreePoint(s.x, m1.x, m2.x, e.x,t);
        float y = thirdDegreePoint(s.y, m1.y, m2.y, e.y,t);
        
        vertexBuffer[vertexCount] =  CGPointMake(x, y);
        
        t += ((float)1.0/count);
        
        vertexCount++;
    }
    
    glVertexPointer(2, GL_FLOAT, 0, vertexBuffer);
    glDrawArrays(GL_POINTS, 0, vertexCount);
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
    
    dt += 0.001;
    
}
//////////////////TOOLBAR ACTIONS END///////////////////////


#pragma mark Touches hadling
CGFloat oldSpeed;
CGFloat lambda = 1;
int touchCount = 0;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	orgBrushOpacity = kMagic;
	dt = 0.0;
    
    CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
    
    firstTouch = YES;
    touchCount = 0;
    
    c= [touch locationInView:self];
    c.y = bounds.size.height - c.y;
    p1=p2=p3=c;

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	touchCount++;
    
    CGRect				bounds = [self bounds];
    UITouch*			touch = [[event touchesForView:self] anyObject];
    
    p3=p2;
    p2=p1;
    
    c = [touch locationInView:self];
    c.y = bounds.size.height - c.y;
    p1 = [touch previousLocationInView:self];
    p1.y = bounds.size.height - p1.y;
    
    dt = 0.0;
    
    if(touchCount >= 3)
	{
        [self renderLineFromPoint:p3 midPoint:p2 midPoint2:p1 toPoint:c];
    }
	
	CGFloat distanceFromPrevious = findDistance(location,previousLocation);
	
	totalDistance = totalDistance+distanceFromPrevious;
		
	NSTimeInterval timeSincePrevious = self.currentTimeStamp - self.previousTimeStamp;
	
	totalTime = totalTime+timeSincePrevious;

	CGFloat speed = totalDistance/totalTime;
	
	GLfloat speedtFactor = speed/3000;
	
	const CGFloat *components = CGColorGetComponents(brush.brushColor.CGColor);
	
	GLuint width = CGImageGetWidth(brushImage);
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
	GLfloat brushNormalColor = components[3]*kBrushOpacity;

	GLfloat alpha =  brushNormalColor;//MIN(speedtFactor*brushNormalColor, brushNormalColor);
	
	GLfloat brushNormalSize = (width/ kBrushScale)*[brush.brushSize intValue]/4;
	
	GLfloat pointSize = MIN(brushNormalSize*speedtFactor, brushNormalSize);

	orgBrushOpacity = orgBrushOpacity -.009;
	                                                                                                                                                                             
	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	
	glEnable(GL_POINT_SPRITE_OES);
	//glTexEnvf(GL_POINT_SPRITE_OES, GL_COORD_REPLACE_OES, GL_TRUE);
	glPointSize(pointSize);	
	
	glColor4f(components[0]	* kBrushOpacity, components[1] * kBrushOpacity,  components[2]	* kBrushOpacity, alpha );	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"END");
    dt = 0.0;
    
    p3=p2;
    p2=p1;
    
    CGRect				bounds = [self bounds];
    UITouch*	touch = [[event touchesForView:self] anyObject];
    
    c = [touch locationInView:self];
    c.y = bounds.size.height - c.y;
    p1 = [touch previousLocationInView:self];
    p1.y = bounds.size.height - p1.y;
	
	UIImage *hoverImage = [self snapUIImage];
	[self.viewController performSelector:@selector(saveSnapShot:) withObject:hoverImage];		
	[self erase];
}


-(UIImage*)snapUIImage
{
	PathwaysAppDelegate *appDelegate = (PathwaysAppDelegate*)[UIApplication sharedApplication].delegate;
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"GalleryPhoto"
                                              inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchResults = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
	
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
    NSInteger x = 0, y = 0, width = backingWidth, height = backingHeight;
    NSInteger dataLength = width * height * 4;
    GLubyte *data = (GLubyte*)malloc(dataLength * sizeof(GLubyte));
	
    // Read pixel data from the framebuffer
    glPixelStorei(GL_PACK_ALIGNMENT, 4);
    glReadPixels(x, y, width, height, GL_RGBA, GL_UNSIGNED_BYTE, data);
	
    // Create a CGImage with the pixel data
    // If your OpenGL ES content is opaque, use kCGImageAlphaNoneSkipLast to ignore the alpha channel
    // otherwise, use kCGImageAlphaPremultipliedLast
    CGDataProviderRef ref = CGDataProviderCreateWithData(NULL, data, dataLength, NULL);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef iref = CGImageCreate(width, height, 8, 32, width * 4, colorspace, kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast,ref, NULL, true, kCGRenderingIntentDefault);
	
    // OpenGL ES measures data in PIXELS
    // Create a graphics context with the target size measured in POINTS
    NSInteger widthInPoints, heightInPoints;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
	{
        // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
        // Set the scale parameter to your OpenGL ES view's contentScaleFactor
        // so that you get a high-resolution snapshot when its value is greater than 1.0
        CGFloat scale = self.contentScaleFactor;
        widthInPoints = width / scale;
        heightInPoints = height / scale;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(widthInPoints, heightInPoints), NO, scale);
    }
    else {
        // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
        widthInPoints = width;
        heightInPoints = height;
        UIGraphicsBeginImageContext(CGSizeMake(widthInPoints, heightInPoints));
    }
	
    CGContextRef cgcontext = UIGraphicsGetCurrentContext();
	
    // UIKit coordinate system is upside down to GL/Quartz coordinate system
    // Flip the CGImage by rendering it to the flipped bitmap context
    // The size of the destination area is measured in POINTS
    CGContextSetBlendMode(cgcontext, kCGBlendModeCopy);
    CGContextDrawImage(cgcontext, CGRectMake(0.0, 0.0, widthInPoints, heightInPoints), iref);
	
    // Retrieve the UIImage from the current context
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    // Clean up
    free(data);
    CFRelease(ref);
    CFRelease(colorspace);
    CGImageRelease(iref);
    return image;
}

@end
