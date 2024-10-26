package states.stages;

import states.stages.objects.*;
import flixel.addons.display.FlxBackdrop;

class Forest extends BaseStage
{
	var ground:FlxBackdrop;
	var river:BGSprite;
	var treesShadowRight:FlxBackdrop;
	var treesShadowLeft:FlxBackdrop;
	var treesRight:FlxBackdrop;
	var treesLeft:FlxBackdrop;
	var orb:BGSprite;

	var shadows:FlxBackdrop;
	
	override function create()
	{
		ground = new FlxBackdrop(Paths.image('forest/forest-ground'), Y, 0, -55);
		ground.x = -130;
		ground.velocity.set(0, 50);
		ground.updateHitbox();
		ground.scrollFactor.set(0.65, 0.65);
		add(ground);

		river = new BGSprite('forest/forest-rive', -242, -255, 0.65, 0.65);
		river.alpha = 0;
		add(river);

		treesShadowRight = new FlxBackdrop(Paths.image('forest/forest-right-shadowTrees'), Y, 0, 0);
		treesShadowRight.x = 1414;
		treesShadowRight.velocity.set(0, 50);
		treesShadowRight.updateHitbox();
		treesShadowRight.scrollFactor.set(0.75, 0.75);
		treesShadowRight.blend = MULTIPLY;
		treesShadowRight.alpha = 0.6;
		add(treesShadowRight);

		treesShadowLeft = new FlxBackdrop(Paths.image('forest/forest-left-shadowTrees'), Y, 0, 0);
		treesShadowLeft.x = -66;
		treesShadowLeft.velocity.set(0, 50);
		treesShadowLeft.updateHitbox();
		treesShadowLeft.scrollFactor.set(0.75, 0.75);
		treesShadowLeft.blend = MULTIPLY;
		treesShadowLeft.alpha = 0.6;
		add(treesShadowLeft);

		treesRight = new FlxBackdrop(Paths.image('forest/forest-right-trees'), Y, 0, -10);
		treesRight.x = 1799;
		treesRight.velocity.set(0, 75);
		treesRight.updateHitbox();
		treesRight.scrollFactor.set(0.9, 0.85);
		add(treesRight);

		treesLeft = new FlxBackdrop(Paths.image('forest/forest-left-trees'), Y, 0, -10);
		treesLeft.x = -101;
		treesLeft.velocity.set(0, 75);
		treesLeft.updateHitbox();
		treesLeft.scrollFactor.set(0.9, 0.85);
		add(treesLeft);

		orb = new BGSprite('forest/kareshi-orb', 1243, 684, 1, 1);
		add(orb);
	}
	
	override function createPost()
	{
		shadows = new FlxBackdrop(Paths.image('forest/forest-shadows'), Y, 0, 0);
		shadows.x = -359;
		shadows.velocity.set(0, 100);
		shadows.updateHitbox();
		shadows.scrollFactor.set(0.15, 0.15);
		shadows.blend = MULTIPLY;
		shadows.alpha = 0.7;
		add(shadows);
	}

	override function update(elapsed:Float)
	{
		
	}
}