from datetime import datetime
import os
import time
from apscheduler.schedulers.background import BackgroundScheduler
import requests
from bs4 import BeautifulSoup

threshold = 5.00

def notify():
    price = getlowest()[1]
    link = getlowest()[0]
    if float(price) < threshold :
        os.system("""
              osascript -e 'display notification "{}" with title "{}"'
              """.format("Lowest price is $" + price + ". Link is " + link, "Price Notification"))  # beep\n
    else:
        os.system("""
                      osascript -e 'display notification "{}" with title "{}"'
                      """.format("There is no card below the threshold price", "Price Notification"))  # beep\n


def tick():
    print('Tick! The time is: %s' % datetime.now())


def getlowest():
    url = "https://www.ebay.com/sch/i.html"
    data = {"_from": "R40", "_nkw": "Babe Ruth Baseball Card", "_sacat": "0", "_trksid": "m570.l1313"}

    response = requests.get(url, params=data)
    bsObj = BeautifulSoup(response.text, "html.parser")
    prices = bsObj.find("div", {"class": "srp-river-results clearfix"}).findAll("li", {"class": "s-item"})

    lowestPrice = 10000000000000
    cheapest = ""

    for price in prices:
        cost = price.find("span", {"class": "s-item__price"}).text[1:]
        cost = cost.replace(",", "")
        if "to" in cost:  # deals with range of prices (ex: 1.00 to 4.00)
            cost = cost[0:4]
        # print(price.find("a", {"class": "s-item__link"}).get("href") + ": " + cost)

        if float(cost) < float(lowestPrice):
            lowestPrice = cost
            cheapest = price.find("a", {"class": "s-item__link"}).get("href")
        elif float(cost) == float(lowestPrice):
            cheapest = cheapest + " and \n" + price.find("a", {"class": "s-item__link"}).get("href")

    return (cheapest, lowestPrice)


if __name__ == '__main__':
    #notify("Notification", "Heres an alert without using external libraries.")
    scheduler = BackgroundScheduler()
    scheduler.add_job(notify, 'cron', day_of_week='mon-fri', hour=12, minute=56)
    scheduler.start()

    try:
        # This is here to simulate application activity (which keeps the main thread alive).
        while True:
            time.sleep(2)
    except (KeyboardInterrupt, SystemExit):
        # Not strictly necessary if daemonic mode is enabled but should be done if possible
        scheduler.shutdown()