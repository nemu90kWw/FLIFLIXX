package fliflixx.object.maingame
{
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import fliflixx.asset.ExplosionAsset;
	import fliflixx.asset.SmokeAsset;
	import fliflixx.object.maingame.CGameObject;
	import common.Screen;
	import flash.geom.Rectangle;
	import fliflixx.object.maingame.CBlock;
	
	public class CExplosion extends CGameObject
	{
		private var asset:MovieClip;
		private var frame:int = 0;
		
		// --------------------------------//
		// èâä˙âª
		// --------------------------------//
		override public function initialize():void
		{
			registerObject("DEPTH_EFFECT", "PRIO_EFFECT");
			
			asset = new ExplosionAsset();
			asset.stop();
			
			changeAction("act_main");
			return;
		}

		// --------------------------------//
		// ÉÅÉCÉì
		// --------------------------------//
		public function act_main():void
		{
			if (count % 3 == 0)
			{
				frame++;
			
				if (frame == asset.totalFrames + 1) {
					vanish();
				}
			}
			
			asset.x = x;
			asset.y = y;
			asset.gotoAndStop(frame);
		}
		
		// --------------------------------//
		// ï`âÊ
		// --------------------------------//
		override public function draw(screen:Screen):void
		{
			screen.buffer.draw(asset, asset.transform.matrix);
			return;
		}
	}
}