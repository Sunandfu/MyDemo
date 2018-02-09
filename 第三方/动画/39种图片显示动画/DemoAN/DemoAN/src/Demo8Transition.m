

#import "Demo8Transition.h"

@implementation Demo8Transition

- (void)setupTransition
{
    // Setup matrices
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustumf(-0.1, 0.1, -0.15, 0.15, 0.4, 100.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();    
    glEnable(GL_CULL_FACE);
    f = 0;
	
	vertices[0] = 0.0;
	vertices[1] = 1.5;
	vertices[2] = 0.0;	
	vertices[3] = 0.0;
	vertices[4] = -1.5;
	vertices[5] = 0.0;	
	vertices[6] = 1.0;
	vertices[7] = -1.5;
	vertices[8] = 0.0;	
	vertices[9] = 1.0;
	vertices[10] = 1.5;
	vertices[11] = 0.0;
	
	
	vertices[12] = 0.0-1.0;
	vertices[13] = 1.5;
	vertices[14] = 0.0;	
	vertices[15] = 0.0-1.0;
	vertices[16] = -1.5;
	vertices[17] = 0.0;	
	vertices[18] = 1.0-1.0;
	vertices[19] = -1.5;
	vertices[20] = 0.0;	
	vertices[21] = 1.0-1.0;
	vertices[22] = 1.5;
	vertices[23] = 0.0;
	
	texcoords[0] = 0.0;
	texcoords[1] = 0.0;
	
	texcoords[2] = 0.0;
	texcoords[3] = 1.0;
	
	texcoords[4] = 0.5;
	texcoords[5] = 1.0;
	
	texcoords[6] = 0.5;
	texcoords[7] = 0.0;
	
	
	texcoords[8] = 0.5;
	texcoords[9] = 0.0;
	
	texcoords[10] = 0.5;
	texcoords[11] = 1.0;
	
	texcoords[12] = 1.0;
	texcoords[13] = 1.0;
	
	texcoords[14] = 1.0;
	texcoords[15] = 0.0;
}

// GL context is active and screen texture bound to be used
- (BOOL)drawTransitionFrameWithTextureFrom:(GLuint)textureFromView 
                                 textureTo:(GLuint)textureToView
{

	CGFloat frmoviewver[] =
	{
		-1.0,1.5,0.0,
		-1.0,-1.5,0.0,
		1.0,-1.5,0.0,
		1.0,1.5,0.0,
	};
	CGFloat texver[] =
	{
		0.0,0.0,
		0.0,1.0,
		1.0,1.0,
		1.0,0.0,
	};
	glMatrixMode(GL_MODELVIEW);
	//绘制底层
	glPushMatrix();
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glBindTexture(GL_TEXTURE_2D, textureToView);
	
	glVertexPointer(3, GL_FLOAT, 0, frmoviewver);
	glTexCoordPointer(2, GL_FLOAT, 0, texver);
	
	glTranslatef(0, 0, -4);
	glColor4f(1.0,1.0,1.0,1.0);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	
	glDisable(GL_VERTEX_ARRAY);
	glDisable(GL_TEXTURE_COORD_ARRAY);
	glPopMatrix();
	
	//绘制百叶窗
	//f = M_PI/4.0;
	glBindTexture(GL_TEXTURE_2D, textureFromView);
	glColor4f(0.6,0.6,0.6,1.0);
	
		glPushMatrix();
		
		glTranslatef(0.0, 0.0, -4);
		glTranslatef(-1.0, 0.0, 0);
		glRotatef(-f,0.0,1.0,0.0);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		
		glVertexPointer(3, GL_FLOAT, 0, &vertices[0]);
		glTexCoordPointer(2, GL_FLOAT, 0, &texcoords[0]);
		
		glPolygonOffset(0, -1);
		glEnable(GL_POLYGON_OFFSET_FILL);
		
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		
		glDisable(GL_VERTEX_ARRAY);
		glDisable(GL_TEXTURE_COORD_ARRAY);
		glDisable(GL_POLYGON_OFFSET_FILL);
		
		glPopMatrix();
	
	
	glPushMatrix();
	
	glTranslatef(0.0, 0.0, -4);
	glTranslatef(1.0, 0.0, 0.0);
	glRotatef(f,0.0,1.0,0.0);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	
	glVertexPointer(3, GL_FLOAT, 0, &vertices[12]);
	glTexCoordPointer(2, GL_FLOAT, 0, &texcoords[8]);
	
	glPolygonOffset(0, -1);
	glEnable(GL_POLYGON_OFFSET_FILL);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glDisable(GL_VERTEX_ARRAY);
	glDisable(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_POLYGON_OFFSET_FILL);
	
	glPopMatrix();
	
	f += 90.0/160.0;
    return f < 90;
}

- (void)transitionEnded
{
}

@end
