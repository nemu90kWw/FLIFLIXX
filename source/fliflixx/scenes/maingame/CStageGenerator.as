
package fliflixx.scenes.maingame
{
	import fliflixx.object.maingame.CMogler;
	import fliflixx.system.Database;
	import fliflixx.object.maingame.CGameObject;
	
	public class CStageGenerator
	{
		private var func_map:CMap;
		
		private var stagedata:XML = new XML(Database.getItem("XML_STAGEDATA"));
		private var stagelist:Array = new Array();
		
		public function CStageGenerator(map:CMap)
		{
			func_map = map;
			
			var xml:XML = new XML(Database.getItem("XML_STAGEDATA"));
			for(var i:int; i < xml.stage.length(); i++)
			{
				stagelist[(i+1)%5] = xml.stage[i];
			}
			return;
		}
		
		// --------------------------------//
		// マップ作成
		// --------------------------------//
		public function createStage(stage:int, area:int):void
		{
			func_map.initialize();
			createObject(stagelist[stage].area[area-1].children());
			return;
		}
		
		private function createObject(xml:XMLList, parent:CGameObject = null):void
		{
			for(var i:int; i < xml.length(); i++)
			{
				var elem:XML = xml[i];
				switch(elem.localName())
				{
				case "ebifly":
					//デフォルト引数
					var x:Number = 320;
					var y:Number = 216;
					
					if(elem.@x != undefined) {x = elem.@x;}
					if(elem.@y != undefined) {y = elem.@y;}
					
					func_map.setEbiflyPosition(x, y);
					break;
				case "mogler":
					//デフォルト引数
					var type:String = "STOP";
					var x:Number = 0;
					var y:Number = 0;
					var speed:Number = 0;
					var range:Number = 0;
					var init:Number = 0;
					
					if(elem.@type != undefined) {type = elem.@type;}
					if(elem.@x != undefined) {x = elem.@x;}
					if(elem.@y != undefined) {y = elem.@y;}
					if(elem.@speed != undefined) {speed = elem.@speed;}
					if(elem.@range != undefined) {range = elem.@range;}
					if(elem.@init != undefined) {init = elem.@init;}
					
					var objref:CGameObject = func_map.setMogler(type, x, y, speed, range, init, parent);
					
					//親子関係
					if(elem.children().length() >= 1) {
						createObject(elem.children(), objref);
					}
					
					break;
				case "block":
					//デフォルト引数
					var color:String = "RED";
					var type:String = "STOP";
					var x:Number = 0;
					var y:Number = 0;
					var width:Number = 32;
					var height:Number = 32;
					var speed:Number = 0;
					var range:Number = 0;
					var init:Number = 0;
					
					if(elem.@color != undefined) {color = elem.@color;}
					if(elem.@type != undefined) {type = elem.@type;}
					if(elem.@x != undefined) {x = elem.@x;}
					if(elem.@y != undefined) {y = elem.@y;}
					if(elem.@width != undefined) {width = elem.@width;}
					if(elem.@height != undefined) {height = elem.@height;}
					if(elem.@speed != undefined) {speed = elem.@speed;}
					if(elem.@range != undefined) {range = elem.@range;}
					if(elem.@init != undefined) {init = elem.@init;}
					
					var objref:CGameObject = func_map.setBlock(color, type, x, y, width, height, speed, range, init, parent);
					
					//親子関係
					if(elem.children().length() >= 1) {
						createObject(elem.children(), objref);
					}
					
					break;
				}
			}
			return;
		}
	}
}
