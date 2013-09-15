
package fliflixx.scenes
{
	import common.Mouse;
	import common.Screen;
	import fliflixx.scenes.maingame.*;
	
	import fliflixx.object.common.CFrame;
	import fliflixx.object.maingame.*;
	import fliflixx.system.GameData;
	import fliflixx.system.PlayData;
	
	public class MainGameScene extends SceneBase
	{
		private var func_map:CMap;
		private var func_stage:CStageGenerator;
		private var nomiss:Boolean;
		//private var statetext:String = "";
		public var ebifly:CEbifly;
		public var message:CMessage;
		
		public var gamedata:GameData = new GameData();
		
		// --------------------------------//
		// 初期化
		// --------------------------------//
		public function MainGameScene(mode:String, stage:int, area:int)
		{
			func_map = new CMap(this);
			func_stage = new CStageGenerator(func_map);
			
			gamedata.mode = mode;
			gamedata.stage = stage;
			gamedata.area = area;
			
			gamedata.score = 0;
			gamedata.time = 90;
			
			createObject(new CFrame(gamedata.stage));
			createObject(new CStatusBar());
			
			changeAction("game_start");
			return;
		}

		// --------------------------------//
		// ステージ開始
		// --------------------------------//
		public function game_start():void
		{
			switch(gamedata.stage){
			case 1: func_bgm.play("BGM_STAGE1"); break;
			case 2: func_bgm.play("BGM_STAGE2"); break;
			case 3: func_bgm.play("BGM_STAGE3"); break;
			case 4: func_bgm.play("BGM_STAGE1"); break;
			case 0: if(gamedata.area != 8) {func_bgm.play("BGM_STAGE2");} break;
			}
			
			func_stage.createStage(gamedata.stage, gamedata.area);
			
			//初期化
			nomiss = true;
			
			changeAction("game_wait");
			return;
		}

		// --------------------------------//
		// リトライ
		// --------------------------------//
		public function game_retry():void
		{
			message.vanish();
			
			switch(gamedata.mode) {
			case "SEQUENTIAL": func_map.retry(); break;
			case "SINGLE": func_stage.createStage(gamedata.stage, gamedata.area); break;
			}
			
			changeAction("game_wait");
			return;
		}

		// --------------------------------//
		// 待機
		// --------------------------------//
		public function game_wait():void
		{
			if(gamedata.mode == "SINGLE") {gamedata.time = 0;}
			
			if(count > 5)
			{
				//開始
				if(Mouse.press)
				{
					ebifly.changeAction("act_run");
					
					changeAction("game_main");
					return;
				}
			}
			
			return;
		}

		// --------------------------------//
		// メイン
		// --------------------------------//
		public function game_main():void
		{
			//ステージクリア移行
			if(func_obj.searchPriority("PRIO_ENEMY").length == 0)
			{
				changeAction("game_stageclear");
				return;
			}
			
			//ミス移行
			if(func_obj.searchPriority("PRIO_MISSILE").length == 0)
			{
				changeAction("game_miss");
				return;
			}
			
			switch(gamedata.mode) {
			case "SEQUENTIAL":
				gamedata.time -= 0.01666667;	// 1 / 60 = 0.01666667
				if(gamedata.time < 0) {
					gamedata.time = 0;
				}
				break;
			case "SINGLE":
				gamedata.time += 0.01666667;
				if(gamedata.time > 99.99) {
					gamedata.time = 99.99;
				}
				break;
			}
			
			return;
		}

		// --------------------------------//
		// ステージクリア
		// --------------------------------//
		public function game_stageclear():void
		{
			if(count == 0)
			{
				ebifly.changeAction("act_stop");
				
				//ブロックの動きを止める
				var block:* = func_obj.searchPriority("PRIO_BLOCK");
				for(var i:String in block)
				{
					block[i].changeAction("act_stop");
				}
				
				if(nomiss == true && gamedata.mode == "SEQUENTIAL")
				{
					message = createObject(new CMessage(CMessage.NOMISSCLEAR));
					gamedata.time += 5;
				}
				else {
					createObject(new CMessage(CMessage.CLEAR));
				}
				
				if(gamedata.mode == "SINGLE")
				{
					if(PlayData.records.isBest(gamedata.stage, gamedata.area, gamedata.time))
					{
						message = createObject(new CMessage(CMessage.BESTRECORD));
						PlayData.records.entry(gamedata.stage, gamedata.area, gamedata.time);
						PlayData.records.saveData();
					}
				}
			}
			
			if(Mouse.press)
			{
				switch(gamedata.mode) {
				case "SEQUENTIAL": changeAction_fadeout("game_nextstage"); break;
				case "SINGLE": changeAction_fadeout("game_returntotitle"); break;
				}
				
				return;
			}
			
			return;
		}

		// --------------------------------//
		// 次ステージへ
		// --------------------------------//
		public function game_nextstage():void
		{
			message.vanish();
			
			//次ワールドへ
			if(gamedata.area == 8)
			{
				gamedata.stage++;
				gamedata.area = 1;
				
				//全クリ
				if(gamedata.stage == 5)
				{
					changeScene(new AllClearScene(gamedata));
					return;
				}
			}
			else {
				gamedata.area++;
			}
			
			changeAction("game_start")
			return;
		}

		// --------------------------------//
		// ミス
		// --------------------------------//
		public function game_miss():void
		{
			switch(gamedata.mode) {
			case "SEQUENTIAL":
				if(count == 0)
				{
					nomiss = false;
					
					message = createObject(new CMessage(CMessage.MISS));
					gamedata.time -= 5;
					
					if(gamedata.time < 0) {
						gamedata.time = 0;
					}
				}
				
				if(gamedata.time < 1) {
					if (count == 48)
					{
						message.vanish();
						changeAction("game_over");
					}
				}
				else {
					if (Mouse.press) {
						changeAction_fadeout("game_retry");
					}
				}
				break;
			case "SINGLE":
				if(count == 0) {
					message = createObject(new CMessage(CMessage.MISS));
				}
				if (Mouse.press) {
					changeAction_fadeout("game_retry");
				}
				break;
			}
			
			return;
		}

		// --------------------------------//
		// ゲームオーバー
		// --------------------------------//
		public function game_over():void
		{
			if(count == 0)
			{
				func_bgm.play("BGM_GAMEOVER");
				message = createObject(new CMessage(CMessage.GAMEOVER));
				
				//動きを止める
				var mogler:* = func_obj.searchPriority("PRIO_ENEMY");
				for(var i:String in mogler) {
					mogler[i].changeAction("act_stop");
				}
				
				var block:* = func_obj.searchPriority("PRIO_BLOCK");
				for(var i:String in block) {
					block[i].changeAction("act_stop");
				}
				
				var effect:* = func_obj.searchPriority("PRIO_EFFECT");
				for(var i:String in effect) {
					effect[i].changeAction("act_stop");
				}
			}
			
			if (count == 270)
			{
				changeAction_fadeout("game_entry");
			}
			
			return;
		}

		// --------------------------------//
		// シーン移動
		// --------------------------------//
		public function game_entry():void
		{
			message.vanish();
			changeScene(new RankingScene(gamedata));
			return;
		}
		
		public function game_returntotitle():void
		{
			message.vanish();
			changeScene(new TitleScene());
			return;
		}
		
		// --------------------------------//
		// 描画
		// --------------------------------//
		override public function draw():void
		{
			func_obj.draw();
		}
	}
}
