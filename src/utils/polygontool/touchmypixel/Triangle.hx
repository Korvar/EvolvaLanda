 /* 
 * Based on JSFL util by mayobutter (Box2D Forums)
 * and  Eric Jordan (http://www.ewjordan.com/earClip/) Ear Clipping experiment in Processing
 * 
 * Tarwin Stroh-Spijer - Touch My Pixel - http://www.touchmypixel.com/
 *
 * Converted to haXe by Joacim Magnusson
 * www.splashdust.net
 * */

package src.utils.polygontool.touchmypixel;
	
class Triangle {
	
	public var x:Array<Float>;
	public var y:Array<Float>;
	
	public function toString() : String {
		return "{("+x[0]+","+y[0]+"), ("+x[1]+","+y[1]+"), ("+x[2]+","+y[2]+")}";
	}
	
	public function new(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float) {
		x = new Array();
		y = new Array();
		var dx1:Float = x2-x1;
		var dx2:Float = x3-x1;
		var dy1:Float = y2-y1;
		var dy2:Float = y3-y1;
		var cross:Float = (dx1*dy2)-(dx2*dy1);
		var ccw:Bool = (cross>0);
		if (ccw){
			x[0] = x1; x[1] = x2; x[2] = x3;
			y[0] = y1; y[1] = y2; y[2] = y3;
		} else{
			x[0] = x1; x[1] = x3; x[2] = x2;
			y[0] = y1; y[1] = y3; y[2] = y2;
		}			
	}
	
	public function isInside(_x:Float, _y:Float){
		var vx2:Float = _x - x[0]; var vy2 = _y - y[0];
		var vx1:Float = x[1] - x[0]; var vy1 = y[1] - y[0];
		var vx0:Float = x[2] - x[0]; var vy0 = y[2] - y[0];
		
		var dot00:Float = vx0 * vx0 + vy0 * vy0;
		var dot01:Float = vx0 * vx1 + vy0 * vy1;
		var dot02:Float = vx0 * vx2 + vy0 * vy2;
		var dot11:Float = vx1 * vx1 + vy1 * vy1;
		var dot12:Float = vx1 * vx2 + vy1 * vy2;
		var invDenom:Float = 1.0 / (dot00 * dot11 - dot01 * dot01);
		var u:Float = (dot11 * dot02 - dot01 * dot12) * invDenom;
		var v:Float = (dot00 * dot12 - dot01 * dot02) * invDenom;
		
		return ((u > 0) && (v > 0) && (u + v < 1));
	}		
}