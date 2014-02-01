require 'sinatra'
require 'open3'
require 'json'

gv_type = 'text/vnd.graphviz'

supported_transforms = {
    '*/*'           => 'dot',
    gv_type         => 'dot',
    #'image/png'    => 'dot -Tpng',
    #'image/gif'    => 'dot -Tgif',
    'image/svg+xml' => 'dot -Tsvg'
}

get '/' do
  content_type :json
  JSON.pretty_generate ({
    name: 'GVaaS: Graphviz as a Service',
    repository: 'https://github.com/ryanbrainard/gvaas',
    resources: {
        url: '/dot',
        method: 'POST',
        content_type: 'text/vnd.graphviz',
        accept: supported_transforms.keys
    }
  })
end

post '/dot' do
  error(415) unless request.media_type == gv_type

  accept = request.accept ? request.accept.first : gv_type
  transform = supported_transforms.detect{|t,_| t == accept}
  error(415) unless transform
  content_type transform[0]
  cmd = transform[1]

  out, log, status = Open3.capture3(cmd, stdin_data: request.body.string)
  STDERR.puts log
  error(500) unless status.exitstatus.zero?
  out
end