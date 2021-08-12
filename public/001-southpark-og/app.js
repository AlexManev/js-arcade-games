//init game library
const Graphics = PIXI.Graphics;
const Application = PIXI.Application;
const app = new Application();

const game_sound = new Howl({
    src: ['./Resources/sounds/Eric_Cartman-Poker_Face.wav'],
    loop: true
})
const you_killed_kenny_sound = new Howl({
    src: ['./Resources/sounds/You_Killed_Kenny.wav'],
    loop: false
})

//define game constants
var SPEED = 10;
var DIFFICULTY = 2;
const SPEED_UP = 0.0005;
const ZONE_WIDTH = 400;
const ZONE_HEIGHT = 600;

const ColorBlack = 0x000000;
const ColorWhite = 0xFFFFFF;


var playerData = {
    name : "Aleks",
    file : "./Resources/images/kenny.png",
    bmp : null,
    x : 300,
    y : 450,
    isDead : false
}

var game = {
    player : playerData,
    scoreCount: 0,
    highScore: 0
}


var OpenGraphicsWindow = function(height, wight){
    app.height = height;
    app.width = wight;
    document.body.appendChild(app.view);
}

var LoadDefaultColors = function(){
    app.renderer.backgroundColor = 0x23395D;
}

var LoadResources = function(){
    //load bitmap
    //load sound effects
}

var FillRectangle = function(color,x,y,width,height){
    var r = new Graphics();
    r.beginFill(color);
    r.drawRect(x,y,width,height);
    r.endFill();
    app.stage.addChild(r);
}

var DrawText = function(text, color, font, size, x, y){
    //TODO x and y positions 
    var style = new PIXI.TextStyle({
        fill: color,
        fontFamily: font,
        fontSize: size
    });
    var t = new PIXI.Text(text, style);
    app.stage.addChild(t);

    return t;
}

var BitmapCollision = function(a, b)
{
  var ab = a.getBounds();
  var bb = b.getBounds();
  return ab.x + ab.width > bb.x && ab.x < bb.x + bb.width && ab.y + ab.height > bb.y && ab.y < bb.y + bb.height;
}

var PlayerOverlaps = function(player){
    if(player.bmp.x < 200)
        player.bmp.x = 200;
    if(player.bmp.x + player.bmp.width > 600)
        player.bmp.x = 600-player.bmp.width;
}

var ProcessEvents = function(game){
    document.addEventListener("keydown", function(e){
        console.log(DIFFICULTY)
        if(e.key === "ArrowRight" || e.key.toLocaleUpperCase() === "D"){
            game.player.bmp.x += SPEED;
        }else if(e.key === "ArrowLeft" || e.key.toLocaleUpperCase() === "A"){
            SmoothLeftMove(game, SPEED);
        }else if(e.key === "Enter"){
            DrawGame(game);
            DIFFICULTY = 2;
            SPEED = 10;
        }else {
            console.log(e.key)
        }
        PlayerOverlaps(game.player)
    });
}

var SmoothLeftMove = function(game, speed)
{
    for (let index = 0; index < speed; index++) {
        game.player.bmp.x--;
    }
}

var DrawBitmap = function(data, x, y){
    var sprite = new PIXI.Sprite.from(data);
    sprite.position.set(x,y);
    app.stage.addChild(sprite);
    return sprite;
}

var DrawPlayer = function(player){
    var bmp = DrawBitmap(player.file, player.x, player.y);
    player.bmp = bmp;
}

var CoverOverlap = function(){
    DrawBitmap("./Resources/images/Left_Side.png", 0, 0);
    DrawBitmap("./Resources/images/Right_Side.png", 600, 0);
}

var RandomBarrier = function(y){
    var n = Math.floor(Math.random() * 2)
    switch(n)
    {
        case 0:
            return DrawBitmap("./Resources/images/ExitLeft.png",200+193,y)
        case 1:
            return DrawBitmap("./Resources/images/ExitRight.png",200-30,y)
        default:
            return "./Resources/images/ExitMiddle.png"
    }
}

var SetupBarrier = function(game, numBarrier){
    game.barriers = [];
    var y = 0;
    for (let i = 0; i < numBarrier; i++) {
        game.barriers.push({
            bmp: RandomBarrier(y)
        });
        y -= 300;
    }
}

var DrawGame = function(game)
{
    FillRectangle(ColorBlack, 200, 0, ZONE_WIDTH, ZONE_HEIGHT);
    DrawPlayer(game.player);
    SetupBarrier(game, 200);
    CoverOverlap();
    game.scoreCount = 0;
    game.score = DrawText("score: 0", "red", "Montserrat", 20, 0, 0);
    game_sound.play();
}

var PlayerIsDead = function()
{
    game_sound.stop();
    you_killed_kenny_sound.play();
    DIFFICULTY = 0;
    if(game.scoreCount > game.highScore)
        game.highScore = game.scoreCount;
}

var GameLoop = function(delta){
    game.barriers.forEach(e => {
        e.bmp.y += DIFFICULTY;
        if(BitmapCollision(game.player.bmp, e.bmp) && DIFFICULTY > 0){
            PlayerIsDead();
        }
    });
    if(DIFFICULTY > 0){
        DIFFICULTY += SPEED_UP;
        SPEED += SPEED_UP;
    }
    game.scoreCount += DIFFICULTY;
    game.score.text = 'score: '+Math.floor(game.scoreCount) +'\nhighscore: '+Math.floor(game.highScore);
}

var Main = function(){
    OpenGraphicsWindow(800,600);
    LoadDefaultColors();
    DrawGame(game);

    ProcessEvents(game);

    app.ticker.add(GameLoop);

}



Main();