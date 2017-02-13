$(document).on('click', '.notifyjs-bootstrap-base', function() {
    location.reload(true);
});

var taskID = setInterval(function(){
    var div = document.getElementById('msgHolder'),
    divChildren = div.childNodes;
    if(divChildren.length === 0) {
        clearInterval(taskID);
    }
    for (var i=0; i<divChildren.length; i++) {
        $.get(
            "/api/v1/job/" + divChildren[i].getAttribute('value'),
            {},
            function(data) {
                var obj = JSON.parse(data);
                if(obj.status === "completed") {
                    $.notify(obj.message + " Click to refresh.", {
                        className: "success",
                        autoHide: false
                    });
                    clearInterval(taskID);
                }
                if(obj.status === "failed") {
                    $.notify(obj.msg, {
                        className: "error",
                        autoHide: true
                    });
                    clearInterval(taskID);
                }
            }
        );
    }
}, 1000);