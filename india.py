import requests
from requests.auth import HTTPBasicAuth
import json
from datetime import datetime


def getFamousQuote():
    url = "https://andruxnet-random-famous-quotes.p.mashape.com/"
    headers = {
    "X-Mashape-Key": "TBRqShOpRgmshawBlh4owSh0JeoJp1CmwJFjsng8YyEOucUfBV",
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json"
    }
    params = {"cat": "movies"}

    response = requests.post(url, headers=headers, data=params)
    response_data = json.loads(response.text)
    return ("\"" + response_data[0]["quote"] + "\" - " + response_data[0]["author"])


def loveCalculator(name1, name2):
    url = "https://love-calculator.p.mashape.com/getPercentage"
    headers = {
    "X-Mashape-Key": "TBRqShOpRgmshawBlh4owSh0JeoJp1CmwJFjsng8YyEOucUfBV",
    "Accept": "application/json"
    }
    params = {"fname" : name1, "sname" : name2}
    response = requests.get(url, headers=headers, params=params)
    response_data = json.loads(response.text)
    return(response_data["fname"] + " and " + response_data["sname"] + " have a match of " +
           response_data["percentage"] + "%, meaning that they are " + response_data["result"])


def randomJeopardyQuestion():
    url = "http://jservice.io/api/random"
    headers = {"Accept":"application/json"}
    params = {"count":1}
    response = requests.get(url, headers=headers, params=params)
    response_data = json.loads(response.text)
    return("Category: " + response_data[0]["category"]["title"] + "\nQuestion: " + response_data[0]["question"] +
           "\nAnswer: " + response_data[0]["answer"])


def onThisDay():
    month = datetime.today().month
    day = datetime.today().day
    url = "http://numbersapi.com/" + str(month) + "/" + str(day) + "/date"
    headers = {"Accept":"application/json"}
    response = requests.get(url, headers=headers)
    return response.text


if __name__ == "__main__":
    print("This API returns a random quote from a movie")
    print(getFamousQuote())
    print("\nThis API runs a love calculator based on two names you give it")
    print(loveCalculator("Jim", "Pamela"))
    print("\nThis API returns a random jeopardy question and the answer")
    print(randomJeopardyQuestion())
    print("\nThis API returns a fact about the current date in history")
    print(onThisDay())