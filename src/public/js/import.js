let allFiles = [];
let emailaddr = '';

const handleEmailChange = event => {
    emailaddr = event.target.value;
    console.log(emailaddr);
}

const handleFileChange = event => {
    const files = event.target.files
    // console.log(files);
    for (let i = 0; i < files.length; i++) {
        allFiles.push(files[i]);
    }
}

const sendFile = (file, i) => {
    let formData = new FormData();
    formData.append('myFile', file, emailaddr + '^' + file.name + '^');
    console.log(formData);
    fetch('/saveFile', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            console.log(data.path)
        })
        .catch(error => {
            console.error(error)
        })
}

const handleFileUpload = () => {
    event.preventDefault();
    console.log(allFiles);
    for (let i = 0; i < allFiles.length; i++) {
        sendFile(allFiles[i], i);
    }
    alert("File uploaded!");
}
