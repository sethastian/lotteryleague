root = "/home/lotteryleague"
working_directory root
pid "#{root}/tmp/unicorn.pid"
listen "unix:/tmp/unicorn.lotteryleague.sock"
stderr_path "#{root}/config/unicorn.stderr.log"
