# Description:
#   Hubot script to fetch beers on tap from the Encinitas Ale House
#
# Dependencies:
#   'cheerio': '^1.2'
#
# Commands:
#   hubot beer me - displays beers on tap from Encinitas Ale House
#
# Author:
#   @chrishepner

cheerio = require("cheerio")

HUBOT_ALEHOUSE_URL = "https://docs.google.com/document/d/1Xtc-2hL12566vrsPJRjcLrwre02w1lQJaTkbcKbwuiY/pub"
module.exports = (robot) ->

  robot.respond /beer me/i, (msg) ->
    robot.http(HUBOT_ALEHOUSE_URL)
      .get() (err, res, body) ->
        if err
          msg.send("Encountered an error #{err}")
          return
        if res.statusCode isnt 200
          msg.send("Request is non-HTTP 200")
          return
        $ = cheerio.load(body)
        $('style').remove()

        isHeader = false
        headerSeen = false
        outputLines = []
        $('#contents > p').each (i, el) ->
          lineText = $(this).text().trim()
          if lineText == ''
            isHeader = true
          else
            if isHeader
              lineText = '*' + lineText + '*'
              headerSeen = true
              isHeader = false
            else
              lineText = ':beer: ' + lineText
            if headerSeen
              outputLines.push(lineText)
        msg.send(outputLines.join("\n"))