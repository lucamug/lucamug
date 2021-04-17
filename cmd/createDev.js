#!/usr/local/bin/node
const fs = require("fs");
const path = require('path');
const bootstrap = require(process.cwd() + '/bootstrap');
const util = require('util');
const copyFilePromise = util.promisify(fs.copyFile);
const devDir = ".dev"

console.log(`\nCreating dev environment...\n`);
bootstrap.bootstrap(function(){
    bootstrap.rmDir(devDir, false);
    fs.mkdirSync(`${devDir}`, { recursive: true });
    console.log("Copying files");
    copyFiles(`${bootstrap.tempDir}`, `${devDir}`, 
        [ 'index.html'
        , 'elm-starter.js'
        , 'manifest.json'
        ]).then(() => {
        console.log("done");
    }).catch(err => {
        throw err;
    });
});

function copyFiles(srcDir, destDir, files) {
    return Promise.all(files.map(f => {
       return copyFilePromise(path.join(srcDir, f), path.join(destDir, f));
    }));
}