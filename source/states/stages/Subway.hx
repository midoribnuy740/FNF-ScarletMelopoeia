package states.stages;

import states.stages.objects.*;
import flixel.addons.display.FlxBackdrop;

class Subway extends BaseStage
{
    var gensoSky:BGSprite;
    var gensoMountains:FlxSprite;

    var tunnelBg:BGSprite;
    var tunnelLight:FlxBackdrop;
	var gap:FlxBackdrop;

    var subwayBg:BGSprite;
	var spookyBg:BGSprite;
    var subwayDarkBg:BGSprite;

    var gapFilter:BGSprite;
    var filter:BGSprite;
    var introVoid:BGSprite;

    override function create()
	{
        gensoSky = new BGSprite('subway/genso-sky', 0, 0, 0, 0);
		add(gensoSky);
        
        gensoMountains = new FlxSprite(Paths.image('subway/genso-mountains'));
        gensoMountains.x = 384;
        gensoMountains.y = 381;
		gensoMountains.scrollFactor.set(1, 1);
        gensoMountains.velocity.x = 1.5;
		add(gensoMountains);

        tunnelBg = new BGSprite('subway/subway-tunnelBg', 518, 199, 1, 1);
		add(tunnelBg);

        tunnelLight = new FlxBackdrop(Paths.image('subway/subway-tunnelLight'), X, 700, 0);
		tunnelLight.y = 251;
		tunnelLight.velocity.set(1500, 0);
		tunnelLight.updateHitbox();
		tunnelLight.scrollFactor.set(1, 1);
		add(tunnelLight);

		gap = new FlxBackdrop(Paths.image('subway/subway-bgGap'), X, 0, 0);
		gap.alpha = 0;
		gap.velocity.set(100, 0);
		gap.updateHitbox();
		gap.scrollFactor.set(0, 0);
		add(gap);

        subwayDarkBg = new BGSprite('subway/subway-darkBg', 238, 199, 1, 1);
		add(subwayDarkBg);

        subwayBg = new BGSprite('subway/subway-bg', 238, 199, 1, 1);
		subwayBg.alpha = 0;
		add(subwayBg);

		spookyBg = new BGSprite('subway/spooky-subway', 238, 199, 1, 1, ['spooky-bg'], true);
		spookyBg.alpha = 0;
		add(spookyBg);

        introVoid = new BGSprite('gensomooru/introVoid', 0, 0, 0, 0);
		introVoid.x = (FlxG.width / 2) - (introVoid.width / 2);
		introVoid.y = (FlxG.height / 2) - (introVoid.height / 2);
		introVoid.updateHitbox();
		introVoid.cameras = [game.camHUD];
        add(introVoid);
    }

    override function createPost()
	{
		gapFilter = new BGSprite('subway/subway-gapFilter', 0, 0, 0, 0);
        gapFilter.blend = MULTIPLY;
		gapFilter.alpha = 0;
		add(gapFilter);

        filter = new BGSprite('subway/subway-filter', 0, 0, 0, 0);
        filter.blend = MULTIPLY;
		add(filter);

        game.dad.alpha = false;
		game.healthBar.visible = false;
        game.overlayBar.visible = false;
		game.iconP1.visible = false;
		game.iconP2.visible = false;

        game.healthBar.alpha = 0;
		game.overlayBar.alpha = 0;
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

    override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch (eventName)
		{
			case "Intro Event":
				prologueIntro();
			case "Generic Event":
				switch(value1)
				{
					case "gap":
						subwayBg.alpha = 0;
						spookyBg.alpha = 1;
						gap.alpha = 1;
						gapFilter.alpha = 1;
						tunnelLight.alpha = 0;
						FlxTween.tween(gapFilter, {alpha: 0.5}, 2.5, {ease: FlxEase.linear});
					case "out":
						FlxTween.tween(subwayBg, {alpha: 1}, 1.5, {ease: FlxEase.linear});
						FlxTween.tween(spookyBg, {alpha: 0}, 1.5, {ease: FlxEase.linear});
						FlxTween.tween(gap, {alpha: 0}, 1.5, {ease: FlxEase.linear});
						FlxTween.tween(gapFilter, {alpha: 0}, 1.5, {ease: FlxEase.linear});
						FlxTween.tween(tunnelBg, {x: tunnelBg.x + 1000}, 1, {ease: FlxEase.linear, startDelay: 2});
				}
		}
	}

    function prologueIntro():Void
	{
		FlxTween.tween(introVoid, {alpha: 0}, 1.5, {ease: FlxEase.linear, startDelay: 8});
        FlxTween.tween(game.strumPlayerBG, {alpha: 0.5}, 1, {ease: FlxEase.linear, startDelay: 8});
        FlxTween.tween(subwayBg, {alpha: 1}, 2, {ease: FlxEase.linear, startDelay: 9});
	}
}