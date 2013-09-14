package fliflixx.object.maingame
{
	import fliflixx.object.CObject;
	
	public class CGameObject extends CObject
	{
		// --------------------------------//
		// やられ
		// --------------------------------//
		public function kill():void
		{
			vanish();
			return;
		}
		
		// --------------------------------//
		// データ取得
		// --------------------------------//
		public function getGameMode():String {return scene.gamedata.mode;}
		public function getStage():int {return scene.gamedata.stage;}
		public function getArea():int {return scene.gamedata.area;}
		public function getTime():Number {return scene.gamedata.time;}
		public function getScore():int {return scene.gamedata.score;}
		
		public function getEnemyCount():int {
			return scene.func_obj.searchPriority("PRIO_ENEMY").length;
		}
		
		// --------------------------------//
		// データ操作
		// --------------------------------//
		public function addScore(num:int):void
		{
			scene.gamedata.score += num;
			return;
		}
		
		// --------------------------------//
		// 角度
		// --------------------------------//
		public function getAngle(x:Number, y:Number, seido:uint = 0):Number
		{
			var tempx:Number = x-getX();
			var tempy:Number = y-getY();
			
			if(seido == 0) {
				return (Math.atan2(tempy, tempx)*128/Math.PI)+64;
			}
			else {
				return (Math.round((Math.atan2(tempy, tempx)*128/Math.PI)/(256/seido))*(256/seido))+64;
			}
		}
		
		public function getDistance(x:Number, y:Number):Number
		{
			var tempx:Number = getX()-x;
			var tempy:Number = getY()-y;
			return Math.sqrt((tempx)*(tempx)+(tempy)*(tempy));
		}
		
		// --------------------------------//
		// 当たり判定
		// --------------------------------//
		public function getCollidedEnemies():Array
		{
			var enemylist:Array = scene.func_obj.searchPriority("PRIO_ENEMY");
			var result:Array = new Array();
			
			for each(var enemy:CMogler in enemylist)
			{
				if(getDistance(enemy.getX(), enemy.getY()) < 40)
				{
					result.push(enemy);
				}
			}
			return result;
		}
		
		public function collidedWithBlock(x:Number, y:Number):Boolean
		{
			var blocklist:Array = scene.func_obj.searchPriority("PRIO_BLOCK");
			var left:Number;
			var right:Number;
			var top:Number;
			var bottom:Number;
			for each(var block:CBlock in blocklist)
			{
				left   = block.getX() - block.width/2;
				right  = block.getX() + block.width/2+1;
				top    = block.getY() - block.height/2;
				bottom = block.getY() + block.height/2+1;
				//*
				if(left < x && right > x && top < y && bottom > y) {
					return true;
				}
				/*/
				var a:int = (left - x) & (x - right) & (top - y) & (y - bottom);
				
				if(a < 0) {
					return true;
				}
				//*/
			}
			return false;
		}
		
		public function collidedWithFrame(x:Number, y:Number):Boolean
		{
			if(16 > x ||  624 < x || 48 > y || 384 < y) {
				return true;
			}
			else {
				return false
			}
		}
		/*
		public function hitCheck(prio:String):Array
		{
			var obj = func_obj.searchPriority(prio);
			var result = new Array();
			
			for(var i in obj)
			{
				if(this.hitrect.hitTest(obj[i].hitrect) == true)
				{
					if(obj[i].isInsideScreen())
					{
						result.push(obj[i]);
					}
				}
			}
			
			return result;
		}
		*/
	}
}