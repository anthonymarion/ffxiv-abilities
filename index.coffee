cheerio = require 'cheerio'
fs = require 'fs'
_ = require 'underscore'

classes = [
  'WHM', 'CNJ',
  'THM', 'BLM',
  'ACN', 'SMN', 'SCH',
  'GLA', 'PLD',
  'PGL', 'MNK',
  'MRD', 'WAR',
  'LNC', 'DRG',
  'ARC', 'BRD'
]

abilities = []

extractObtained = (text) ->
  matches = /Obtained\s+(.*)\s+Lv.([0-9]*)/.exec text
  return matches[0]

pagesDir = fs.readdirSync 'pages'
pagesDir.forEach (page) ->
  data = fs.readFileSync "pages/#{page}"
  console.log 'error reading file' if not data
  $ = cheerio.load(data)

  result = $('div.search_result_box')
  console.log result.length
  data = result.map (ndx, el) ->
    tooltip = $(el).attr('data-tooltip')
    $tooltip = cheerio.load(tooltip)
    $descriptionBox = $tooltip('.DescriptionBox div')

    return {
      name: $tooltip('div h2').text()
      desc: $($descriptionBox[0]).text()
      classes: $tooltip('.hud-widget-text-5').text().split ' '
      obtained: extractObtained $tooltip('div').text()
    }

  # Filter out traits
  data = _(data).filter (dat) -> dat.classes[0] isnt ''

  abilities = abilities.concat(data)

#console.log abilities

classes.forEach (className) ->
  classAbilities = abilities
  classAbilities = _(classAbilities).filter (ability) -> _(ability.classes).contains className
  classAbilities = _(classAbilities).uniq (ability) -> ability.name

  formatted = ""

  classAbilities.forEach (ability) ->
    formatted = formatted.concat """
      #{ability.name}
        #{ability.desc}
        #{ability.obtained}

    """

  fs.unlink "abilities/#{className}.txt"
  fs.writeFileSync "abilities/#{className}.txt", formatted
