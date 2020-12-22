
function Music(target)
{
	var nowplaying = false;
	var changed    = false;
	
	var sndobj = new Sound(target);
	var name   = "";
	var prebgm = "";
	
	var mastervolume = 100;
	var volume       = 100;
	var fadevolume   = 100;
	var fadeout = false;
	
	var poschange_time   = new Array();
	var poschange_length = new Array();
	var posnum  = 1;
	var loopnum = 1;
	
	var checktime = 0;
	var pretime   = 0;
	
	// --------------------------------//
	// メインループ
	// --------------------------------//
	Music.prototype.main = function()
	{
		if(!nowplaying) {return;}		//再生してない
		
		//曲の再生位置切り替え
		if (sndobj.position > poschange_time[posnum]) {
			if (changed == false)
			{
				var changepoint = sndobj.position + poschange_length[posnum];
				sndobj.stop();
				sndobj.start( changepoint / 1000 );
				posnum++;
				if (poschange_time[posnum] == null)
				{
					posnum = loopnum;
				}
				changed = true;
			}
		}
		else {
			changed = false;
		}
		
		//フェードアウトの処理
		if (fadeout) {
			fadevolume /= 1.08;
		}
		
		//何らかの外的要因で再生がストップした時の処理
		if (sndobj.position == pretime)
		{
			checktime++;
			if (checktime > 20)
			{
				sndobj.start(sndobj.position / 1000);
				checktime = 0;
			}
		}
		else
		{
			checktime = 0;
			pretime = sndobj.position;
		}
		
		//ボリューム計算
		sndobj.setVolume((((mastervolume/100)*volume)/100)*fadevolume);
		
		return;
	}

	//メインを登録
	if(target instanceof MovieClip) {
		target.onEnterFrame = this.main;
	}

	// --------------------------------//
	// 曲の割り当て
	// --------------------------------//
	Music.prototype.attachSound = function(idName)
	{
		name = idName;
		sndobj.attachSound(idName);
		
		return;
	}
	
	// ------------------------------------------------------------//
	//
	//  ◆ 曲の再生
	//
	//	引数
	//		args[0, 2, 4, ...] : 曲の再生位置を変更するタイミング
	//		args[1, 3, 5, ...] : 位置を戻す秒数
	//		args[... , end]    : 一周終了時の戻しポイント
	//
	// ------------------------------------------------------------//
	Music.prototype.play = function(args)
	{
		var i = 1;
		for( ; args.length > 1; i++ )
		{
			poschange_time[i]   = (args.shift() * 1000);
			poschange_length[i] = (args.shift() * 1000);
		}
		poschange_time[i] = null;
		loopnum = args.shift();
		
		if( loopnum == undefined ) {
			loopnum = 1;
		}
		
		if (prebgm != name)
		{
			sndobj.stop();
			sndobj.start();
			
			this.debugOutput("曲（"+name+"）を再生", "VERBOSE");
			
			posnum = 1;
			prebgm = name;
			fadeout = false;
			sndobj.setVolume(mastervolume);
			volume = 100;
			fadevolume = 100;
			changed = true;
			nowplaying = true;
		}
		return;
	}
	
	// --------------------------------//
	// 再生している曲の操作
	// --------------------------------//
	
	// 停止
	Music.prototype.stop = function()
	{
		nowplaying = false;
		prebgm = "";
		sndobj.stop();
	}
	
	// フェードアウト
	Music.prototype.fadeout = function()
	{
		prebgm = "";
		fadeout = true;
	}
	
	// --------------------------------//
	// ボリュームの設定
	// --------------------------------//
	Music.prototype.setVolume = function(num) {volume = num;}
	Music.prototype.setMasterVolume = function(num) {mastervolume = num;}
}
