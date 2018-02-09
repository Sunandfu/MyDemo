

#import "EPGLTransitionView.h"
#define TOTAL1 1
//横向百叶窗
//
// TBD
//

@interface Demo7Transition : NSObject<EPGLTransitionViewDelegate> {
    float f;
	
	GLfloat vertices[12];
	
	GLfloat texcoords[8];
	
	GLuint woodTexture;

}
void fcos(CGFloat x1,CGFloat y1,CGFloat z1,CGFloat x2,CGFloat y2,CGFloat z2,CGFloat x3,CGFloat y3,CGFloat z3,CGFloat *nomal1);
@end
