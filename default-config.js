module.exports = {
  // listen ip for answer requests 0.0.0.0 everyone or 10.0.0.1 just request from one
  host: '0.0.0.0',
  // listen port of the server
  port: 8080,
  // where the rrd data are located collected default is /var/lib/collectd/rdd
  basedir: '/var/lib/collectd/rrd'
  // for optional general domain extension
}