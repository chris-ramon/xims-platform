require 'colorize'

REPO_ROOT = File.dirname(__FILE__)
TESTS_LOG = File.join(REPO_ROOT, 'tests.log')

namespace :test do
  task all: ['program:all', 'server:all', 'rspec', 'js:all']

  namespace :program do
    task 'all' do
      background_process('elasticsearch -f -D es.config=/usr/local/opt/elasticsearch/config/elasticsearch.yml', TESTS_LOG)
      background_process('postgres -D /usr/local/var/postgres', TESTS_LOG)
    end
  end

  namespace :server do
    task all: ['backend', 'frontend']
    task 'backend' do
      background_process('RAILS_ENV=development rails s', TESTS_LOG)
    end
    task 'frontend' do
      background_process('(cd ../xims-app/; grunt serve)', TESTS_LOG)
    end
  end

  task 'rspec' do
    wait_for_server('0.0.0.0', '9200', false)

    puts("\n=======================================".blue)
    puts("Running rspec tests".blue)
    puts("=======================================".blue)

    output = `rspec`

    puts output
    if output !~ /0 failures/
      raise 'FAILED'
    end
  end

  namespace :js do
    task all: ['unit', 'e2e']
    task 'unit' do
      puts("\n=======================================".blue)
      puts("Running AngularJS Unit tests".blue)
      puts("=======================================".blue)

      output = `(cd ../xims-app/; grunt test)`
      puts output
      if output !~ /SUCCESS/
        raise 'FAILED'
      end
    end
    task 'e2e' do
      wait_for_server('0.0.0.0', '9000')

      puts("\n=======================================".blue)
      puts("Running AngularJS E2E tests".blue)
      puts("=======================================".blue)

      output = `(cd ../xims-app/node_modules/protractor/bin/; ./protractor ../../../test-e2e/protractor.conf.js)`
      puts output
      if output !~ /0 failures/
        raise 'FAILED'
      end
    end
  end
end

def background_process(command, logfile=nil)
  command = [*command]
  spawn_opts = {:pgroup => true}
  if !logfile.nil?
    puts "Running '#{command.join(' ')}', redirecting output to #{logfile}"
    spawn_opts[[:err, :out]] = [logfile, 'a']
  end
  pid = Process.spawn({}, *command, spawn_opts)

  at_exit do
    pgid = Process.getpgid(pid)
    begin
      Timeout.timeout(5) do
        Process.kill(:SIGINT, -pgid)
        Process.wait(-pgid)
      end
    rescue Timeout::Error
      begin
        Timeout.timeout(5) do
          Process.kill(:SIGTERM, -pgid)
          Process.wait(-pgid)
        end
      rescue Timeout::Error
        Process.kill(:SIGKILL, -pgid)
        Process.wait(-pgid)
      end
    end
  end
end

# Wait for a server to respond with status 200 at "/"
def wait_for_server(server, port, include_options=true)
  attempts = 0
  begin
    if include_options
      http = Net::HTTP.start(server, port, {open_timeout: 10, read_timeout: 10})
    else
      http = Net::HTTP.start(server, port)
    end
    response = http.head("/")
    response.code == "200"
    true
  rescue
    sleep(1)
    attempts += 1
    if attempts < 20
      retry
    else
      false
    end
  end
end