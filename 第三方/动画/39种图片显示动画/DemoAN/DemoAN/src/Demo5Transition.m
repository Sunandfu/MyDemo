

#import "Demo5Transition.h"

@implementation Demo5Transition

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
	
	vertices[6] = 2.0/TOTAL;
	vertices[7] = -1.5;
	vertices[8] = 0.0;
	
	vertices[9] = 2.0/TOTAL;
	vertices[10] = 1.5;
	vertices[11] = 0.0;
	
	for (int i = 0;i<TOTAL;i++) 
	{
		texcoords[i*8] = (i*1.0)/(TOTAL * 1.0);
		texcoords[i*8 + 1] = 0.0;
		
		texcoords[i*8 + 2] = (i*1.0)/(TOTAL * 1.0);
		texcoords[i*8 + 3] = 1.0;
		
		texcoords[i*8 + 4] = ((i+1)*1.0)/(TOTAL * 1.0);
		texcoords[i*8 + 5] = 1.0;
		
		texcoords[i*8 + 6] = ((i+1)*1.0)/(TOTAL * 1.0);
		texcoords[i*8 + 7] = 0.0;
	}
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
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	
	glDisable(GL_VERTEX_ARRAY);
	glDisable(GL_TEXTURE_COORD_ARRAY);
	glPopMatrix();
	
	//绘制百叶窗
	//f = M_PI/4.0;
	glBindTexture(GL_TEXTURE_2D, textureFromView);
	for (int i = 0;i<TOTAL;i++)
	{
		glPushMatrix();
		
		glTranslatef(-1+i*2.0/TOTAL, 0, -4);
		glRotatef(-f,0.0,1.0,0.0);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		
		
		glVertexPointer(3, GL_FLOAT, 0, &vertices[0]);
		glTexCoordPointer(2, GL_FLOAT, 0, &texcoords[i*8]);
		
		glPolygonOffset(0, -1);
		glEnable(GL_POLYGON_OFFSET_FILL);
		
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		
		glDisable(GL_VERTEX_ARRAY);
		glDisable(GL_TEXTURE_COORD_ARRAY);
		glDisable(GL_POLYGON_OFFSET_FILL);
		
		glPopMatrix();
	}
	f += 90.0/160.0;
    return f < 90;
}

- (void)transitionEnded
{
}

@end
