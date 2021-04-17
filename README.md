# elm-book-review

## URL

https://wizardly-clarke-07b476.netlify.app/

[![Netlify Status](https://api.netlify.com/api/v1/badges/187d4f7d-bffb-4464-a2a6-95950660c8ad/deploy-status)](https://app.netlify.com/sites/wizardly-clarke-07b476/deploys)

## Development

```
$ git clone https://github.com/lucamug/elm-books-review
$ elm-books-review
$ cmd/start/start
```

## Build
```
$ cmd/build
```
Create the folder `build` with all the required assets

## Release

Merging modification in the `Master` branch will automatically update the website

## Utilities
```
$ cmd/analyse
```
To analyse the code. The report is in `cmd/issues/txt`

```
$ cmd/remove-unused-imports
```
To remove unused imports

```
$ cmd/surge
```
To publish the `build` folder in `Surge`, for testing
