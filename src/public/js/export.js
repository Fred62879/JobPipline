function handleExport() {
    console.log("Saving");
    var content = "sleep 10s";
    var blob = new Blob([content], {type: "text/plain;charset=utf-8"});
    console.log("Saving");
    saveAs(blob, "file1.txt");
    console.log("Done");
}
