  // Example showing how to use the PGraphics depth buffer as input for a Depth of Field shader, without CPU read back
  // Processing PGraphics depth buffer is not readable, its contents need to be copyed to a readable texture in order to use it
  // by Nacho Cossio (www.nachocossio.com), Depth of Field shader from the ProScene library https://github.com/remixlab/proscene
  
  PGraphics pg;
  PShader dofShader;
  CustomFrameBuffer fbo;
  
  int colorPalette[] = {#cdfff5, #cbced8, #f2ddde, #F2F1C4};
  PVector[] positions;
  int[] colors;
  int totalNum = 120;
  
  public void setup() {
    size(800,800,P3D);
    smooth(4);
    pg = createGraphics(width, height, P3D);
    dofShader = loadShader("data/dof.glsl");
    dofShader.set("aspect", width / (float) height);
    dofShader.set("maxBlur", 0.015);  
    dofShader.set("aperture", 0.04);
    
    PGL pgl = beginPGL();
    GL4  gl = ((PJOGL)pgl).gl.getGL4();
    fbo = new CustomFrameBuffer(gl, width, height);
    endPGL();
    
    positions = new PVector[totalNum];
    colors = new int[totalNum];
    float extent = 1000;
    PVector half = new PVector(extent/2,extent/2,extent/2);
    for(int i = 0; i < totalNum;i++){
      positions[i] = new PVector(random(extent), random(extent), random(extent)).sub(half);
      colors[i] = colorPalette[ (i % colorPalette.length)];
    }
  }
  
  public void draw() {
    pg.beginDraw();
    pg.background(#9aa3b6);

    pg.noLights();
    pg.ambientLight(100,100,100);
    pg.directionalLight(120, 120, 120, 1, 0.5f, -1);
    pg.fill(#cdfff5);
    pg.stroke(0);
    pg.strokeWeight(1.5f);
    pg.translate(width/2, height/2, -500);
    pg.rotateY(frameCount * 0.002);
    
    int size = 100;
    for(int i = 0; i < totalNum;i++){
      pg.pushMatrix();
      pg.fill(colors[i]);
      pg.translate(positions[i].x, positions[i].y, positions[i].z);
      pg.box(size);
      pg.popMatrix();
    }

    PGL pgl = pg.beginPGL();
    FrameBuffer fb = ((PGraphicsOpenGL)pg).getFrameBuffer(true);
    fbo.copyDepthFrom(pgl, fb.glFbo);
    
    pg.endPGL();
    pg.endDraw();

    PMatrix3D projectionMatrix = ((PGraphicsOpenGL)pg).projection;
    float C = projectionMatrix.m22;
    float D = projectionMatrix.m23;
    float near = D / (C -1f);
    float far = D / (C + 1f);
    
    pgl = beginPGL();
    
    int textureID = fbo.getDepthTexture()[0];
    int textureUnit = PGL.TEXTURE2;

    //int loc = pgl.getUniformLocation(shader.glProgram, "depthTexture");
    //pgl.uniform1i(loc, textureID);
    pgl.activeTexture(textureUnit);
    pgl.bindTexture(PGL.TEXTURE_2D, textureID);
    dofShader.set("depthTexture", textureID);
    dofShader.set("focus", map(mouseX, 0, width, 0f, 0.6f));
    dofShader.set("znear", near);
    dofShader.set("zfar", far);
    shader(dofShader);

    background(10);
    image(pg,0,0,width,height);    
    endPGL();
  }
