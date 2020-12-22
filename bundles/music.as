
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
	// ���C�����[�v
	// --------------------------------//
	Music.prototype.main = function()
	{
		if(!nowplaying) {return;}		//�Đ����ĂȂ�
		
		//�Ȃ̍Đ��ʒu�؂�ւ�
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
		
		//�t�F�[�h�A�E�g�̏���
		if (fadeout) {
			fadevolume /= 1.08;
		}
		
		//���炩�̊O�I�v���ōĐ����X�g�b�v�������̏���
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
		
		//�{�����[���v�Z
		sndobj.setVolume((((mastervolume/100)*volume)/100)*fadevolume);
		
		return;
	}

	//���C����o�^
	if(target instanceof MovieClip) {
		target.onEnterFrame = this.main;
	}

	// --------------------------------//
	// �Ȃ̊��蓖��
	// --------------------------------//
	Music.prototype.attachSound = function(idName)
	{
		name = idName;
		sndobj.attachSound(idName);
		
		return;
	}
	
	// ------------------------------------------------------------//
	//
	//  �� �Ȃ̍Đ�
	//
	//	����
	//		args[0, 2, 4, ...] : �Ȃ̍Đ��ʒu��ύX����^�C�~���O
	//		args[1, 3, 5, ...] : �ʒu��߂��b��
	//		args[... , end]    : ����I�����̖߂��|�C���g
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
			
			this.debugOutput("�ȁi"+name+"�j���Đ�", "VERBOSE");
			
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
	// �Đ����Ă���Ȃ̑���
	// --------------------------------//
	
	// ��~
	Music.prototype.stop = function()
	{
		nowplaying = false;
		prebgm = "";
		sndobj.stop();
	}
	
	// �t�F�[�h�A�E�g
	Music.prototype.fadeout = function()
	{
		prebgm = "";
		fadeout = true;
	}
	
	// --------------------------------//
	// �{�����[���̐ݒ�
	// --------------------------------//
	Music.prototype.setVolume = function(num) {volume = num;}
	Music.prototype.setMasterVolume = function(num) {mastervolume = num;}
}
