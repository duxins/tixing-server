# Export structure without autoincrement
# taken from http://stackoverflow.com/a/20695238/575163
Rake::Task["db:structure:dump"].enhance do
  path = Rails.root.join('db', 'structure.sql')
  File.write path, File.read(path).gsub(/ AUTO_INCREMENT=\d*/, '')
end
