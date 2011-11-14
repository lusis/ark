module Ark
  class Repo

    def initialize(options = {})
      @options = options
      Grit::Repo.init_bare_or_open(path)
    end

    def set(key, value, message = nil)
      message ||= "set '#{key}'"
      save(message) do |index|
        index.add(key, value)
      end
    end

    def get(key, value = nil, *)
      if head && blob = head.commit.tree / key
        blob.data
      end
    end

    def delete(key, message = nil, *)
      message ||= "deleted '#{key}'"
      self.get(key).tap do
        save(message) {|index| index.delete(key) }
      end
    end

    def clear(message = nil)
      message ||= "purged repo"
      save(message) do |index|
        if tree = index.current_tree
          tree.contents.each do |entry|
            index.delete(entry.name)
          end
        end
      end
    end

    def log(key)
      git.log(branch, key).map{|commit| commit.to_hash }
    end

    def keys
      head.commit.tree.contents.map {|blob| blob.name }
    end

    def git
      @git ||= Grit::Repo.new(path)
    end

    private
    def branch
      @options[:branch] || 'master'
    end

    def head
      git.get_head(branch)
    end

    def save(message)
      index = git.index
      if head
        commit = head.commit
        index.current_tree = commit.tree
      end
      yield index
      index.commit(message, :parents => Array(commit), :head => branch) if index.tree.any?
    end

    def path(key='')
      @path ||= File.join(File.expand_path(@options[:repo]), key)
    end

  end
end
