Command = require '../../command'
Protocol = require '../../protocol'
LineTransform = require '../../linetransform'

class LogcatCommand extends Command
  execute: (options = {}) ->
    # For some reason, LG G Flex requires a filter spec with the -B option.
    # It doesn't actually use it, though. Regardless of the spec we always get
    # all events on all devices.
    cmd = 'logcat *:I 2>/dev/null'
    cmd = "logcat -c 2>/dev/null && #{cmd}" if options.clear
    this._send "shell:echo && #{cmd}"
    @parser.readAscii 4
      .then (reply) =>
        switch reply
          when Protocol.OKAY
            @parser.raw().pipe new LineTransform autoDetect: true
          when Protocol.FAIL
            @parser.readError()
          else
            @parser.unexpected reply, 'OKAY or FAIL'

module.exports = LogcatCommand
