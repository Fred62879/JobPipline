const fileUpload = require('express-fileupload');
const express = require('express');
const bodyParser = require('body-parser');
const uid = require('uid');

let app = express();
app.use(bodyParser.urlencoded({extended: true}));
app.set("view engine", "ejs");
app.use(express.static(__dirname + "/public"));
app.use(fileUpload());

console.log(__dirname + "/public");

app.get("/", function(req, res){
    res.render("./job");
});

app.post('/saveFile', (req, res) => {
    const file = req.files.myFile;
    const fileName = file.name
    const path = __dirname + '/../pending/' + fileName + uid();
    file.mv(path, (error) => {
        if (error) {
            console.error(error)
            res.writeHead(500, {
                'Content-Type': 'application/json'
            })
            res.end(JSON.stringify({ status: 'error', message: error }))
            return
        }

        res.writeHead(200, {
            'Content-Type': 'application/json'
        })
        res.end(JSON.stringify({ status: 'success', path: '/pending/' + fileName }))
    })
})

app.listen(3000, function() {
   console.log("The Server Has Started!");
});
