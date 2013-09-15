package fliflixx.object.maingame
{
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import fliflixx.asset.SmokeAsset;
	import fliflixx.object.maingame.CGameObject;
	import common.Screen;
	import flash.geom.Rectangle;
	import fliflixx.object.maingame.CBlock;
	
	public class CSmoke extends CGameObject
	{
		private var asset:MovieClip;
		
		private var angle:Number = 0;
		private var speed:Number = 0;
		
		private var ebifly_vx:Number = 0;
		private var ebifly_vy:Number = 0;
		
		private var frame:int = 0;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function CSmoke(angle:Number, speed:Number, ebifly_vx:Number, ebifly_vy:Number)
		{
			this.angle = angle;
			this.speed = speed;
			this.ebifly_vx = ebifly_vx;
			this.ebifly_vy = ebifly_vy;
		}
		
		override public function initialize():void
		{
			registerObject("DEPTH_EFFECT", "PRIO_EFFECT");
			
			asset = new SmokeAsset();
			asset.stop();
			
			changeAction("act_main");
			return;
		}

		// --------------------------------//
		// メイン
		// --------------------------------//
		public function act_main():void
		{
			x += MathEx.getVectorX(angle, speed) + ebifly_vx;
			y += MathEx.getVectorY(angle, speed) + ebifly_vy;
			
			if(getStage() != 0)
			{
				//当たり判定
				var hit:Boolean = false;
				if(count % 3 == 0) {
					hit = collidedWithBlock(getX(), getY());
				}
				else {
					hit = collidedWithFrame(getX(), getY());
				}
				
				//障害物に当たったら速度を落とす
				if(hit == true)
				{
					speed /= 2.5;
					ebifly_vx /= 2;
					ebifly_vy /= 2;
				}
				else
				{
					speed /= 1.1;
					ebifly_vx /= 1.2;
					ebifly_vy /= 1.2;
				}
			}
			
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
		// 描画
		// --------------------------------//
		override public function draw(screen:Screen):void
		{
			//screen.buffer.fillRect(new Rectangle(x-size/2, y-size/2, size, size), 0xFFFFFF);
			
			screen.buffer.draw(asset, asset.transform.matrix);
			return;
		}
	}
}