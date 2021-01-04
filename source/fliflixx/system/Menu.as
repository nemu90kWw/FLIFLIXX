package fliflixx.system 
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FullScreenEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class Menu extends EventDispatcher
	{
		private var nativeWindow:NativeWindow;
		
		private var menu:NativeMenu = new NativeMenu();
		private var fileMenu:NativeMenu = new NativeMenu();
		private var displayMenu:NativeMenu = new NativeMenu();
		private var helpMenu:NativeMenu = new NativeMenu();
		
		private var fullScreenItem:NativeMenuItem;
		
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
			
			// 表示
			fullScreenItem = displayMenu.addItem(createMenuItem("フルスクリーン", "S"))
			fullScreenItem.addEventListener(Event.SELECT, toggleFullScreen);
			
			// ヘルプ
			helpMenu.addItem(createMenuItem("http://90k-games.com/")).addEventListener(Event.SELECT, function(e:Event):void {
				navigateToURL(new URLRequest("http://90k-games.com/"));
			});
			
			addSubMenu(fileMenu, "ファイル", "F");
			addSubMenu(displayMenu, "表示", "V");
			addSubMenu(helpMenu, "ヘルプ", "H");
			
			nativeWindow.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			nativeWindow.menu = menu;
		}
		
		private function onFullScreen(e:FullScreenEvent):void 
		{
			fullScreenItem.checked = e.fullScreen;
		}
		
		private function toggleFullScreen(e:Event):void
		{
			if (fullScreenItem.checked == false) {
				dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, true, true));
			}
			else {
				dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, false, true));
			}
		}
	}
}