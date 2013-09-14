package fliflixx.object.maingame
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import fliflixx.object.maingame.CSmoke;
	import flash.display.BitmapData;
	
	public class CMogler extends CGameObject
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
		
		private static var cell:Object = new Object();
		
		private var point_x:Number = 0;
		private var point_y:Number = 0;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function CMogler(type:String, speed:Number, range:Number, now:Number)
		{
			bmp = cell.stop;
			
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
			registerObject("DEPTH_ENEMY", "PRIO_ENEMY");
			return;
		}
		
		public static function standbyGraphics():void
		{
			CMoglerErase.standbyGraphics();
			
			var matrix:Matrix = new Matrix();
			
			var eye:Sprite = new Sprite();
			eye.graphics.beginFill(0xFFFFFF);
			eye.graphics.drawCircle(0, 0, 10);
			eye.graphics.endFill();
			eye.graphics.beginFill(0x000000);
			eye.graphics.drawCircle(0, -1.5, 7.5);
			eye.graphics.endFill();
			
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xFFE000);
			sprite.graphics.drawCircle(32, 32, 32);
			sprite.graphics.lineStyle(2, 0);
			sprite.graphics.moveTo(32-10, 32+15);
			sprite.graphics.lineTo(32+10, 32+15);
			cell.move = new Array();
			for(var i:int = 0; i < 256; i++)
			{
				cell.move[i] = new BitmapData(64, 64, true, 0);
				cell.move[i].draw(sprite, matrix);
				
				matrix.rotate(Math.PI/128 * i);
				matrix.translate(32-15, 32-7.5);
				cell.move[i].draw(eye, matrix);
				matrix.identity();
				
				matrix.rotate(Math.PI/128 * i);
				matrix.translate(32+15, 32-7.5);
				cell.move[i].draw(eye, matrix);
				matrix.identity();
			}
			
			sprite.graphics.moveTo(32+5,  32-7);
			sprite.graphics.lineTo(32+25, 32-7);
			sprite.graphics.moveTo(32-5,  32-7);
			sprite.graphics.lineTo(32-25, 32-7);
			sprite.graphics.endFill();
			cell.stop = new BitmapData(64, 64, true, 0);
			cell.stop.draw(sprite);
			
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
			aim();
			
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
			aim();
			
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
			aim();
			
			x = posx + MathEx.getVectorX(now, range);
			y = posy + MathEx.getVectorY(now, range);
			
			now += speed;
			return;
		}
		
		private function aim():void
		{
			var ebifly:Array = scene.func_obj.searchPriority("PRIO_MISSILE");
			
			if(ebifly.length >= 1)
			{
				//注視する座標を更新
				point_x = ebifly[0].getX();
				point_y = ebifly[0].getY();
			}
			
			bmp = cell.move[Math.floor((getAngle(point_x, point_y, 256)+256)%256)];
			return;
		}
		
		// --------------------------------//
		// やられた
		// --------------------------------//
		override public function kill():void
		{
			createObject(new CMoglerErase(), 0, 0);
			
			vanish();
			return;
		}
	}
}

import common.Screen;
import flash.display.Sprite;
import flash.geom.Matrix;
import fliflixx.object.maingame.CGameObject;
import flash.display.BitmapData;

class CMoglerErase extends CGameObject
{
	private static var cell:Array = new Array();
	private var currentframe:String = "WHITE";
	
	// --------------------------------//
	// 初期化
	// --------------------------------//
	override public function initialize():void
	{
		registerObject("DEPTH_ERASE", "PRIO_EFFECT");
		
		changeAction("act_main");
		return;
	}
	
	public static function standbyGraphics():void
	{
		var bmp:BitmapData = new BitmapData(64, 64, true, 0);
		var matrix:Matrix = new Matrix();
		
		var sprite:Sprite = new Sprite();
		
		sprite.graphics.beginFill(0xFFFFFF);
		sprite.graphics.drawCircle(32, 32, 32);
		sprite.graphics.endFill();
		bmp.draw(sprite, matrix);
		cell.push(bmp);
		cell.push(bmp);
		cell.push(bmp);
		
		sprite = new Sprite();
		sprite.graphics.beginFill(0xFFAA55);
		sprite.graphics.drawCircle(0, 0, 32);
		sprite.graphics.endFill();
		sprite.graphics.beginFill(0xFFFFFF);
		sprite.graphics.drawCircle(-15, -8.5, 10);
		sprite.graphics.drawCircle( 15, -8.5, 10);
		sprite.graphics.endFill();
		sprite.graphics.beginFill(0x000000);
		sprite.graphics.drawCircle(-15, -8.5, 5);
		sprite.graphics.drawCircle( 15, -8.5, 5);
		sprite.graphics.endFill();
		sprite.graphics.beginFill(0xF00040);
		sprite.graphics.drawCircle(0, 15, 10);
		sprite.graphics.endFill();
		
		var rotation:Number = 0;
		var scale:Number = 1;
		var cnt:int = 0;
		while(scale > 0)
		{
			bmp = new BitmapData(64, 64, true, 0);
			
			rotation += 2/3;
			
			if(cnt >= 117) {
				scale -= 0.005;
			}
			matrix.identity();
			matrix.scale(scale, scale);
			matrix.rotate(Math.PI/128*rotation);
			matrix.translate(32, 32);
			bmp.draw(sprite, matrix);
			
			cell.push(bmp);
			cnt++;
		}
		
		return;
	}
	
	// --------------------------------//
	// メイン
	// --------------------------------//
	public function act_main():void
	{
		if(cell.length == count)
		{
			kill();
			return;
		}
		
		bmp = cell[count];
		return;
	}
	/*
	// --------------------------------//
	// 描画
	// --------------------------------//
	override public function draw(screen:BitmapScreen):void
	{
		matrix.identity();
		matrix.scale(scale, scale);
		matrix.rotate(Math.PI/128*rotation);
		matrix.translate(x, y);
		screen.bmp.draw(sprite[currentframe], matrix);
		return;
	}
	*/
}
