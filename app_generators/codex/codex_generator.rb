class CodexGenerator < RubiGen::Base

  DEFAULT_SHEBANG = File.join(Config::CONFIG['bindir'],
                              Config::CONFIG['ruby_install_name'])

  default_options :author => nil

  attr_reader :name

  def initialize(runtime_args, runtime_options = {})
    super
    usage if args.empty?
    @destination_root = File.expand_path(args.shift)
    @name = base_name
    extract_options
  end

  def manifest
    record do |m|
      # Ensure appropriate folder(s) exists
      m.directory ''
      BASEDIRS.each { |path| m.directory path }

      # Create stubs
      m.template_copy_each %w[Rakefile]
      m.template_copy_each "html/all.html"
      %w[basics building example including_code table_of_contents].each do |slide|
        m.file_copy_each "slides/#{slide}.slides"
      end
      m.file_copy_each "slides/metadata.yml"
      %w[build_all postprocess_all pressie].each do |bin|
        m.file_copy_each "bin/#{bin}.rb"
      end
      %w[basic_continuation cc_throw_catch closure_continuation closure_continuation_2].each do |code|
        m.file_copy_each "code/control/#{code}.rb"
      end
      ["CollapseCode.html", "Cpp.html", "CrashTest.html", "CSharp.html", "CSS.html",
        "Delphi.html", "FirstLine.html", "Index.html", "Java.html", "JavaScript.html",
        "NoControls.html", "NoGutter.html", "PHP.html", "Python.html", "Ruby.html",
        "ShowColumns.html", "SmartTabs.html", "SQL.html",
        "VB.html", "XML.html",
        "Scripts/clipboard.swf", "Scripts/shBrushCpp.js", "Scripts/shBrushCSharp.js",
        "Scripts/shBrushCss.js", "Scripts/shBrushDelphi.js", "Scripts/shBrushJava.js",
        "Scripts/shBrushJScript.js", "Scripts/shBrushPhp.js", "Scripts/shBrushPython.js",
        "Scripts/shBrushRuby.js", "Scripts/shBrushSql.js", "Scripts/shBrushVb.js",
        "Scripts/shBrushXml.js", "Scripts/shCore.js", "Scripts/shCore.uncompressed.js",
        "Styles/SyntaxHighlighter.css", "Styles/TestPages.css",
        "Templates/Test.dwt"
        ].each do |syntax|
          m.file_copy_each "dp.SyntaxHighlighter/#{syntax}"
        end

      m.dependency "install_rubigen_scripts", [destination_root, 'codex'],
        :shebang => options[:shebang], :collision => :force
    end
  end

  protected
    def banner
      <<-EOS
Creates a Codex presentations.
Codex is imple tool for creating source-code intensive presentations and courses

USAGE: #{spec.name} name
EOS
    end

    def add_options!(opts)
      opts.separator ''
      opts.separator 'Options:'
      # For each option below, place the default
      # at the top of the file next to "default_options"
      # opts.on("-a", "--author=\"Your Name\"", String,
      #         "Some comment about this option",
      #         "Default: none") { |options[:author]| }
      opts.on("-v", "--version", "Show the #{File.basename($0)} version number and quit.")
    end

    def extract_options
      # for each option, extract it into a local variable (and create an "attr_reader :author" at the top)
      # Templates can access these value via the attr_reader-generated methods, but not the
      # raw instance variable value.
      # @author = options[:author]
    end

    # Installation skeleton.  Intermediate directories are automatically
    # created so don't sweat their absence here.
    BASEDIRS = %w(
      bin
      code/control
      html
      dp.SyntaxHighlighter/Scripts
      dp.SyntaxHighlighter/Styles
      dp.SyntaxHighlighter/Templates
      script
      slides
    )
end