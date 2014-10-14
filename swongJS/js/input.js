var keys = [];

document.body.addEventListener("keydown", function(e) {
    if (e.keyCode == 87 || e.keyCode == 83 || e.keyCode == 73 || e.keyCode == 75) {
        e.preventDefault();
    }
    keys[e.keyCode] = true;
});

document.body.addEventListener("keyup", function(e) {
    e.preventDefault();
    keys[e.keyCode] = false;
});
