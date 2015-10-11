# node-slack-files

A client of Slack Web API on file upload.

https://api.slack.com/methods/files.upload

## Installation

Install with [npm](https://www.npmjs.com/):

```shell
npm install coffee-script -g
npm install slack-files --save
```

## Example

```javascript
var slack = require('slack-files');
slack.upload('xoxp-aaaaaaaaaa-bbbbbbbbbb-ccccccccccc-dddddddddd', 'sample.txt')
  .spread(function (response, body) { console.log(body.file.url) });
```

See more examples in [./test/*.coffee](./test)
