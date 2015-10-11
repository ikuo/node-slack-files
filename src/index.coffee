_ = require('lodash')
fs = require('fs')
Promise = require('bluebird')
request = Promise.promisifyAll(require('request'))

module.exports =
  # https://api.slack.com/methods/files.upload
  upload: (token, localPath,
    { filetype,
      filename,
      title,
      initial_comment,
      channels
    } = {}
  ) ->
    data =
      token: token
      file: fs.createReadStream(localPath)
      filetype: filetype
      filename: filename
      title: title
      initial_comment: initial_comment
      channels: channels?.join(',')
    formData = _.omit(data, (value) -> !value)

    request.postAsync(
      url: 'https://slack.com/api/files.upload',
      json: true,
      formData: formData
    )
