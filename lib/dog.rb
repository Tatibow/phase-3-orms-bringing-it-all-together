class Dog
    attr_accessor(:id,:name, :breed)

    def initialize(id: nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end

    def self.create_table
        sql = "CREATE TABLE IF NOT EXISTS dogs(
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
            );"
            DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = "DROP TABLE IF EXISTS dogs;"
        DB[:conn].execute(sql)
    end

    def save
        sql = "INSERT INTO dogs(name, breed) VALUES(?,?);"
        DB[:conn].execute(sql, self.name, self.breed)
         self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
        # return instance of dog class
        self
    end

    def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)
        dog.save
    end

    def self.new_from_db(row)
        self.new(id:row[0], name:row[1], breed:row[2])
    end

    def self.all
       sql = "SELECT * FROM dogs;"
       DB[:conn].execute(sql).map do |row|
        self.new(id:row[0], name:row[1], breed:row[2])
       end
    end

    def self.find_by_name(name)
        sql = "SELECT * FROM dogs WHERE name =?"
        DB[:conn].execute(sql, name).map do |row|
        self.new_from_db(row)
        end.first
    end

    def self.find(id)
        sql = "SELECT * FROM dogs WHERE id = ?"
        DB[:conn].execute(sql, id).map do |row|
            self.new_from_db(row)
        end.first
    end
end
