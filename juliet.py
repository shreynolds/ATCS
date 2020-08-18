import requests
from bs4 import BeautifulSoup
import re
import operator
from datetime import datetime
from datetime import timedelta

if __name__ == "__main__":

    url = "https://knightbook.menloschool.org"

    human_headers = {"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
                 "accept-language": "en-US,en;q=0.9",
                 "accept-encoding": "gzip, deflate, br",
                 "upgrade-insecure-requests": "1",
                 "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.183 Safari/537.36 Vivaldi/1.96.1147.64"
                 }

    session = requests.Session()

    response = session.get(url, headers=human_headers)
    response_bs = BeautifulSoup(response.text, "html.parser")
    login_page = response_bs.form['action']
    login_method = response_bs.form['method']

    inputList = response_bs.findAll('input')

    login_inputs = {}
    for tag in inputList:
	    if 'name' in tag.attrs:
		    login_inputs[tag['name']] = tag.get('value','')

    login_inputs["username"] = ""
    login_inputs["password"] = ""

    location = response.history[0].headers['Location']
    server = re.match("^(https://\w+\.\w+\.\w{1,3}:?\d*)[/a-zA-Z]*", location).group(1)

    knightbook = session.post(server + login_page, data = login_inputs)
    bsObj = BeautifulSoup(knightbook.text, "html.parser")
    personList = bsObj.findAll("div", {"class":"student-box"})
    bday = []

    for person in personList:
        bday.append({"person": person.div.text, "grade": person["data-grade"], "gender": person["data-gender"],
                     "days": int(person["data-days-until-birthday"])})

    bday = sorted(bday, key=lambda i:i["days"]) #sorting it based on birthday
    #https://www.geeksforgeeks.org/ways-sort-list-dictionaries-values-python-using-lambda-function/

    bday = bday[0:10] #getting the first ten
    print("The People with the ten soonest birthdays:")
    for person in bday:
         print("Name: " + person["person"])
         print("Grade: " + person["grade"])
         print("Gender: " + person["gender"])
         print("Birthday: " + str(datetime.now() + timedelta(days=person["days"]))[5:10])
         #citation: http://www.pressthered.com/adding_dates_and_times_in_python/
         print()

    url = "https://knightbook.menloschool.org/get_student_info.php?lookup=student_detail&id="
    ids = []
    cities = []
    for person in personList:
        ids.append(person["data-rid"])
    for id in ids:
        response = session.get(url + id, headers=human_headers)
        regex = re.search("<br \/>([\w ,-.])+<\/a>", response.text)
        address = regex.group()
        #print(address[6:address.index(",")+4])
        cities.append(address[6:address.index(",")+4])
    countCities = dict()
    for city in cities:
        if city in countCities:
            countCities[city] += 1
        else:
            countCities[city] = 1
    sorted = sorted(countCities.items(), key=operator.itemgetter(1), reverse=True)

    for thing in sorted:
        print(thing[0] + " has " + str(thing[1]) + " student(s).")
