require 'mysql2'
require 'open-uri'
require 'redis'
require 'sinatra'

client = Mysql2::Client.new(host: "db1",
                            username: "app",
                            password: "supersecret",
                            database: "acmecorp",
                            read_timeout: 1,
                            write_timeout: 1,
                            connect_timeout: 1,
                            reconnect: true
                           )

redis = Redis.new(host: "cache1")

set bind: "0.0.0.0"

get '/' do
  output = <<OUT
<html>
  <head>
    <title>AcmeCorp Image Hosting</title>
  </head>
  <body>
  <center>
  <h1>Images:</h1>
OUT

  counter = 0
  client.query("SELECT * FROM images").each do |row|
    break if counter > 10
    count = redis.get(row['id']) || 0
    output += "<p><img src='#{row['local_path']}' /><br>Created at #{row['created_at']}, #{count} views</p>"
    redis.incr(row['id'])
    counter += 1
  end

  output += <<OUT
  <p><a href="/randomizer">Generate another image!</a></p>
  </center>
  </body>
</html>
OUT

  output
end

get '/randomizer' do
  sources = [ 'https://i.imgur.com/eGd3mCU.jpg',
              'https://i.imgur.com/CCduPc8.png',
              'https://i.imgur.com/Dz6uCzK.png' ]
  filename = (0...24).map { (65 + rand(26)).chr }.join
  filename += ".jpg"
  file = File.open("/home/ubuntu/public/#{filename}", "w")
  file.write(open(sources.sample).read)
  file.close
  client.query("INSERT INTO images (local_path, created_at) VALUES ('#{filename}', NOW())")
  redirect '/'
end
