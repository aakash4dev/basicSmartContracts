const fs = require('fs');
const path = require('path');

const contractsDir = './contracts'; // Replace with the actual path to your contracts directory

fs.readdir(contractsDir, (err, files) => {
    if (err) {
        console.error("An error occurred:", err);
        return;
    }

    const solFiles = files.filter(file => path.extname(file) === '.sol');

    if (solFiles.length === 0) {
        console.log("No .sol files found in the directory");
        return;
    }

    const randomFile = solFiles[Math.floor(Math.random() * solFiles.length)];
    const filePath = path.join(contractsDir, randomFile);

    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
            console.error("Error reading file:", err);
            return;
        }
        console.log(`Contents of ${randomFile}:\n${data}`);
    });
});
