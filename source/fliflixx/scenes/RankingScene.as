
package fliflixx.scenes
{
	import common.Mouse;
	import common.Surface;
	import fliflixx.scenes.SceneBase;
	import fliflixx.system.Ranking;
	import fliflixx.system.Records;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Sprite;
	import fliflixx.system.GameData;
	import fliflixx.system.PlayData;
	
	public class RankingScene extends SceneBase
	{
		private var gamedata:GameData;
		private const RANKING_MAX:uint = 10;
		private const ranking:Ranking = PlayData.ranking;
		private const records:Records = PlayData.records;
		private var table:String = "";
		private var scorenum:Array = new Array();
		private var rank:*;
		private var bmp:BitmapData;
		private var currentframe:Number = 0;
		private static var cell:Array = new Array();
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function RankingScene(gamedata:GameData = null)
		{
			this.gamedata = gamedata;
			
			//文字入力用テーブル
			table += " ABCDEFGHIJKLMNOPQRSTUVWXYZabcde";
			table += "fghijklmnopqrstuvwxyz0123456789_";
			table += "-=+\\|[{]};:'\",<.>/?!@#$%^&*()~←㍗";
			
			bmp = new BitmapData(640, 400, true, 0);
			
			if(gamedata == null)
			{
				changeAction("ranking_view");
			}
			else
			{
				rank = ranking.isRankIn(gamedata.score);
				
				if (records.data.progress < (gamedata.stage - 1) * 8 + gamedata.area)
				{
					records.data.progress = (gamedata.stage - 1) * 8 + gamedata.area;
					records.saveData();
				}
				
				if(rank == false) {
					changeAction("ranking_view");
				}
				else {
					changeAction("ranking_entry");
				}
			}
			
			return;
		}
		
		public static function standbyGraphics():void
		{
			//mogler
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xA08000);
			sprite.graphics.drawCircle(40, 40, 39);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(0xB0A0C0);
			sprite.graphics.drawCircle(40-19, 40-9, 12.5);
			sprite.graphics.drawCircle(40+19, 40-9, 12.5);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(0x100020);
			sprite.graphics.drawCircle(40-17, 40-9, 10);
			sprite.graphics.drawCircle(40+17, 40-9, 10);
			sprite.graphics.endFill();
			sprite.graphics.lineStyle(2, 0x100020);
			sprite.graphics.moveTo(40-19, 40+14);
			sprite.graphics.curveTo(40-15, 40+23, 40, 40+24);
			sprite.graphics.curveTo(40+15, 40+23, 40+19, 40+14);
			
			var temp:BitmapData = new BitmapData(80, 80, true, 0);
			temp.draw(sprite);
			
			var src:BitmapData = new BitmapData(80, 400, true, 0);
			src.copyPixels(temp, temp.rect, new Point(0, 16+96*0));
			src.copyPixels(temp, temp.rect, new Point(0, 16+96*1));
			src.copyPixels(temp, temp.rect, new Point(0, 16+96*2));
			src.copyPixels(temp, temp.rect, new Point(0, 16+96*3));
			
			for(var i:int = 0; i < 112; i++)
			{
				var bmp:BitmapData = new BitmapData(80+40*2, 400, true, 0);
				for(var y:int = 0; y < 400; y++) {
					bmp.copyPixels(src, new Rectangle(0, y, 80+40*2, 1), new Point(40+Math.sin(Math.PI/56*(i+y/3))*40, y));
				}
				cell.push(bmp);
			}
			return;
		}
		
		// --------------------------------//
		// 表示更新
		// --------------------------------//
		public function ranking_update():void
		{
			bmp.fillRect(bmp.rect, 0);
			
			func_text.draw("16px_y", bmp, "RECORD OF HISCORES", 176, 48);
			func_text.draw("16px_y", bmp, "RANK SCORE    NAME    STAGE   DATE", 32, 80);
			bmp.fillRect(new Rectangle(16,    96+8, 16*38, 1), 0xFFFFFFFF);
			bmp.fillRect(new Rectangle(16+1,  96+9, 16*38, 1), 0xFF000000);
			bmp.fillRect(new Rectangle(16,   272+8, 16*38, 1), 0xFFFFFFFF);
			bmp.fillRect(new Rectangle(16+1, 272+9, 16*38, 1), 0xFF000000);
			//func_text.draw("16px", bmp, "--------------------------------------", 16, 96);
			//func_text.draw("16px", bmp, "--------------------------------------", 16, 272);
			
			//ランキング表示
			for(var i:int = 1; i <= RANKING_MAX; i++)
			{
				var rank:String;
				switch(i)
				{
				case 1  : rank = " 1st";break;
				case 2  : rank = " 2nd";break;
				case 3  : rank = " 3rd";break;
				default : rank = " "+i+"th";break;
				case 10 : rank = "10th";break;
				}
				func_text.draw("16px", bmp, rank, 24, 112+(i-1)*16);
				
				var score:String = MathEx.addZero(ranking.data.score[i], 6);
				func_text.draw("16px", bmp, score, 104, 112+(i-1)*16);
				
				func_text.draw("16px", bmp, ranking.data.name[i], 216, 112+(i-1)*16);
				func_text.draw("16px", bmp, ranking.data.stage[i], 384, 112+(i-1)*16);
				func_text.draw("16px", bmp, ranking.data.date[i], 480, 112+(i-1)*16);
			}
			
			return;
		}
		
		// --------------------------------//
		// 表示のみ（クリックでタイトル行き）
		// --------------------------------//
		public function ranking_view():void
		{
			if(count == 0) {
				ranking_update();
			}
			else {
				if(Mouse.press) {
					changeAction_fadeout("ranking_end");
				}
			}
			
			return;
		}
		
		// --------------------------------//
		// タイトルに戻る
		// --------------------------------//
		public function ranking_end():void
		{
			func_obj.removePriority("PRIO_FRAME");
			changeScene(new TitleScene());
			
			return;
		}
		
		// --------------------------------//
		// 名前入力
		// --------------------------------//
		private const TABLE_X:uint = 64;
		private const TABLE_Y:uint = 312;
		private const TABLE_WIDTH:uint = 32;
		private const TABLE_HEIGHT:uint = 3;
		private const TABLE_CHIPSIZE:uint = 16;
		private var mc_entrycursor:CCursor;
		private var mc_tablecursor:CCursor;
		private var namestr:String = "";
		private var writepos:uint = 0;
		public function ranking_entry():void
		{
			//初期化
			if(count == 0)
			{
				func_bgm.play("BGM_RANKING");
				
				ranking.insert(rank, gamedata.score, gamedata.stage, gamedata.area);
				ranking_update();
				var txt:String = table.substr(0, TABLE_WIDTH)+"\n"+table.substr(TABLE_WIDTH, TABLE_WIDTH)+"\n"+table.substr(TABLE_WIDTH*2, TABLE_WIDTH);
				func_text.draw("16px", bmp, txt, TABLE_X, TABLE_Y);
				
				mc_entrycursor = createObject(new CCursor());
				mc_entrycursor.x = 216;
				mc_entrycursor.y = 112 + (16*(rank-1));
				
				mc_tablecursor = createObject(new CCursor());
				mc_tablecursor.x = TABLE_X;
				mc_tablecursor.y = TABLE_Y;
			}
			
			//文字選択
			if(Mouse.x > TABLE_X && Mouse.y > TABLE_Y && Mouse.x < TABLE_X + (TABLE_CHIPSIZE*TABLE_WIDTH) && Mouse.y < TABLE_Y + (TABLE_CHIPSIZE*TABLE_HEIGHT))
			{
				var point_x:Number = Math.floor((Mouse.x - TABLE_X) / TABLE_CHIPSIZE);
				var point_y:Number = Math.floor((Mouse.y - TABLE_Y) / TABLE_CHIPSIZE);
				
				mc_tablecursor.x = TABLE_X + point_x * TABLE_CHIPSIZE;
				mc_tablecursor.y = TABLE_Y + point_y * TABLE_CHIPSIZE;
				mc_tablecursor.visible = true;
				
				//入力
				if(Mouse.press)
				{
					func_se.play("SE_HIT");
					var char:String = table.charAt(point_x + point_y * TABLE_WIDTH);
					
					switch(char) {
					default:
						var str:String = namestr;
						namestr = str.slice(0,writepos)+char+str.slice(writepos+1);		//上書き
						
						bmp.fillRect(new Rectangle(mc_entrycursor.x, mc_entrycursor.y, 16, 16), 0x188000);
						func_text.draw("16px", bmp, char, mc_entrycursor.x, mc_entrycursor.y);
						
						if(writepos < 9)
						{
							writepos++;
							mc_entrycursor.x += TABLE_CHIPSIZE;
						}
						break;
					//戻る
					case "←":
						if(writepos > 0)
						{
							writepos--;
							mc_entrycursor.x -= TABLE_CHIPSIZE;
						}
						break;
					//決定
					case "㍗":
						ranking.data.name[rank] = namestr;
						ranking.saveData();
						
						mc_entrycursor.vanish();
						mc_tablecursor.vanish();
						
						changeAction("ranking_view");
						break;
					}
				}
			}
			else {
				mc_tablecursor.visible = false;
			}
			
			return;
		}
		
		override public function draw():void
		{
			screen.buffer.fillRect(screen.buffer.rect, 0x106800);
			for(var x:int = -96; x < 640; x += 96) {
				var c:BitmapData = cell[Math.floor(currentframe)];
				screen.buffer.copyPixels(c, c.rect, new Point(x, 0));
			}
			currentframe += 1/3;
			if(currentframe >= cell.length) {currentframe -= cell.length;}
			
			screen.buffer.copyPixels(bmp, bmp.rect, new Point(0, 0));
			func_obj.draw();
		}
	}
}

import fliflixx.object.CObject;
import common.Surface;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Point;

class CCursor extends CObject
{
	private var rect:BitmapData = new BitmapData(16, 16, false, 0xFFFFFFFF);
	private var matrix:Matrix = new Matrix();
	
	override public function initialize():void
	{
		registerObject("DEPTH_FRAME", "PRIO_FRAME");
	}
	
	override public function draw(screen:Surface):void
	{
		if(visible == false) {return;}
		
		if(count % 12 < 4) {
			screen.buffer.copyPixels(rect, rect.rect, new Point(x, y));
		}
		else if(count % 12 < 8)
		{
			matrix.identity();
			matrix.translate(x, y);
			screen.buffer.draw(rect, matrix, null, "invert");
		}
		return;
	}
}
