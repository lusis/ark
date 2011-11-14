module Ark
  class Record

    attr_accessor :errors, :basepath, :record_type, :schema

    def self.inherited(record)
    end

    def initialize
      @db = Ark::Repo.db || Ark::Repo.connect
      @record_type ||= "record"
      @basepath ||= "_objects/#{@record_type}"
    end

    def valid?
    end

    def save
      self.valid? ? @db.set("#{@basepath}/#{@name}.json", data, "Setting #{@record_type} - #{@name}") : false
    end

    def self.[](key)
    end

    protected
    def validate
    end

  end
end
