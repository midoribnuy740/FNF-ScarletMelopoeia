package states.stages;

import states.stages.objects.*;

class Gensomooru extends BaseStage
{
    var sakuya:BGSprite;

	var introVoid:BGSprite;
	var introText:BGSprite;

	var title:BGSprite;
	var quote:BGSprite;

    override function create()
	{
		var mall:BGSprite = new BGSprite('gensomooru/mall', 98, 149, 1, 1);
		add(mall);

        var flanShadow:BGSprite = new BGSprite('gensomooru/char-shadow', 460, 751, 1, 1);
        flanShadow.blend = MULTIPLY;
		add(flanShadow);
        var remiShadow:BGSprite = new BGSprite('gensomooru/char-shadow', 800, 751, 1, 1);
        remiShadow.blend = MULTIPLY;
		add(remiShadow);

        var skidShadow:BGSprite = new BGSprite('gensomooru/char-shadow', 260, 791, 1, 1);
        skidShadow.blend = MULTIPLY;
		add(skidShadow);
        var pumpShadow:BGSprite = new BGSprite('gensomooru/char-shadow', 1040, 791, 1, 1);
        pumpShadow.blend = MULTIPLY;
		add(pumpShadow);

        var cart:BGSprite = new BGSprite('gensomooru/cart', 640, 493, 1, 1);
		add(cart);

        sakuya = new BGSprite('gensomooru/spooky-sakuya', 579, 308, 1, 1, ['sakuya-left', 'sakuya-right']);
        add(sakuya);

		introVoid = new BGSprite('gensomooru/introVoid', 0, 0, 0, 0);
		introVoid.x = (FlxG.width / 2) - (introVoid.width / 2);
		introVoid.y = (FlxG.height / 2) - (introVoid.height / 2);
		introVoid.updateHitbox();
		introVoid.cameras = [game.camHUD];

		introText = new BGSprite('gensomooru/introText', 0, 0, 0, 0);
		introText.x = (FlxG.width / 2) - (introText.width / 2);
		introText.y = (FlxG.height / 2) - (introText.height / 2);
		introText.updateHitbox();
		introText.cameras = [game.camHUD];
		introText.alpha = 0;

		add(introVoid);
		add(introText);
	}
	
	override function createPost()
	{
		var boombox:BGSprite = new BGSprite('gensomooru/boombox', 594, 669, 1, 1);
		add(boombox);

		title = new BGSprite('shrine/week-intro/arrival-title', 298, -1011, 1, 1.5);
		title.alpha = 0;
		add(title);

		quote = new BGSprite('shrine/week-intro/arrival-quote', 71, -642, 1, 1.45);
		quote.alpha = 0;
		add(quote);

		game.healthBar.visible = false;
		game.overlayBar.visible = false;
		game.timeTxt.visible = false;
		game.iconP1.visible = false;
		game.iconP2.visible = false;
						
		game.healthBar.alpha = 0;
		game.overlayBar.alpha = 0;
		game.timeTxt.alpha = 0;
		game.iconP1.alpha = 0;
		game.iconP2.alpha = 0;
		game.strumPlayerBG.alpha = 0;

		if(!ClientPrefs.data.middleScroll)
		{
			for(i in 0...game.opponentStrums.length){
				game.opponentStrums.members[i].x -= 1000;
			}
			game.strumEnemyBG.alpha = 0;

			for(i in 0...game.playerStrums.length){
				game.playerStrums.members[i].x -= 313;
			}
			game.strumPlayerBG.x = (FlxG.width / 2) - (game.strumPlayerBG.width / 2);

			FlxTween.tween(game.scoreTxt, {x: (FlxG.width / 2) - (game.scoreTxt.width / 2)}, 1, {ease: FlxEase.circOut});
			if(ClientPrefs.data.downScroll)
			{
				game.botplayTxt.y -= 100;
			}
			else{
				game.botplayTxt.y += 100;
			}
		}
	}

    override function beatHit()
	{
		if(curBeat % 2 == 0)
		{
            sakuya.x = 579;
            sakuya.y = 308;
			sakuya.animation.play('sakuya-left');
		}
		if(curBeat % 2 == 1)
		{
            sakuya.animation.play('sakuya-right');
            sakuya.x = 577;
            sakuya.y = 307;
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch (eventName)
		{
			case "Intro Event":
				prologueIntro();
				if (isStoryMode)
				{
					smWeekIntro();
				}
				FlxTween.tween(game.strumPlayerBG, {alpha: 0.5}, 1, {ease: FlxEase.linear, startDelay: 14});
		}
	}

	function prologueIntro():Void
	{
		FlxTween.tween(introText, {alpha: 1}, 1.5, {ease: FlxEase.linear});

		FlxTween.tween(introText, {alpha: 0}, 1.5, {ease: FlxEase.linear, startDelay: 4});
		FlxTween.tween(introVoid, {alpha: 0}, 1.5, {ease: FlxEase.linear, startDelay: 5});
	}

	function smWeekIntro():Void
	{
		FlxTween.tween(title, {alpha: 1}, 1.5, {ease: FlxEase.linear, startDelay: 9});
		FlxTween.tween(quote, {alpha: 1}, 1.5, {ease: FlxEase.linear, startDelay: 9});

		FlxTween.tween(title, {alpha: 0}, 1.5, {ease: FlxEase.linear, startDelay: 13});
		FlxTween.tween(quote, {alpha: 0}, 1.5, {ease: FlxEase.circIn, startDelay: 13});
	}
}