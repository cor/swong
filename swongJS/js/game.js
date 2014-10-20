var canvas = document.getElementById("canvas");
var context = canvas.getContext("2d");

canvas.width = 800;
canvas.height = 600;

var Direction = {
    North : 1,
    East : 2,
    South : 3,
    West : 4
};

// game objects
paddle1 = new Paddle();

paddle2 = new Paddle();
paddle2.position.x = canvas.width - paddle2.size.width;

ball = new Ball();


// update function
function update() {

    if (keys[87]) {
        paddle1.velocity.dy--;
    }

    if (keys[83]) {
        paddle1.velocity.dy++;
    }

    // slow down vertically if there's now vertical input
    if (!(keys[87] || keys[83])) {
        paddle1.velocity.dy *= 0.9;
    }
    paddle1.update();


    if (keys[73]) {
        paddle2.velocity.dy--;
    }

    if (keys[75]) {
        paddle2.velocity.dy++;
    }

    // slow down vertically if there's now vertical input
    if (!(keys[73] || keys[75])) {
        paddle2.velocity.dy *= 0.9;
    }
    paddle2.update();
    
    ball.update();
}

function draw() {

    context.clearRect(0,0,canvas.width,canvas.height);

    paddle1.draw();
    paddle2.draw();
    ball.draw();
}

function collisions() {
    paddle1.collisions();
    paddle2.collisions();
}

function tick() {
    update();
    collisions();
    draw();
    requestAnimationFrame(tick);
}

tick();
