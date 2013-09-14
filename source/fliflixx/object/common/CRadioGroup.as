package fliflixx.object.common
{
	import fliflixx.object.CObject;
	import common.Mouse;
	import flash.display.BitmapData;
	
	public class CRadioGroup extends CObject
	{
		public var item:Object = new Object();
		public var operate:Boolean = true;
		
		private var selected:CRadioButton = null;
		private var decided:Boolean = false;
		
		override public function initialize():void
		{
			registerObject("DEPTH_MESSAGE", "PRIO_SYSTEM");
			
			changeAction("act_main");
			return;
		}
		
		public function addItem(font:String, label:String, x:Number, y:Number):CRadioButton
		{
			var button:CRadioButton = createObject(new CRadioButton(font, label), x, y, true);
			childlist.push(button);
			
			item[label] = button;
			return button;
		}
		
		public function setSelectedItem(label:String):void
		{
			for each(var btn:CRadioButton in item) {
				btn.selected = false;
			}
			item[label].selected = true;
			selected = item[label];
		}
		
		public function getSelectedItem():CRadioButton
		{
			return selected;
		}
		
		// --------------------------------//
		// メイン
		// --------------------------------//
		public function act_main():void
		{
			return;
		}
	}
}