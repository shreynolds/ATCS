import requests
from bs4 import BeautifulSoup


if __name__ == '__main__':

	url = "https://www.ebay.com/sch/i.html"
	data = {"_from": "R40", "_nkw": "Babe Ruth Baseball Card", "_sacat": "0", "_trksid": "m570.l1313"}

	response = requests.get(url, params=data)
	bsObj = BeautifulSoup(response.text, "html.parser")
	prices = bsObj.find("div", {"class": "srp-river-results clearfix"}).findAll("li", {"class":"s-item"})

	lowestPrice = 10000000000000
	cheapest = ""

	for price in prices:
		cost = price.find("span", {"class": "s-item__price"}).text[1:]
		cost = cost.replace(",","")
		if "to" in cost: #deals with range of prices (ex: 1.00 to 4.00)
			cost = cost[0:4]
		#print(price.find("a", {"class": "s-item__link"}).get("href") + ": " + cost)

		if float(cost) < float(lowestPrice):
			lowestPrice = cost
			cheapest = price.find("a", {"class": "s-item__link"}).get("href")
		elif float(cost) == float(lowestPrice):
			cheapest = cheapest + " and \n" + price.find("a", {"class": "s-item__link"}).get("href")

	print("The cheapest card(s): " + str(cheapest) + " \nPrice = $"+ str(lowestPrice))
