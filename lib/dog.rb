require 'pry'
class Dog

  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    breed = row[2]
    new_dog = self.new(name: name, breed: breed, id: id)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs
    (id INTEGER PRIMARY KEY,
    name TEXT,
    BREED TEXT)
    ;
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.breed)
    self
  end

  def self.create(attributes)
    new_doggy = self.new(attributes)
    new_doggy.save
  end

  def self.find_by_id(num)
    sql = <<-SQL
    SELECT * FROM dogs WHERE id = ?
    SQL

    DB[:conn].execute(sql, num).map do |row|
    self.new_from_db(row)
  end.first
  end
 
  def self.find_or_create_by(name:, breed:)
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
  if !dog.empty?
      dog_data = dog[0]
      dog = Dog.new(id:1, name:1, breed:3)
  else
      dog = self.create(name: name, breed: breed)
  end
  dog
  end

end
