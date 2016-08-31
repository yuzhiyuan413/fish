require "migration_helper"
class CreateAccountRoles < ActiveRecord::Migration

  extend MigrationHelper
  def self.up
    create_many_to_many :accounts, :roles
  end

  def self.down
    drop_many_to_many :accounts, :roles
  end
end
