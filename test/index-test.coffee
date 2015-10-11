expect = require('chai').use(require('chai-as-promised')).expect
files = require('../src')
nock = require('nock')

describe 'slack-files', ->
  token = 'xoxp-aaaaaaaaaa-bbbbbbbbbb-ccccccccccc-dddddddddd'
  context '#upload', ->
    mockHttp = (key) ->
      nock('https://slack.com:443')
        .filteringRequestBody((body) -> '*')
        .post('/api/files.upload', '*')
        .replyWithFile(200, "#{__dirname}/fixtures/upload-#{key}.json")

    context 'with non-existent local path', ->
      it 'returns error', ->
        file = './test/fixtures/missing-file.text'
        expect(
          files.upload(token, file)
            .catch(Error, (err) -> err.message)
        ).to.eventually.equal("form-data: ENOENT, open './test/fixtures/missing-file.text'")

    context 'with invalid token', ->
      beforeEach -> mockHttp('ng-auth')

      it 'returns error', ->
        file = './test/fixtures/sample.txt'
        expect(
          files.upload(token, file)
            .spread((response, body) -> body)
        )
        .to.eventually.deep
        .equal(ok: false, error: 'invalid_auth')

    context 'with valid local path', ->
      beforeEach -> mockHttp('ok')

      it 'uploads the file', ->
        file = './test/fixtures/sample.txt'
        expect(
          files.upload(token, file)
            .spread (response, body) ->
              size: body.file?.size
              filetype: body.file?.filetype
              ok: body.ok
        )
        .to.eventually.deep
        .equal(size: 12, filetype: 'text', ok: true)
