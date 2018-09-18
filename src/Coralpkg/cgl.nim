# Coral opengl wrapper
import
  strformat,
  opengl,
  maths,
  typeinfo,
  typetraits

## Vertex arrays
proc newVertexArray* (shouldBind = true): GLuint=
  glGenVertexArrays(1, addr result)
  if shouldBind: glBindVertexArray(result)

proc bindVertexArray* (buffer: GLuint)=
    glBindVertexArray(buffer)

proc unBindVertexArray* ()=
  glBindVertexArray(0)

template useVertexArray* (buffer: GLuint, body: untyped)=
    bindVertexArray(buffer)
    body
    unBindVertexArray()

## Vertex buffers
proc newVertexBufferObject* [T](btype: GLenum, dimensions: uint32, attrib: uint32, data: var seq[T], dynamic = false): GLuint=
    glGenBuffers(1, addr result)
    glBindBuffer(btype, result)

    glBufferData(
        btype,
        cast[GLsizeiptr](sizeof(T) * data.len),
        (if data.len == 0: cast[pointer](0) else: addr data[0]),
        if dynamic: GL_DYNAMIC_DRAW
        else: GL_STATIC_DRAW)

    let GLType = case T.name:
      of "float32", "GLfloat":
        cGL_FLOAT
      of "float", "float64":
        cGL_DOUBLE
      of "int", "uint32", "uint":
        cGL_INT
      of "int16", "uint16":
        cGL_SHORT
      of "int8", "uint8":
        cGL_BYTE
      else:
        cGL_FLOAT
    
    glEnableVertexAttribArray(GLuint(attrib))

    glVertexAttribPointer(
        (GLuint)attrib,
        (GLint)dimensions,
        GLType,
        GL_FALSE,
        0,
        cast[pointer](0))

    glBindBuffer(btype, 0)

proc newElementBuffer* [T](indices: var seq[T]): GLuint =
  glGenBuffers(1, addr result)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, result)
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(T) * indices.len, addr indices[0], GL_STATIC_DRAW)
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)

proc bindElementBuffer* (id: GLuint)=
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, id)

proc unBindElementBuffer* ()=
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)

template useElementBuffer* (id: GLuint, body: untyped)=
  bindElementBuffer(id)
  body
  unBindElementBuffer()

proc bindVertexBufferObject* (id: GLuint, btype: GLenum)=
   glBindBuffer(btype, id)

proc unBindVertexBufferObject* (btype: GLenum)=
   glBindBuffer(btype, 0)

template useVertexBufferObject* (id: GLuint, btype: GLenum, body: untyped)=
    bindVertexBufferObject(id, btype)
    body
    unBindVertexBufferObject(btype)

## Shaders
proc loadShaderFromString* (stype: GLenum, code: string): GLuint=
    result = glCreateShader(stype)
    let cstra = allocCStringArray([code])
    glShaderSource(result, 1, cstra, nil)
    glCompileShader(result)

    var
        res: GLint = 0
        log_len: GLint = 0

    glGetShaderiv(result, GL_COMPILE_STATUS, addr res)
    glGetShaderiv(result, GL_INFO_LOG_LENGTH, addr log_len)

    if log_len > 0:
        var log: cstring = cast[cstring](alloc(log_len + 1))
        glGetShaderInfoLog(
            result,
            (GLsizei)log_len,
            nil,
            log)
      
        let shaderStr =
          case stype:
           of GL_VERTEX_SHADER:
             "GL_VERTEX_SHADER"
           of GL_FRAGMENT_SHADER:
             "GL_FRAGMENT_SHADER"
           of GL_GEOMETRY_SHADER:
             "GL_GEOMETRY_SHADER"
           else: ""

        echo &"{shaderStr}::ERROR: {log}"
        dealloc(log)

proc newShaderProgram* (vertex = 0.GLuint, fragment = 0.GLuint, geometry = 0.GLuint): GLuint=
  result = glCreateProgram()

  if vertex   != 0: glAttachShader(result, vertex)
  if fragment != 0: glAttachShader(result, fragment)
  if geometry != 0: glAttachShader(result, geometry)
  glLinkProgram(result)

  var
      res: GLint = 0
      log_len: GLint = 0

  glGetProgramiv(result, GL_LINK_STATUS, addr res)
  glGetProgramiv(result, GL_INFO_LOG_LENGTH, addr log_len)
  if log_len > 0:
    var log: cstring = cast[cstring](alloc(log_len + 1))
    glGetProgramInfoLog(result, (GLsizei)log_len, nil, log)
    echo &"PROGRAM::ERROR: {log}"
    dealloc(log) # might not need to with garbage collection

proc bindShaderProgram* (prog: GLuint)=
  glUseProgram(prog)

proc unBindShaderProgram* ()=
  glUseProgram(0)

template useShaderProgram* (prog: GLuint, body: untyped)=
  bindShaderProgram(prog)
  body
  unBindShaderProgram()

##
## Uniforms
##

proc getUniformLoc* (prog: GLuint, id: string): auto=
  result = glGetUniformLocation(prog, id)

template `%`* (prog: GLuint, id: string): GLint=
  result = getUniformLoc(prog, id)

proc setUniform* (id: GLint, i: int)= glUniform1i(id, i.cint)
proc setUniform* (id: GLint, b: bool)= glUniform1i(id, (if b: 1 else: 0))
proc setUniform* (id: GLint, f: float)= glUniform1f(id, f)
proc setUniform* (id: GLint, x, y: float)= glUniform2f(id, x, y)
proc setUniform* (id: GLint, x, y, z: float)= glUniform3f(id, x, y, z)
proc setUniform* (id: GLint, x, y, z, w: float)= glUniform4f(id, x, y, z, w)

proc setUniform* (id: GLint, v3: Vec3)=
  setUniform(id, v3.x, v3.y, v3.z)

proc setUniform* (id: GLint, v3: Vec3, w: float)=
  setUniform(id, v3.x, v3.y, v3.z, w)

proc setUniform* (id: GLint, m: var array[16, float32])=
  glUniformMatrix4fv(id, 1.GLsizei, GL_FALSE, addr m[0])

proc setUniform* (id: GLint, m: var Mat4)=
  glUniformMatrix4fv(id, 1.GLsizei, GL_TRUE, addr m.m[0])

## GL functions
proc clearColorBuffer* (clearColor=(0.0, 0.0, 0.0, 1.0))=
  glClearColor(clearColor[0], clearColor[1], clearColor[2], clearColor[3])
  glClear(GL_COLOR_BUFFER_BIT)

proc clearDepthBuffer* (clearColor=(0.0, 0.0, 0.0, 1.0))=
  glClearColor(clearColor[0], clearColor[1], clearColor[2], clearColor[3])
  glClear(GL_DEPTH_BUFFER_BIT)

proc clearStencilBuffer* (clearColor=(0.0, 0.0, 0.0, 1.0))=
  glClearColor(clearColor[0], clearColor[1], clearColor[2], clearColor[3])
  glClear(GL_STENCIL_BUFFER_BIT)

proc clearColorAndDepthBuffers* (clearColor=(0.0, 0.0, 0.0, 1.0))=
  glClearColor(clearColor[0], clearColor[1], clearColor[2], clearColor[3])
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

proc clearColorDepthAndStencilBuffers* (clearColor=(0.0, 0.0, 0.0, 1.0))=
  glClearColor(clearColor[0], clearColor[1], clearColor[2], clearColor[3])
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT or GL_STENCIL_BUFFER_BIT)