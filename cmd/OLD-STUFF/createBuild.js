#!/usr/local/bin/node
const fs = require("fs");
const path = require('path');
const childProcess = require("child_process");
const terser = require("terser");
const conf = require(process.cwd() + '/.temp/conf.json');

main();

function main () {
    const buildFolder = `dist`;
    const tempFolder = `.temp`;
    rmDir(buildFolder, false);
    console.log(`Compile elm`);
    childProcess.exec(`./node_modules/.bin/elm make src/Main.elm --output=${tempFolder}/elm.js --optimize`, (error, out) => {
        if (error) {
            console.log(error);
            process.exit(0);
        }
        const elmCode = fs.readFileSync(`${tempFolder}/elm.js`, 'utf8');
        console.log(`Minify elm`);
        const elmMinCode = terser.minify(elmCode);
        if (elmMinCode.error) {
            console.log(elmMinCode.error);
            process.exit(0);
        } 
        fs.writeFileSync(`${buildFolder}/elm.js`, elmMinCode.code); 
    });
};

function rmDir (dirPath, removeSelf) {
    if (removeSelf === undefined) {
        removeSelf = true;
    }
    try {
        var files = fs.readdirSync(dirPath);
    } catch(e) {
        return;
    }
    if (files.length > 0)
        for (var i = 0; i < files.length; i++) {
            var filePath = path.join(dirPath, files[i]);
            if (fs.statSync(filePath).isFile()) {
                fs.unlinkSync(filePath);
            } else {
                rmDir(filePath);
            }
        }
    if (removeSelf) {
        fs.rmdirSync(dirPath);
    }
};

