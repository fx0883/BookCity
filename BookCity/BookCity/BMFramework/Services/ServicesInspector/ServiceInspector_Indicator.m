

//#import "ServiceInspector.h"
#import "ServiceInspector_Indicator.h"
#import "BMContext.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#if (__ON__ == __BEE_DEVELOPMENT__)

#pragma mark -

@implementation ServiceInspector_Indicator

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self )
	{
		self.backgroundColor = [UIColor clearColor];
		self.userInteractionEnabled = NO;
		self.contentMode = UIViewContentModeCenter;
//		self.image = [SharedBMContext.bundle image:@"tap.png"];
//        
//        NSString *	path = [NSString stringWithFormat:@"%@/%@-568h@2x.%@", self.resourcePath, fullName, extension];
//		NSString *	path2 = [NSString stringWithFormat:@"%@/%@-568h.%@", self.resourcePath, fullName, extension];
//		
//		image = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
//		if ( nil == image )
//		{
//			image = [[[UIImage alloc] initWithContentsOfFile:path2] autorelease];
//		}
        
        NSString *pPathImage = [SharedBMContext.bundle pathForResource:@"tap@2x" ofType:@"png"];
        self.image =[[UIImage alloc] initWithContentsOfFile:pPathImage];
	}
	return self;
}

- (void)startAnimation
{
	self.alpha = 1.0f;
	self.transform = CGAffineTransformMakeScale( 0.5f, 0.5f );

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDuration:0.6f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(didAppearingAnimationStopped)];
	
	self.alpha = 0.0f;
	self.transform = CGAffineTransformIdentity;
	
	[UIView commitAnimations];
}

- (void)didAppearingAnimationStopped
{
	[self removeFromSuperview];
}

- (void)dealloc
{

}

@end

#endif	// #if (__ON__ == __BEE_DEVELOPMENT__)
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
