
function Paddle() {

    this.position = {
        x: 0,
        y: 0
    };

    this.size = {
        height: 80,
        width: 20
    };

    this.velocity =  {
        dx: 0,
        dy: 0
    };

    this.movementMultiplier = 0.1;

    this.move = function(direction) {
        switch(direction) {
            case Direction.North:
                this.velocity.dy--;
                break;
            case Direction.East:
                this.velocity.dx++;
                break;
            case Direction.South:
                this.velocity.dy++;
                break;
            case Direction.West:
                this.velocity.dx--;
                break;
        }
    };

    this.update = function() {
        this.position.x += (this.velocity.dx * this.movementMultiplier);
        this.position.y += (this.velocity.dy * this.movementMultiplier);
    };

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

    this.draw = function() {

        context.fillStyle = "#161717";

        context.fillRect(this.position.x, this.position.y, this.size.width, this.size.height);
    };
}
