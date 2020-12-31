package fliflixx.object.maingame
{
	import common.Surface;
	import flash.geom.Rectangle;
	
	public class CBlock extends CGameObject
	{
		public var posx:Number = 0;
		public var posy:Number = 0;
		private var speed:Number = 0;
		private var range:Number = 0;
		private var now:Number = 0;
		
		public var defaultx:Number = 0;
		public var defaulty:Number = 0;
		private var init:Number = 0;
		private var initspeed:Number = 0;
		
		public var width:uint;
		public var height:uint;
		private var color_light:uint;
		private var color_main:uint;
		private var color_shadow:uint;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function CBlock(color:String, type:String, speed:Number, range:Number, now:Number)
		{
			switch(color) {
			case "RED":
				color_light = 0xFFE0EE;
				color_main = 0xFF60B0;
				color_shadow = 0x800040;
				break;
			case "BLUE":
				color_light = 0xE0E0FF;
				color_main = 0xA0A0FF;
				color_shadow = 0x202080;
				break;
			case "WHITE":
				color_light = 0xC080C0;
				color_main = 0xFFFFFF;
				color_shadow = 0xC080C0;
				break;
			}
			
			this.speed = speed;
			this.range = range;
			this.now = now;
			this.init = now;
			this.initspeed = speed;
			
			switch(type) {
			case "VERTICAL":
				actfunc_ref = "act_vertical";
				break;
			case "HORIZONTAL":
				actfunc_ref = "act_horizontal";
				break;
			case "CIRCLE":
				actfunc_ref = "act_circle";
				break;
			}
			
			return;
		}
		
		override public function initialize():void
		{
			registerObject("DEPTH_BLOCK", "PRIO_BLOCK");
			return;
		}
		
		public function resetPosition():void
		{
			posx = defaultx;
			posy = defaulty;
			now   = init;
			speed = initspeed;
			return;
		}
		
		// --------------------------------//
		// 縦移動
		// --------------------------------//
		public function act_vertical():void
		{
			x = posx;
			y = posy + now;
			
			now += speed;
			
			//反転
			if(now > range)
			{
				now -= now - range;
				speed = -speed;
			}
			if(now < 0)
			{
				now = -now;
				speed = -speed;
			}
			
			return;
		}

		// --------------------------------//
		// 横移動
		// --------------------------------//
		public function act_horizontal():void
		{
			x = posx + now;
			y = posy;
			
			now += speed;
			
			//反転
			if(now > range)
			{
				now -= now - range;
				speed = -speed;
			}
			if(now < 0)
			{
				now = -now;
				speed = -speed;
			}
			
			return;
		}

		// --------------------------------//
		// 円形移動
		// --------------------------------//
		public function act_circle():void
		{
			x = posx + MathEx.getVectorX(now, range);
			y = posy + MathEx.getVectorY(now, range);
			
			now += speed;
			return;
		}

		// --------------------------------//
		// 親オブジェクトから切り離される
		// --------------------------------//
		override public function drop():void
		{
			if(deleteflag == true) {return;}
			
			createObject(new CBlockErase(width, height), 0, 0);
			
			vanish();
			return;
		}
		
		// --------------------------------//
		// 描画
		// --------------------------------//
		override public function draw(screen:Surface):void
		{
			screen.buffer.fillRect(new Rectangle(int(getX()-width/2),   int(getY()-height/2), width+1, height+1), color_light);
			screen.buffer.fillRect(new Rectangle(int(getX()-width/2)+1, int(getY()-height/2)+1, width, height), color_shadow);
			screen.buffer.fillRect(new Rectangle(int(getX()-width/2)+1, int(getY()-height/2)+1, width-1, height-1), color_main);
			return;
		}
	}
}

import common.Surface;
import flash.geom.Rectangle;
import fliflixx.object.maingame.CGameObject;
import common.Surface;

class CBlockErase extends CGameObject
{
	private var width:Number;
	private var height:Number;
	
	// --------------------------------//
	// 初期化
	// --------------------------------//
	public function CBlockErase(width:Number, height:Number)
	{
		this.width = width;
		this.height = height;
		
		return;
	}
	
	override public function initialize():void
	{
		registerObject("DEPTH_BLOCK", "PRIO_EFFECT");
		
		changeAction("act_main");
		return;
	}
	
	// --------------------------------//
	// メイン
	// --------------------------------//
	public function act_main():void
	{
		width /= 1.15;
		height /= 1.15;
		
		if(width <= 1) {
			vanish();
		}
		
		return;
	}
	
	// --------------------------------//
	// 描画
	// --------------------------------//
	override public function draw(screen:Surface):void
	{
		screen.buffer.fillRect(new Rectangle(getX()-width/2, getY()-height/2, width, height), 0xFFFFFF);
		return;
	}
}
