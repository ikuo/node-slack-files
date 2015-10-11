expect = require('chai').use(require('chai-as-promised')).expect
files = require('../src')
nock = require('nock')

describe 'slack-files', ->
  token = 'xoxp-aaaaaaaaaa-bbbbbbbbbb-ccccccccccc-dddddddddd'
  context '#upload', ->
    context 'with valid local path', ->
      beforeEach ->
        nock('https://slack.com:443')
          .filteringRequestBody((body) -> '*')
          .post('/api/files.upload', '*')
          .replyWithFile(200, "#{__dirname}/fixtures/upload-ok.json")

      it 'uploads the file', ->
        file = './test/fixtures/sample.txt'
        expect (
          files.upload(token, file)
            .spread (response, body) ->
              size: body.file?.size
              filetype: body.file?.filetype
              ok: body.ok
        )
        .to.eventually.deep
        .equal(size: 12, filetype: 'text', ok: true)