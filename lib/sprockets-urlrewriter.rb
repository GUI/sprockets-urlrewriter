require 'sprockets' 
require 'pathname' 
require 'uri' 
 
module Sprockets 
  class UrlRewriter < Processor 
    def evaluate(context, locals) 
      # FIXME: Accessing logical_path instance variable directly instead of
      # using public method, since the public method incorrectly chops paths
      # with periods in them: https://github.com/sstephenson/sprockets/pull/299
      #
      # logical_path = context.logical_path
      logical_path = context.instance_variable_get("@logical_path")

      rel = Pathname.new(logical_path).parent
      data.gsub /url\(['"]?([^\s)]+\.[a-z]+)(\?\d+)?['"]?\)/ do |url| 
        unless URI.parse($1).absolute?
          new_path = rel.join Pathname.new($1)
          url = "url(#{new_path})"
        end

        url
      end 
    end 
  end 
end
