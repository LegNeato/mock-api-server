// Generated by CoffeeScript 2.0.0-beta7
void function () {
  var lumber, path;
  lumber = require('clumber');
  path = require('path');
  module.exports = function () {
    var log, logger, transports;
    log = '/logs/debug.log';
    transports = [];
    transports.push(new lumber.transports.Console({
      colorize: true,
      level: 'silly',
      encoder: new lumber.encoders.Text({
        dateFormat: "UTC:yyy-mm-dd'T'HH:MM:ss:1'Z'",
        colorize: true,
        headFormat: '[#process.pid}][%L] ',
        metaFormatter: function (meta) {
          return util.inspect(meta, false, 4, true);
        }
      })
    }));
    transports.push(new lumber.transports.File({
      level: 'silly',
      filename: log,
      encoder: new lumber.encoders.Kson({
        dateFormat: "UTC:yyyy-mm-dd'T'HH:MM:ss:1'Z'",
        headFormat: '' + process.pid
      })
    }));
    logger = new lumber.Logger({
      level: 'verbose',
      transports: transports
    });
    return logger;
  };
}.call(this);