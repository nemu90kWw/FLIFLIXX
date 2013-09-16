
package fliflixx.scenes
{
	import common.Mouse;
	import fliflixx.system.Database;
	import fliflixx.object.common.CFrame;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import fliflixx.object.common.CButton;
	import fliflixx.object.common.CMenu;
	import fliflixx.system.BestRecords;
	import fliflixx.object.common.CRadioGroup;
	import fliflixx.system.PlayData;
	
	public class TitleScene extends SceneBase
	{
		private const records:BestRecords = PlayData.records;
		
		private var bmp:BitmapData = new BitmapData(640, 400, true, 0);
		private var bmp_logo:BitmapData = Database.getItem("BMP_TITLELOGO");
		
		private var menu:CMenu;
		private var radio:CRadioGroup;
		private var selectedstage:String;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function TitleScene()
		{
			func_bgm.stop();
			createObject(new CFrame(1));
			
			changeAction("act_mainmenu");
			return;
		}
		
		// --------------------------------//
		// メニュー
		// --------------------------------//
		public function act_mainmenu():void
		{
			if(count == 0)
			{
				bmp.fillRect(bmp.rect, 0);
				bmp.copyPixels(bmp_logo, bmp_logo.rect, new Point(16, 80));
				func_text.draw("16px", bmp, "for AS3", 400, 172);
				func_text.draw("16px", bmp, "BGM-TYPE", 320-(8*16/2), 320);
				func_text.draw("8px", bmp, "FLIXX-like visual & FLIXX-like music", 320-(36*8/2), 60);
				func_text.draw("16px", bmp, "Programmed by nemu90kWw.", 320-(24*16/2), 376);
				
				//メニュー作成
				menu = createObject(new CMenu());
				menu.addItem("16px", "GAME START", 320, 230);
				menu.addItem("16px", "PRACTICE", 320, 255);
				menu.addItem("16px", "LOCAL RANKING", 320, 280);
				
				radio = createObject(new CRadioGroup());
				radio.addItem("16px", "ORIGINAL", 258, 350);
				radio.addItem("16px", "FAMICOM", 390, 350);
				
				radio.setSelectedItem(PlayData.option.data.bgmtype);
			}
			
			//決定
			if(menu.isDecided() == true)
			{
				switch(menu.getSelectedItem().label) {
				case "GAME START": changeAction_fadeout("act_gotomaingame"); break;
				case "PRACTICE": changeAction("act_stageselect"); break;
				case "LOCAL RANKING": changeAction_fadeout("act_gotoranking"); break;
				}
			}
			
			//文字消し
			if(menu.getSelectedItem() != null)
			{
				PlayData.option.data.bgmtype = radio.getSelectedItem().label;
				PlayData.option.saveData();
				radio.vanish();
				
				bmp.fillRect(bmp.rect, 0);
				bmp.copyPixels(bmp_logo, bmp_logo.rect, new Point(16, 80));
			}
			return;
		}
		
		public function act_stageselect():void
		{
			if(count == 0)
			{
				var progress:int = 0;
				
				bmp.fillRect(bmp.rect, 0);
				bmp.copyPixels(bmp_logo, bmp_logo.rect, new Point(16, 80));
				
				//メニュー作成
				menu = createObject(new CMenu());
				menu.addItem("16px", "RETURN TO MAINMENU", 320, 376);
				
				for (var i:int = 1; i <= 5; i++)
				{
					for (var j:int = 1; j <= 8; j++)
					{
						var item:CButton;
						if (i != 5) {
							item = menu.addItem("16px", i.toString() + "-" + j.toString(), -4 + j * 72, 156 + i * 36);
						}
						else {
							item = menu.addItem("16px", "Ex" + j.toString(), -4 + j * 72, 156 + i * 36);
						}
						
						var time:Number = records.data.record[i%5][j];
						var sec:String = MathEx.addZero(Math.floor(time), 2);
						var dn:String  = MathEx.addZero(Math.floor(time*100 % 100), 2);
						
						func_text.draw("8px", bmp, "rec"+sec+"."+dn, -36+j*72, 164+i*36);
					}
				}
			}
			
			//決定
			if(menu.isDecided() == true)
			{
				switch(menu.getSelectedItem().label) {
				default:
					selectedstage = menu.getSelectedItem().label;
					changeAction_fadeout("act_gotoselectedstage");
					break;
				case "RETURN TO MAINMENU": changeAction("act_mainmenu"); break;
				}
			}
			
			//文字消し
			if(menu.getSelectedItem() != null)
			{
				bmp.fillRect(bmp.rect, 0);
				bmp.copyPixels(bmp_logo, bmp_logo.rect, new Point(16, 80));
			}
			return;
		}
		
		// --------------------------------//
		// シーン移動
		// --------------------------------//
		public function act_gotomaingame():void
		{
			changeScene(new MainGameScene("SEQUENTIAL", 1, 1));
			return;
		}
		
		public function act_gotoselectedstage():void
		{
			changeScene(new MainGameScene("SINGLE", int(selectedstage.charAt(0)), int(selectedstage.charAt(2))));
			return;
		}
		
		public function act_gotoranking():void
		{
			changeScene(new RankingScene());
			return;
		}
		
		// --------------------------------//
		// 描画
		// --------------------------------//
		override public function draw():void
		{
			screen.buffer.fillRect(screen.buffer.rect, 0);
			func_obj.draw();
			screen.buffer.copyPixels(bmp, bmp.rect, new Point(0, 0));
			return;
		}
	}
}
