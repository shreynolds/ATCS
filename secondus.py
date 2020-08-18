import requests
import pandas as pd
import json
import urllib
import json

if __name__ == "__main__":

    data = [] # the main storage of all the data of the different places. A list of dictionaries.

    # Reading in the data from the CSV file, and shortening it
    cities = pd.read_csv("cities.csv")
    cities = cities[:60]

    todayIcons = dict()
    tomorrowIcons = dict()

    # Looping through the data, and adding the important values to our data list
    for x in range (0, 59):
        coords = cities["Coordinates"][x]
        lat = coords[0:coords.index(",")]
        long = coords[coords.index(",") + 2:]
        dict = {
            "city": cities["City"][x],
            "state": cities["State"][x],
            "lat": float(lat),
            "long": float(long)
        }
        data.append(dict)

    weatherUrl = "http://api.openweathermap.org/data/2.5/weather"
    headers = {"Accept": "application/json"}
    # https://openweathermap.org/current
    # ^API for the weather in a certain zip code

    # For each city, using the first API to find its current weather and all details associated with that
    for dict in data:
        params = {'lat': dict["lat"],
               'lon': dict["long"],
               "APPID": 'facfdcafeef637f8f9e81b712fa0fdc4',
                "units": "imperial"} # units means using Fahrenheit
        response = requests.get(weatherUrl, headers=headers, params=params)
        response_json = json.loads(response.text)
        dict["todayWeather"] = response_json['weather'][0]["description"]
        dict["todayTemp"] = response_json['main']["temp"]
        dict["todayIcon"] = response_json['weather'][0]['icon']

    # For each city, using the second API to find the weather forecast and all those details
    for dict in data:
        urlBegin = "http://api.aerisapi.com/forecasts/"
        urlEnd = "?limit=2&client_id=vjeCefJPXimjUalXuZuPv&client_secret=heeAbAZ2jIHz7OjBTY9XX3PSkt6ytj0zzsjL7son"
        lat = dict["lat"]
        long = dict["long"]
        request = urllib.request.urlopen(urlBegin + str(lat) + "," + str(long) + urlEnd)
        response = request.read()
        response_json = json.loads(response)
        if response_json['success']: # code from the site: makes sure that the call went through
            ob = response_json['response'][0]['periods'][1]
            dict["tomorrowTemp"] = ob['avgTempF']
            dict["tomorrowWeather"] = ob['weather']
            dict["tomorrowIcon"] = ob['icon']
            dict["tomorrowSimple"] = ob['weatherPrimary']

    mapquestKey = "	2lYkSpGYbCVAtzAG1ef2cJfWCnK7vINx" # key to load the mapquest map

    map_js = ""  # creating the javascript

    # creating the two layers, one for today's data and one for tomorrow's data
    map_js += """
    todayLayer = L.layerGroup();
    tomorrowLayer = L.layerGroup();
    """

    # adding the buttons to switch between current weather and tomorrow's forecast
    # style citation: https://stackoverflow.com/questions/31924890/leaflet-js-custom-control-button-add-text-hover
    map_js += """  var choice = L.control({position: 'topright'});
    choice.onAdd = function(map)
    {
        var div = L.DomUtil.create("div", 'leaflet-bar leaflet-control leaflet-control-custom');
        div.style.backgroundColor = 'white';    

        var today = document.createElement('input'); //creating the button for today
        today.type= "radio"; //button type is radio
        today.name = "choice"; //they need the same name and id so that it is one or the other
        today.id = "id";
        today.checked = true; //making it start checked, because we start with today's weather

        var tomorrow = document.createElement('input'); //creating the button for tomorrow
        tomorrow.type = "radio";
        tomorrow.name = "choice";
        tomorrow.id = "id";

        var todayLabel = document.createElement('text'); //creating the label for today
        todayLabel.htmlFor = "id";
        todayLabel.appendChild(document.createTextNode('Current Weather'));

        var tomorrowLabel = document.createElement('text'); //creating the label for tomorrow
        tomorrowLabel.htmlFor = "id";
        tomorrowLabel.appendChild(document.createTextNode('Forecast for Tomorrow'));

        //adding all of the labels and radio buttons to the legend
        div.appendChild(today);
        div.appendChild(todayLabel);
        div.appendChild(tomorrow);
        div.appendChild(tomorrowLabel);

        //what happens if today is checked -- shows the layer and legend for today, and 
        //removes the layer and legend for tomorrow
        today.addEventListener('change', function()
        {
            if(this.checked) {
                map.removeLayer(tomorrowLayer);
                map.addLayer(todayLayer);
                map.removeControl(tomorrowLegend);
                todayLegend.addTo(map);
            }
        });

        //what happens if tomorrow is checked -- shows the layer and legend for tomorrow,
        //and removes the layer and legend for today
        tomorrow.addEventListener('change', function()
        {
            if(this.checked)
            {
                map.removeLayer(todayLayer);
                map.addLayer(tomorrowLayer);
                map.removeControl(todayLegend);
                tomorrowLegend.addTo(map);
            }
        });

        return div;
    }
    choice.addTo(map); //adding the buttons to the map
"""
    # citation for adding/removing legend:
    # https://gis.stackexchange.com/questions/68941/how-to-add-remove-legend-with-leaflet-layers-control

    # the javascript function that returns the right color based on the temperature
    map_js += "function getColor(temp){" \
              "if (temp < 30){" \
              "return '#0571b0'}" \
              "else if (temp < 60){" \
              "return '#92c5de'}" \
              "else if (temp < 80){" \
              "return '#f4a582'}" \
              "else{" \
              "return '#ca0020'}" \
              "}"

    # Creates the legend based on the different colors
    # citation for how to do this: summer code (VTS)
    map_js += """ var legend = L.control({position: 'bottomleft'});   
    legend.onAdd = function (map) {                    
        var div = L.DomUtil.create('div', 'legend'),
            colors = ['#0571b0','#92c5de', '#f4a582', '#ca0020'],
            features = ["<30°F", "30-59°F", "60-79°F", ">80°F"];
        div.style.backgroundColor = 'white';   //giving it a background

        div.innerHTML += '<b>Legend <br></b>'; //Title
        
        //looping through the different colors and names associated with them, and adding ig to the legend
        for(var x = 0; x < 4; x ++)
        {
            div.innerHTML += "<span style='background:" + colors[x]  + "; color: " + colors[x] + "'>OO</span>"
            div.innerHTML += features[x];
            div.innerHTML += "<br>";
        }

        return div;
    };
    legend.addTo(map); //adding this legend to the map
        """

    imageURL = "http://openweathermap.org/img/w/"
    imageEnd = ".png"

    # Adding
    for dict in data:
        lat = dict["lat"]
        long = dict["long"]
        name = dict["city"]
        temp = dict["todayTemp"]
        state = dict["state"]
        text = str(name) + ", " + str(state)+ " <br>" + str(str(temp)[:2]) + "°F <br>" + str(dict["todayWeather"]).capitalize()
        # citation: https://www.tutorialspoint.com/python/string_capitalize.htm
        map_js += """var marker = L.circle([""" + str(lat) + ", " + str(long) + """], {
        draggable: false,
        color: getColor(""" + str(temp) + """),
        fillOpacity: 0,
        radius: 50000
       }).bindPopup('""" + str(text) + """').addTo(map);
       
       todayLayer.addLayer(marker);

      """
    # citation for adding to layer:
    # https://gis.stackexchange.com/questions/267965/the-proper-way-to-add-markers-to-a-layer-group-in-leaflet

    # Looping through the data for today's data and adding the image to the map
    for dict in data:
        name = dict["todayWeather"]
        lat = dict["lat"]
        long = dict["long"]
        image = dict["todayIcon"]
        url = str(imageURL + image + imageEnd) # url is image url

        # Creating the dictionary of names and icons that will be used to create the legend
        if url not in todayIcons:
            todayIcons[str(url)] = name
        elif name not in str(todayIcons[url]):
            todayIcons[url] = str(todayIcons[url] + ", " + name)

        # Creating an overlay of the image and adding it to today's layer
        map_js += """ var imageUrl = '""" + url + """';
            var imageBounds = [
             ["""+ str(lat - .6) + """,""" + str(long - .6)+"""],
            [""" + str(lat - .6) + """, """ + str(long + .6) + """],
            [""" + str(lat + .6) + """, """ + str(long + .6) + """],
            [""" + str(lat + .6) + """, """ + str(long - .6) + """]
            ];

             overlay = L.imageOverlay(imageUrl, imageBounds).setOpacity(0.8).addTo(map); //adding image overlay
             
             todayLayer.addLayer(overlay); //adding it to the layer
             """
        # https://developer.mapquest.com/documentation/mapquest-js/v1.3/examples/map-with-image-overlay/

    # Looping through the data for tomorrow's forecast and adding it to the map
    imageBegin = "https://cdn.aerisapi.com/wxicons/v2/"
    for dict in data:
        lat = dict["lat"]
        long = dict["long"]
        url = str(imageBegin + dict["tomorrowIcon"])

        # Creating the dictionary with the icons and names, used later for the legend
        if url not in tomorrowIcons:
            tomorrowIcons[url] = dict["tomorrowSimple"]
        elif dict["tomorrowSimple"] not in tomorrowIcons[url]:
            tomorrowIcons[url] = tomorrowIcons[url] + ", " + dict["tomorrowSimple"]

        # The text that will be displayed in the popup
        text = str(dict["city"]) + ", " + str(dict["state"]) + " <br>" + str(str(dict["tomorrowTemp"])[:2]) +\
               "°F <br>" + str(dict["tomorrowWeather"]).capitalize()

        # Creating a marker for the different places, coloring it, and adding it to the layer
        map_js += """var marker = L.circle([""" + str(lat) + ", " + str(long) + """], {
                draggable: false,
                color: getColor(""" + str(dict["tomorrowTemp"]) + """),
                fillOpacity: 0,
                radius: 50000
               }).bindPopup('""" + str(text) + """');

               tomorrowLayer.addLayer(marker);
              """

        # Adds the image overlay, with the image URL, to the layer
        map_js += """ var imageUrl = '""" + url + """';
                    var imageBounds = [
                     [""" + str(lat - .6) + """,""" + str(long - .6) + """],
                    [""" + str(lat - .6) + """, """ + str(long + .6) + """],
                    [""" + str(lat + .6) + """, """ + str(long + .6) + """],
                    [""" + str(lat + .6) + """, """ + str(long - .6) + """]
                    ];

                     overlay = L.imageOverlay(imageUrl, imageBounds).setOpacity(0.9);

                     tomorrowLayer.addLayer(overlay);"""

    # Create two lists of images and the names of the weather from the dictionary
    images = []
    names = []
    for key in todayIcons:
        images.append(str(key))
        names.append(str(todayIcons[key]))

    # Creates the legend for today's weather and adds it to the map
    map_js += """ var todayLegend = L.control({position: 'bottomleft'});   
        todayLegend.onAdd = function (map) {                    
            var div = L.DomUtil.create('div', 'legend'),
                images = """ + str(images) + """,
                names = """ + str(names) + """;
            div.style.backgroundColor = 'white';  //giving it a background 

        //looping through all the images, and putting the associated text next to them
            div.innerHTML += '<b>Legend <br></b>'; //Title
            for(var x = 0; x < """ + str(len(images)) + """; x ++)
            {
                div.innerHTML += "<img src=" + images[x] + " alt='' width = '30' height = '30' >";
                div.innerHTML += names[x];
                div.innerHTML += "<br>";
            }

            return div;
        };
        
        //adding it to the map
        todayLegend.addTo(map); """

    # Creates two lists of images and names for tomorrow's legend
    tomImages = []
    tomNames = []
    for key in tomorrowIcons:
        tomImages.append(str(key))
        tomNames.append(str(tomorrowIcons[key]))

    # Creates a legend for tomorrow's weather
    map_js += """
    var tomorrowLegend = L.control({position: 'bottomleft'});   
        tomorrowLegend.onAdd = function (map) {                    
            var div = L.DomUtil.create('div', 'legend'),
                images = """ + str(tomImages) + """,
                names = """ + str(tomNames) + """;
            div.style.backgroundColor = 'white';   //giving it a background

        //looping through the images and associated text and adding it to the legend
            div.innerHTML += '<b>Legend <br></b>'; //Title
            for(var x = 0; x < """ + str(len(tomImages)) + """; x ++)
            {
                div.innerHTML += "<img src=" + images[x] + " alt='' width = '30' height = '30' >";
                div.innerHTML += names[x];
                div.innerHTML += "<br>";
            }
            return div;
        };
        
    """

    # the starting coordinates of the map are the center coordinates of the US
    us_lat = 39.82
    us_long = -98.58

    # The header and beginning text for the map
    map_start = """<html>
      <head>
        <script src="https://api.mqcdn.com/sdk/mapquest-js/v1.3.2/mapquest.js"></script>
        <link type="text/css" rel="stylesheet" href="https://api.mqcdn.com/sdk/mapquest-js/v1.3.2/mapquest.css"/>

        <script type="text/javascript">
          window.onload = function() {
            L.mapquest.key = '""" + mapquestKey + """'; //loading mapquest key

            var map = L.mapquest.map('map', {
              center: [""" + str(us_lat) + ", " + str(us_long) + """], //center is center of US
              layers: L.mapquest.tileLayer('map'), //creating the tile layer background
              zoom: 5 //the start zoom
            });

      """

    # The ending text for the map
    map_end = """      };
        </script>
      </head>

      <body style="border: 0; margin: 0;">
        <div id="map" style="width: 100%; height: 675px;"></div>
      </body>
    </html>"""

    # Opening and writing the file
    myfile = open("mymap.html", "w")
    myfile.write(map_start + map_js + map_end)
    myfile.close()