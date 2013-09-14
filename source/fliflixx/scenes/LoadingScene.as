package fliflixx.scenes
{
	import common.BitmapText;
	import common.MultiLoader;
	import common.AppInfo;
	import fliflixx.system.Database;
	import fliflixx.object.common.*;
	import fliflixx.object.maingame.*;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.net.LocalConnection;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	
	public class LoadingScene extends SceneBase
	{
		private var loader:MultiLoader = new MultiLoader();
		private var itemlist:Array = new Array();
		private var localconnection:LocalConnection = new LocalConnection();
		private var systext:String = "";
		
		public function LoadingScene():void
		{
			changeAction("act_standbyloading");
			return;
		}
		
		// --------------------------------//
		// 描画
		// --------------------------------//
		override public function draw():void
		{
			screen.buffer.fillRect(screen.buffer.rect, 0);
			if(systext != "") {
				func_text.draw("16px", screen.buffer, systext, 8, 400-24);
			}
		}
		
		// --------------------------------//
		// ローディングに必要なものを読込
		// --------------------------------//
		public function act_standbyloading():void
		{
			if(count == 0)
			{
				loader.loadBitmap("BMP_16PXTEXT", "graphic/text_16x16.png");
				
				//読み込みテーブル
				itemlist.push({type:"BITMAP", name:"BMP_TITLELOGO", url:"graphic/titlelogo.png"});
				itemlist.push({type:"BITMAP", name:"BMP_MINILOGO", url:"graphic/minilogo.png"});
				itemlist.push({type:"SOUND", name:"SE_EXPLOSION", url:"se/sqbomb.mp3"});
				itemlist.push({type:"SOUND", name:"SE_HIT", url:"se/fx4.mp3"});
				itemlist.push({type:"SOUND", name:"SE_SMOKE", url:"se/sqsmoke.mp3"});
				itemlist.push({type:"SWF", name:"SWF_BGMLIBRARY", url:"bgm.swf"});
				itemlist.push({type:"XML", name:"XML_STAGEDATA", url:"stagedata.xml"});
			}
			
			if(loader.isComplete())
			{
				Database.addItem("BMP_16PXTEXT", loader.getContent("BMP_16PXTEXT"));
				
				//テーブル作成
				var table_16px:String = ""
				+ " ABCDEFGHIJKLMNOPQRSTUVWXYZabcde"
				+ "fghijklmnopqrstuvwxyz0123456789_"
				+ "-=+\\|[{]};:'\",<.>/?!@#$%^&*()~←㍗";
				
				//通常テキスト
				func_text.addFont("16px",   Database.getItem("BMP_16PXTEXT"),   table_16px, 16, 16);
				
				//横幅半分テキスト
				var tempbmp:BitmapData = new BitmapData(256, 48, true, 0);
				var matrix:Matrix = new Matrix();
				matrix.scale(0.5, 1);
				tempbmp.draw(Database.getItem("BMP_16PXTEXT"), matrix);
				func_text.addFont("8px", tempbmp, table_16px, 8, 16);
				
				//黄色テキスト
				var ybmp:BitmapData = Database.getItem("BMP_16PXTEXT").clone();
				ybmp.colorTransform(ybmp.rect, new ColorTransform(1, 1, 1, 1, -8-128, -56, -192-56, 0));
				ybmp.colorTransform(ybmp.rect, new ColorTransform(1, 1, 1, 1, 128, 56, 56, 0));
				func_text.addFont("16px_y", ybmp, table_16px, 16, 16);
				
				if(localconnection.domain == "localhost") {
					changeAction("act_localloading");
				}
				else {
					changeAction("act_networkloading");
				}
			}
		}
		
		// --------------------------------//
		// 各種データ読み込み
		// --------------------------------//
		private var item:Object = null;
		
		//ネットワーク上では１つづつ読み込む
		public function act_networkloading():void
		{
			if(item == null)
			{
				item = itemlist.shift();
				loader.load(item.type, item.name, item.url);
				
				systext = "NOWLOADING... "+item.name;
			}
			
			if(loader.isError())
			{
				changeAction("act_error");
				return;
			}
			
			if(loader.isComplete())
			{
				switch(item.type)
				{
				default: Database.addItem(item.name, loader.getContent(item.name)); break;
				case "SOUND": func_se.addSound(item.name, loader.getContent(item.name)); break;
				}
				
				item = null;
				
				//ロード完了
				if(itemlist.length == 0)
				{
					systext = "WAIT...";
					changeAction("act_standbygrphics");
					return;
				}
			}
		}
		
		//ローカルではまとめて読み込む
		public function act_localloading():void
		{
			if(count == 0)
			{
				for each(var item:Object in itemlist)
				{
					loader.load(item.type, item.name, item.url);
				}
			}
			
			if(loader.isError())
			{
				changeAction("act_error");
				return;
			}
				
			if(loader.isComplete())
			{
				for each(var item:* in itemlist)
				{
					switch(item.type)
					{
					default: Database.addItem(item.name, loader.getContent(item.name)); break;
					case "SOUND": func_se.addSound(item.name, loader.getContent(item.name)); break;
					}
				}
				
				changeAction("act_standbygrphics");
				return;
			}
		}
		
		public function act_error():void
		{
			if(count == 0)
			{
				systext = "";
				
				for each(var name:String in loader.getErrorFiles())
				{
					systext += "\nERROR! NOT FOUND - "+name;
				}
			}
		}
		
		// --------------------------------//
		// オブジェクトのBMP作成
		// --------------------------------//
		private var objlist:Array = new Array
		(
			CEbifly,
			CMogler,
			CFrame,
			RankingScene,
			AllClearScene
		);
		
		private var cls:* = null;
		public function act_standbygrphics():void
		{
			//フレームごとに処理を分散
			if(cls == null)
			{
				cls = objlist.shift();
				systext = "STANDBY... "+describeType(cls).@name.split("::")[1];	//クラス名取得
			}
			else
			{
				cls.standbyGraphics();
				cls = null;
				
				if(objlist.length == 0) {
					changeAction("act_tunefps");
				}
			}
		}
		
		// --------------------------------//
		// FPS調整
		// --------------------------------//
		private var destfps:Number;
		private var pretimer:Number;
		
		public function act_tunefps():void
		{
			if(count == 0)
			{
				destfps = AppInfo.frameRate;
				pretimer = getTimer();
			}
			else if(count % 18 == 0)
			{
				var timer:Number = getTimer()-pretimer;
				systext = "WAIT... "+(1000/destfps*18)+" / "+timer.toString();
				pretimer = getTimer();
				
				if(timer < (1000/destfps*18)-20)	//早すぎる
				{
					AppInfo.frameRate -= 2.5;
				}
				else if(timer > (1000/destfps*18)+20)	//遅すぎる
				{
					AppInfo.frameRate += 5;
				}
				else	//丁度
				{
					systext = "";
					changeAction("act_gotomaingame");
					return;
				}
			}
			
			if(count == 18*16)	//時間切れ
			{
				changeAction("act_gotomaingame");
				return;
			}
		}
		
		// --------------------------------//
		// シーン変更
		// --------------------------------//
		public function act_gotomaingame():void
		{
			changeScene(new InitializeScene());
		}
	}
}