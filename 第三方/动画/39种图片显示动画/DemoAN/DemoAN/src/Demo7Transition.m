

#import "Demo7Transition.h"

@implementation Demo7Transition

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
	
	vertices[0] = -1.0;
	vertices[1] = 1.5;
	vertices[2] = tan(30.0*M_PI/180.0);
	
	vertices[3] = -1.0;
	vertices[4] = -1.5;
	vertices[5] = tan(30.0*M_PI/180.0);
	
	vertices[6] = 1.0;
	vertices[7] = -1.5;
	vertices[8] = tan(30.0*M_PI/180.0);
	
	vertices[9] = 1.0;
	vertices[10] = 1.5;
	vertices[11] = tan(30.0*M_PI/180.0);

	texcoords[0] = 0.0;
	texcoords[1] = 0.0;
		
	texcoords[2] = 0.0;
	texcoords[3] = 1.0;
		
	texcoords[4] = 1.0;
	texcoords[5] = 1.0;
		
	texcoords[6] = 1.0;
	texcoords[7] = 0.0;
	
	
	
	CGImageRef woodImage;
    size_t width;
    size_t height;
    
    woodImage = [UIImage imageNamed:@"table.jpg"].CGImage;
	
    width = CGImageGetWidth(woodImage);
    height = CGImageGetHeight(woodImage);
    width = 512;
	height = 512;
    if (woodImage) {
        GLubyte *woodImageData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
        CGContextRef imageContext = CGBitmapContextCreate(woodImageData, 
                                                          width, 
                                                          height, 
                                                          8, 
                                                          width * 4, 
                                                          CGImageGetColorSpace(woodImage), 
                                                          kCGImageAlphaPremultipliedLast);
        CGContextDrawImage(imageContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), woodImage);
        CGContextRelease(imageContext);
        
        glGenTextures(1, &woodTexture);
        glBindTexture(GL_TEXTURE_2D, woodTexture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, woodImageData);
        free(woodImageData);        
    }
	
	
}

// GL context is active and screen texture bound to be used
- (BOOL)drawTransitionFrameWithTextureFrom:(GLuint)textureFromView 
                                 textureTo:(GLuint)textureToView
{
	
	CGFloat frmoviewver[] =
	{
		-1.0,1.5,tan(30.0*M_PI/180.0),
		-1.0,-1.5,tan(30.0*M_PI/180.0),
		1.0,-1.5,tan(30.0*M_PI/180.0),
		1.0,1.5,tan(30.0*M_PI/180.0),
	};
	 
	CGFloat frmoviewver1[] =
	{
		1.0,1.5,tan(30.0*M_PI/180.0),
		1.0,-1.5,tan(30.0*M_PI/180.0),
		0.0,-1.5,tan(30.0*M_PI/180.0)-sqrt(3),
		
		0.0,1.5,tan(30.0*M_PI/180.0)-sqrt(3),
		//0.0,-1.5,tan(30.0*M_PI/180.0)-sqrt(3),
		//1.0,-1.5,tan(30.0*M_PI/180.0),
		//1.0,1.5,tan(30.0*M_PI/180.0),
	};
	CGFloat texver[] =
	{
		0.0,0.0,
		0.0,1.0,
		1.0,1.0,
		1.0,0.0,
	};
	
	
	CGFloat topver[] =
	{
		-1.0,1.5,tan(30.0*M_PI/180.0),
		1.0,1.5,tan(30.0*M_PI/180.0),
		0.0,1.5,tan(30.0*M_PI/180.0)-sqrt(3),
	};
	CGFloat toptexver[] =
	{
		0.0,0.0,
		0.0,1.0,
		1.0,0.5,
	};
	
	GLfloat rotate = cos(f*M_PI/120.0)+1;
	glMatrixMode(GL_MODELVIEW);
	glPushMatrix();
	//glRotatef(-10.0,1.0,0.0,0.0);
	//绘制旧的
	glPushMatrix();
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glBindTexture(GL_TEXTURE_2D, textureFromView);
	
	glVertexPointer(3, GL_FLOAT, 0, frmoviewver);
	glTexCoordPointer(2, GL_FLOAT, 0, texver);
	
	glTranslatef(0, 0, -4-tan(30.0*M_PI/180.0));
	glRotatef(-f,0.0,1.0,0.0);
	
	glRotatef(30.0*rotate,1.0,0.0,0.0);
	
	glColor4f(0.7,0.7,0.7,1.0);
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	
	glDisable(GL_VERTEX_ARRAY);
	glDisable(GL_TEXTURE_COORD_ARRAY);
	glPopMatrix();
	
	//绘制新的
	glPushMatrix();
	glBindTexture(GL_TEXTURE_2D, textureToView);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	
	CGFloat NOM[3];
	fcos(frmoviewver1[0],frmoviewver1[1],frmoviewver1[2],frmoviewver1[3],frmoviewver1[4],frmoviewver1[5],frmoviewver1[6],frmoviewver1[7],frmoviewver1[8],NOM);
	glEnableClientState(GL_NORMAL_ARRAY);
	glNormalPointer(GL_FLOAT, 0, NOM);
	
	
	glVertexPointer(3, GL_FLOAT, 0, frmoviewver1);
	glTexCoordPointer(2, GL_FLOAT, 0, texver);
	
	glTranslatef(0, 0, -4-tan(30.0*M_PI/180.0));
	glColor4f(1.0,1.0,1.0,1.0);
	//glRotatef(-30.0,0.0,0.0,1.0);
	//glRotatef(120.0,0.0,1.0,0.0);
	glRotatef(-f,0.0,1.0,0.0);
	glRotatef(30.0*rotate,1.0,0.0,0.0);
	
	glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
	
	glDisable(GL_VERTEX_ARRAY);
	glDisable(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_NORMAL_ARRAY);
	glPopMatrix();
	
	
	//绘制顶部分
	glPushMatrix();	
	
	glBindTexture(GL_TEXTURE_2D, woodTexture);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glVertexPointer(3, GL_FLOAT, 0, topver);
	glTexCoordPointer(2, GL_FLOAT, 0, toptexver);
	glTranslatef(0, 0, -4-tan(30.0*M_PI/180.0));
	glColor4f(1.0,1.0,1.0,1.0);
	//glRotatef(120.0,0.0,1.0,0.0);
	glRotatef(-f,0.0,1.0,0.0);
	glRotatef(30.0*rotate,1.0,0.0,0.0);
	//glRotatef(-30.0,0.0,0.0,1.0);
	glDrawArrays(GL_TRIANGLE_FAN, 0, 3);
	
	glDisable(GL_VERTEX_ARRAY);
	glDisable(GL_TEXTURE_COORD_ARRAY);
	glPopMatrix();

	glPopMatrix();
	
	f += 120.0/180.0;
    return f < 120.0;
}

void fcos(CGFloat x1,CGFloat y1,CGFloat z1,CGFloat x2,CGFloat y2,CGFloat z2,CGFloat x3,CGFloat y3,CGFloat z3,CGFloat *nomal1)
{
	CGFloat vect1[3],vect2[3];
	vect1[0] = x2 - x1;vect1[1] = y2 - y1;vect1[2] = z2 - z1;
	vect2[0] = x3 - x1;vect2[1] = y3 - y1;vect2[2] = z3 - z1;
	
	nomal1[0] = vect1[1]*vect2[2] - vect1[2]*vect2[1];
	nomal1[1] = vect1[2]*vect2[0] - vect1[0]*vect2[2];
	nomal1[2] = vect1[0]*vect2[1] - vect1[1]*vect2[0];
}


- (void)transitionEnded
{
}

@end
