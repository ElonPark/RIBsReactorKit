import 'jqtree'
import * as blobUtil from 'blob-util'

require('file-loader?name=[name].[ext]!./index.html');

const sock = new WebSocket("ws://0.0.0.0:8080");

sock.addEventListener("message", e => {
    if (typeof e.data === "string") {
        try {
            let parsedJSON = JSON.parse("[" + e.data + "]");
            $('#tree').remove()
            $("<div>", {
                id: 'tree'
            }).appendTo('#body');
            $('#tree').tree({
                data: parsedJSON,
                autoOpen: true,
                onCreateLi: function (node, $li) {
                    $li.find('.jqtree-element').click(function () {
                        sock.send(node.name.replace(" (View) ", ""));
                        return false;
                    });
                }
            });
        } catch (e) {
        }
    } else {
        const blob = new Blob([e.data], {
            type: 'image/png'
        });
        var blobURL = blobUtil.createObjectURL(blob);
        document.getElementById('capture').setAttribute('src', blobURL);
    }
});
