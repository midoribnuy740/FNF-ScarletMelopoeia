package states.stages;

import states.stages.objects.*;

class Gensomooru extends BaseStage
{
    var sakuya:BGSprite;

    override function create()
	{
		var mall:BGSprite = new BGSprite('gensomooru/mall', 98, 149, 1, 1);
		add(mall);

        var flanShadow:BGSprite = new BGSprite('gensomooru/char-shadow', 520, 751, 1, 1);
        flanShadow.blend = MULTIPLY;
		add(flanShadow);
        var remiShadow:BGSprite = new BGSprite('gensomooru/char-shadow', 740, 751, 1, 1);
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
	}
	
	override function createPost()
	{
		var boombox:BGSprite = new BGSprite('gensomooru/boombox', 594, 669, 1, 1);
		add(boombox);
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

}