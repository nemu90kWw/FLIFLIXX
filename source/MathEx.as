
package
{
	public class MathEx
	{
		public static function getVectorX(dir:Number, speed:Number):Number
		{
			return Math.cos(Math.PI/128*(dir+192))*speed;
		}
		
		public static function getVectorY(dir:Number, speed:Number):Number
		{
			return Math.sin(Math.PI/128*(dir+192))*speed;
		}
		
		public static function getBearing(dir1:Number, dir2:Number):Number
		{
			var d1:Number = normalizeAngle(dir1);
			var d2:Number = normalizeAngle(dir2);
			
			if(d2-128 > d1) {d1 += 256;}
			if(d2+128 < d1) {d1 -= 256;}
			
			return d1-d2;
		}
		
		public static function normalizeAngle(dir:Number):Number
		{
			if (dir < -128) {
				dir = 256 - (-dir % 256);
		    }
			dir = (dir + 128) % 256 - 128;
			return dir;
		}
		
		public static function addZero(num:Number, digit:int):String
		{
			if(num.toString().length <= digit) {
				return (1<<(digit-String(num).length)).toString(2).substr(1)+num;
			}
			else {
				return String(Math.pow(10, digit)-1);	//カンスト
			}
		}
	}
}
