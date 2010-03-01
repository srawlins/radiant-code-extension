class CodeProcessors::HighlightJsProcessor < CodeProcessors::Base
  
  # Are we to use Styles 'n Scripts assets? This requires:
  # * Radiant::Config['code.use_sns'] = 'true'
  # * sns extension is installed
  # * highlight.pack.js exists in the JS assets
  # * each required highlight.js style exists in the CSS assets,
  #   for example github.css
  #
  # To avoid name conflicts with either highlight.js languages or styles, you
  # may specify a prefix for either. For example:
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
    s = ''
    if useSNS?
      script_name = Radiant::Config['code.sns_hljs_script'] || 'highlight.pack.js'
      script = Javascript.find_by_name(script_name).url
      s << '<script type="text/javascript" src="' + script + '"></script>'
    else
      s << '<script type="text/javascript" src="http://softwaremaniacs.org/media/soft/highlight/highlight.pack.js"></script>'
    end
    s << '<script type="text/javascript">hljs.tabReplace = \'    \';hljs.initHighlightingOnLoad();</script>'
  end

  # Include required stylesheets
  def include_stylesheets
    s = ''
    if useSNS?
      style_name  = Radiant::Config['code.sns_style_prefix'] || ''
      style_name += theme + '.css'
      style = Stylesheet.find_by_name(style_name).url
      s << '<link rel="stylesheet" title="highlight.js theme" href="' + style + '" />'
    else
      s << '<link rel="stylesheet" title="highlight.js theme" href="http://softwaremaniacs.org/media/soft/highlight/styles/' + theme + '.css" />'
    end
  end
 
  protected

  def default_theme
    'idea'
  end

end
