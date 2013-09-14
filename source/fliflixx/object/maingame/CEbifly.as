
package fliflixx.object.maingame
{
	import fliflixx.object.maingame.CGameObject;
	import common.Mouse;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import common.Screen;
	import flash.geom.Point;
	
	public class CEbifly extends CGameObject
	{
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
			var sprite:Array = new Array();
			
			for(var i:int = 0; i < 5; i++)
			{
				sprite[i] = new Sprite();
			}
			
			//後ろ
			sprite[0].graphics.beginFill(0xF83038);
			sprite[0].graphics.moveTo(-6.3, -2.0);
			sprite[0].graphics.lineTo(-13.2, 11.8);
			sprite[0].graphics.lineTo(-4, 3.8);
			sprite[0].graphics.endFill();
			sprite[0].graphics.beginFill(0xF83038);
			sprite[0].graphics.moveTo(6.3, -2.0);
			sprite[0].graphics.lineTo(13.2, 11.8);
			sprite[0].graphics.lineTo(4, 3.8);
			sprite[0].graphics.endFill();
			
			sprite[1].graphics.beginFill(0xF83038);
			sprite[1].graphics.moveTo(-8.5, -2.0);
			sprite[1].graphics.lineTo(-15, 11);
			sprite[1].graphics.lineTo(-5.7, 3.5);
			sprite[1].graphics.endFill();
			sprite[1].graphics.beginFill(0xE02030);
			sprite[1].graphics.moveTo(4.8, -2.0);
			sprite[1].graphics.lineTo(10.7, 12);
			sprite[1].graphics.lineTo(2.6, 4.0);
			sprite[1].graphics.endFill();
			
			sprite[3].graphics.beginFill(0xE02030);
			sprite[3].graphics.moveTo(1.8, -2.0);
			sprite[3].graphics.lineTo(4.7, 13.2);
			sprite[3].graphics.lineTo(0, 4.5);
			sprite[3].graphics.endFill();
			
			sprite[4].graphics.beginFill(0xE02030);
			sprite[4].graphics.moveTo(0, 2);
			sprite[4].graphics.lineTo(-1.1, 4.4);
			sprite[4].graphics.lineTo(0, 13.2);
			sprite[4].graphics.lineTo(1.1, 4.4);
			sprite[4].graphics.endFill();
			
			//本体
			for(var i:int = 0; i < 5; i++)
			{
				sprite[i].graphics.beginFill(0xF8FF80);
				sprite[i].graphics.moveTo(0, -12);
				sprite[i].graphics.lineTo(5, -8.4);
				sprite[i].graphics.lineTo(6, 1.9);
				sprite[i].graphics.lineTo(4.2, 5.2);
				sprite[i].graphics.lineTo(1.4, 6.5);
				sprite[i].graphics.lineTo(-1.4, 6.5);
				sprite[i].graphics.lineTo(-4.2, 5.2);
				sprite[i].graphics.lineTo(-6, 1.9);
				sprite[i].graphics.lineTo(-5, -8.4);
				sprite[i].graphics.endFill();
			}
			
			//前側
			sprite[0].graphics.beginFill(0xFF4840);
			sprite[0].graphics.moveTo(0, 1.5);
			sprite[0].graphics.lineTo(-1.5, 4.4);
			sprite[0].graphics.lineTo(0, 13.2);
			sprite[0].graphics.lineTo(1.5, 4.4);
			sprite[0].graphics.endFill();
			
			sprite[1].graphics.beginFill(0xFF4840);
			sprite[1].graphics.moveTo(1.8, -1.4);
			sprite[1].graphics.lineTo(-0.3, 4.5);
			sprite[1].graphics.lineTo(4.7, 13.2);
			sprite[1].graphics.endFill();
			
			sprite[2].graphics.beginFill(0xFF4840);
			sprite[2].graphics.moveTo(-9.3, -2.1);
			sprite[2].graphics.lineTo(-16.2, 10.6);
			sprite[2].graphics.lineTo(-6.5, 3.1);
			sprite[2].graphics.endFill();
			sprite[2].graphics.beginFill(0xFF4840);
			sprite[2].graphics.moveTo(3.1, -1.4);
			sprite[2].graphics.lineTo(8.4, 12.9);
			sprite[2].graphics.lineTo(1.1, 4.5);
			sprite[2].graphics.endFill();
			
			sprite[3].graphics.beginFill(0xFF4840);
			sprite[3].graphics.moveTo(-8.5, -2);
			sprite[3].graphics.lineTo(-15.7, 10.9);
			sprite[3].graphics.lineTo(-5.7, 3.5);
			sprite[3].graphics.endFill();
			sprite[3].graphics.beginFill(0xFF4840);
			sprite[3].graphics.moveTo(4.8, -1.7);
			sprite[3].graphics.lineTo(10.7, 12);
			sprite[3].graphics.lineTo(2.6, 4);
			sprite[3].graphics.endFill();
			
			sprite[4].graphics.beginFill(0xFF4840);
			sprite[4].graphics.moveTo(-6.3, -2.0);
			sprite[4].graphics.lineTo(-13.8, 11.8);
			sprite[4].graphics.lineTo(-4, 3.8);
			sprite[4].graphics.endFill();
			sprite[4].graphics.beginFill(0xFF4840);
			sprite[4].graphics.moveTo(6.3, -2.0);
			sprite[4].graphics.lineTo(13.8, 11.8);
			sprite[4].graphics.lineTo(4, 3.8);
			sprite[4].graphics.endFill();
			
			cell = new Object();
			var matrix:Matrix = new Matrix();
			for(var j:int = 0; j < 256; j++)
			{
				cell[j] = new Array();
				
				for(var i:int = 0; i < 8; i++)
				{
					cell[j][i] = new BitmapData(32, 32, true, 0);
					
					matrix.identity();
					
					if(i < 5)
					{
						matrix.rotate(Math.PI/128*j);
						matrix.translate(16, 16);
						cell[j][i].draw(sprite[i], matrix);
					}
					else
					{
						matrix.scale(-1, 1);
						matrix.rotate(Math.PI/128*j);
						matrix.translate(16, 16);
						cell[j][i].draw(sprite[8-i], matrix);
					}
				}
			}
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
					for(var i:int = 0; i < 10; i++)
					{
						createObject(
							new CSmoke(
								angle-32+Math.random()*64,
								-16-4+Math.random()*8,
								vx/1.5,
								vy/1.5
							),
							MathEx.getVectorX(angle, -10)-3+Math.random()*6,
							MathEx.getVectorY(angle, -10)-3+Math.random()*6
						);
					}
				}
			}
			
			//移動
			x += vx/3;
			y += vy/3;
			
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
			var bmp:BitmapData = cell[Math.floor((angle+256+0.5)%256)][currentframe];
			screen.buffer.copyPixels(bmp, bmp.rect, new Point(x-16, y-16));
			
			anime_interval--;
			if(anime_interval <= 0)
			{
				currentframe = (currentframe+1)%8;
				anime_interval = 3;
			}
		}
		
		// --------------------------------//
		// ミス
		// --------------------------------//
		override public function kill():void
		{
			playSE("SE_EXPLOSION");
			
			for(var i:int; i < 64; i++)
			{
				createObject(new CSmoke(256/64*i, 12, 0, 0), MathEx.getVectorX(256/64*i, 30), MathEx.getVectorY(256/64*i, 30));
				createObject(new CSmoke(256/64*i, 8-(i%2)*2, 0, 0), MathEx.getVectorX(256/64*i, 20), MathEx.getVectorY(256/64*i, 20));
				createObject(new CSmoke(Math.random()*256, 4, 0, 0), MathEx.getVectorX(Math.random()*256, 100), MathEx.getVectorY(Math.random()*256, 100));
			}
			vanish();
			return;
		}
	}
}
