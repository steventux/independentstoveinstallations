worker_processes 6 # amount of unicorn workers to spin up
timeout 30         # restarts workers that hang for 30 seconds
preload_app false   # avoid regeneration of jekyll site for each fork
