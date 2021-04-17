#!/usr/local/bin/node

const puppeteer = require('puppeteer');
const fs = require("fs");

// https://css-tricks.com/essential-meta-tags-social-media/
//
// 1200 x 630 pixels for the best display on high resolution devices.
// At the minimum, you should use images that are 600 x 315

const target = process.argv[2] ? process.argv[2] : "http://localhost:8000/opt"
const parsed = target.match( /^([^\/]*\/\/[^\/]+)(\/.*)$/ );
const defaultOptions = 
    { "targetDomain": "https://example.com"
    , "startingDomain": parsed ? parsed[1] : ""
    , "startingUrl": parsed ? parsed[2] : ""
    , "headless": process.argv[3] !== "head"
    , "sitemapName": "sitemap.txt"
    , "targetDir": "dist"
    , "extraHtml": ''
    , "batchesSize": 10
    , "pageName": "index.html"
    , "snapshots": false
    , "snapshotsName": "snapshot.jpg"
    , "snapshotsWidth": 600
    , "snapshotsHeight": 315
    , "snapshotsQuality" : 80
    , "urls": []
    };
    
(async function() {
    try {
        const browser = await puppeteer.launch(
          { headless: defaultOptions.headless
          // , args: [`--window-size=${options.snapshotsWidth},${options.snapshotsHeight}`]
          });
        const page = await browser.newPage();
        // await page.setViewport({width: options.snapshotsWidth, height: options.snapshotsHeight});
        await page.goto(`${defaultOptions.startingDomain}${defaultOptions.startingUrl}`, {waitUntil: 'networkidle0'});
        const html = await page.content();
        await page.close();
        const preContent = html.match(/<pre>([\s\S]*)<\/pre>/)[1].replace(/&lt;/g,"<").replace(/&gt;/g,">");
        const spaOptions = JSON.parse(preContent);
        const options = {...defaultOptions, ...spaOptions} 
        console.log(`### Static Pages Generation START ###

Building ${options.urls.length} static pages for ${options.targetDomain}`);
        const sitemap = options.urls.map(function(url){return `${options.targetDomain}${url}`;}).join("\n");
        fs.mkdirSync(`${options.targetDir}`, { recursive: true });
        fs.writeFileSync(`${options.targetDir}/${options.sitemapName}`, sitemap);
        const urlsInBatches = chunkArray(options.urls, options.batchesSize);
        await urlsInBatches.reduce(async (previousBatch, currentBatch, index) => {
            await previousBatch;
            console.log(`\nProcessing batch ${index + 1} of ${urlsInBatches.length}...\n`);
            const currentBatchPromises = currentBatch.map(url => processUrl(url, browser, options))
            const result = await Promise.all(currentBatchPromises);
        }, Promise.resolve());
        await browser.close();
        console.log(`\n### Static Pages Generation END ###\n\n`);
    } catch (error) {
        console.log(`${String(error).split("\n")[0]} (see below for more details).

### Usage ###
            
pages-generator

pages-generator http://localhost:8000/sitemap

pages-generator http://localhost:8000/sitemap head

This address should respond a JSON structure enclosed in <pre> tags.
Something like:

<pre>
    { "targetDomain": "https://example.com"
    , "sitemapName": "sitemap.txt"
    , "targetDir": "dist"
    , "extraHtml": '<script src="/bundle.js"></script>'
    , "batchesSize": 10
    , "headless": true
    , "snapshots": false
    , "snapshotsName": "snapshot.jpg"
    , "snapshotsWidth": 600
    , "snapshotsHeight": 315
    , "snapshotsQuality" : 80
    , "urls": 
        [ "/"
        , "/posts"
        , "/post/2020/06/02"
        , "/about"
        ]
    }
</pre>

### Default Options ###

`, defaultOptions, `

### Error details ###
`);
        console.error(error);
  }

})();

async function processUrl (url, browser, options) {
    const page = await browser.newPage();
    await page.setViewport({width: options.snapshotsWidth, height: options.snapshotsHeight});
    await page.goto(`${options.startingDomain}${url}`, {waitUntil: 'networkidle0'});
    fs.mkdirSync(`${options.targetDir}${url}`, { recursive: true });
    let html = await page.content();
    html = html.replace('</body>',`${options.extraHtml}</body>`);
    console.log(`* ${options.startingDomain}${url}`);
    fs.writeFileSync(`${options.targetDir}${url}/${options.pageName}`, html);
    if (options.snapshots) {
        await page.screenshot({path: `${options.targetDir}${url}/${options.snapshotsName}`, quality: options.snapshotsQuality});
    }
    await page.close();
}

/**
 * Returns an array with arrays of the given size.
 *
 * @param myArray {Array} Array to split
 * @param chunkSize {Integer} Size of every group
 */

function chunkArray(myArray, chunk_size){
    var results = [];
    while (myArray.length) {
        results.push(myArray.splice(0, chunk_size));
    }
    return results;
}