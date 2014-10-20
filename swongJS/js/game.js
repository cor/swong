// canvas setup
var canvas = document.getElementById("canvas");
var context = canvas.getContext("2d");

canvas.width = 800;
canvas.height = 600;

// Direction "enumeration"
var Direction = {
    North : 1,
    East : 2,
    South : 3,
    West : 4
};

// game objects
paddle1 = new Paddle();
paddle1.position.y = canvas.height / 2 - paddle1.size.height / 2;

paddle2 = new Paddle();
paddle2.position.y = canvas.height / 2 - paddle2.size.height / 2;
paddle2.position.x = canvas.width - paddle2.size.width;

ball = new Ball();
ball.position.x = canvas.width / 2;
ball.position.y = canvas.height / 2;
ball.velocity.dx = 15;
ball.velocity.dy = 30;


// game loop functions
function update() {
    paddle1.update();
    paddle2.update();
    ball.update();
}

function ai() {

    // if the ball is moving left, move left paddle
    if (ball.velocity.dx < 0) {
        paddle1.velocity.dy = ball.position.y - paddle1.centerPosition().y;
        paddle2.velocity.dy = 0;
    }

    // if the ball is not moving left,
    // then it's moving right thus the right paddle will be moved
    else {
        paddle2.velocity.dy = ball.position.y - paddle2.centerPosition().y;
        paddle1.velocity.dy = 0;
    }
}

function collisions() {
    paddle1.collisions();
    paddle2.collisions();
    ball.collisions();
}

function draw() {
    context.clearRect(0,0,canvas.width,canvas.height);

    paddle1.draw();
    paddle2.draw();
    ball.draw();
}

// game loop
function tick() {
    update();
    ai();
    collisions();
    draw();
    requestAnimationFrame(tick);
}

tick();
