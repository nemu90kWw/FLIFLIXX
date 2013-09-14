
package fliflixx.object.common
{
	import fliflixx.object.CObject;
	import common.Mouse;
	import flash.display.BitmapData;
	
	public class CMenu extends CObject
	{
		public var item:Array = new Array();
		public var operate:Boolean = true;
		
		private var selected:CButton = null;
		private var decided:Boolean = false;
		
		override public function initialize():void
		{
			registerObject("DEPTH_MESSAGE", "PRIO_SYSTEM");
			
			changeAction("act_main");
			return;
		}
		
		public function addItem(font:String, label:String, x:Number, y:Number):CButton
		{
			var button:CButton = createObject(new CButton(font, label), x, y);
			item.push(button);
			return button;
		}
		
		public function isDecided():Boolean
		{
			return decided;
		}
		
		public function getSelectedItem():CButton
		{
			return selected;
		}
		
		// --------------------------------//
		// メイン
		// --------------------------------//
		public function act_main():void
		{
			for each(var btn:CButton in item)
			{
				if(btn.decided == true)
				{
					func_se.play("SE_HIT");
					selected = btn;
					
					//全ボタン無効化
					for(var i:String in item) {
						item[i].operate = false;
					}
					
					changeAction("act_decide");
				}
			}
			return;
		}
		
		public function act_decide():void
		{
			for each(var btn:CButton in item)
			{
				if(btn === selected)
				{
					if(count <= 12)
					{
						if(count % 6 < 3) {
							btn.visible = false;
						}
						else {
							btn.visible = true;
						}
					}
				}
				else {
					btn.visible = false;
				}
			}
			
			if(count == 20) {
				decided = true;
			}
			
			if(count == 21)
			{
				for(var i:String in item) {
					item[i].vanish();
				}
				vanish();
			}
			return;
		}
	}
}
