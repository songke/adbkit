const Command = require('../../command');
const Protocol = require('../../protocol');

class HostTransportCommand extends Command {
  execute(serial) {
    this._send(`host:transport:${serial}`);
    return this.parser.readAscii(4)
      .then(reply => {
        switch (reply) {
          case Protocol.OKAY:
            return true;
          case Protocol.FAIL:
            return this.parser.readError();
          default:
            return this.parser.unexpected(reply, 'OKAY or FAIL');
        }
    });
  }
}

module.exports = HostTransportCommand;