module.exports =

  ###
  Looks for ![](#!foo.jpg)
  and replaces them with a url

  returns (formattedContent)
  ###
  subImgSrcs: (content, uploadedImages, cb) ->
    tmpImageSrcRegExp = /!\[\]\(#![^\)]+/g
    
    imgDict = _.reduce uploadedImages, (accum, img) ->
                  accum[img.filename] = img.fd
                  return accum
              , {}

    cb content.replace tmpImageSrcRegExp, (src) ->
      return '![](' + imgDict[src.replace('![](#!', '')]

  ###
  Looks for #foo and change to <a class='hashtag' href='/tag/foo'>foo</a>

  returns (formattedContent, tags)
  ###
  hashtag: (content, cb) ->
    return cb('', []) if !content?
    
    hashtagRegex = /#(\w+)/g
    
    formattedContent = content.replace hashtagRegex, (match) ->
        match = match.replace('#', '')
        return "<a class='hashtag' href='/tags/#{match}'>#{match}</a>"

    tags = content.match(/#(\w+)/g)

    cb(formattedContent, tags)