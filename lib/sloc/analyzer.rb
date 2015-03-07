module Sloc
  class Analyzer
    def initialize(options = {})
      @options = options
    end

    def analyze(code, extension)
      result = {}

      code.gsub!(/\r\n|\r/, "\n")

      result[:total]          = code.scan("\n").size
      result[:empty_lines]    = code.scan(/^\s*$/).size
      result[:single_comment] = code.scan(single_comment_expression(extension)).size

      result
    end

    def comment_expressions(extension)
      start, stop = block_comment_expression(extension)

      {
        :single => single_comment_expression(extension),
        :start  => start,
        :stop   => stop,
      }
    end

    def single_comment_expression(extension)
      case extension
      when ".rb" then /#/
      when ".vim" then /"/
      end
    end

    def block_comment_expression(extension)
      case extension
      when ".rb" then [/=begin/, /=end/]
      else [nil, nil]
      end
    end
  end
end
