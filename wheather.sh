# this is weather cli tool , to print weather on the screen

#!/bin/bash

cmd="$1"
place="$2"

temp=$(mktemp)

temp2=$(mktemp)

if [[ "$cmd" == "weather" ]]; then 
  curl -s https://geocoding-api.open-meteo.com/v1/search?name="$place" > "$temp" & 
  pid=$!

  wait $pid 
  response=$(cat "$temp")
  
   lat=$(echo "$response" | jq -r '.results[0].latitude')
  lon=$(echo "$response" | jq -r '.results[0].longitude') 

  echo "latitude=$lat"
  echo "longitude=$lon"

response2=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m")

  
  echo "timezone=$timezone=$(echo "$response2" | jq -r '.timezone')"
  echo "elevation=$elevation=$(echo "$response2" | jq -r '.elevation')"

  echo "time=$(echo "$response2" | jq -r '.current.time')"
  echo "temp=$(echo "$response2" | jq -r '.current.temperature_2m')"
  echo "wind=$(echo "$response2" | jq -r '.current.wind_speed_10m')"

  echo "temp_unit=$(echo "$response2" | jq -r '.current_units.temperature_2m')"
  echo "wind_unit=$(echo "$response2" | jq -r '.current_units.wind_speed_10m')"
 

fi
