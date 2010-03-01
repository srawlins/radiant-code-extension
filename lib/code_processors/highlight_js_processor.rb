class CodeProcessors::HighlightJsProcessor < CodeProcessors::Base
  
  # Are we to use Styles 'n Scripts assets? This requires:
  # * Radiant::Config['code.use_sns'] = 'true'
  # * sns extension is installed
  # * highlight.pack.js exists in the JS assets
  # * each required highlight.js language exists in JS assets,
  #   for example ruby.js
  # * each required highlight.js style exists in the CSS assets,
  #   for example github.css
  #
  # To avoid name conflicts with either highlight.js languages or styles, you
  # may specify a prefix for either. For example:
  # * Radiant::Config['code.sns_language_prefix'] = 'hljs_'  # for hljs_ruby.js
  # * Radiant::Config['code.sns_style_prefix'] = 'hljs_'  # for hljs_github.css
  #
  # To allow for different highlight.pack.js filenames (for example, to support
  # versioning), use something like the following:
  # * Radiant::Config['code.sns_hljs_script'] = 'highlight-5.8.pack.js'
  def useSNS?
    Radiant::Config['code.use_sns'] == 'true'
  end
  
  # Highlight code using highlight.js javascript library
  # Options:
  # * <tt>:lang</tt> - Code language
  # * <tt>:lines</tt> - Line numbering (table/inline/false)
  def highlight( code, options = {} )
    options.symbolize_keys!

    "<pre><code class=\"#{options[:lang] || language}\">#{CGI.escapeHTML(code)}</code></pre>"
  end

  # Include required javascripts
  def include_javascripts
    '<script type="text/javascript" src="http://softwaremaniacs.org/media/soft/highlight/highlight.pack.js"></script><script type="text/javascript">hljs.tabReplace = \'    \';hljs.initHighlightingOnLoad();</script>'
  end

  # Include required stylesheets
  def include_stylesheets
    '<link rel="stylesheet" title="highlight.js theme" href="http://softwaremaniacs.org/media/soft/highlight/styles/' + theme + '.css" />'
  end
 
  protected

  def default_theme
    'idea'
  end

end
