program GameMain;
uses SwinGame, sgTypes, SysUtils;

const
SPEED = 4; //Defult Speed.
SPEED_UP = 0.0007; // Speed that the barriers Speed up by.
ZONE_WIDTH = 400;
ZONE_HEIGHT = 600;

type
	BarrierKind = (ExitLeft, ExitMiddle, ExitRight);
	BoostPosition = (Left, Middle, Right);

	PlayerData = record
		name: String;
		bmp: Bitmap;
		x,y: Single;
		isDead : Boolean;
	end;

	BarrierData = record
		bmp: Bitmap;
		kind: BarrierKind;
		x,y: Single;
		dx,dy:Single;
	end;

	BoostData = record
		kind: BoostPosition;
		bmp: Bitmap;
		x,y: Double;
		dx,dy:Double;
	end;

	HSData = record
		current: Integer;
		UFile : Text;
		TFile : String;
		NameFile: String;
		Code:Integer;
	end;

	GameData = record
		barrier: array of BarrierData;
		player: PlayerData;
		score: Integer;
		boost: array of BoostData;
		countBoost: Integer;
		highscore: HSData;
	end;

//LoadRecources is where all the data (images, sound effects)
//are loaded into the program 

procedure LoadResources();
begin
	LoadBitmapNamed('Choose',		'Choose.jpg');

	LoadBitmapNamed('Kenny',		'kenny.png');
	LoadBitmapNamed('Cartman',		'Eric_Cartman.png');
	LoadBitmapNamed('Kyle', 		'Kyle.png');
	LoadBitmapNamed('Stean', 		'Stean.png');

	LoadBitmapNamed('Left_Side', 'Left_Side.png');
	LoadBitmapNamed('Right_Side', 'Right_Side.png');

	LoadBitmapNamed('ExitLeft', 	'ExitLeft.png');
	LoadBitmapNamed('ExitMiddle', 	'ExitMiddle.png');
	LoadBitmapNamed('ExitRight', 	'ExitRight.png');

	LoadBitmapNamed('Towelie_Left', 'Towelie_Left.png');
	LoadBitmapNamed('Towelie_Middle', 'Towelie_Middle.png');
	LoadBitmapNamed('Towelie_Right', 'Towelie_Right.png');

	LoadSoundEffectNamed('You_Killed_Kenny', 'You_Killed_Kenny.wav');
	LoadSoundEffectNamed('Screw_You_Guys', 'Screw_You_Guys.wav');
	LoadSoundEffectNamed('Not_Funny', 'Not_Funny.wav');
	LoadSoundEffectNamed('Stans_A_Girl', 'Stans_A_Girl.wav');

	LoadSoundEffectNamed('Eric_Gaga_Song', 'Eric_Cartman-Poker_Face.wav');
end;

//When the player is dead it plays 
//Sound Effect depending on whitch character died.

procedure DyingSound(var game: GameData);
begin
	if game.player.isDead then 
	begin
		StopMusic();
		if game.player.bmp = BitmapNamed('Kenny') then PlaySoundEffect('You_Killed_Kenny')
		else if game.player.bmp = BitmapNamed('Cartman') then PlaySoundEffect('Screw_You_Guys')
		else if game.player.bmp = BitmapNamed('Kyle') then PlaySoundEffect('Not_Funny')
		else if game.player.bmp = BitmapNamed('Stean') then PlaySoundEffect('Stans_A_Girl');
	end;
end;

//Returns a bitmap of barrier that is asked for.

function BarrierBitmap(kind: BarrierKind): Bitmap;
begin
	case kind of
		ExitLeft:		result := BitmapNamed('ExitLeft');
		ExitMiddle:		result := BitmapNamed('ExitMiddle');
		ExitRight:		result := BitmapNamed('ExitRight');
	end;
end;

//Returs a bitmap of the boost that is asked for.

function BoostBitmap(position: BoostPosition): Bitmap;
begin
	case position of
		Left:			result := BitmapNamed('Towelie_Left');
		Middle:			result := BitmapNamed('Towelie_Middle');
		Right:			result := BitmapNamed('Towelie_Right');
	end;
end;

//Randomy chooses barrier, and returns the chosen barrier as BarrieerData.

function RandomBarrier(y: Integer): BarrierData;
begin
result.kind := BarrierKind(Rnd(3));
result.bmp := BarrierBitmap(result.kind);
result.x := 200;
result.y := y;
result.dy := 3;
end;

//Randomy chooses boosts position, and returns the chosen boost as BoostData

function RandomBoost(y: Integer): BoostData;
begin
	result.kind := BoostPosition(Rnd(3));
	result.bmp := BoostBitmap(result.kind);
	result.x := 200;
	result.y := y;
	result.dy := 3;
end;

//Draws the Barrier in the game on given positions

procedure DrawBarrier(const barrier: BarrierData);
begin
	DrawBitmap(barrier.bmp, barrier.x, barrier.y);
end;

//draws the boosts in the game on given positions

procedure DrawBoost(const boost: BoostData);
begin
	DrawBitmap(boost.bmp, boost.x, boost.y);
end;

//Checks if Buttions are clicked on the right positions

function ButtonClicked(btnX, btnY: Single; btnWidth, btnHeight: Integer): Boolean;
var
	btnRight, btnBottom: Single;
	mX, mY: Single;
begin
	mX := MouseX();
	my := MouseY();
	btnRight := btnX + btnWidth;
  	btnBottom := btnY + btnHeight;

  	result := false;

  	if MouseClicked(LeftButton) then
  	begin
  		if (mX >= btnX) and (mX <= btnRight) and (mY >= btnY) and (mY <= btnBottom) then
    	begin
      		result := true;
      	end;
    end;
end;

//This procedure Draws the Character in its position.

procedure DrawPlayer(const player: PlayerData);
begin
	DrawBitmap(player.bmp, player.x, player.y);
end;

//This procedure just covers the character when he is out of the
//playing zone.

procedure CoverOverlap();
begin

	DrawBitmap('Left_Side', 0, 0);
	DrawBitmap('Right_Side', 600,0);
end;

//Wraps the character into the playing zone
//so if the character overlaps on one side it appears from the other side.

procedure PlayerOverlaps(var game:GameData);
begin
	if game.player.x < 200 - BitmapWidth(game.player.bmp) then
		game.player.x := 600;
	if game.player.x > 600 then
		game.player.x := 200 - BitmapWidth(game.player.bmp);
end;

//returns True/False if the player have contact with a barrier.

function PlayerIsDead(const barrier: BarrierData; const player: PlayerData): Boolean;
begin
	result := BitmapCollision(barrier.bmp, Round(barrier.x), Round(barrier.y), player.bmp, Round(player.x), Round(player.y));
end;

//returns True/False if the player have contact with a boost.

function PlayerHitBoost(const boost: BoostData; const player: PlayerData): Boolean;
begin
	result := BitmapCollision(boost.bmp, Round(boost.x), Round(boost.y), player.bmp, Round(player.x), Round(player.y));
end;

//Prints the highscore on the screen

procedure SetCurrentHighscore(var hs: HSData);
begin
	hs.TFile := 'D:\Swinburne\Public\Programming\code\ProjectTemplate\HS.txt';
	Assign(hs.UFile,hs.TFile);
	 
	Reset(hs.UFile); //'Reset(x)' - means open the file x
	Readln(hs.UFile,hs.NameFile); //Give NameFile the value of the first line
	Val(hs.NameFile, hs.current, hs.Code);  // Assign it to game.highscore Code = 0
	Close(hs.UFile); //close the file

end;

//Procedute to check if the player's score is bigger then the highscore

procedure CheckForHighscore(var game: GameData; var hs: HSData);
begin
	if game.score > hs.current then
	begin
		Erase (hs.UFile); // delete the txt file
		Assign(hs.UFile, hs.TFile);
		rewrite(hs.UFile);//create new file
		Append(hs.UFile); //get access in it
		Writeln(hs.UFile,game.score); //Write the new game score
		Close(hs.UFile); //Close the file 
	end;	
end;

//Draw Game sets up all the game features before the game starts.

procedure DrawGame(var game: GameData);
var
	i:Integer;
begin
	ClearScreen(ColorWhite);
	FillRectangle(ColorBlack,200,0,ZONE_WIDTH,ZONE_HEIGHT);
	DrawPlayer(game.player);
	PlayerOverlaps(game);
	CoverOverlap();

	DrawText('Score: ' + IntToStr(game.score), ColorRed, 'maven_pro_regular', 20, 0, 0);
	DrawText('Score Boost: X' + IntToStr(game.countBoost), ColorRed, 'maven_pro_regular', 20, 0, 30);
	DrawText('Highscore: ' + IntToStr(game.highscore.current), ColorRed, 'maven_pro_regular', 20, 610, 0);

	for i := 0 to High(game.barrier) do
	begin
		DrawBarrier(game.barrier[i]);
		DrawBoost(game.boost[i]);

	end;
	RefreshScreen(60);
end;

//Update Game is responcible for all the movement and events happening in the game
//e.g. Speeding up of the barriers, game score...

procedure UpdateGame(var game: GameData);
var
	i: Integer;
	hsOld: Integer;
	
begin
	for i := 0 to High(game.barrier) do
	begin
		game.player.isDead := PlayerIsDead(game.barrier[i],game.player);

		if PlayerHitBoost(game.boost[i], game.player) then
		begin
			game.countBoost += 1;
			game.boost[i].y := 601;
			game.score *= game.countBoost;
		end;

		game.score := (Round(game.barrier[0].y / 10))*game.countBoost;
		game.barrier[i].y += game.barrier[i].dy;
		game.barrier[i].dy += SPEED_UP;
		game.boost[i].y += game.boost[i].dy;
		game.boost[i].dy += SPEED_UP;

		if game.player.isDead then
		begin
		    CheckForHighscore(game, game.highscore);
		    RefreshScreen(60);
			exit;
		end;
	end;
end;

//The movement of the character is
//given in the Handle User Input procedure

procedure HandleUserInput(var game: GameData);
begin
	ProcessEvents();

	if (KeyDown(VK_LEFT)) then
		game.player.x -= SPEED;
	if (KeyDown(VK_RIGHT)) then
		game.player.x +=SPEED;
end;

//Setup Barrier gives the Barrier's position position to 
//all the Barriers off the screen.

procedure SetupBarrier (var game: GameData; numBarrier: Integer);
var
	i: Integer;
	y: Integer;
begin
	SetLength(game.barrier, numBarrier);
	y := 0;
	for i := 0 to High(game.barrier) do
	begin
		game.barrier[i] := RandomBarrier(y);
		y -= 300;
	end;
end;

//Setup Boosts gives the boosts position position to 
//all the boosts off the screen.

procedure SetupBoost (var game: GameData; numBoosts: Integer);
var
	i: Integer;
	y: Integer;
begin
	SetLength(game.boost, numBoosts);
	y := -150;
	for i := 0 to High(game.boost) do
	begin
		game.boost[i] := RandomBoost(y);
		y -= 300;
	end;
end;

//Choose Character procedure waits and gives the user 
//option to choose which character he/she wants to play with

procedure ChooseCharacter(var game: GameData);
var
	bmpY, bmpX: Single;
	choose: Boolean;
begin
	bmpY := 0;
	bmpX := 0;
	choose := false;
	PlayMusic('Eric_Cartman-Poker_Face.wav');

	while 	ButtonClicked(0,0,190,600) = true and //Cartman
			ButtonClicked(200,0,210,600) = true and //Kyle
			ButtonClicked(419,0,197,600) = true and //Stean
			ButtonClicked(625,0,175,600) = true do //Kenny
	begin
		ProcessEvents();
		ClearScreen(ColorBlack);
		DrawBitmap('Choose', bmpX, bmpY);

		if ButtonClicked(0,0,190,600) then game.player.bmp := BitmapNamed('Cartman')
		else if ButtonClicked(200,0,210,600) then game.player.bmp := BitmapNamed('Kyle')
		else if ButtonClicked(419,0,197,600) then game.player.bmp := BitmapNamed('Stean')
		else if ButtonClicked(625,0,175,600) then game.player.bmp := BitmapNamed('Kenny'); 

		if WindowCloseRequested() then exit;

		RefreshScreen(60);
	end;
	repeat
		ProcessEvents();
		ClearScreen(ColorBlack);
		CoverOverlap();
		bmpY += 5;
		DrawBitmap('Choose', bmpX, bmpY);
		RefreshScreen(60);
	until bmpY > ScreenHeight();
end;

//This is where the game starts,
//barriers, Boosts, score, boousts count and player are all
//set to their defult values and positions.

procedure StartGame(var game: GameData);

begin
	game.highscore.Code := 0; //code is just that i make the text from the file into Integer.
	SetupBarrier(game,200);
	SetupBoost(game,200);

	game.score :=	0;
	game.countBoost := 1;
	SetCurrentHighscore(game.highscore);

	ChooseCharacter(game);

	game.player.x := Round((ScreenWidth() - BitmapWidth(game.player.bmp)) / 2);
	game.player.y := 450;
	game.player.isDead := false;
end;

procedure Main();
var
	game: GameData;
	i: Integer;

begin

	OpenGraphicsWindow('South Park - Faster Then Light', 800, 600);
	LoadDefaultColors();
    LoadResources();

    //this loops are repeatted until the user decides to close the program.
	repeat
	    ProcessEvents();
	    StartGame(game);
		    repeat
		    	DrawGame(game);
		    	HandleUserInput(game);
		    	UpdateGame(game);
		    until game.player.isDead or WindowCloseRequested();
			DyingSound(game);
		    Delay(5000);
		RefreshScreen(60);
	until WindowCloseRequested();
	
end;

begin
	Main();
end.