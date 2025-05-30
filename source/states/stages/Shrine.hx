package states.stages;

import states.stages.objects.*;
import objects.*;

class Shrine extends BaseStage
{
	var title:BGSprite;
	var quote:BGSprite;

	var orbBack:FlxSprite;
	var orbFront:FlxSprite;

	var dropZoom:FlxTween;

	override function create()
	{
		var sky:BGSprite = new BGSprite('shrine/shrine-sky', -581, -266, 0, 0);
		add(sky);

		var clouds:BGSprite = new BGSprite('shrine/shrine-clouds', -211, -551, 0.2, 1.1);
		add(clouds);

		var mountains:BGSprite = new BGSprite('shrine/shrine-mountains', -371, 94, 0.6, 1.1);
		add(mountains);

		var trees:BGSprite = new BGSprite('shrine/shrine-trees', -641, 126, 0.9, 1.05);
		add(trees);

		var grounds:BGSprite = new BGSprite('shrine/shrine-grounds', -614, 144, 1, 1);
		add(grounds);

		var reimuShadow:BGSprite = new BGSprite('shrine/shadows/shrine-shadow-reimu', 141, 806, 1, 1);
		reimuShadow.alpha = 0.6;
		add(reimuShadow);

		var kanShadow:BGSprite = new BGSprite('shrine/shadows/shrine-shadow-kan', 515, 758, 1, 1);
		kanShadow.alpha = 0.6;
		add(kanShadow);

		var karShadow:BGSprite = new BGSprite('shrine/shadows/shrine-shadow-kar', 864, 800, 1, 1);
		karShadow.alpha = 0.6;
		add(karShadow);

		orbBack = new FlxSprite().loadGraphic(Paths.image('shrine/orb-back'));
		orbBack.x = 359;
		orbBack.y = 577;
		orbBack.angularVelocity = 200;
		orbBack.visible = false;
		add(orbBack);
	}

	override function createPost()
	{
		if (isStoryMode)
		{
			game.strumEnemyBG.alpha = 0;
			game.strumPlayerBG.alpha = 0;
			game.camFollow.x = 650;
			game.camFollow.y = -1000;
		}

		orbFront = new FlxSprite().loadGraphic(Paths.image('shrine/orb-front'));
		orbFront.x = 5;
		orbFront.y = 608;
		orbFront.visible = false;
		orbFront.angularVelocity = -200;
		add(orbFront);
		
		var sunlight:BGSprite = new BGSprite('shrine/shrine-sunlight', -677, -411, 0, 0);
		sunlight.alpha = 0.2;
		sunlight.blend = ADD;
		add(sunlight);

		title = new BGSprite('shrine/week-intro/arrival-title', 298, -1011, 1, 1.5);
		title.alpha = 0;
		add(title);

		quote = new BGSprite('shrine/week-intro/arrival-quote', 71, -642, 1, 1.45);
		quote.alpha = 0;
		add(quote);
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch (eventName)
		{
			case "Intro Event":
				if (isStoryMode)
				{
					smWeekIntro();
					game.isCameraOnForcedPos = true;
					game.camFollow.x = 650;
					game.camFollow.y = -400;
				}

			case "Generic Event":
				switch (value2)
				{
					case 'reimuSolo': // reimu solo
						dropZoom = FlxTween.tween(FlxG.camera, {zoom: 1}, 5.5, {
							ease: FlxEase.linear,
							onComplete: function(twn:FlxTween)
							{
								dropZoom = null;
							}
						});
					default:
						FlxG.camera.zoom = 0.8;
				}

			case "Spell Card":
				orbBack.visible = true;
				orbFront.visible = true;

				var char:Character = game.dad;
				var powerup:FlxSprite = new FlxSprite().loadGraphic(Paths.image('powerup'));
				powerup.x = char.x + (char.width / 2) - (powerup.width / 2);
				powerup.y = char.y - 50;
				powerup.alpha = 1;
				add(powerup);

				FlxTween.tween(powerup, {y: powerup.y - 30, alpha: 0}, 1.5, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						remove(powerup);
						powerup.destroy();
					}
				});

				FlxG.sound.play(Paths.sound('spell'), 0.5);
				char.color = 0xFFFFE1E1;
				FlxTween.color(char, 0.5, 0xFFFFE1E1, 0xFFFFFFFF, {ease: FlxEase.circOut});
		}
	}

	function smWeekIntro():Void
	{
		FlxTween.tween(title, {alpha: 1}, 1.5, {ease: FlxEase.linear});
		FlxTween.tween(quote, {alpha: 1}, 1.5, {ease: FlxEase.linear});

		FlxTween.tween(title, {alpha: 0}, 1.5, {ease: FlxEase.linear, startDelay: 6});
		FlxTween.tween(quote, {alpha: 0}, 1.5, {ease: FlxEase.circIn, startDelay: 6});

		FlxTween.tween(game.camFollow, {y: 525}, 2, {ease: FlxEase.circInOut, startDelay: 6});

		FlxTween.tween(game.strumEnemyBG, {alpha: 0.5}, 1, {ease: FlxEase.linear, startDelay: 7});
		FlxTween.tween(game.strumPlayerBG, {alpha: 0.5}, 1, {ease: FlxEase.linear, startDelay: 7});
	}
}






//                                   @@@                                                                      @@@@@@@@@@                                 
//                               @@@@@@@@@@@@@                                                             @@@@@@@@@@@@@@@@@                             
//                             @@@@@@@@@@@@@@@@@@                                                        @@@@@@@%%###%%@@@@@@@                           
//                           @@@@@@%########%@@@@@@@                                                   @@@@@@%############@@@@@                          
//                          @@@@@%##############@@@@@@@                                              @@@@@%#################@@@@                         
//                         @@@@@%#################%@@@@@@                                          @@@@@%####################@@@@                        
//                         @@@@%#####################%@@@@@@                                     @@@@@%######################@@@@@                       
//                         @@@@%########################%@@@@@                                  @@@@@########################@@@@@                       
//                         @@@@@##########################%@@@@@                               @@@@%##%%%%##################%@@@@@                       
//                         @@@@@%##################%@@@@%###%@@@@@         @@@@@@            @@@@@##%@@@@@@#################@@@@@                        
//                          @@@@@##################@@@%@@@@%##%@@@@@    @@@@@@@@@@@@        @@@@%#%@@@%%%@@################@@@@@                         
//                           @@@@@#################%@@%#%%@@@%##%@@@@@@@@@@@@@@@@@@@@@     @@@@##%@@%%%%%@%###############@@@@@                          
//                            @@@@@#################%@@%%##%%@@###@@@@@@@@@@@@@@@@@@@@@@  @@@@##@@%%%%%%@%###############%@@@@                           
//                             @@@@@#################%@%%####%%@%##%@@@@@@@@@@@@@@@@@@@@@@@@%#%@%%%%%%%%%################%@@@@@@                         
//                              @@@@@####################%#%%%%%%%%##@@@@@@@@@@@@@@@@@@@@@@##%@%%%%%%%%%###################%@@@@@@                       
//                            @@@@@%###################%%@@@@@@@@@@@%%%@@@@@@@@@@@@@@@@@@@##%@@@@@@@@@@@@@@@@%###############%@@@@@@                     
//                          @@@@@@#################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%############%@@@@@                     
//                        @@@@@@###############%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%###########%@@@@@                    
//                       @@@@@%##############%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%########%%@@@@                    
//                       @@@@@#############%@@@@%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#######%@@@@                    
//                       @@@@%###########%@@@@%%%%@@@%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@######%%@@@@                   
//                       @@@@%##########@@@@%%%%@@@%%%###%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%###%%@@@@                   
//                       @@@@%%########@@@%%#%%@@@%%####%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%##%%@@@@                   
//                       @@@@%%######%@@@%###%%@@@%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#%@@@@@                   
//                       @@@@@%#####%@@@%#####%%@@@@@@@%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@                   
//                        @@@@%####%@@@%######%%%@@@@@@%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                    
//                        @@@@@@%##%@@%#########%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                     
//                    @@@@@@@@@@@@%@@@%###########%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                    
//                @@@@@@@@@%%%@@@@@@@%#################%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@%%@@%%%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@%%@@@@@@@               
//           @@@@@@@@@%%#######%%%@@@%########%%%%%%%%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@%=#@@%#%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@%###%%@@@@@@@           
//      @@@@@@@@@@%###############@@@%#####%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#==#@@%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#######%%@@@@@@@       
//  @@@@@@@@@%%##################%@@@%##%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*===%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%###########%@@@@@@@@   
// @@@@@@@%#######################%@@@%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*===+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%##############%%@@@@@@ 
//   @@@@@@@@@%###################%@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+====#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%###############%@@@@@@@ 
//       @@@@@@@@@@%##############%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#+=====%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%##########%%@@@@@@@@    
//            @@@@@@@@@@##########%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@+======+@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%######@@@@@@@          
//                 @@@@@%########@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%+=======@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#%@@@@@              
//                   @@@########@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%+=:-====#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                
//                   @@@######%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%=.:====+@@@@@@@@@@@@@@@@@@#+#@@@@@@@@@@@@@@@@@@@@                
//                  @@@@#####%@@@@@@@@@@@@@@@@@@@@@@@@@@@@%###@@@@@@@@@@%#**++====++**%*:..-===+%#*+==++++#@@@@@@%+=*@@@@@@@@@@@@@@@@@@@@@               
//                  @@@%####%@@@@@@@@@@@@@@@@@@@@#++===+%@#===#@@@@@@%*+======---=#@@%=:....:::::::::=#@@%+=#@@@@*===%@@@@@@@@@@@@@@@@@@@@               
//                  @@@%####@@@@@@@@@@@@@@@@@@@@#-----==%@%+=--+@@@%+:.............*@@%:............ .:#@@*:+%@%*====*@@@@@@@@@@@@@@@@@@@@@              
//                  @@@%###%@@@%@@@@@@@@@@@@@@@%=....:-=*@@+==:.:++:..........:-:..*@@@-...........:::=%@@*:=#@%***+==%@@@@@@@@@@@@@@@@@@@@              
//                  @@@%###@@@@%@@@@@@@@@@@@@@@*:.....-=+%@#==-...............+@@@@@@@@-..........:%@@@@@@*:=%@@@@@@@##@@@@@@@@@@@@@@@@@@@@              
//                  @@@%###@@@%%@@%%@@@@@@@@@@@+......:==%@@+==:..............+@@@@@@@@:..........:@@@@@@@+.:--:-+#@@@@@@@@@@@@@@@@@@@@%@@@@             
//                  @@@%###@@@%%%%##%%%##%%%@@#-......:-=#@@*==:..............+@@@%%@@=...........:@@@%#**:.::----:-#@@@@@@@@@@@@@@@@@@#%@@@             
//                  @@@%##@@@@@%%#%#####%%@@@@#=:.....:+%@@%+=-::--::.........:*@@@@@*:............=@@@@*:..:------:*@@@@@@@@@@@@@@@@@@@%@@@@            
//                  @@@%@@@@@@@%%%@%%%%%@@@@@@@@@@@@@@@@@@*=-::-------:.........:---:.......................::---::+%@@@@@@@@@@@@@@@@@@@@@@@@            
//                  @@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@%+-.:-------......-+-..................................-#@@@@@@@@@@@@@@@@@@@@@@@@@@@           
//                  @@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#:..:::::.......=%@%*=::.....:=+:.................:+#@@@@@@@@@@@@@@@@@@@@   @@@@@@           
//                   @        @@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@#+:.............:-==+++++===-:...............-*#@@@@@@@@@@@@@@@@@@@@@@     @@@@@@          
//                             @@@@@@@@@@@@@@@@@%%%@@@@@@@@@@@@@@%*+-:................................:-+#@@@@@@@@@@@@@@@@@@@@@@@@         @@@@          
//                               @@@@@@@@@@@@@@@%#%%%%%%@@@@@@@@@@@@@@%#*+=-:..................:-=+*#%@@@@@@@@@@@@@@@@@@@@@@@@@                          
//                                 @@@@@@@@@@@@%%##%%%@@@@@@@@@@*=+*#%%@@@@@@@@@%%#*******##%%@@@@@@@%#*+=*%@@@@@@@@@@@@@@@@                             
//                                     @@@@@@@@@%%%%@@@@@@@@@@@@========+%@@@@@@@@@@@@@@@@@%%%%#*++========*%@@@@@@@@@@@@@                               
//                                         @@@@@@%%@@@@@@@@@@@@#++**+**#%@@@@       @@@@@#*+++++++*#####+=-=+%@@@@@@@@@@@@@@                             
//                                           @@@@@@@@@@@@@@@@@@=====+*%@@@@@@        @@@@@@@@@@@%%#+=-:...::-=%@@@@@@@@@@@@@@@@                          
//                                        @@@@@@@@@@@@@@@@@@@@---====+#@@@@@          @@@@*++=---::......:=#%@@@@@@@@@@%###%@@@@@                        
//                                      @@@@%#***%@@@@@@@@@@@::--*%@@@@%@@@@@         @@@@:............:+%@@%###%@@@@@@@@@%##@@@@@@                      
//                                      @@@@%###***#@@@@@@@%-:=%@@%#****##%@@@        @@@=............:*@@#******#%%@@@@@@@@%@@@@@@@@@@@@@@@             
//                                   @@@@@@@@@@@@@@%%%%@@@#::*@@%#*#%%@@@@@@@@@      @@@@-...........:*@@#*****#%@@@@%%%%%%@@@@@@@@@@%%%%@@@@@           
//                                  @@@@%+-::::--+*%@@%#%@%=*@@##%@@@#*+**%@@@@      @@@@=::........:+@@#****#%@@@#=:.......::::-=*%@%+==+%@@@@          
//                                  @@@%=...........:*@@%@@@@@%@@#=:.....:=*@@@@     @@@@+==--------+%@%****#%@@%=:..............-=+@@#===+#@@@          
//                                  @@@%=::..........:*@@@%%@@@@*........:-*@@@@   @@@@@@%+=========*@@#**##%@@%+==-------:....:--=#@@#==+*%@@@@@        
//                                  @@@@#==-----:::---#@@****#@@+-::::::--=*@@@@   @@@@@@@@@%######%@@@%###%@@%*+++++++=======-===*@@@%%@@@@@@@@@        
//                                 @@@@@@%*+=========*%@%#####@@@=========+%@@@@@  @@@@**#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%##****%@@@@@@@@%##%@@@        
//                                 @@@%#@@@@@@@@@@%@@@@@@@%%%%@@@@%#****#%@@@@@@@   @@@%========+++++*######*******##%%@@@@@@@@@@@@%********#@@@@        
//                                 @@@%===+*%%@@@@@%##*#%%@@@@@@@@@@@@@@@@@%#%@@@   @@@@+----=====-------------=======+++++*****************%@@@         
//                                 @@@@=-----================+++++++********#@@@@    @@@#++=======----------------=======+++***************#@@@@         
//                                 @@@@#+==========================++++++++*#@@@@    @@@@@@@@@@@@%%%%##**++==============++++*********#%%@@@@@@          
//                                  @@@@@@@@%%%##***++++++++++++++++***####%%@@@      @@@@@@@@@@@@@@@@@@@@@@@@@%%%%###********##%%%@@@@@@@@@@@           
//                                   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                
//                                          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                   @@@@@@@@@@@@@@@@@                       
