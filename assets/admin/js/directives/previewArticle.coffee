app.directive 'previewArticle',
  ['marked',
  ( marked ) ->

    restrict: 'AE'

    link: (s, el, attrs) ->

      if (attrs.previewArticle)
        s.$watch attrs.previewArticle, (article) ->

          if article?

            # hashtags
            hashtagRegex = /#(\w+)/g
            articlePreview = article.replace hashtagRegex, (match) ->
                match = match.replace('#', '')
                return "<a class='hashtag' href='/tags/#{match}'>#{match}</a>"

            # markdown
            renderer = new marked.Renderer()
            renderer.heading = (text) ->
              return text
            articlePreview = marked(articlePreview, { renderer: renderer })
            
            # image previews
            tmpImageSrcRegExp = /src="#![^"]+/g
            articlePreview = articlePreview.replace tmpImageSrcRegExp, (srcAttr) ->
              return 'src="' + s.inlineImgs[srcAttr.replace('src="#!', '')].dataUrl

          else
            articlePreview = ''

          el.html(articlePreview)
]
