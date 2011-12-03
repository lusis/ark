module Ark
  module Helpers

    def minify_json(string)
      string.gsub(/\n|\s+/,'')
    end

  end
end
