package fliflixx.object
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import fliflixx.scenes.SceneBase;
	
	import common.Task;
	import common.Screen;
	
	public class CObject extends Task
	{
		public var scene:SceneBase;
		public var bmp:BitmapData;
		public var deleteflag:Boolean = false;
		
		public var parent:CObject = null;
		public var childlist:Array = new Array();
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var visible:Boolean = true;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function initialize():void {}
		
		// --------------------------------//
		// オブジェクト登録
		// --------------------------------//
		public function registerObject(depth:String, prio:String):void
		{
			scene.func_obj.register(this, depth, prio);
			return;
		}
		
		// --------------------------------//
		// 新規オブジェクト
		// --------------------------------//
		public function createObject(instance:CObject, initx:Number, inity:Number, connect:Boolean = false):*
		{
			instance.scene = scene;
			
			if(connect == true)
			{
				instance.parent = this;
				
				instance.x = initx;
				instance.y = inity;
			}
			else
			{
				instance.x = getX() + initx;
				instance.y = getY() + inity;
			}
			
			instance.initialize();
			return instance;
		}
		
		// --------------------------------//
		// 接続
		// --------------------------------//
		public function connect(instance:CObject):void
		{
			if(instance.parent == null)
			{
				instance.parent = this;
				
				instance.x -= this.x;
				instance.y -= this.y;
			}
			
			return;
		}
		
		// --------------------------------//
		// 切り離し
		// --------------------------------//
		public function unconnect(instance:CObject):void
		{
			if(instance.parent == this)
			{
				instance.parent = null;
				
				instance.x += this.getX();
				instance.y += this.getY();
			}
			
			return;
		}
		
		// --------------------------------//
		// グローバル座標を取得
		// --------------------------------//
		public function getX():Number
		{
			if(parent != null) {
				return x + parent.getX();
			}
			
			return x;
		}
		
		public function getY():Number
		{
			if(parent != null) {
				return y + parent.getY();
			}
			
			return y;
		}
		
		// --------------------------------//
		// 消滅
		// --------------------------------//
		public function vanish():void
		{
			scene.func_obj.removeMovieClip(this);
			actfunc_ref = "act_stop";
			return;
		}
		
		// --------------------------------//
		// デストラクタ
		// --------------------------------//
		public function erase():void
		{
			for each(var child:CObject in childlist)
			{
				child.drop();
			}
			return;
		}
		
		// --------------------------------//
		// 存在確認
		// --------------------------------//
		public function exists():Boolean
		{
			return deleteflag;
		}
		
		// --------------------------------//
		// 親から切り離される
		// --------------------------------//
		public function drop():void
		{
			vanish();
			return;
		}
		
		public function draw(screen:Screen):void
		{
			if(visible == false) {return;}
			if(bmp == null) {return;}
			
			var pos:Point = new Point(int(getX())-bmp.width/2, int(getY())-bmp.height/2);
			screen.buffer.copyPixels(bmp, bmp.rect, pos);
			
			return;
		}
		
		public function updateObjList(list:Array):void
		{
			for(var i:String in list)
			{
				if(list[i] is CObject == false)
				{
					list.splice(i, 1);
				}
			}
			
			return;
		}
		
		// --------------------------------//
		// 効果音
		// --------------------------------//
		public function playSE(name:String):void
		{
			func_se.play(name);
			return;
		}
	}
}
