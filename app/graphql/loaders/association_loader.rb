# https://github.com/Shopify/graphql-batch/blob/master/examples/association_loader.rb
# initialize(model, association_name) などのmodelはモデル、association_nameは関連名(has_many books のbooksなど)
# private validateメソッドはその関連が本当にあるか確認
# Promiseは貯めてあとで実行(resolve)してくれて、resolve済み(ロード済み)かどうかを管理してくれる
# preload_association メソッド内でpreloadなどN+1対応をやってくれる
# performメソッドに取得実行時の処理が書かれている
# こちらの記事が詳しいです: https://blog.kymmt.com/entry/graphql-batch-examples
module Loaders
  class AssociationLoader < GraphQL::Batch::Loader
    def self.validate(model, association_name)
      new(model, association_name)
      nil
    end

    def initialize(model, association_name)
      super()
      @model = model
      @association_name = association_name
      validate
    end

    def load(record)
      raise TypeError, "#{@model} loader can't load association for #{record.class}" unless record.is_a?(@model)
      return Promise.resolve(read_association(record)) if association_loaded?(record)
      super
    end

    # We want to load the associations on all records, even if they have the same id
    def cache_key(record)
      record.object_id
    end

    def perform(records)
      preload_association(records)
      records.each { |record| fulfill(record, read_association(record)) }
    end

    private

    def validate
      unless @model.reflect_on_association(@association_name)
        raise ArgumentError, "No association #{@association_name} on #{@model}"
      end
    end

    def preload_association(records)
      ::ActiveRecord::Associations::Preloader.new(records: records, associations: @association_name).call
    end

    def read_association(record)
      record.public_send(@association_name)
    end

    def association_loaded?(record)
      record.association(@association_name).loaded?
    end
  end
end