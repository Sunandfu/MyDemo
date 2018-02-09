//
//  GLProgram.m
//  HTY360Player
//
//  Created by  on 11/8/15.
//  Copyright © 2015 Hanton. All rights reserved.
//

#import "GLProgram.h"

#pragma mark - Function Pointer Definitions

typedef void (*GLInfoFunction)(GLuint program, GLenum pname, GLint* params);
typedef void (*GLLogFunction) (GLuint program, GLsizei bufsize, GLsizei* length, GLchar* infolog);

#pragma mark - Private Extension Method Declaration

@interface GLProgram()

- (BOOL)compileShader:(GLuint *)shader
                 type:(GLenum)type
               string:(NSString *)shaderString;
- (NSString *)logForOpenGLObject:(GLuint)object
                    infoCallback:(GLInfoFunction)infoFunc
                         logFunc:(GLLogFunction)logFunc;
@end

@implementation GLProgram

#pragma mark - init

- (id)initWithVertexShaderString:(NSString *)vShaderString
            fragmentShaderString:(NSString *)fShaderString {
    self = [super init];
    if (self) {
        _attributes = [[NSMutableArray alloc] init];
        _uniforms = [[NSMutableArray alloc] init];
        _program = glCreateProgram();
        
        if (![self compileShader:&_vertShader
                            type:GL_VERTEX_SHADER
                          string:vShaderString])
            NSLog(@"Failed to compile vertex shader");
        
        if (![self compileShader:&_fragShader
                            type:GL_FRAGMENT_SHADER
                          string:fShaderString])
            NSLog(@"Failed to compile fragment shader");
        
        glAttachShader(_program, _vertShader);
        glAttachShader(_program, _fragShader);
    }
    
    return self;
}

- (id)initWithVertexShaderString:(NSString *)vShaderString
          fragmentShaderFilename:(NSString *)fShaderFilename {
    NSString *fragShaderPathname = [[NSBundle mainBundle] pathForResource:fShaderFilename ofType:@"fsh"];
    NSString *fragmentShaderString = [NSString stringWithContentsOfFile:fragShaderPathname
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];
    
    if ((self = [self initWithVertexShaderString:vShaderString fragmentShaderString:fragmentShaderString])) {
        
    }
    
    return self;
}

- (id)initWithVertexShaderFilename:(NSString *)vShaderFilename
            fragmentShaderFilename:(NSString *)fShaderFilename {
    NSString *vertShaderPathname = [[NSBundle mainBundle] pathForResource:vShaderFilename ofType:@"vsh"];
    NSString *vertexShaderString = [NSString stringWithContentsOfFile:vertShaderPathname
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];
    
    NSString *fragShaderPathname = [[NSBundle mainBundle] pathForResource:fShaderFilename ofType:@"fsh"];
    NSString *fragmentShaderString = [NSString stringWithContentsOfFile:fragShaderPathname
                                                               encoding:NSUTF8StringEncoding
                                                                  error:nil];
    
    if ((self = [self initWithVertexShaderString:vertexShaderString fragmentShaderString:fragmentShaderString])) {
        
    }
    
    return self;
}

#pragma mark - compile

- (BOOL)compileShader:(GLuint *)shader
                 type:(GLenum)type
               string:(NSString *)shaderString {
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[shaderString UTF8String];
    if (!source) {
        NSLog(@"Failed to load shader: %@", shaderString);
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    
    if (status != GL_TRUE) {
        GLint logLength;
        glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
        if (logLength > 0) {
            GLchar *log = (GLchar *)malloc(logLength);
            glGetShaderInfoLog(*shader, logLength, &logLength, log);
            NSLog(@"Shader compile log:\n%s", log);
            free(log);
        }
    }
    
    return status == GL_TRUE;
}

#pragma mark - add attribute

- (void)addAttribute:(NSString *)attributeName {
    if (![self.attributes containsObject:attributeName]) {
        [self.attributes addObject:attributeName];
        glBindAttribLocation(self.program,
                             (GLuint)[self.attributes indexOfObject:attributeName],
                             [attributeName UTF8String]);
    }
}

#pragma mark - index methods

- (GLuint)attributeIndex:(NSString *)attributeName {
    return (GLuint)[self.attributes indexOfObject:attributeName];
}

- (GLuint)uniformIndex:(NSString *)uniformName {
    return glGetUniformLocation(self.program, [uniformName UTF8String]);
}

#pragma mark - link

- (BOOL)link {
    GLint status;
    glLinkProgram(self.program);
    
    glGetProgramiv(self.program, GL_LINK_STATUS, &status);
    if (status == GL_FALSE)
        return NO;
    
    if (self.vertShader) {
        glDeleteShader(self.vertShader);
        self.vertShader = 0;
    }
    if (self.fragShader) {
        glDeleteShader(self.fragShader);
        self.fragShader = 0;
    }
    
    return YES;
}

#pragma mark - use

- (void)use {
    glUseProgram(self.program);
}

#pragma mark - privatelog

- (NSString *)logForOpenGLObject:(GLuint)object
                    infoCallback:(GLInfoFunction)infoFunc
                         logFunc:(GLLogFunction)logFunc {
    GLint logLength = 0, charsWritten = 0;
    
    infoFunc(object, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength < 1)
        return nil;
    
    char *logBytes = malloc(logLength);
    logFunc(object, logLength, &charsWritten, logBytes);
    NSString *log = [[NSString alloc] initWithBytes:logBytes
                                             length:logLength
                                           encoding:NSUTF8StringEncoding];
    free(logBytes);
    return log;
}

- (NSString *)vertexShaderLog {
    return [self logForOpenGLObject:self.vertShader
                       infoCallback:(GLInfoFunction)&glGetProgramiv
                            logFunc:(GLLogFunction)&glGetProgramInfoLog];
    
}

- (NSString *)fragmentShaderLog {
    return [self logForOpenGLObject:self.fragShader
                       infoCallback:(GLInfoFunction)&glGetProgramiv
                            logFunc:(GLLogFunction)&glGetProgramInfoLog];
}

- (NSString *)programLog {
    return [self logForOpenGLObject:self.program
                       infoCallback:(GLInfoFunction)&glGetProgramiv
                            logFunc:(GLLogFunction)&glGetProgramInfoLog];
}

- (void)validate {
    GLint logLength;
    
    glValidateProgram(self.program);
    glGetProgramiv(self.program, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *infoLog = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(self.program, logLength, &logLength, infoLog);
        NSLog(@"Program validate log:\n%s", infoLog);
        free(infoLog);
    }
}

#pragma mark - dealloc

- (void)dealloc {
    if (_vertShader)
        glDeleteShader(_vertShader);
    
    if (_fragShader)
        glDeleteShader(_fragShader);
    
    if (_program)
        glDeleteProgram(_program);
}

@end
