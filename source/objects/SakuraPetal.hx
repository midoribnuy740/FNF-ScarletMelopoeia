
package objects;

class SakuraPetal extends FlxSprite
{
	//this code was made by broster, thank u one more time once again

    public function new(x:Float, y:Float)
	{
		super(x, y);

		loadGraphic(Paths.image('titlescreen/petal'));
		
		antialiasing = ClientPrefs.data.antialiasing;
	}

	override function kill()
    {
        super.kill();
    }
}