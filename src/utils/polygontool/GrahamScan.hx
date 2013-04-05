/**
 *  Use this class freely - 2009 blog.efnx.com
 *
 *  Ported to haXe by Joacim Magnusson www.splashdust.net
 */

package src.utils.polygontool;
   
class GrahamScan
{
	/**
	*  The Graham scan is a method of computing the convex hull of a finite set of points
	*  in the plane with time complexity O(n log n). It is named after Ronald Graham, who
	*  published the original algorithm in 1972. The algorithm finds all vertices of
	*  the convex hull ordered along its boundary. It may also be easily modified to report
	*  all input points that lie on the boundary of their convex hull.
	*/
	
	public function new(){}
	
	/**
	*  Returns a convex hull given an unordered array of points.
	*/
	public function convexHull(data:Array<Dynamic>):Array<Dynamic>
	{
		return findHull( order(data) );
	}
	
	/**
	*  Orders an array of points counterclockwise.
	*/
	public function order(data:Array<Dynamic>):Array<Dynamic>
	{
		//trace("GrahamScan::order()");
		// first run through all the points and find the upper left [lower left]
		var p = data[0];
		var n:Int = data.length;
		for (i in 0...n)
		{
			//trace("   p:",p,"d:",data[i]);
			if(data[i].y < p.y)
			{
				//trace("   d.y < p.y / d is new p.");
				p = data[i];
			}
			else if(data[i].y == p.y && data[i].x < p.x)
			{
				//trace("   d.y == p.y, d.x < p.x / d is new p.");
				p = data[i];
			}
		}
		// next find all the cotangents of the angles made by the point P and the
		// other points
		var sorted  :Array<Dynamic> = new Array();
		// we need arrays for positive and negative values, because Array.sort
		// will put sort the negatives backwards.
		var pos     :Array<Dynamic> = new Array();
		var neg     :Array<Dynamic> = new Array();
		// add points back in order
		for (i in 0...n)
		{
			var a   :Float = data[i].x - p.x;
			var b   :Float = data[i].y - p.y;
			var cot :Float = b/a;
			if(cot < 0)
				neg.push({point:data[i], cotangent:cot});
			else
				pos.push({point:data[i], cotangent:cot});
		}
		// sort the arrays
		//untyped pos.sortOn("cotangent", Array.NUMERIC | Array.DESCENDING);
		//untyped neg.sortOn("cotangent", Array.NUMERIC | Array.DESCENDING);
		pos.sort(function(x,y){
			return x.cotangent - y.cotangent;
		});
		neg.sort(function(x,y):Int{
			return x.cotangent - y.cotangent;
		});
		sorted = neg.concat(pos);
		
		var ordered :Array<Dynamic> = new Array();
		ordered.push(p);
		for (i in 0...n)
		{
			if(p == sorted[i].point)
				continue;
			ordered.push(sorted[i].point);
		}
		return ordered;
	}
	/**
	*  Given and array of points ordered counterclockwise, findHull will
	*  filter the points and return an array containing the vertices of a
	*  convex polygon that envelopes those points.
	*/
	public function findHull(data:Array<Dynamic>):Array<Dynamic>
	{
		//trace("GrahamScan::findHull()");
		var n   :Int    = data.length;
		var hull:Array<Dynamic>  = new Array();
		hull.push(data[0]); // add the pivot
		hull.push(data[1]); // makes first vector
		
		trace(hull.length);
		
		for (i in 2...n)
		{
			while(direction(hull[hull.length - 2], hull[hull.length - 1], data[i]) > 0)
				hull.pop();
			hull.push(data[i]);
		}
		
		return hull;
	}
	/**
	*
	*/
	private function direction(p1:Dynamic, p2:Dynamic, p3:Dynamic):Float
	{
		trace(p1);
		trace(p2);
		trace(p3);
		// > 0  is right turn
		// == 0 is collinear
		// < 0  is left turn
		// we only want right turns, usually we want right turns, but
		// flash's grid is flipped on y.
		return (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x);
	}
}
