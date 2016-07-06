float threshold = 1;

class Circle{
  float r, x, y;
  boolean isOuter;
  
  Circle( float x, float y,float r, boolean isOuter){
    this.r = r;
    this.x = x;
    this.y = y;
    this.isOuter = isOuter;
    ellipse(x,y,2*r, 2*r);
    ellipse(width-x,y,2*r, 2*r);
    ellipse(x,height-y,2*r, 2*r);
    ellipse(width-x,height-y,2*r, 2*r);
  }
}

Circle spawnChild(Circle c1, Circle c2, Circle C,float n){
  if (C.isOuter){
    float k1 = 1/c1.r;
    float k2 = 1/c2.r;
    float k3 = -1/C.r;
    float k4 = k1+k2+k3+2*sqrt(k1*k2+k1*k3+k2*k3);
    float r = 1/k4;

    float a = r + c2.r;
    float b = r + c1.r;
    float c = dist(c1.x,c1.y,c2.x,c2.y);
    float theta = acos((-a*a + b*b  + c*c)/(2*b*c));
    float ux = c2.x-c1.x;
    float uy = c2.y-c1.y;
    float norm = sqrt(ux*ux + uy*uy);
    float nux = ux/norm;
    float nuy = uy/norm;
    float orthux = 0;
    float orthuy = 0;
    
    float mx = (c1.x + c2.x)/2;
    float my = (c1.y + c2.y)/2;
    
    float mtheta = atan((my-C.y)/(mx-C.x));
    float BGx = C.x + C.r*cos(mtheta);
    float BGy = C.y + C.r*sin(mtheta);
    
   
    float orthux1 = -uy;
    float orthuy1 = ux;
    float northux1 = orthux1/norm;
    float northuy1 = orthuy1/norm;
    float x1 = c1.x + (r+c1.r)*cos(theta)*nux + (r+c1.r)*sin(theta)*northux1;
    float y1 = c1.y + (r+c1.r)*cos(theta)*nuy + (r+c1.r)*sin(theta)*northuy1;
    
    float orthux2 = uy;
    float orthuy2 = -ux;
    float northux2 = orthux2/norm;
    float northuy2 = orthuy2/norm;
    float x2 = c1.x + (r+c1.r)*cos(theta)*nux + (r+c1.r)*sin(theta)*northux2;
    float y2 = c1.y + (r+c1.r)*cos(theta)*nuy + (r+c1.r)*sin(theta)*northuy2;
    
    float x =0;
    float y =0;
    
    if (dist(x1,y1,BGx,BGy) < dist(x2,y2,BGx,BGy)){
      x = x1;
      y = y1;
    } else {
      x = x2;
      y = y2;
    }
    Circle output = new Circle(x,y,r,false);
    return output; 
  } else{
    float k1 = 1/c1.r;
    float  k2 = 1/c2.r;
    float k3 = 1/C.r;
    float k4 = k1+k2+k3+2*sqrt(k1*k2+k1*k3+k2*k3);
    float r = 1/k4;
    float badGuessX = (c1.x+c2.x+C.x)/3;
    float badGuessY = (c1.y+c2.y+C.y)/3;
    float a = r + c2.r;
    float b = r + c1.r;
    float c = dist(c1.x,c1.y,c2.x,c2.y);
    float theta = acos((-a*a + b*b  + c*c)/(2*b*c));
    float ux = c2.x-c1.x;
    float uy = c2.y-c1.y;
    float norm = sqrt(ux*ux + uy*uy);
    float nux = ux/norm;
    float nuy = uy/norm;
    float orthux = 0;
    float orthuy = 0;
    if (dist(-uy, ux, badGuessX, badGuessY) < dist(uy, -ux, badGuessX, badGuessY)){
      orthux = -uy;
      orthuy = ux;
    } else {
      orthux = uy;
      orthuy = -ux;
    }
    float northux = orthux/norm;
    float northuy = orthuy/norm;
    float x = c1.x + (r+c1.r)*cos(theta)*nux + (r+c1.r)*sin(theta)*northux;
    float y = c1.y + (r+c1.r)*cos(theta)*nuy + (r+c1.r)*sin(theta)*northuy;
    Circle output = new Circle(x,y,r,false);
    return output; 
  } 
}

void recursiveDance(Circle upper, Circle lower, Circle C, float n){
  if (min(upper.r, lower.r,C.r) < threshold){
    return;
  }
  Circle baby = spawnChild(upper,lower,C,n*n);
  recursiveDance(upper,baby,C,n+1);
  recursiveDance(baby,lower,C,n+1);
  recursiveDance(upper,lower,baby,n+1);
}
void setup(){
  size(600,600);
  Circle outer = new Circle(width/2,width/2,width/2,true);
  Circle upper = new Circle(width/2,width/4,width/4,false);
  Circle lower = new Circle(width/2,3*width/4,width/4,false);
  recursiveDance(upper,lower,outer,1);
  Circle left  = spawnChild(upper,lower,outer,1);
  Circle right = new Circle(2*outer.x - left.x,left.y, left.r,false);
  line(upper.x,upper.y,right.x,right.y);
  line(lower.x,lower.y,right.x,right.y);
  line(lower.x,lower.y,upper.x,upper.y);
  //recursiveDance(lower,right,outer,1);
  Circle inner  = spawnChild(upper,lower,left,1);
  line(lower.x,lower.y,width-inner.x,inner.y);
  line(upper.x,upper.y,width-inner.x,inner.y);
  line(right.x,right.y,width-inner.x,inner.y);
  Circle lowerChild  = spawnChild(left,lower,outer,1);
  line(right.x,right.y,width-lowerChild.x,lowerChild.y);
  Circle grandchild  = spawnChild(lowerChild,left,outer,1);
  line(right.x,right.y,width-grandchild.x,grandchild.y);
  line(width-lowerChild.x,lowerChild.y,width-grandchild.x,grandchild.y);
}