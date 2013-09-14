package fliflixx.object.maingame
{
	import fliflixx.object.maingame.CGameObject;
	import common.Screen;
	import flash.geom.Rectangle;
	import fliflixx.object.maingame.CBlock;
	
	public class CSmoke extends CGameObject
	{
		private var angle:Number = 0;
		private var speed:Number = 0;
		
		private var ebifly_vx:Number = 0;
		private var ebifly_vy:Number = 0;
		
		private var size:Number = 30;
		
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
					speed /= 2;
					ebifly_vx /= 1.25;
					ebifly_vy /= 1.25;
				}
				else
				{
					speed /= 1.05;
					ebifly_vx /= 1.05;
					ebifly_vy /= 1.05;
				}
			}
			size -= 0.3;
			
			if(size <= 1) {vanish()}
		}
		
		// --------------------------------//
		// 描画
		// --------------------------------//
		override public function draw(screen:Screen):void
		{
			screen.buffer.fillRect(new Rectangle(x-size/2, y-size/2, size, size), 0xFFFFFF);
			return;
		}
	}
}