function Ball() {

    // current positoin
    this.position = {
        x: 0,
        y: 0
    };

    // ball size, height and width should be the same
    this.size = {
        height: 30,
        width: 30
    };

    // velocity vector
    this.velocity = {
        dx: 0,
        dy: 0
    };

    this.movementMultiplier = 0.1;

    // update ball position by adding velocity
    this.update = function() {

        this.position.x += (this.velocity.dx * this.movementMultiplier);
        this.position.y += (this.velocity.dy * this.movementMultiplier);
    };

    // check if the ball hit one of the canvas' sides
    this.collisions = function() {

        // top side of canvas
        if (this.position.y - this.size.height / 2 < 0) {
            this.velocity.dy *= -1;
        }

        // bottom side of canvas
        if (this.position.y + this.size.height / 2 > canvas.height) {
            this.velocity.dy *= -1;
        }

        // left side of canvas
        if (this.position.x - this.size.width / 2 < 0) {
            this.velocity.dx *= -1;
        }

        // right side of canvas
        if (this.position.x + this.size.width / 2 > canvas.width) {
            this.velocity.dx *= -1;
        }

    };

    // draw the ball on the canvas
    this.draw = function() {
        context.beginPath();
        context.arc(this.position.x, this.position.y, this.size.height / 2, 0, 2 * Math.PI, false);
        context.fillStyle = "#8D78E3";
        context.fill();
    };

}
