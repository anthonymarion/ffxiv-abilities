#/usr/bin/env bash

classes=(
	'ARCANIST'
	'ARCHER'
	'BARD'
	'BLACK+MAGE'
	'CONJURER'
	'DRAGOON'
	'GLADIATOR'
	'LANCER'
	'MARAUDER'
	'MONK'
	'PALADIN'
	'PUGILIST'
	'SCHOLAR'
	'SUMMONER'
	'THAUMATURGE'
	'WARRIOR'
	'WHITE+MAGE'
)

for class in "${classes[@]}"; do
	url="http://xivdb.com/modules/search/search.php?query=!filters&page=1&pagearray=%7B%7D&language=1&filters=%22SKILLS%3AACA_INGAME_1%3AASA_$class%3AAOA_AOALVL_AOADESC%3A%22"
	echo $url

	rm pages/$class.html
	curl "$url" > pages/$class.html
done


