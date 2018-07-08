# frozen_string_literal: true

require "active_support/concern"
require "active_support/core_ext/module/attribute_accessors"

# Trashy let's you soft-delete Active Record models with ease.
module Trashy
  extend ActiveSupport::Concern

  VERSION = "0.1.0"

  # If automatic is true, which it is by default, set a default scope that
  # filters the soft-deleted records.
  mattr_accessor(:automatic, instance_accessor: false) { true }

  # The default timestamp column name to look for is deleted_at. If you need to
  # override it globally, you can set this value in an initializer.
  mattr_accessor(:default_column, instance_accessor: false) { "deleted_at" }

  # The column can, optionally, be a boolean. Usually, a timestamp is the
  # better option, but if you want to trash a legacy model, this is an option.
  mattr_accessor(:default_boolean, instance_accessor: false) { false }

  included do
    cattr_accessor(:trashy_column) { Trashy.default_column }
    cattr_accessor(:trashy_boolean) { Trashy.default_boolean }

    default_scope { untrashed } if Trashy.automatic
  end

  module ClassMethods
    # Untrashed returns all the records for this model that haven't been
    # soft-deleted.
    def untrashed
      @has_trashy_column ||= column_names.include?(trashy_column.to_s)
      return all unless @has_trashy_column

      where(trashy_column.to_s => (false if trashy_boolean))
    end

    # Trashed returns the soft-deleted records for this model.
    def trashed
      @has_trashy_column ||= column_names.include?(trashy_column.to_s)
      return none unless @has_trashy_column

      unscoped.where.not(trashy_column.to_s => (false if trashy_boolean))
    end
  end

  def trash
    return unless respond_to?(trashy_column)

    update_column(trashy_column, trashy_boolean || Time.current)
  end

  def untrash
    return unless respond_to?(trashy_column)

    update_column(trashy_column, (false if trashy_boolean))
  end
end
