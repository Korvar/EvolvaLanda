/***
* Feel free to use this code however you wish.
* Created by Joacim Magnusson (www.splashdust.net) 
*/

package src.utils;

import flash.geom.Point;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.text.TextField;

import src.utils.polygontool.touchmypixel.Triangulator;
import src.utils.polygontool.touchmypixel.Polygon;
import src.utils.polygontool.GrahamScan;

class PolygonTool
{
	public function new() : Void {}
	
	// Originally posted as C code at http://debian.fmi.uni-sofia.bg/~sergei/cgsr/docs/clockwise.htm
	public function isPolyConvex(p_poly:Array<Dynamic>) : Bool
	{
		var i:Int,j:Int,k:Int;
		var flag:Int = 0;
		var z:Float;
		var n:Int = p_poly.length;
		
		if (n < 3)
			return false;
		
		for (i in 0...n) {
			j = (i + 1) % n;
			k = (i + 2) % n;
			z  = (p_poly[j].x - p_poly[i].x) * (p_poly[k].y - p_poly[j].y);
			z -= (p_poly[j].y - p_poly[i].y) * (p_poly[k].x - p_poly[j].x);
			if (z < 0)
				flag |= 1;
			else if (z > 0)
				flag |= 2;
			if (flag == 3)
				return false;
		}
		if (flag != 0)
			return true;
		else
			return false;
	}
	
	// Determine if an arbitrary polygon is winded clockwise
	public function isPolyClockwise(p_vertices:Array<Dynamic>)
	{
		var i:Int,j:Int,k:Int;
		var count:Int = 0;
		var z:Float;
		
		if (p_vertices.length < 3)
			return false;
		
		for (i in 0...p_vertices.length) {
			j = (i + 1) % p_vertices.length;
			k = (i + 2) % p_vertices.length;
			z  = (p_vertices[j].x - p_vertices[i].x) * (p_vertices[k].y - p_vertices[j].y);
			z -= (p_vertices[j].y - p_vertices[i].y) * (p_vertices[k].x - p_vertices[j].x);
			if (z < 0)
				count--;
			else if (z > 0)
				count++;
		}
		if (count > 0)
			return false;
		else if (count < 0)
			return true;
		else
			return false;
	}
	
	public function getConvexPoly(p_vertices:Array<Dynamic>) : Array<Dynamic>
	{
		var grahamScan = new GrahamScan();
		return grahamScan.convexHull(p_vertices.slice(0));
	}
	
	public function earClip(p_vertices:Array<Dynamic>) : Array<Array<Dynamic>>
	{
		// Touchmypixel's triangulator needs an array of points.
		var points:Array<Point> = new Array();
		for(v in p_vertices) {
			points.push(new Point(v.x, v.y));
		}
		var triangles = Triangulator.triangulatePolygon(points);
		var polys = Triangulator.polygonizeTriangles(triangles);
		
		// We want to return an Array<Array<Dynamic>>
		var polyArray:Array<Array<Dynamic>> = new Array();
		if(polys != null) {
			for(i in 0...polys.length-1) { // The last poly seem to always be a copy of the next last one for some reason.
				var poly:Array<Dynamic> = new Array();
				if(polys[i] != null) {
					for (j in 0...polys[i].x.length) {
						poly.push({x:polys[i].x[j], y:polys[i].y[j]});
					}
				}
				polyArray.push(poly);
			}
		} else {
			return null;
		}
		
		return polyArray;
	}
	
	public function getCentroid(p_pa:Array<Dynamic>) : Dynamic
	{
		var cx:Float=0;
		var cy:Float=0;
		var C:Dynamic = {};
		
		// We don't want to modify the original array, so let's make a copy of the array and it's values
		var pa = p_pa.slice(0);
		
		pa.push(pa[0]);
		var n:Int=pa.length-1;
		while(n > -1){
			C = pa[n];
			if(n > 0){
				cx+=C.x;
				cy+=C.y;
			}
			n--;
		}
		
		return {x:cx/(pa.length-1), y:cy/(pa.length-1)}; // Calculate the centroid
	}
	
	
	public function lengthOfLine(p1:Dynamic,p2:Dynamic) : Float
	{
		var dx:Float,dy:Float;
		dx = p2.x-p1.x;
		dy = p2.y-p1.y;
		return Math.sqrt(dx*dx + dy*dy);
	}
	
	/**
	* Translate all vertices in p_poly by a factor of p_vector
	*/
	public function translatePoly(p_poly:Array<Dynamic>, p_vector:Dynamic) : Array<Dynamic>
	{
		var translatedPoly:Array<Dynamic> = new Array();
		for(vertex in p_poly) {
			translatedPoly.push({x: vertex.x + p_vector.x, y: vertex.y + p_vector.y});
		}
		return translatedPoly;
	}
	
	
	/**
	* Cut out a piece of a polygon and return the remain piece.
	* subjectPoly is the poly being cut
	* cuttingPoly is the poly used for cutting
	* Will only work if the cutting poly contour is intersecting the subject poly contour.
	*/
	public function cutPoly(p_subjectPoly:Array<Dynamic>, p_cuttingPoly:Array<Dynamic>, ?p_dbgDraw:Sprite = null) : Array<Dynamic>
	{
		p_dbgDraw.graphics.clear();
		
		var resultingPoly:Array<Dynamic> = new Array();
		
		// Copy the original polygons so they don't get modified.
		var subjectPolyCopy:Array<Dynamic> = p_subjectPoly.slice(0);
		var cuttingPolyCopy:Array<Dynamic> = p_cuttingPoly.slice(0);
			
		// Add the first vertex at the end of the polygon.
		subjectPolyCopy.push(subjectPolyCopy[0]);
		cuttingPolyCopy.push(cuttingPolyCopy[0]);
			
		var isInside:Bool = false;
		var innerVerticesAdded:Bool = false;
		
		// First we need to make sure that vertex 0 of the cutting polygon is not inside the subject polygon
		// We'll do that by shifting the vertices until it is outside
		var vert0Check:Dynamic = lineIntersectPoly(cuttingPolyCopy[0], cuttingPolyCopy[1], subjectPolyCopy);
		while(vert0Check.start_inside || vert0Check.Intersects) {
			cuttingPolyCopy.insert(0,cuttingPolyCopy.pop());
			vert0Check = lineIntersectPoly(cuttingPolyCopy[0], cuttingPolyCopy[1], subjectPolyCopy);
		}
		
		// And then the same thing goes for the subject poly
		var vert0Check:Dynamic = lineIntersectPoly(subjectPolyCopy[0], subjectPolyCopy[1], cuttingPolyCopy);
		while(vert0Check.start_inside || vert0Check.Intersects) {
			subjectPolyCopy.insert(0,subjectPolyCopy.pop());
			vert0Check = lineIntersectPoly(subjectPolyCopy[0], subjectPolyCopy[1], cuttingPolyCopy);
		}
		
		// We want our polys to in oposite vertex order
		if(isPolyClockwise(subjectPolyCopy))
			subjectPolyCopy.reverse();
		if(!isPolyClockwise(cuttingPolyCopy))
			cuttingPolyCopy.reverse();
		
		/* trace(isPolyClockwise(subjectPolyCopy));
		trace(isPolyClockwise(cuttingPolyCopy));
		
		p_dbgDraw.graphics.lineStyle(2, 0xFF0000);
		p_dbgDraw.graphics.moveTo(subjectPolyCopy[0].x, subjectPolyCopy[0].y);
		var wn:Int = 0;
		for(vertex in subjectPolyCopy) {
			p_dbgDraw.graphics.lineTo(vertex.x, vertex.y);
			var wntf:TextField = new TextField();
			untyped wntf.text=wn;
			wntf.width=15;
			wntf.height=15;
			wntf.x = vertex.x;
			wntf.y = vertex.y;
			p_dbgDraw.addChild(wntf);
			wn++;
		}
		
		p_dbgDraw.graphics.lineStyle(2, 0x0000FF);
		p_dbgDraw.graphics.moveTo(cuttingPolyCopy[0].x, cuttingPolyCopy[0].y);
		var wn:Int = 0;
		for(vertex in cuttingPolyCopy) {
			p_dbgDraw.graphics.lineTo(vertex.x, vertex.y);
			var wntf:TextField = new TextField();
			untyped wntf.text=wn;
			wntf.width=15;
			wntf.height=15;
			wntf.x = vertex.x;
			wntf.y = vertex.y;
			p_dbgDraw.addChild(wntf);
			wn++;
		} */
		
		// Check the subject poly for intersections with the cutting poly.
		// Add all vertices that are outside and the intersection points.
		for(i in 0...subjectPolyCopy.length) {
			if(i > 0) {
				var lip:Dynamic = lineIntersectPoly(subjectPolyCopy[i-1], subjectPolyCopy[i], cuttingPolyCopy);
				
				if(p_dbgDraw!=null) {
					
					// Determine if the current vertex is inside or outside of the cuting poly
					if(!lip.start_inside && !lip.end_inside) isInside = false;
					else if(!lip.start_inside && lip.end_inside) isInside = true;
					else if(lip.start_inside && lip.end_inside) isInside = true;
					else if(lip.start_inside && !lip.end_inside) isInside = false;
					
					// if this is the first vertex outside, we'll add the intersection vertex before this vertex
					if(!isInside && lip.start_inside)
						resultingPoly.push(lip.Intersections[0]);
					
					// Add vertices that are outside
					if(!isInside && !(lip.Intersects && !lip.start_inside && !lip.end_inside))
						resultingPoly.push(subjectPolyCopy[i]);
					
					// If this is the first vertex inside, add the intersection vertex,
					// and then the vertices from the cutting poly that is inside the subject
					if((isInside && !lip.start_inside) || (lip.Intersects && !lip.start_inside && !lip.end_inside)) {
						if(!(lip.Intersects && !lip.start_inside && !lip.end_inside))
							resultingPoly.push(lip.Intersections[0]);
						else
							resultingPoly.push(lip.Intersections[1]);
						
						if(!innerVerticesAdded) {
							// Check intersections for the cutting poly, and add the vertices that are inside the subject
							var isInside2:Bool = false;
							for(j in 0...cuttingPolyCopy.length) {
								if(j > 0) {
									var lip2:Dynamic = lineIntersectPoly(cuttingPolyCopy[j-1], cuttingPolyCopy[j], subjectPolyCopy);
									if(!lip2.start_inside && !lip2.end_inside) isInside2 = false;
									else if(!lip2.start_inside && lip2.end_inside) isInside2 = true;
									else if(lip2.start_inside && lip2.end_inside) isInside2 = true;
									else if(lip2.start_inside && !lip2.end_inside) isInside2 = false;
									// Add vertices that are inside
									if(isInside2)
										resultingPoly.push(cuttingPolyCopy[j]);
								}
							}
							
							if((lip.Intersects && !lip.start_inside && !lip.end_inside)) {
								resultingPoly.push(lip.Intersections[0]);
							}
							
							innerVerticesAdded = true;
						}
					}
					
					if((lip.Intersects && !lip.start_inside && !lip.end_inside))
						resultingPoly.push(subjectPolyCopy[i]);
					
				}
			}
		}
		
		return resultingPoly;
	}
	
	
	// Originally posted at http://keith-hair.net/blog/2008/08/04/find-Intersection-point-of-two-lines-in-as3/
	//---------------------------------------------------------------
	//Checks for Intersection of Segment if as_seg is true.
	//Checks for Intersection of Line if as_seg is false.
	//Return Intersection of Segment "AB" and Segment "EF" as a Dynamic
	//Return null if there is no Intersection
	//---------------------------------------------------------------
	public function lineIntersectLine(A:Dynamic,B:Dynamic,E:Dynamic,F:Dynamic,as_seg:Bool=true) : Dynamic
	{
		var ip:Dynamic;
		var a1:Float;
		var a2:Float;
		var b1:Float;
		var b2:Float;
		var c1:Float;
		var c2:Float;
		
		a1= B.y-A.y;
		b1= A.x-B.x;
		c1= B.x*A.y - A.x*B.y;
		a2 = F.y - E.y;
		b2= E.x-F.x;
		c2= F.x*E.y - E.x*F.y;
		
		var denom:Float=a1*b2 - a2*b1;
		if(denom == 0){
			return null;
		}
		ip = {
			x : (b1*c2 - b2*c1)/denom,
			y : (a2*c1 - a1*c2)/denom
		};
	 
		//---------------------------------------------------
		//Do checks to see if Intersection to endpoints
		//distance is longer than actual Segments.
		//Return null if it is with any.
		//---------------------------------------------------
		if(as_seg){
			if(lengthOfLine(ip, B) > lengthOfLine(A, B)){
				return null;
			}
			if(lengthOfLine(ip, A) > lengthOfLine(A, B)){
				return null;
			}	
			
			if(lengthOfLine(ip, F) > lengthOfLine(E, F)){
				return null;
			}
			if(lengthOfLine(ip, E) > lengthOfLine(E, F)){
				return null;
			}
		}
		return ip;
	}
	
	// Originally posted at http://keith-hair.net/blog/2008/08/04/find-Intersection-point-of-two-lines-in-as3/
	/*---------------------------------------------------------------------------
	Returns an Object with the following properties:
	intersects        -Boolean indicating if an intersection exists.
	start_inside      -Boolean indicating if Point A is inside of the polygon.
	end_inside       -Boolean indicating if Point B is inside of the polygon.
	intersections    -Array of intersection Points along the polygon.
	centroid          -A Point indicating "center of mass" of the polygon.
	 
	"pa" is an Array of Points.
	----------------------------------------------------------------------------*/
	public function lineIntersectPoly(A : Dynamic, B : Dynamic, p_pa:Array<Dynamic>):Dynamic
	{
		var An:Int=1;
		var Bn:Int=1;
		var C:Dynamic;
		var D:Dynamic;
		var i:Dynamic;
		var cx:Float=0;
		var cy:Float=0;
		
		// We don't want to modify the original array, so let's make a copy of the array and it's values
		var pa = p_pa.slice(0);
		
		var result:Dynamic = {Intersects:false, Intersections:[], start_inside:false, end_inside:false};
		//pa.push(pa[0]);
		var n:Int=pa.length-1;
		while(n > -1){
			C = pa[n];
			if(n > 0){
				cx+=C.x;
				cy+=C.y;
				D = ( pa[n-1] ? pa[n-1] : pa[0] );
				i=lineIntersectLine(A,B,C,D);
				if(i != null){
					result.Intersections.push(i);
				}
				if(lineIntersectLine(A,{x:C.x+D.x, y:A.y},C,D) != null){
					An++;
				}
				if(lineIntersectLine(B,{x:C.x+D.x, y:B.y},C,D) != null){
					Bn++;
				}
			}
			n--;
		}
		if(An % 2 == 0){
			result.start_inside=true;
		}
		if(Bn % 2 == 0){
			result.end_inside=true;
		}
		result.centroid={x:cx/(pa.length-1), y:cy/(pa.length-1)};
		result.Intersects = result.Intersections.length > 0;
		return result;
	}

}
