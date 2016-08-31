module MigrationHelper
   # Add foreign key for migrations
   # Usage:
   # * /db/migrate/xxxx_create_users.rb
   # class CreateUsers < ActiveRecord::Migration
   #   extend MigrateionHelpers
   #   def self.up
   #     ...
   #     create_foreign_key :users, :group_id, :groups
   #   end
   #   def down.up
   #     ...
   #     drop_foreign_key  :users, :group_id
   #   end
   # end
   #
  def create_foreign_key(from_table, from_column, to_table, to_column='id')
    execute %(alter table #{from_table}
              add constraint #{constraint_name(from_table, from_column)}
              foreign key (#{from_column})
              references #{to_table}(#{to_column}))
  end

  def drop_foreign_key(from_table, from_column)
    execute %(alter table #{from_table}
              drop FOREIGN KEY #{constraint_name(from_table, from_column)})
  end

  def constraint_name(table, column)
    "fk_#{table}_#{column}"
  end


   # Add many-to-many relationship for migrations
   # Usage:
   # * /db/migrate/xxxx_create_users.rb
   # class CreateUsers < ActiveRecord::Migration
   #   extend MigrateionHelpers
   #   def self.up
   #     ...
   #   end
   #   def down.up
   #     ...
   #   end
   # end
   # * /db/migrate/xxxx_create_groups.rb
   # class CreateGroups < ActiveRecord::Migration
   #   extend MigrateionHelpers
   #   def self.up
   #     ...
   #     create_many_to_many :users, :groups
   #   end
   #   def down.up
   #     ...
   #     drop_many_to_many :users, :groups
   #   end
   # end
   #
  def create_many_to_many(table1, table2, table_name=nil, columns=nil)
    if table_name.nil?
      @table = many_to_many_name(table1, table2)
    else
      @table = table_name
    end

    @column1 = table1.to_s.singularize + "_id"
    @column2 = table2.to_s.singularize + "_id"
    create_table @table, :id => false do |t|
      t.integer @column1
      t.integer @column2
    end

    if !columns.nil?
      columns.each{|key, value| add_column @table, key, value}
    end

    create_foreign_key @table, @column1, table1
    create_foreign_key @table, @column2, table2
  end

  def drop_many_to_many(table1, table2,table_name=nil)
    if table_name.nil?
      @table = many_to_many_name(table1, table2)
    else
      @table = table_name
    end

    @column1 = table1.to_s.singularize + "_id"
    @column2 = table2.to_s.singularize + "_id"

    drop_foreign_key @table, @column1
    drop_foreign_key @table, @column2

    drop_table @table
  end

  def many_to_many_name(table1, table2)
    "#{table1}_#{table2}"
  end

end
