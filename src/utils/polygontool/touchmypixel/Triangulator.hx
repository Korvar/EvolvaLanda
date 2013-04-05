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

import flash.geom.Point;

class Triangulator {
	
	public function new()
	{	
	}
	
	/* give it an array of points (vertexes)
	 * returns an array of Triangles
	 * */
	public static function triangulatePolygon(v:Array<Point>):Array<Triangle>
	{
		var xA:Array<Float> = new Array();
		var yA:Array<Float> = new Array();
		
		for(p in v) {
			xA.push(p.x);
			yA.push(p.y);
		}
		
		return(triangulatePolygonFromFlatArray(xA, yA));
	}
	
	/* give it a list of vertexes as flat arrays
	 * returns an array of Triangles
	 * */
	public static function triangulatePolygonFromFlatArray(xv:Array<Float>, yv:Array<Float>):Array<Triangle>
	{
		if (xv.length < 3 || yv.length < 3 || yv.length != xv.length) {
			trace("Please make sure both arrays or of the same length and have at least 3 vertices in them!");
			return null;
		}
		
		var i:Int = 0;
		var vNum:Int = xv.length;
	  
		var buffer:Array<Triangle> = new Array();
		var bufferSize:Int = 0;
		var xrem:Array<Float> = new Array();
		var yrem:Array<Float> = new Array();
		
		for (i in 0...vNum) {
			xrem[i] = xv[i];
			yrem[i] = yv[i];
		}

		while (vNum > 3){
			//Find an ear
			var earIndex = -1;
			for (i in 0...vNum) {
				if (isEar(i, xrem, yrem)) {
					earIndex = i;
					break;
				}
			}

			//If we still haven't found an ear, we're screwed.
			//The user did Something Bad, so return null.
			//This will probably crash their program, since
			//they won't bother to check the return value.
			//At this we shall laugh, heartily and with great gusto.
			if (earIndex == -1) {
				//trace('no ear found');
				return null;
			}

			//Clip off the ear:
			//  - remove the ear tip from the list

			//Opt note: actually creates a new list, maybe
			//this should be done in-place instead.  A linked
			//list would be even better to avoid array-fu.
			--vNum;
			var newx:Array<Float> = new Array();
			var newy:Array<Float> = new Array();
			var currDest:Int = 0;
			for (i in 0...vNum) {
				if (currDest == earIndex) ++currDest;
				newx[i] = xrem[currDest];
				newy[i] = yrem[currDest];
				++currDest;
			}

			//  - add the clipped triangle to the triangle list
			var under:Int = (earIndex == 0)?(xrem.length - 1):(earIndex - 1);
			var over:Int = (earIndex == xrem.length - 1)?0:(earIndex + 1);
			
			//if(5 < getSmallestAngle(xrem[earIndex], yrem[earIndex], xrem[over], yrem[over], xrem[under], yrem[under]))
			
			var toAdd:Triangle = new Triangle(xrem[earIndex], yrem[earIndex], xrem[over], yrem[over], xrem[under], yrem[under]);
			buffer[bufferSize] = toAdd;
			++bufferSize;
		
			//  - replace the old list with the new one
			xrem = newx;
			yrem = newy;
		}
		
		var toAddMore:Triangle = new Triangle(xrem[1], yrem[1], xrem[2], yrem[2], xrem[0], yrem[0]);
		buffer[bufferSize] = toAddMore;
		++bufferSize;

		var res:Array<Triangle> = new Array();
		for (i in 0...bufferSize) {
			res[i] = buffer[i];
		}
		return buffer;
	}
	
	public static function getSmallestAngle(pax:Float, pay:Float, pbx:Float, pby:Float, pcx:Float, pcy:Float) : Float {
		var angles:Array<Float> = new Array();
		var pax=pax;
		var pay=pay;
		var pbx=pbx;
		var pby=pby;
		var pcx=pcx;
		var pcy=pcy;
		var abx=pax-pbx;
		var aby=pay-pby;
		var ab=Math.sqrt(abx*abx+aby*aby);
		var bcx=pbx-pcx;
		var bcy=pby-pcy;
		var bc=Math.sqrt(bcx*bcx+bcy*bcy);
		var cax=pcx-pax;
		var cay=pcy-pay;
		var ca=Math.sqrt(cax*cax+cay*cay);
		var cosA=-(bc*bc-ab*ab-ca*ca)/(2*ab*ca);
		var acosA=Math.acos(cosA)*180/Math.PI;
		var cosB=-(ca*ca-bc*bc-ab*ab)/(2*bc*ab);
		var acosB=Math.acos(cosB)*180/Math.PI;
		var cosC=-(ab*ab-ca*ca-bc*bc)/(2*ca*bc);
		var acosC=Math.acos(cosC)*180/Math.PI;
		angles.push(acosA);
		angles.push(acosB);
		angles.push(acosC);
		angles.sort(function(x,y){
			if(x>y)
				return 1;
			else if(y>x)
				return -1;
			else
				return 0;
		});
		
		return angles[0];
	}
	
	/* takes: array of Triangles 
	 * returns: array of Polygons
	 * */
	public static function polygonizeTriangles(triangulated:Array<Triangle>):Array<Polygon>
	{
		var polys:Array<Polygon>;
		var polyIndex:Int = 0;
		var poly:Polygon = null;

		var i:Int = 0;
		
		if (triangulated == null){
			return null;
		} else {
			polys = new Array();
			var covered:Array<Bool> = new Array();
			for (i in 0...triangulated.length) {
				covered[i] = false;
			}

			var notDone:Bool = true;

			while(notDone){
				var currTri:Int = -1;
				for (i in 0...triangulated.length) {
					if (covered[i]) continue;
					currTri = i;
					break;
				}
				if (currTri == -1){
					notDone = false;
				} else{
					poly = new Polygon(triangulated[currTri].x, triangulated[currTri].y);
					covered[currTri] = true;
					for (i in 0...triangulated.length) {
						if (covered[i]) continue;
						var newP:Polygon = poly.add(triangulated[i]);
						if (newP == null || newP.x.length > 7) continue;
						if (newP.isConvex()){
							poly = newP;
							covered[i] = true;
						}
					}
				}
				polys[polyIndex] = poly;
				polyIndex++;
			}
		}
		
		var ret:Array<Polygon> = new Array();
		for (i in 0...polyIndex) {
			ret[i] = polys[i];
		}
		return ret;
	}

	//Checks if vertex i is the tip of an ear
	/*
	 * */
	public static function isEar(i:Int, xv:Array<Float>, yv:Array<Float>):Bool
	{
		var dx0:Float, dy0:Float, dx1:Float, dy1:Float;
		dx0 = dy0 = dx1 = dy1 = 0;
		if (i >= xv.length || i < 0 || xv.length < 3) {
			return false;
		}
		var upper:Int = i + 1;
		var lower:Int = i - 1;
		if (i == 0){
			dx0 = xv[0] - xv[xv.length - 1];
			dy0 = yv[0] - yv[yv.length - 1];
			dx1 = xv[1] - xv[0];
			dy1 = yv[1] - yv[0];
			lower = xv.length - 1;
		} else if (i == xv.length - 1) {
			dx0 = xv[i] - xv[i - 1];
			dy0 = yv[i] - yv[i - 1];
			dx1 = xv[0] - xv[i];
			dy1 = yv[0] - yv[i];
			upper = 0;
		} else{
			dx0 = xv[i] - xv[i - 1];
			dy0 = yv[i] - yv[i - 1];
			dx1 = xv[i + 1] - xv[i];
			dy1 = yv[i + 1] - yv[i];
		}
		
		var cross:Float = (dx0*dy1)-(dx1*dy0);
		if (cross > 0) return false;
		var myTri:Triangle = new Triangle(xv[i], yv[i], xv[upper], yv[upper], xv[lower], yv[lower]);

		for (j in 0...xv.length) {
			if (!(j == i || j == lower || j == upper)) {
				if (myTri.isInside(xv[j], yv[j])) return false;
			}
		}
		return true;
	}	
}