
package fliflixx.object.maingame
{
	import flash.display.MovieClip;
	import fliflixx.asset.EbiflyAsset;
	import common.Mouse;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import common.Screen;
	import flash.geom.Point;
	
	public class CEbifly extends CGameObject
	{
		private static var asset:MovieClip;
		
		private var xscale:Number = 100;
		private var yscale:Number = 100;
		
		private var vx:Number = 0;
		private var vy:Number = 0;
		private var angle:Number = 0;
		
		private var combo:int = 0;
		
		private static var cell:Object;
		
		private var currentframe:uint = 0;
		private var anime_interval:uint = 3;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		override public function initialize():void
		{
			registerObject("DEPTH_MISSILE", "PRIO_MISSILE");
			
			actfunc_ref = "act_wait";
			return;
		}
		
		public static function standbyGraphics():void
		{
			asset = new EbiflyAsset();
			asset.stop();
			
			return;
		}
		
		// --------------------------------//
		// 待機中
		// --------------------------------//
		public function act_wait():void
		{
			angle = getAngle(Mouse.x, Mouse.y);
			return;
		}
		
		// --------------------------------//
		// メイン
		// --------------------------------//
		private var prevangle:Number;
		public function act_run():void
		{
			//初期化なし
			if(count == 0)
			{
				return;
			}
			
			if(count % 3 == 0)
			{
				var bearing:Number;
				prevangle = angle;
				
				if(getDistance(Mouse.x, Mouse.y) > 20)
				{
					angle = getAngle(Mouse.x, Mouse.y);
					
					//相対角度を取得
					bearing = MathEx.getBearing(prevangle, angle);
					/*
					bearing = prevangle-angle;
					if(bearing >= 128) {
						bearing -= 256;
					}
					else if(bearing <= -128) {
						bearing += 256;
					}
					*/
				}
				else {
					bearing = 0;
				}
				
				//加速
				var speed:Number;
				if(Mouse.down) {
					speed = 1.7;
				}
				else {
					speed = 0.9;
				}
				vx += MathEx.getVectorX(angle, speed);
				vy += MathEx.getVectorY(angle, speed);
				
				//減速
				var brake:Number;
				if(Mouse.down) {
					brake = 1.05 + (Math.abs(bearing)/80);
				}
				else {
					brake = 1.12 + (Math.abs(bearing)/260);
				}
				
				vx /= brake;
				vy /= brake;
			}
			
			//煙
			if(count % 6 == 0)
			{
				if(Mouse.down)
				{
					playSE("SE_SMOKE");
					createObject(
						new CSmoke(
							angle - 8 + Math.random() * 16,
							-10 - 2 + Math.random() * 4,
							vx / 2,
							vy / 2
						),
						Math.random() * 8 - 4,
						Math.random() * 8 - 4
					);
				}
			}
			
			//移動
			x += vx/3;
			y += vy/3;
			
			//拡縮
			if(count % 3 == 0)
			{
				xscale = (xscale * 3 + (110-getDistance(x+vx, y+vy)*2) + 100) / 5;
				yscale = (yscale * 3 + ( 80+getDistance(x+vx, y+vy)*4) + 100) / 5;
			}
	
			//敵が存在しない場合は判定しない
			if(getEnemyCount() == 0) {
				return;
			}
			
			if(getGameMode() == "SEQUENTIAL")
			{
				//時間切れ
				if(getTime() <= 0)
				{
					kill();
					return;
				}
			}
			
			//当たり判定
			if(collidedWithBlock(getX(), getY()) || collidedWithFrame(getX(), getY()))
			{
				kill();
				return;
			}
			
			var moglerlist:Array = getCollidedEnemies();
			for each(var mogler:CMogler in moglerlist)
			{
				playSE("SE_HIT");
				mogler.kill();
				
				if(getGameMode() == "SEQUENTIAL")
				{
					//スコア計算
					combo++;
					addScore((12+getStage()+combo) * Math.floor(getTime()));
				}
			}
			
			return;
		}
		
		override public function draw(screen:Screen):void
		{
			var matrix:Matrix = new Matrix();
			matrix.scale(xscale / 100, yscale / 100);
			matrix.rotate(Math.PI / 128 * angle);
			matrix.translate(x, y);
			
			asset.gotoAndStop(currentframe + 1);
			screen.buffer.draw(asset, matrix);
			
			anime_interval--;
			if(anime_interval <= 0)
			{
				currentframe = (currentframe + 1) % 8;
				anime_interval = 3;
			}
		}
		
		// --------------------------------//
		// ミス
		// --------------------------------//
		override public function kill():void
		{
			playSE("SE_EXPLOSION");
			
			createObject(new CExplosion(), 0, 0);
			vanish();
			return;
		}
	}
}
