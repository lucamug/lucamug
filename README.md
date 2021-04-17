# elm-book-review

## URL

Published as [https://lucamug.guupa.com/](https://lucamug.guupa.com/).

[![Netlify Status](https://api.netlify.com/api/v1/badges/14ad54e4-938e-45c4-9888-4edf3f69ac01/deploy-status)](https://app.netlify.com/sites/condescending-mccarthy-e887b3/deploys)

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
