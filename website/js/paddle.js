function Paddle() {

    // current position
    this.position = {
        x: 0,
        y: 0
    };

    // paddle size
    this.size = {
        height: 80,
        width: 20
    };

    // velocity vector
    this.velocity = {
        dx: 0,
        dy: 0
    };

    this.color = "black";
    this.movementMultiplier = 0.1;
    this.maxSpeed = 50;

    // returns the position of the paddle with the anchor point adjusted to 0.5, 0.5
    this.centerPosition = function() {
        return {
            x: this.position.x + ( this.size.width / 2 ),
            y: this.position.y + ( this.size.height / 2 )
        };

    };

    // add the current velocity of the paddle to the position
    this.update = function() {

        this.position.x += (this.velocity.dx * this.movementMultiplier);
        this.position.y += (this.velocity.dy * this.movementMultiplier);
    };

    // function that handles collisions
    this.collisions = function() {

        if (this.position.y < 0) {
            this.position.y = 0;
            this.velocity.dy = 0;
        }

        if (this.position.y + this.size.height > canvas.height ) {
            this.position.y = canvas.height - this.size.height;
            this.velocity.dy = 0;
        }

        if (this.position.x < 0) {
            this.position.x = 0;
            this.velocity.dx = 0;
        }

        if (this.position.x + this.size.width > canvas.width ) {
            this.position.x = canvas.width - this.size.width;
            this.velocity.dx = 0;
        }
    };

    // draw the paddle on the screen
    this.draw = function() {
        context.fillStyle = this.color;
        context.fillRect(this.position.x, this.position.y, this.size.width, this.size.height);
    };
}
