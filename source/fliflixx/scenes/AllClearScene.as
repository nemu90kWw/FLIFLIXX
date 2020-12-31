
package fliflixx.scenes
{
	import flash.display.Sprite;
	import common.Surface;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import fliflixx.system.GameData;
	
	public class AllClearScene extends SceneBase
	{
		private var gamedata:GameData;
		private static var matrix:Matrix = new Matrix();
		private static var cell:Array = new Array();
		private static var sprite:Sprite;
		private var currentframe:uint = 0;
		private var anime_interval:uint = 12;
		private var rotation:int = 0;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function AllClearScene(gamedata:GameData)
		{
			this.gamedata = gamedata;
			
			func_bgm.play("BGM_ALLCLEAR");
			
			cursor._visible = false;
			changeAction("act_wait");
			return;
		}
		
		public static function standbyGraphics():void
		{
			var circlecolor:Array = new Array
			(
				0xFC7186,
				0xEA9425,
				0x7FB25A,
				0x20AB8D,
				0x3E84B4,
				0x9453EA,
				0xEC4CD2
			);
			var circleanime:Array = new Array();
			
			//●の配置
			for(var i:int = 0; i < circlecolor.length; i++)
			{
				var temp:Sprite = new Sprite();
				var size:Number = 8.7;
				var y:Number = 42;
				for(var j:int = 0; j < 9; j++)
				{
					temp.graphics.beginFill(circlecolor[(j+i) % circlecolor.length]);
					temp.graphics.drawCircle(0, y-8, size);
					temp.graphics.endFill();
					
					size *= 1.3;
					y *= 1.3;
				}
				circleanime.push(temp);
			}
			/*
			//●の配置
			for(var i:int = 0; i < circlecolor.length; i++)
			{
				var temp:Sprite = new Sprite();
				var size:Number = 8.5;
				var y:Number = 36;
				for(var j:int = 0; j < 20; j++)
				{
					temp.graphics.beginFill(circlecolor[(j+i) % circlecolor.length]);
					temp.graphics.drawCircle(0, y, size);
					temp.graphics.endFill();
					
					size *= 1.15;
					y *= 1.15;
				}
				circleanime.push(temp);
			}
			*/
			
			//全体のアニメーション
			for(var j:int = 0; j < circlecolor.length; j++)
			{
				cell[j] = new BitmapData(640, 400, false, 0x188000);
				for(var i:int = 0; i < circlecolor.length*2; i++)
				{
					matrix.identity();
					matrix.rotate(Math.PI/circlecolor.length*-i);
					matrix.translate(320, 200);
					cell[j].draw(circleanime[circlecolor.length-1-((i+j) % circlecolor.length)], matrix);
				}
			}
			
			//mogler
			sprite = new Sprite();
			sprite.graphics.beginFill(0xFFE000);
			sprite.graphics.drawCircle(0, 0, 32);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(0xFFFFFF);
			sprite.graphics.drawCircle(-15, -9.5, 10);
			sprite.graphics.drawCircle( 15, -9.5, 10);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(0x000000);
			sprite.graphics.drawCircle(-13.2, -10, 7.5);
			sprite.graphics.drawCircle( 13.2, -10, 7.5);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(0xF00040);
			sprite.graphics.drawCircle(0, 13, 12);
			sprite.graphics.endFill();
			
			return;
		}
		
		// --------------------------------//
		// 待機
		// --------------------------------//
		public function act_wait():void
		{
			if(count == 390) {
				changeAction_fadeout("act_gotoranking");
			}
			
			return;
		}
		
		// --------------------------------//
		// ランキングへ
		// --------------------------------//
		public function act_gotoranking():void
		{
			cursor._visible = true;
			changeScene(new RankingScene(gamedata));
			return;
		}
		
		override public function draw():void
		{
			screen.buffer.copyPixels(cell[currentframe], cell[currentframe].rect, new Point(0, 0));
			
			anime_interval--;
			if(anime_interval <= 0)
			{
				currentframe = (currentframe+1)%cell.length;
				anime_interval = 12;
			}
			
			matrix.identity();
			matrix.rotate(Math.PI/180*rotation);
			matrix.translate(320, 200);
			screen.buffer.draw(sprite, matrix);
			rotation += 2;
			
			var score:String = MathEx.addZero(gamedata.score, 6);
			func_text.draw("16px", screen.buffer, "YOUR SCORE IS\n\n "+score+" pts.\n\n\n\n\n\n\n ", 216, 64);
			func_text.draw("16px", screen.buffer, "Congratulations!!", 184, 304);
		}
	}
}
