var taskID = setInterval(function(){
    var div = document.getElementById('msgHolder'),
    divChildren = div.childNodes;
    for (var i=0; i<divChildren.length; i++) {
        $.get(
            "/api/v1/job/" + divChildren[i].getAttribute('value'),
            {},
            function(data) {
                var obj = JSON.parse(data);
                if(obj.status == "completed") {
                    $.notify(obj.message, "success");
                    clearInterval(taskID);
                }
                if(obj.status == "failed") {
                    $.notify(obj.message, "error");
                    clearInterval(taskID);
                }
                //$.notify(data, "warn");
            }
        );
    }
}, 1000);