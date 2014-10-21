// canvas setup
var canvas = document.getElementById("canvas");
var context = canvas.getContext("2d");

canvas.width = 900;
canvas.height = 600;

// resize canvas when window is resized
window.addEventListener('resize', resizeCanvas, false);

function resizeCanvas() {

    // 900 is the maximum page width
    if (window.innerWidth < 900) {
        canvas.width = window.innerWidth;
    } else {
        canvas.width = 900;
    }

    // set the paddles to the new positions
    paddle1.position.x = 30;
    paddle2.position.x = canvas.width - paddle2.size.width - 30;

    // reset the ball position to the center of the canvas
    ball.position.x = canvas.width / 2;
    ball.position.x = canvas.height / 2;
}

// setup game objects

// paddle 1
paddle1 = new Paddle();
paddle1.color = "#4F4F4F";
paddle1.position.y = canvas.height / 2 - paddle1.size.height / 2;
paddle1.position.x = 30;

// paddle 2
paddle2 = new Paddle();
paddle2.color = "#2A2A2A";
paddle2.position.y = canvas.height / 2 - paddle2.size.height / 2;
paddle2.position.x = canvas.width - paddle2.size.width - 30;

// ball
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

    // built in collision functions with the game objects and the edges of the canvas
    paddle1.collisions();
    paddle2.collisions();
    ball.collisions();

    // paddle 1 + ball
    if (ball.position.x < paddle1.position.x + paddle1.size.width + (ball.size.width / 2)) {
        // paddle 1 is at the same horizontal position as the ball
        if (ball.position.y > paddle1.position.y && ball.position.y < paddle1.position.y + paddle1.size.height) {
            // paddle 1 is at the same vertical position as the ball
            ball.velocity.dx *= -1;
        }
    }

    // paddle 2 + ball
    if (ball.position.x > paddle2.position.x - paddle2.size.width + (ball.size.width / 4)) {
        // paddle 2 is at the same horizontal position as the ball
        if (ball.position.y > paddle2.position.y && ball.position.y < paddle2.position.y + paddle2.size.height) {
            // paddle 2 is at the same vertical position as the ball
            ball.velocity.dx *= -1;
        }
    }

}

function draw() {

    // clear the canvas before drawing
    context.clearRect(0,0,canvas.width,canvas.height);

    // draw all the game objects
    paddle1.draw();
    paddle2.draw();
    ball.draw();

    // draw "Download Now" text
    context.font = "60px Futura, Helvetica";
    context.textAlign = "center";
    context.fillText("Download Now", canvas.width / 2, canvas.height / 2);
}

// game loop
function tick() {
    update(); // update positions, apply velocity
    ai(); // let the ai move the paddles
    collisions(); // check for collisions
    draw(); // draw the result on the screen
    requestAnimationFrame(tick); // request the next frame
}

// start the game loop
tick();
