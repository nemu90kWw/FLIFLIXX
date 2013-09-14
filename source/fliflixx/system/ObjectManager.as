
package fliflixx.system
{
	// ----------------------------------------------------------------//
	// 
	//  ◆ オブジェクト管理システム
	// 
	// ----------------------------------------------------------------//

	import common.Screen;
	import fliflixx.object.CObject;
	
	public class ObjectManager
	{
		private static var priolist:Object = new Array();
		private static var depthlist:Array = new Array();
		
		private var objlist:Object = new Object();
		private var grplist:Object = new Object();
		
		private var screen:Screen;
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function ObjectManager(scr:Screen)
		{
			screen = scr;
			
			for each(var prio:String in priolist) {
				objlist[prio] = new Array();
			}
			
			for each(var depth:String in depthlist) {
				grplist[depth] = new Array();
			}
			
			return;
		}
		
		// --------------------------------//
		// プライオリティ追加
		// --------------------------------//
		public static function addPriority(prio:String):void
		{
			priolist.push(prio);
			return;
		}
		
		// --------------------------------//
		// 深度追加
		// --------------------------------//
		public static function addDepth(depth:String):void
		{
			depthlist.push(depth);
			return;
		}
		
		// --------------------------------//
		// 登録
		// --------------------------------//
		public function register(objref:CObject, depth:String, prio:String):void
		{
			objlist[prio].push(objref);
			grplist[depth].push(objref);
			return;
		}
		
		// --------------------------------//
		// 削除
		// --------------------------------//
		public function removeMovieClip(objref:CObject):void
		{
			//削除フラグを立てるだけ
			//update()でまとめて消される
			objref.deleteflag = true;
			return;
		}
		
		// ----------------------------------------//
		// 指定プライオリティを全削除
		// ----------------------------------------//
		public function removePriority(prio:String):void
		{
			var objlist:Array = this.searchPriority(prio);
			for each(var obj:* in objlist) {
				this.removeMovieClip(obj);
			}
			
			return;
		}
		
		// --------------------------------//
		// 更新
		// --------------------------------//
		public function update():void
		{
			for each(var prio:String in priolist)
			{
				//配列削除時の番号ズレ問題を回避するために逆順で呼び出す
				for(var i:int = objlist[prio].length-1; i >= 0; i--)
				{
					if(objlist[prio][i].deleteflag == true)
					{
						objlist[prio][i].erase();	//デストラクタ
						//objlist[prio][i].sprite.parent.removeChild(objlist[prio][i].sprite);
						objlist[prio].splice(i, 1);
					}
				}
			}
			
			for each(var depth:String in depthlist)
			{
				for(var i:int = grplist[depth].length-1; i >= 0; i--)
				{
					if(grplist[depth][i].deleteflag == true)
					{
						grplist[depth].splice(i, 1);
					}
				}
			}
			
			return;
		}
		
		// --------------------------------//
		// 実行
		// --------------------------------//
		public function run():void
		{
			//実行中の変更に影響されないためにリストの内容をコピーしておく
			var list:Array = new Array();
			for(var i:uint = 0; i < priolist.length; i++) {
				list = list.concat(this.searchPriority(priolist[i]));
			}
			
			//実行
			for(var i:uint = 0; i < list.length; i++ ) {
				list[i].main();
			}
			
			this.update();
			
			return;
		}
		
		// --------------------------------//
		// 描画
		// --------------------------------//
		public function draw():void
		{
			for each(var depth:* in depthlist)
			{
				for each(var o:* in grplist[depth])
				{
					o.draw(screen);
				}
			}
			
			return;
		}
		
		// --------------------------------//
		// 全削除
		// --------------------------------//
		public function removeAll():void
		{
			for(var i:uint = 0; i < length; i++)
			{
				for(var j:uint = 0; j < objlist[i].length; j++)
				{
					this.removeMovieClip(objlist[i][j]);
				}
			}
			
			return;
		}
		
		// --------------------------------//
		// 指定プライオリティのリストを返す
		// --------------------------------//
		public function searchPriority(prio:String):Array
		{
			return objlist[prio].slice(0, objlist[prio].length);
		}
	}
}
