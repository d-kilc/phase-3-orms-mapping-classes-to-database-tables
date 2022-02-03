class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id:nil)
    @id = id
    @name = name
    @album = album
  end

  def self.create_table
    sql = <<-SQL
      create table if not exists songs (
        id integer primary key,
        name text,
        album text
      );
    SQL

    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      insert into songs (name, album)
      values (?,?)
    SQL

    DB[:conn].execute(sql, self.name, self.album)

    #after the insert, grab the ID and slap it onto the ruby obj
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
    return self
  end

  def self.create name:, album:
    song = Song.new name: name, album: album
    song.save
    song
  end

end