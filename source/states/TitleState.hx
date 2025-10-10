package states;

import backend.WeekData;

import flixel.input.keyboard.FlxKey;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import haxe.Json;

import objects.SakuraPetal;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

import shaders.ColorSwap;

import states.StoryMenuState;
import states.OutdatedState;
import states.MainMenuState;

typedef TitleData =
{
	var titlex:Float;
	var titley:Float;
	var startx:Float;
	var starty:Float;
	var reimux:Float;
	var reimuy:Float;
	var backgroundSprite:String;
	var bpm:Float;
	
	@:optional var animation:String;
	@:optional var dance_left:Array<Int>;
	@:optional var dance_right:Array<Int>;
	@:optional var idle:Bool;
}

class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var credGroup:FlxGroup = new FlxGroup();
	var textGroup:FlxGroup = new FlxGroup();
	var blackScreen:FlxSprite;
	var credTextShit:Alphabet;
	var ngSpr:FlxSprite;
	
	var titleTextColors:Array<FlxColor> = [0xFFFFCCCC, 0xFFCC3333];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	#if TITLE_SCREEN_EASTER_EGG
	final easterEggKeys:Array<String> = [
		'SHADOW', 'RIVEREN', 'BBPANZU', 'PESSY'
	];
	final allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var easterEggKeysBuffer:String = '';
	#end

	var mustUpdate:Bool = false;

	public static var updateVersion:String = '';

	override public function create():Void
	{
		Paths.clearStoredMemory();
		super.create();
		Paths.clearUnusedMemory();

		if(!initialized)
		{
			ClientPrefs.loadPrefs();
			Language.reloadPhrases();
		}

		curWacky = FlxG.random.getObject(getIntroTextShit());

		#if CHECK_FOR_UPDATES
		if(ClientPrefs.data.checkForUpdates && !closedState) {
			trace('checking for update');
			var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");

			http.onData = function (data:String)
			{
				updateVersion = data.split('\n')[0].trim();
				var curVersion:String = MainMenuState.psychEngineVersion.trim();
				trace('version online: ' + updateVersion + ', your version: ' + curVersion);
				if(updateVersion != curVersion) {
					trace('versions arent matching!');
					mustUpdate = true;
				}
			}

			http.onError = function (error) {
				trace('error: $error');
			}

			http.request();
		}
		#end

		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		}

		FlxG.mouse.visible = false;
		#if FREEPLAY
		MusicBeatState.switchState(new FreeplayState());
		#elseif CHARTING
		MusicBeatState.switchState(new ChartingState());
		#else
		if(FlxG.save.data.flashing == null && !FlashingState.leftState)
		{
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		}
		else
		{
			startIntro();
		}
		#end
	}

	var logoBl:FlxSprite;
	var reimuSit:FlxSprite;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;

	var sakuraPetals:FlxTypedGroup<SakuraPetal>;

	function startIntro()
	{
		persistentUpdate = true;
		if (!initialized && FlxG.sound.music == null)
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

		loadJsonData();
		#if TITLE_SCREEN_EASTER_EGG easterEggData(); #end
		Conductor.bpm = musicBPM;

		logoBl = new FlxSprite(logoPosition.x, logoPosition.y);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.data.antialiasing;

		logoBl.animation.addByPrefix('bump', 'logo-bump', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();

		reimuSit = new FlxSprite(reimuPosition.x, reimuPosition.y);
		reimuSit.antialiasing = ClientPrefs.data.antialiasing;
		
		if(ClientPrefs.data.shaders)
		{
			swagShader = new ColorSwap();
			reimuSit.shader = swagShader.shader;
			logoBl.shader = swagShader.shader;
		}
		
		reimuSit.frames = Paths.getSparrowAtlas(characterImage);
		
		reimuSit.animation.addByPrefix('idle', animationName, 24, true);
		reimuSit.animation.play('idle');


		var animFrames:Array<FlxFrame> = [];
		titleText = new FlxSprite(spacePosition.x, spacePosition.y);
		titleText.frames = Paths.getSparrowAtlas('titleSpace');
		@:privateAccess
		{
			titleText.animation.findByPrefix(animFrames, "space-idle");
			titleText.animation.findByPrefix(animFrames, "space-freeze");
		}
		
		if (newTitle = animFrames.length > 0)
		{
			titleText.animation.addByPrefix('idle', "space-idle", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.data.flashing ? "space-pressed" : "space-freeze", 24);
		}
		else
		{
			titleText.animation.addByPrefix('idle', "Press Space", 24);
			titleText.animation.addByPrefix('press', "space-pressed", 24);
		}
		titleText.animation.play('idle');
		titleText.updateHitbox();

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.antialiasing = ClientPrefs.data.antialiasing;
		logo.screenCenter();

		blackScreen = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		blackScreen.scale.set(FlxG.width, FlxG.height);
		blackScreen.updateHitbox();
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.data.antialiasing;

		sakuraPetals = new FlxTypedGroup<SakuraPetal>(20);

		for(i in 0...sakuraPetals.maxSize)
		{
			var petal = new SakuraPetal(0, 0);
			petal.kill();
			sakuraPetals.add(petal);
		}

		add(reimuSit);
		add(sakuraPetals); // Flowing Petals
		add(logoBl); // SM Logo
		add(titleText); // "Press Space" text
		add(credGroup);
		add(ngSpr);

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	// JSON data
	var characterImage:String = 'sit-reimu';
	var animationName:String = 'sit-reimu';

	var reimuPosition:FlxPoint = FlxPoint.get(534, 364);
	var logoPosition:FlxPoint = FlxPoint.get(50, 100);
	var spacePosition:FlxPoint = FlxPoint.get(800, 476);
	
	var musicBPM:Float = 102;

	function loadJsonData()
	{
		if(Paths.fileExists('images/sit-reimu.json', TEXT))
		{
			var titleRaw:String = Paths.getTextFromFile('images/sit-reimu.json');
			if(titleRaw != null && titleRaw.length > 0)
			{
				try
				{
					var titleJSON:TitleData = tjson.TJSON.parse(titleRaw);
					reimuPosition.set(titleJSON.reimux, titleJSON.reimuy);
					logoPosition.set(titleJSON.titlex, titleJSON.titley);
					spacePosition.set(titleJSON.startx, titleJSON.starty);
					musicBPM = titleJSON.bpm;
					
					if(titleJSON.animation != null && titleJSON.animation.length > 0) animationName = titleJSON.animation;
					if (titleJSON.backgroundSprite != null && titleJSON.backgroundSprite.trim().length > 0)
					{
						var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image(titleJSON.backgroundSprite));
						bg.antialiasing = ClientPrefs.data.antialiasing;
						add(bg);
					}
				}
				catch(e:haxe.Exception)
				{
					trace('[WARN] Title JSON might broken, ignoring issue...\n${e.details()}');
				}
			}
			else trace('[WARN] No Title JSON detected, using default values.');
		}
		//else trace('[WARN] No Title JSON detected, using default values.');
	}

	function easterEggData()
	{
		if (FlxG.save.data.psychDevsEasterEgg == null) FlxG.save.data.psychDevsEasterEgg = ''; //Crash prevention
		var easterEgg:String = FlxG.save.data.psychDevsEasterEgg;
		switch(easterEgg.toUpperCase())
		{
			case 'SHADOW':
				characterImage = 'ShadowBump';
				animationName = 'Shadow Title Bump';
				reimuPosition.x += 210;
				reimuPosition.y += 40;
		}
	}

	function getIntroTextShit():Array<Array<String>>
	{
		#if MODS_ALLOWED
		var firstArray:Array<String> = Mods.mergeAllTextsNamed('data/introText.txt');
		#else
		var fullText:String = Assets.getText(Paths.txt('introText'));
		var firstArray:Array<String> = fullText.split('\n');
		#end
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	private static var playJingle:Bool = false;
	
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		var pressedSpace:Bool = FlxG.keys.justPressed.SPACE || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedSpace = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedSpace = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedSpace = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += FlxMath.bound(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedSpace)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				
				timer = FlxEase.quadInOut(timer);
				
				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}
			
			if(pressedSpace)
			{
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				
				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(ClientPrefs.data.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					if (mustUpdate)
						MusicBeatState.switchState(new OutdatedState());
					else
						MusicBeatState.switchState(new MainMenuState());

					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
			#if TITLE_SCREEN_EASTER_EGG
			else if (FlxG.keys.firstJustPressed() != FlxKey.NONE)
			{
				var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
				var keyName:String = Std.string(keyPressed);
				if(allowedKeys.contains(keyName)) {
					easterEggKeysBuffer += keyName;
					if(easterEggKeysBuffer.length >= 32) easterEggKeysBuffer = easterEggKeysBuffer.substring(1);
					//trace('Test! Allowed Key pressed!!! Buffer: ' + easterEggKeysBuffer);

					for (wordRaw in easterEggKeys)
					{
						var word:String = wordRaw.toUpperCase(); //just for being sure you're doing it right
						if (easterEggKeysBuffer.contains(word))
						{
							//trace('YOOO! ' + word);
							if (FlxG.save.data.psychDevsEasterEgg == word)
								FlxG.save.data.psychDevsEasterEgg = '';
							else
								FlxG.save.data.psychDevsEasterEgg = word;
							FlxG.save.flush();

							FlxG.sound.play(Paths.sound('secret'));

							var black:FlxSprite = new FlxSprite(0, 0).makeGraphic(1, 1, FlxColor.BLACK);
							black.scale.set(FlxG.width, FlxG.height);
							black.updateHitbox();
							black.alpha = 0;
							add(black);

							FlxTween.tween(black, {alpha: 1}, 1, {onComplete:
								function(twn:FlxTween) {
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new TitleState());
								}
							});
							FlxG.sound.music.fadeOut();
							if(FreeplayState.vocals != null)
							{
								FreeplayState.vocals.fadeOut();
							}
							closedState = true;
							transitioning = true;
							playJingle = true;
							easterEggKeysBuffer = '';
							break;
						}
					}
				}
			}
			#end
		}

		if (initialized && pressedSpace && !skippedIntro)
		{
			skipIntro();
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null)
			{
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(logoBl != null)
			logoBl.animation.play('bump', true);

		if(reimuSit != null)
		{
			if(curBeat % 2 == 0) reimuSit.animation.play('idle', true);
		}

		for(i in 0...1)
		{
			var cherryPetal:SakuraPetal = cast(sakuraPetals.recycle(SakuraPetal), SakuraPetal);
			cherryPetal.setPosition(-50, FlxG.random.float(20, 600));
			cherryPetal.scale.set(FlxG.random.float(0.5, 1), FlxG.random.float(0.5, 1));
			cherryPetal.velocity.x = FlxG.random.float(325, 425);
			cherryPetal.velocity.y = FlxG.random.float(-10, 10);
			cherryPetal.angularVelocity = FlxG.random.float(50, 75);
			cherryPetal.alpha = 0.6;
			sakuraPetals.add(cherryPetal);
		
			if(cherryPetal.x > FlxG.width)
			{
				cherryPetal.kill();
			}
		}

		if(!closedState)
		{
			sickBeats++;
			switch (sickBeats)
			{
				case 1:
					//FlxG.sound.music.stop();
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
					FlxG.sound.music.fadeIn(4, 0, 0.7);
				case 2:
					createCoolText(['Psych Engine by'], 40);
				case 4:
					addMoreText('Shadow Mario', 40);
					addMoreText('Riveren', 40);
				case 5:
					deleteCoolText();
				case 6:
					createCoolText(['Not associated', 'with'], -40);
				case 8:
					addMoreText('Either of these', -40);
					ngSpr.visible = true;
				case 9:
					deleteCoolText();
					ngSpr.visible = false;
				case 10:
					createCoolText([curWacky[0]]);
				case 12:
					addMoreText(curWacky[1]);
				case 13:
					deleteCoolText();
				case 14:
					addMoreText('FNF x Touhou');
				case 15:
					addMoreText('~');
				case 16:
					addMoreText('Scarlet Melopoeia'); // credTextShit.text += '\nFunkin';

				case 17:
					skipIntro();
			}
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			#if TITLE_SCREEN_EASTER_EGG
			if (playJingle) //Ignore deez
			{
				playJingle = false;
				var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null) easteregg = '';
				easteregg = easteregg.toUpperCase();

				var sound:FlxSound = null;
				switch(easteregg)
				{
					case 'RIVEREN':
						sound = FlxG.sound.play(Paths.sound('JingleRiver'));
					case 'SHADOW':
						FlxG.sound.play(Paths.sound('JingleShadow'));
					case 'BBPANZU':
						sound = FlxG.sound.play(Paths.sound('JingleBB'));
					case 'PESSY':
						sound = FlxG.sound.play(Paths.sound('JinglePessy'));

					default: //Go back to normal silly sittin raymoo
						remove(ngSpr);
						remove(credGroup);
						FlxG.camera.flash(FlxColor.WHITE, 2);
						skippedIntro = true;

						FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
						return;
				}

				transitioning = true;
				if(easteregg == 'SHADOW')
				{
					new FlxTimer().start(3.2, function(tmr:FlxTimer)
					{
						remove(ngSpr);
						remove(credGroup);
						FlxG.camera.flash(FlxColor.WHITE, 0.6);
						transitioning = false;
					});
				}
				else
				{
					remove(ngSpr);
					remove(credGroup);
					FlxG.camera.flash(FlxColor.WHITE, 3);
					sound.onComplete = function() {
						FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.7);
						transitioning = false;
						if(easteregg == 'PESSY')
							Achievements.unlock('pessy_easter_egg');
					};
				}
			}
			else #end //Default! Edit this one!!
			{
				remove(ngSpr);
				remove(credGroup);
				FlxG.camera.flash(FlxColor.WHITE, 4);

				var easteregg:String = FlxG.save.data.psychDevsEasterEgg;
				if (easteregg == null) easteregg = '';
				easteregg = easteregg.toUpperCase();
				#if TITLE_SCREEN_EASTER_EGG
				if(easteregg == 'SHADOW')
				{
					FlxG.sound.music.fadeOut();
					if(FreeplayState.vocals != null)
					{
						FreeplayState.vocals.fadeOut();
					}
				}
				#end
			}
			skippedIntro = true;
		}
	}
}
