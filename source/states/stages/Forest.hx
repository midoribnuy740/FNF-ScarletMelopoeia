package states.stages;

import states.stages.objects.*;
import objects.Note;
import flixel.addons.display.FlxBackdrop;

class Forest extends BaseStage
{
	var ground:FlxBackdrop;
	var river:FlxSprite;
	var treesShadowRight:FlxBackdrop;
	var treesShadowLeft:FlxBackdrop;
	var treesRight:FlxBackdrop;
	var treesLeft:FlxBackdrop;

	var tipsy:BGSprite;
	var attacked:Bool = false;

	var orb:BGSprite;

	var shadows:FlxBackdrop;
	var stageDarkness:FlxBackdrop;

	// Spell Card
	var filter1:FlxBackdrop;
	var filter2:FlxBackdrop;

	var spellDarkness:FlxSprite;

	var spellCardOn:Bool = false;

	var strumsPX:Array<Int> = [];
	var strumsPY:Array<Int> = [];
	
	override function create()
	{
		ground = new FlxBackdrop(Paths.image('forest/forest-ground'), Y, 0, -110);
		ground.x = -130;
		ground.velocity.set(0, 100);
		ground.updateHitbox();
		ground.scrollFactor.set(0.65, 0.65);
		add(ground);

		river = new FlxSprite(Paths.image('forest/forest-river'));
		river.x = -242;
		river.y = -1755;
		river.scrollFactor.set(0.65, 0.65);
		river.alpha = 0;
		add(river);

		treesShadowRight = new FlxBackdrop(Paths.image('forest/forest-right-shadowTrees'), Y, 0, 0);
		treesShadowRight.x = 1414;
		treesShadowRight.velocity.set(0, 100);
		treesShadowRight.updateHitbox();
		treesShadowRight.scrollFactor.set(0.75, 0.75);
		treesShadowRight.blend = MULTIPLY;
		treesShadowRight.alpha = 0.6;
		add(treesShadowRight);

		treesShadowLeft = new FlxBackdrop(Paths.image('forest/forest-left-shadowTrees'), Y, 0, 0);
		treesShadowLeft.x = -66;
		treesShadowLeft.velocity.set(0, 100);
		treesShadowLeft.updateHitbox();
		treesShadowLeft.scrollFactor.set(0.75, 0.75);
		treesShadowLeft.blend = MULTIPLY;
		treesShadowLeft.alpha = 0.6;
		add(treesShadowLeft);

		treesRight = new FlxBackdrop(Paths.image('forest/forest-right-trees'), Y, 0, -25);
		treesRight.x = 1799;
		treesRight.velocity.set(0, 150);
		treesRight.updateHitbox();
		treesRight.scrollFactor.set(0.9, 0.85);
		add(treesRight);

		treesLeft = new FlxBackdrop(Paths.image('forest/forest-left-trees'), Y, 0, -25);
		treesLeft.x = -101;
		treesLeft.velocity.set(0, 150);
		treesLeft.updateHitbox();
		treesLeft.scrollFactor.set(0.9, 0.85);
		add(treesLeft);

		tipsy = new BGSprite('characters/sm-sd-tipsy', 837, -856, 1, 1, ['tipsy-idle', 'tipsy-alt-idle', 'tipsy-death'], true);
		add(tipsy);

		filter1 = new FlxBackdrop(Paths.image('forest/spell-card-filter-1'), Y, 0, 0);
		filter1.velocity.set(0, -250);
		filter1.updateHitbox();
		filter1.scrollFactor.set(0, 0);
		filter1.screenCenter(X);
		filter1.alpha = 0;
		add(filter1);

		filter2 = new FlxBackdrop(Paths.image('forest/spell-card-filter-2'), XY, -200, -300);
		filter2.velocity.set(250, 250);
		filter2.updateHitbox();
		filter2.scrollFactor.set(0, 0);
		filter2.alpha = 0;
		add(filter2);

		stageDarkness = new FlxBackdrop(Paths.image('forest/forest-darkness'), XY, 0, 0);
		stageDarkness.updateHitbox();
		stageDarkness.scrollFactor.set(1, 1);
		stageDarkness.blend = MULTIPLY;
		stageDarkness.alpha = 0;
		add(stageDarkness);

		orb = new BGSprite('forest/kareshi-orb', 1243, 684, 1, 1);
		add(orb);
	}
	
	override function createPost()
	{
		game.camFollow.x = 1100;
		game.camFollow.y = 400;
		game.healthBar.visible = false;
		game.overlayBar.visible = false;
		game.timeTxt.visible = false;
		game.iconP1.visible = false;
		game.iconP2.visible = false;

		shadows = new FlxBackdrop(Paths.image('forest/forest-shadows'), Y, 0, 0);
		shadows.x = -359;
		shadows.velocity.set(0, 200);
		shadows.updateHitbox();
		shadows.scrollFactor.set(0.15, 0.15);
		shadows.blend = MULTIPLY;
		shadows.alpha = 0.7;
		add(shadows);

		spellDarkness = new FlxSprite(Paths.image('forest/spell-card-darkness'));
		spellDarkness.alpha = 0;
		spellDarkness.blend = MULTIPLY;
		spellDarkness.scale.set(FlxG.width, FlxG.height);
		spellDarkness.updateHitbox();
		spellDarkness.screenCenter();
		spellDarkness.scrollFactor.set(0, 0);
		game.uiGroup.add(spellDarkness);

		for (i in 0...game.playerStrums.length) {
			strumsPX[i] = game.playerStrums.members[i].x;
			strumsPY[i] = game.playerStrums.members[i].y;
		}
	}

	override function update(elapsed:Float)
	{
		
	}

	override function goodNoteHit(note:Note)
	{
		if(note.noteType == 'Tipsy Attack')
		{
			attacked = true;

			FlxG.sound.play(Paths.sound('orb-shoot'), 0.25);
			var ofuda:FlxSprite = new FlxSprite(Paths.image('ofuda'));
			ofuda.x = orb.x + (orb.width / 2);
			ofuda.y = orb.y + (orb.height / 2);
			ofuda.updateHitbox();
			ofuda.angle = -15;
			ofuda.scrollFactor.set(1, 1);
			ofuda.blend = ADD;
			add(ofuda);

			FlxTween.tween(ofuda, {
					x: tipsy.x + (tipsy.width / 2), 
					y: tipsy.y + (tipsy.height / 2)
				}, 0.1, {
				ease: FlxEase.linear,
				onComplete: function(twn:FlxTween)
					{
						remove(ofuda);
						ofuda.destroy();

						var impact:FlxSprite = new FlxSprite(Paths.image('forest/death-impact'));
						impact.x = tipsy.x + (tipsy.width / 2) - (impact.width / 2);
						impact.y = tipsy.y + (tipsy.height / 2) - (impact.height / 2);
						impact.updateHitbox();
						impact.alpha = 0.5;
						impact.angularVelocity = 300;
						impact.scrollFactor.set(1, 1);
						impact.blend = ADD;
						add(impact);

						FlxTween.tween(impact.scale, {x: 4, y: 4}, 1, {ease: FlxEase.circOut});
						FlxTween.tween(impact, {alpha: 0}, 1, {ease: FlxEase.linear});

						tipsy.animation.play('tipsy-death');
						FlxG.sound.play(Paths.sound('tipsy-death'), 0.5);
						tipsy.offset.set(-5, -20);
						FlxTween.tween(tipsy, {y: -126, alpha: 0}, 2, {
							ease: FlxEase.circOut,
							onComplete: function(twn:FlxTween)
								{
									remove(tipsy);
									tipsy.destroy();
								}
						});
					}
			});
		}
	}

	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "Generic Event":
				switch(value1)
				{
					case "bgChange":
						FlxTween.tween(treesLeft, {x: -606}, 2, {ease: FlxEase.circIn});
						FlxTween.tween(treesShadowLeft, {x: -766}, 2, {ease: FlxEase.circIn});

						FlxTween.tween(treesRight, {x: 2299}, 2, {ease: FlxEase.circIn});
						FlxTween.tween(treesShadowRight, {x: 2014}, 2, {ease: FlxEase.circIn});

						FlxTween.tween(shadows, {alpha: 0}, 2, {ease: FlxEase.linear});
					case "river":
						river.alpha = 1;
						river.velocity.y = 100;
					case "rumia":
						FlxTween.tween(game.dad, {y: -260}, 2, {ease: FlxEase.circOut});

				}
			case "Mob Fairies":
				switch(value1)
				{
					case "blue":
						blueFairy(value2);
					case "pink":
						pinkFairy(value2);
				}
			case "Tipsy":
				switch(value1)
				{
					case "in":
						FlxTween.tween(tipsy, {y: -36}, 2, {
							ease: FlxEase.circOut,
							onComplete: function(twn:FlxTween)
							{
								var tipsyDanmaku:FlxSprite = new FlxSprite(Paths.image('forest/tipsy-danmaku'));
								tipsyDanmaku.x = tipsy.x - 10;
								tipsyDanmaku.y = tipsy.y + 200;
								tipsyDanmaku.scrollFactor.set(1, 1);
								tipsyDanmaku.angularVelocity = 200;
								tipsyDanmaku.alpha = 0;
								add(tipsyDanmaku);

								FlxTween.tween(tipsyDanmaku, {alpha: 1}, 2, {
									ease: FlxEase.circOut,
									onComplete: function(twn:FlxTween)
										{
											tipsyDanmaku.velocity.x = 125;
											tipsyDanmaku.velocity.y = 250;
										}
								});
							}
						});
					case "out":
						if(!attacked)
						{
							tipsy.animation.play('tipsy-alt-idle');
							FlxTween.tween(tipsy, {y: -856}, 2, {ease: FlxEase.circIn,
							onComplete: function(twn:FlxTween)
								{
									remove(tipsy);
									tipsy.destroy();
								}
							});
						}
				}

			case "Spell Card":
				if(!spellCardOn) {
					spellCardOn = true;
					FlxTween.tween(stageDarkness, {alpha: 0.7}, 2, {ease: FlxEase.linear});

					FlxTween.tween(filter1, {alpha: 0.6}, 2, {ease: FlxEase.linear});
					FlxTween.tween(filter2, {alpha: 0.4}, 2, {ease: FlxEase.linear});

					FlxTween.tween(spellDarkness, {alpha: 0.75}, 2, {ease: FlxEase.linear});
				}
				else {
					spellCardOn = false;
					FlxTween.tween(stageDarkness, {alpha: 0}, 2, {ease: FlxEase.linear});

					FlxTween.tween(filter1, {alpha: 0}, 2, {ease: FlxEase.linear});
					FlxTween.tween(filter2, {alpha: 0}, 2, {ease: FlxEase.linear});

					FlxTween.tween(spellDarkness, {alpha: 0}, 2, {ease: FlxEase.linear});
				}

				
		}
	}

	function blueFairy(Side:String):Void
	{
		var fairyStartPos:Int = 0;
		var fairyEndPos:Int = 0;
		var fairyVelocity:Int = FlxG.random.int(200, 300);

		if(Side == 'left')
		{
			fairyStartPos = FlxG.random.int(200, 600);
			fairyEndPos = -600;
		}
		else if(Side == 'right')
		{
			fairyStartPos = FlxG.random.int(1200, 1600);
			fairyEndPos = 2200;
		}

		var blueFairy:BGSprite = new BGSprite('characters/sd-mob-fairy-1', fairyStartPos, -900, 0.8, 0.8, ['blue-idle'], true);
		blueFairy.velocity.set(0, fairyVelocity);
		blueFairy.scale.set(0.75, 0.75);
        addBehindGF(blueFairy);

		FlxTween.tween(blueFairy, {x: fairyEndPos}, 5, {
			ease: FlxEase.circIn, 
			startDelay: 3, 
			onComplete: function(twn:FlxTween)
			{
				remove(blueFairy);
				blueFairy.destroy();
			}
		});
	}

	function pinkFairy (Side:String):Void
	{
		var fairyStartPos:Int = 0;
		var fairyEndPos:Int = 0;
		var fairyVelocity:Int = FlxG.random.int(200, 300);

		if(Side == 'left')
		{
			fairyStartPos = FlxG.random.int(200, 600);
			fairyEndPos = -600;
		}
		else if(Side == 'right')
		{
			fairyStartPos = FlxG.random.int(1200, 1600);
			fairyEndPos = 2200;
		}

		var pinkFairy:BGSprite = new BGSprite('characters/sd-mob-fairy-2', fairyStartPos, -900, 0.8, 0.8, ['pink-idle', 'pink-attack'], true);
		pinkFairy.scale.set(0.8, 0.8);
        addBehindGF(pinkFairy);

		FlxTween.tween(pinkFairy, {y: FlxG.random.int(-100, 100)}, 2, {
			ease: FlxEase.circOut, 
			onComplete: function(twn:FlxTween)
			{
				pinkFairy.animation.play('pink-attack');
				FlxG.sound.play(Paths.sound('mob-fairy-prank'), 0.25);

				var prank:FlxSprite = new FlxSprite(Paths.image('forest/prank'));
				prank.x = pinkFairy.x + (pinkFairy.width * 0.8);
				prank.y = pinkFairy.y + (pinkFairy.height * 0.25);
				prank.updateHitbox();
				prank.alpha = 0.5;
				prank.angularVelocity = -200;
				prank.scrollFactor.set(1, 1);
				prank.blend = ADD;
				add(prank);

				FlxTween.tween(prank.scale, {x: 3, y: 3}, 1, {ease: FlxEase.circOut});
				FlxTween.tween(prank, {alpha: 0}, 1, {ease: FlxEase.circOut});

				for (i in 0...game.playerStrums.length) {
					switch(i)
					{
						case 0:
							game.playerStrums.members[i].x -= 20;
						case 1:
							game.playerStrums.members[i].y += 20;
						case 2:
							game.playerStrums.members[i].y -= 20;
						case 3:
							game.playerStrums.members[i].x += 20;
					}
		
					FlxTween.tween(game.playerStrums.members[i], {x: strumsPX[i], y: strumsPY[i]}, 1, {
						ease: FlxEase.circOut,
						onComplete: function(twn:FlxTween)
							{
								pinkFairy.animation.play('pink-idle');
								FlxTween.tween(pinkFairy, {x: fairyEndPos, y: 600}, 2, {
									ease: FlxEase.circIn, 
									onComplete: function(twn:FlxTween)
									{
										remove(pinkFairy);
										pinkFairy.destroy();
									}
								});
							}
						});
				}
			}
		});
	}
}




 //                                                ...::...:::..:.................:::::::::.............:::::+..::::;XXXXXXXXXXXXXXXXX;:                                            
 //                                             .....::  ..:::..:..................:::::::::::::..::::::::::XXXXXxx+;XXXXXXXXXXXXXXX+x                                              
 //                                           .......:....:::..::................:::::::::::::::::::::::::::x;;;+XXXXXXXXXXXXX+XXxx;....                                            
 //                                         .......:......::::::::.................:::::::::::::::::...::...:x::::+XXXXXXXXxXx++;:::::....                                          
 //                                        ...:..::::.....:::::::::...............::::::+::::::::..:::..:::::;X+xXX;XXXXXXXX+;::::::::::....                                        
 //                                       ...:::::::::.:::::::::::::.........:..:::::::::++:::+::::::::::::::::Xxx::+Xxxxxx+x:::+;::::::::....                                      
 //                                      .::::::::::.:::..::::::::::::::::::::::::::::::::;X;::x::::::::::::::::+xXXXXXXXXX;;::::;;:::::::::...                                     
 //                                     .::..:::::::::::..::::::+;:::::::::::::::::::::::::;+;;:+;::::::::::::::::::;;;;:;;:::::::;x::....::::...                                   
 //                                     :::..:::::.:::::::::::::::;;::::::::::::::::::::::;:;+:;:;+:::::::::::::::::..:::.::.::::::;+::....::.....                                  
 //                                     +::..::::::::::::::::::::::::+::::::::::::::::::::::;;;::+;;:::::::::::::::::..:.:.;:......::+::.....:::...                                 
 //                                    .+::..::::::::::::::::::::::::;+:::..:::::::...:::::::;x:::;;;...::::::::::::::::::::;:::::::::;::::::::::..                                 
 //                                     +:::..::::::::+:::::::::::.::;;+:::::.................:+:..:x:...::::::::::::::::::::+:::::::::::::::::::::.                                
 //                                     ..::+.::::::::+;:::::::::::....:+::.:::;:.:x+;.........;+...:x::.::::.::::::::::::::::::::::::::;:::::::::::.                               
 //                                      ...:+::::::;:x+::::;;;::.........:...   ...:++;+xxXXX$$$$$$$X+;;:+.:..::::::::+::::::;:::::::::;;::::::::: :                               
 //                                       :.: ;::::::+X;x::.:::++::+x;;;::::;:.      .::+++$&$$$$$$$$$X:x++.....:::::::++:::::+::::::::::+::::::::. +                               
 //                                        ;..  ;:::::+;:;x::;;+xxxXXX+:..                 xXx;;++;;;;+x..:.....:::::::x;:::::X::::::::::x:::::::;. x                               
 //                                          +.   x::::+XXXXx;::x$$$$xxXX;               .........::::;:::+:::..:::::::x;:::::+:::::::::;+:::::::+ :x                               
 //                                            .  x::x;:::::;.   :.::;;......    . .   ..........:::::::::;;;:.::::::::++:::::X:::::::::x:::::::+ x;                                
 //                                               .;::::;+;+;::+::::::.......                ........::.:+:X;:::::::::X+;:::+XX;::::;:++:+;:::XX++                                  
 //                                                .:::::+::::::x;:::....                           .. .;;;+;::::::::XX::;XXxXx:+++XXX;.x::::x:                                     
 //                                                :+X:::;;::::::+x....          ..                ...;;+::+:::::::::;+XXXXxX; :;      .x+                                          
 //                                              .:   ;:::;x:::::::;x+.                          ..::X+:::;x:::::xxx;;     :                                                        
 //                                                     :::;+;+::::::x+:.:+;:               ...:::::::::::X;:;+x::;x:::;;                                                           
 //                                                         :+:  :+;::;x..;:;+x;:;;::++x;xXXx:::::::::::;X++;::x;:::::::::::;+                                                      
 //                                                                            :; :+x+::::+xx;:::::::::::::::::::::::::::::::$$XXx.                                                 
 //                                                                           ;;::::::::::;+:::::::::::::..  . ............:&$$$XX$X$$Xx+:                                          
 //                                                                     +xXXXX:::..   .:::::;:::::::::.                 .x$$XX$$$$$$$X+;::;;:.                                      
 //                                                                 ..;X;X$+x:     .;;:::::::x:...::::::.              +&$$$$$&$XX;......         ..                                
 //                                                              .   .X;x$xX:   ;X$+:::::...:+;;:::.::::::+;.        .$$$$$$$$$X.    ..                                             
 //                                                            :    .x$$$$$$$$$&$&XX+;..+;::xXX;:. .:x..+$$$$$$x;.  ;&$$$$$$$$x.   .      .              .                          
 //                                                            +   .:X$$$$$$$$$&$$x;xXXXXxX+XxxXXXXXx+x$$$$$$$$$$$$$$$$$$$$$$+:   .      :::.             .                         
 //                                                            +.  .:$$$$$$$$$$$$X:.:;++x:::.:x;:::;X$$$$$X$$$$$$$$$$$$$$$$$;:.   .     :::.              .                         
 //                                                            x:.::x$$X$$$$$$$+$;:;;;+::::+:.:x:+$$$$$$$$$$$$$$$$$$$$$$$$$$::.  ..    .::.             ....                        
 //                                                          .:::..:$;+$$$$$$$$X$X++;::::xXX+:::X$$$$$$$$$$$$$$$$$$$$$$$&$$$;::  :.   :;:           ..... ..                        
 //                                                         .:.:..x;;$$$$$$$$$x;XXXXxxxXXXXX;+::;X$$$$$$$$$$$$$$$$$$$$$$$$$$X::. :...::.    ..    ....... .:                        
 //                                                        ..   x+;$$$$$$$$X;xXX+;XX;+XXXXX:x;:;XX$$$$$$$$$$$$$$$$$$$$$$$&&$$+:::::::::. .:.    .......   :::                       
 //                                                       .    X:x$$$$$$$X;:+xX;;xX;XXXXXX+x;::+XXX$$$$$$$$$$$$$$$$$$$$$$&&$$$::x+.::;::;.     ::.....   ..:::.                     
 //                                                     ..::.:+++$$$$$$Xx::;Xx:xXXxXXXXXXXXXXXXxXXX$$$$$$$$$$$$$$$$$$$$$$$&&$$X::;;::Xx ;:: .::::::.   .:::::::                     
 //                                                      ..:: :XX$$$$$+::::xx::XXXXXXXXXX+XXXXX+XXX$$$$$$$$$$$$$$$$$$$$$$$$&&$$X:::+X::+:..:::...    .:.    ..:.                    
 //                                                       +....$$$$$$XXXXXXXXXXX$XXXXXXXXxXXX+XXXXX$$$$$$$$$$$$$$$$$$$$$$$$$$&$$$;::+x:        .::;:             ..                 
 //                                                      :::.   $$$$$$$&&&&&&&&&$$&$$$$$$$&&$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$&&$$$+:   ..::::; .::::::::.      ..                 
 //                                                    .:....:;.+$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$&&&$+::::.  .:::::::;.       :::                  
 //           :.                                      .:::..:::::X$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$;+X;   .::.+:         .::::::...              
 // : +  . x  ;:;                                       .;x::;..:+$x$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$&$$$X..:;.:...:+::::::::::::.   ..:;:.            
 //  + ; ;;:; +;;:                                       .+:::.  .&Xx$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$&$$$x+X;.  .;;:;;;;::::.:.  :::::::::+            
 //  .::+ x . .  :                                      ;;::;... .$$$X$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$&$$$XXX  .+:::::.:::;:. .;:::::::::::..:.         
 //   ;         .:;                                  ;:..        :$x$$X$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$;.::+x:  .:;;. .::;;:::::::::::  .::        
 //     ;:::::::;;                                    ;X;;...::::;$X$$$$$$$$$$$$$$$$$$$$$$$$:  ..;x$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$XX    .  .:;.  .:::::::::::::::...:::         
 //         +x:x                     .....................:.;;.::;XX$$$$$$$$$$$$$$$$$$$$$$+         .+$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$XX       +;:::::::::::::::::::..:::::          
 //          X::+           .............:...........................::$$$$$$$$$$$$$$$$$$$         ....:$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$       ;:::::::::::::::::::::::::::;;         
 //         ..    ;     ....:.....................................:::.:;$$$$$$$$$$$$$$$$$$;             ;$$$$$$$$$$$$$$$$$$$$$$$$$$$$       ;     ..::...::::;::. ...:::;;:;.       
 //          x::   ;...........................................::::.......;xX$$$$$$$$$$$$$$X:..::::.   .X$$$$$$$$$$$$$$$$$$$$$$$$$$$X      .+  .;:.  .::::;;+;::::::::..::::::+     
 //          .+::::...::...:.............................:::...................;x$$$$$$$$$$$$$$Xxxxx+X$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$         .::x+x;::::++;:......:::;:;:::;+.     
 //     :.   .;;.:::::::::::............:....:.......:.::::.......................x$$$$$$$$$$$$$$$$$$:.X$$$$$$$$$$$$$$$$$$$$$$$$$$$$$+            .;:...................:::;;;+     
 //      :;.:::::.:..::::::...........:::::.::::.......::...........................:$$$$$$$$$$$$$$$$x;:.:X$$$$$$$$$$$$$$$$$$$$$$&$$Xx        .........................:::::.       
 //      .+:::::::::::::..:::::.....::::::::::::....:::...:...........................;$$$$$$$$$$$$$$x:::::+$$$$XXXx;::::xX$$$X$$&$$+:X   ..................        ..:::...        
 //       +::::::::::::::....:::::::::....::::::::.;:.............:.....................$$$$$$$$$$$$$x+;::;:.     .......   .xXXXx+;.  ........                  .:::::...          
 //      .;::::::::::::::::::::::::::...........::.:......::::.....:....................$$$$$$$$$$$...;......::::::::...................                    .::::::..               
 //       :::::;:::.:::::::::::::::::..........:.:::::::::::::::....:...................$$$$$$$$$X;;+X+:::::::::::::::::...........                   ..........                    
 //        .;::::::::::::::::::::::::.....:::..;;:::::..::::::::....::::::::...........;$$$$$$$$$$$$$$X::::::::::::::::...............  .       ......+:.                           
 //         ::;::::::::::::::::::::::::..:;X+;:::::::::::.::::......::::::..........::;             :+++xX::::::::::::::.................;;:+;.                                     