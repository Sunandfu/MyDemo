

#import "FlipTransitions.h"

@implementation FlipForward

- (void)setupTransition
{
  // Setup matrices
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glRotatef(90, 0, 0, -1);
  glFrustumf(-0.1, 0.1, -0.1333, 0.1333, 0.4, 100.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();    
  glEnable(GL_CULL_FACE);
  f = 0;
}

// GL context is active and screen texture bound to be used
- (BOOL)drawTransitionFrameWithTextureFrom:(GLuint)textureFromView 
                                 textureTo:(GLuint)textureToView
{
  GLfloat vertices[] = {
    -1, -1.3333,
		0, -1.3333,
    -1,  1.3333,
		0,  1.3333,
		0, -1.3333,
		1, -1.3333,
		0,  1.3333,
		1,  1.3333,
  };
  
  GLfloat texcoords[] = {
    0.0, 1,
    0.5, 1,
    0.0, 0,
    0.5, 0,
    0.5, 1,
    1.0, 1,
    0.5, 0,
    1.0, 0,
  };
  
  glVertexPointer(2, GL_FLOAT, 0, vertices);
  glEnableClientState(GL_VERTEX_ARRAY);
  glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
  float v = -(-cos(f)+1.0)/2.0; // For a little ease-in-ease-out
  
	glColor4f(1+v/2.0, 1+v/2.0, 1+v/2.0, 1.0);
  glPushMatrix();
  glTranslatef(0, 0, -4);
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  glPushMatrix();
  glRotatef(v*180.0, 0, 1, 0);
  glPolygonOffset(0, -1);
  glEnable(GL_POLYGON_OFFSET_FILL);
  glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
  glDisable(GL_POLYGON_OFFSET_FILL);
  glRotatef(180.0, 0, 1, 0);
	glColor4f(0.5-v/2.0, 0.5-v/2.0, 0.5-v/2.0, 1.0);
  glBindTexture(GL_TEXTURE_2D, textureToView);
  glPolygonOffset(0, -1);
  glEnable(GL_POLYGON_OFFSET_FILL);
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  glDisable(GL_POLYGON_OFFSET_FILL);
  glPopMatrix();
  glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
  glPopMatrix();
	
  f += M_PI/20.0;
  
  return f < M_PI;
}

- (void)transitionEnded
{
}

@end

@implementation FlipBackward

- (void)setupTransition
{
  // Setup matrices
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glRotatef(90, 0, 0, -1);
  glFrustumf(-0.1, 0.1, -0.1333, 0.1333, 0.4, 100.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();    
  glEnable(GL_CULL_FACE);
  f = 0;
}

// GL context is active and screen texture bound to be used
- (BOOL)drawTransitionFrameWithTextureFrom:(GLuint)textureFromView 
                                 textureTo:(GLuint)textureToView
{
  GLfloat vertices[] = {
    -1, -1.3333,
		0, -1.3333,
    -1,  1.3333,
		0,  1.3333,
		0, -1.3333,
		1, -1.3333,
		0,  1.3333,
		1,  1.3333,
  };
  
  GLfloat texcoords[] = {
    0.0, 1,
    0.5, 1,
    0.0, 0,
    0.5, 0,
    0.5, 1,
    1.0, 1,
    0.5, 0,
    1.0, 0,
  };
  
  glVertexPointer(2, GL_FLOAT, 0, vertices);
  glEnableClientState(GL_VERTEX_ARRAY);
  glTexCoordPointer(2, GL_FLOAT, 0, texcoords);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
  float v = -(-cos(f)+1.0)/2.0; // For a little ease-in-ease-out
  
	glColor4f(0.5-v/2.0, 0.5-v/2.0, 0.5-v/2.0, 1.0);
  glBindTexture(GL_TEXTURE_2D, textureToView);
  glPushMatrix();
  glTranslatef(0, 0, -4);
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  glPushMatrix();
  glRotatef(180-v*180.0, 0, 1, 0);
  glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
  glRotatef(180.0, 0, 1, 0);
	glColor4f(1+v/2.0, 1+v/2.0, 1+v/2.0, 1.0);
  glBindTexture(GL_TEXTURE_2D, textureFromView);
  glPolygonOffset(0, -1);
  glEnable(GL_POLYGON_OFFSET_FILL);
  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  glDisable(GL_POLYGON_OFFSET_FILL);
  glPopMatrix();
  glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
  glPopMatrix();
	
  f += M_PI/20.0;
  
  return f < M_PI;
}

- (void)transitionEnded
{
}

@end
