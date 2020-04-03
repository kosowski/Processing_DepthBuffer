  // Example showing how to use the PGraphics depth buffer as input for a shader, without CPU read back
  // Processing PGraphics depth buffer is not readable, its contents need to be copyed to a readable texture in order to use it
  // by Nacho Cossio (www.nachocossio.com)
  
  PGraphics pg;
  PShader shader;
  CustomFrameBuffer fbo;
  
  public void setup() {
    size(800,800,P3D);
    pg = createGraphics(width, height, P3D);
    shader = loadShader("data/depthViewer.glsl");
    PGL pgl = beginPGL();
    GL4  gl = ((PJOGL)pgl).gl.getGL4();
    fbo = new CustomFrameBuffer(gl, width, height);

    endPGL();
  }
  
  public void draw() {
    pg.beginDraw();
    pg.background(0);

    pg.fill(255,0,0);
    pg.noStroke();
    int numSpheres = 8;
    for(int i=0; i< numSpheres; i++) {
      pg.pushMatrix();
      pg.translate(width * i /(float)numSpheres, height/2 + 100*sin(frameCount*0.02f + i), -400 * sin(frameCount*0.01f + i) );
      pg.sphere(100);
      pg.popMatrix();
    }

    PGL pgl = pg.beginPGL();
    FrameBuffer fb = ((PGraphicsOpenGL)pg).getFrameBuffer(true);
    fbo.copyDepthFrom(pgl, fb.glFbo);
    
    pg.endPGL();
    pg.endDraw();

    pgl = beginPGL();
    
    int textureID = fbo.getDepthTexture()[0];
    int textureUnit = PGL.TEXTURE2;

    //int loc = pgl.getUniformLocation(shader.glProgram, "depthTexture");
    //pgl.uniform1i(loc, textureID);
    pgl.activeTexture(textureUnit);
    pgl.bindTexture(PGL.TEXTURE_2D, textureID);
    shader.set("depthTexture", textureID);
    shader(shader);

    background(10);
    rect(0,0,width,height);    
    endPGL();
  }
