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
	import flash.profiler.showRedrawRegions;
	import flash.ui.Keyboard;

	public class Menu extends EventDispatcher
	{
		private var nativeWindow:NativeWindow;
		
		private var menu:NativeMenu = new NativeMenu();
		private var fileMenu:NativeMenu = new NativeMenu();
		private var displayMenu:NativeMenu = new NativeMenu();
		private var helpMenu:NativeMenu = new NativeMenu();
		
		private var fullScreenItem:NativeMenuItem;
		private var redrawRegionItem:NativeMenuItem;
		
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
		
		private function createSeparator():NativeMenuItem
		{
			return new NativeMenuItem("", true);
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
			fullScreenItem.keyEquivalent = "\renter";
			fullScreenItem.keyEquivalentModifiers = [Keyboard.ALTERNATE];
			fullScreenItem.addEventListener(Event.SELECT, toggleFullScreen);
			
			displayMenu.addItem(createSeparator());
			redrawRegionItem = displayMenu.addItem(createMenuItem("再描画領域を表示"));
			redrawRegionItem.addEventListener(Event.SELECT, toggleRedrawRegions);
			
			// ヘルプ
			helpMenu.addItem(createMenuItem("マニュアルを開く...")).addEventListener(Event.SELECT, function(e:Event):void {
				navigateToURL(new URLRequest("manual/index.html"));
			});
			helpMenu.addItem(createSeparator());
			helpMenu.addItem(createMenuItem("http://90k-games.com/")).addEventListener(Event.SELECT, function(e:Event):void {
				navigateToURL(new URLRequest("http://90k-games.com/"));
			});
			
			addSubMenu(fileMenu, "ファイル", "F");
			addSubMenu(displayMenu, "表示", "V");
			addSubMenu(helpMenu, "ヘルプ", "H");
			
			nativeWindow.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			nativeWindow.menu = menu;
			root.contextMenu = displayMenu;
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
		
		private function toggleRedrawRegions(e:Event):void
		{
			if (redrawRegionItem.checked == false)
			{
				redrawRegionItem.checked = true;
				showRedrawRegions(true);
			}
			else
			{
				redrawRegionItem.checked = false;
				showRedrawRegions(false);
			}
		}
	}
}