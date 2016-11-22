# List of available `st2` services:
# https://github.com/StackStorm/st2/blob/master/st2common/bin/st2ctl#L5
default['stackstorm']['SERVICES'] = %w(st2actionrunner st2api st2stream st2auth st2garbagecollector st2notifier st2resultstracker st2rulesengine st2sensorcontainer).freeze

default['stackstorm']['install_repo']['packages'] = %w(st2)
