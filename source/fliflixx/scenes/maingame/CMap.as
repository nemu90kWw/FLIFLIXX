
package fliflixx.scenes.maingame
{
	import fliflixx.object.maingame.*;
	import fliflixx.scenes.MainGameScene;
	
	public class CMap
	{
		private var scene:MainGameScene;
		public var currentmap:Object;
		
		public function CMap(scene:MainGameScene)
		{
			this.scene = scene;
		}
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function initialize():void
		{
			//全削除
			scene.func_obj.removePriority("PRIO_MISSILE");
			scene.func_obj.removePriority("PRIO_ENEMY");
			scene.func_obj.removePriority("PRIO_BLOCK");
			scene.func_obj.removePriority("PRIO_EFFECT");
			
			scene.ebifly = scene.createObject(new CEbifly());
			
			currentmap = {
				ebifly : new Object(),
				mogler : new Array(),
				block : new Array()
			};
			
			return;
		}
		
		// --------------------------------//
		// ミサイル初期位置設定
		// --------------------------------//
		public function setEbiflyPosition(x:Number, y:Number):void
		{
			scene.ebifly.x = x;
			scene.ebifly.y = y;
			
			currentmap.ebifly.x = x;
			currentmap.ebifly.y = y;
			
			return;
		}
		
		// --------------------------------//
		// 敵設置
		// --------------------------------//
		public function setMogler(type:String, x:Number, y:Number, speed:Number, range:Number, init:Number, parent:CGameObject):CMogler
		{
			var temp:CMogler = scene.createObject(new CMogler(type, speed/3, range, init));
			
			if(parent != null)
			{
				temp.parent = parent;
				parent.childlist.push(temp);
			}
			
			if(type == "STOP")
			{
				temp.x = x;
				temp.y = y;
			}
			else
			{
				temp.posx = x;
				temp.posy = y;
			}
			
			temp.defaultx = x;
			temp.defaulty = y;
			
			currentmap.mogler.push(temp);
			
			return temp;
		}
		
		// --------------------------------//
		// ブロック設置
		// --------------------------------//
		public function setBlock(color:String, type:String, x:Number, y:Number,
			width:Number, height:Number, speed:Number, range:Number, init:Number, parent:CGameObject):CBlock
		{
			var temp:CBlock = scene.createObject(new CBlock(color, type, speed/3, range, init));
			
			if(parent != null)
			{
				temp.parent = parent;
				parent.childlist.push(temp);
			}
			
			if(type == "STOP")
			{
				temp.x = x;
				temp.y = y;
			}
			else
			{
				temp.posx = x;
				temp.posy = y;
			}
			
			temp.width = width-1;
			temp.height = height-1;
			
			temp.defaultx = x;
			temp.defaulty = y;
			
			currentmap.block.push(temp);
			
			return temp;
		}
		
		// --------------------------------//
		// リトライ
		// --------------------------------//
		public function retry():void
		{
			scene.func_obj.removePriority("PRIO_EFFECT");
			
			scene.ebifly = scene.createObject(new CEbifly());
			setEbiflyPosition(currentmap.ebifly.x, currentmap.ebifly.y);
			
			var moglerlist:* = scene.func_obj.searchPriority("PRIO_ENEMY");
			for each(var mogler:CMogler in moglerlist)
			{
				mogler.resetPosition();
			}
			
			var blocklist:* = scene.func_obj.searchPriority("PRIO_BLOCK");
			for each(var block:CBlock in blocklist)
			{
				block.resetPosition();
			}
			
			return;
		}
	}
}
