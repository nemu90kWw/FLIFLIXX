
#include "music.as"

var lc = new LocalConnection();
var func_music = new Music(_root);

lc.allowDomain("*");
lc.connect("swf8connector");

// ä÷êîÇïÔä‹
lc.main = function()    {func_music.main();}
lc.attachSound = function(idName) {func_music.attachSound(idName);}
lc.play = function()    {func_music.play(arguments);}
lc.stop = function()    {func_music.stop();}
lc.fadeout = function() {func_music.fadeout();}
lc.setVolume = function(num)       {func_music.setVolume(num);}
lc.setMasterVolume = function(num) {func_music.setMasterVolume(num);}
