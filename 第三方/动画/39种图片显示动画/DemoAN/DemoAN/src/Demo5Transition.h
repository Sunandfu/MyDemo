

#import "EPGLTransitionView.h"
#define TOTAL 6
//横向百叶窗
//
// TBD
//

@interface Demo5Transition : NSObject<EPGLTransitionViewDelegate> {
    float f;
	
	GLfloat vertices[12];
	
	GLfloat texcoords[TOTAL * 18];
}

@end
