
#import "EPGLTransitionView.h"
#define TOTAL1 1
//横向百叶窗
//
// TBD
//

@interface Demo6Transition : NSObject<EPGLTransitionViewDelegate> {
    float f;
	
	GLfloat vertices[12];
	
	GLfloat texcoords[TOTAL1 * 8];
}

@end
