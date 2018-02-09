

#import "EPGLTransitionView.h"
//碎纸
//
// This is a demo transition that breaks the screen in 4x6 squares that
// falls down off the screen.
//

// Enable this macro to enable the usage of a transition to bring in the new view
//#define ENABLE_PHASE_IN

@interface DemoTransition : NSObject<EPGLTransitionViewDelegate> {
    // 4x6 part, 4 vertex 2 coords
    GLfloat vertices[4][6][4][2];
    GLfloat texcoords[4][6][4][2];
    float yOut[4][6];
    float dyOut[4][6];
#ifdef ENABLE_PHASE_IN
    float yIn[4][6];
#endif
}

@end
