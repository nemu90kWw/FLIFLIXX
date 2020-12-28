package fliflixx.system 
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class Menu extends EventDispatcher
	{
		private var nativeWindow:NativeWindow;
		
		private var menu:NativeMenu = new NativeMenu();
		private var fileMenu:NativeMenu = new NativeMenu();
		private var helpMenu:NativeMenu = new NativeMenu();
		
		private function createMenuItem(label:String, mnemonic:String = ""):NativeMenuItem
		{
			var item:NativeMenuItem = new NativeMenuItem(label);
			
			if (mnemonic != "")
			{
				item.label += "(" + mnemonic + ")";
				item.mnemonicIndex = item.label.length - 2;
			}
			
			return item;
		}
		
		private function addSubMenu(submenu:NativeMenu, label:String, mnemonic:String = ""):NativeMenuItem
		{
			var item:NativeMenuItem = menu.addSubmenu(submenu, label);
			
			if (mnemonic != "")
			{
				item.label += "(" + mnemonic + ")";
				item.mnemonicIndex = item.label.length - 2;
			}
			
			return item;
		}
		
		public function Menu(nativeWindow:NativeWindow, root:Sprite)
		{
			this.nativeWindow = nativeWindow;
			
			// ファイル
			fileMenu.addItem(createMenuItem("終了", "X")).addEventListener(Event.SELECT, function(e:Event):void {
				NativeApplication.nativeApplication.exit();
			});
			
			// ヘルプ
			helpMenu.addItem(createMenuItem("http://90k-games.com/")).addEventListener(Event.SELECT, function(e:Event):void {
				navigateToURL(new URLRequest("http://90k-games.com/"));
			});
			
			addSubMenu(fileMenu, "ファイル", "F");
			addSubMenu(helpMenu, "ヘルプ", "H");
			
			nativeWindow.menu = menu;
		}
	}
}