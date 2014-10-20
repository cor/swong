function Ball() {

    // current positoin
    this.position = {
        x: 0,
        y: 0
    };

    // ball size
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

    this.update = function() {
        this.position.x += (this.velocity.dx * this.movementMultiplier);
        this.position.y += (this.velocity.dy * this.movementMultiplier);
    };

    this.draw = function() {
        context.beginPath();
        context.arc(this.position.x, this.position.y, this.size.height, 0, 2 * Math.PI, false);
        context.fillStyle = "black";
        context.lineWidth = 5;
        context.strokeStyle = "red";
        context.stroke();
    };

}
