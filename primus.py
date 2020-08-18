from urllib.request import urlopen
import time
from bs4 import BeautifulSoup
import re
""" Project Primus!
	Implement a bot that will intelligently find a Wikipedia link ladder 
	between two given pages. You will be graded on both finding the shortest 
	path (or one of them, if there are several of equal length), and how fast 
	your code runs.
"""
__author__ = "Sophie Reynolds"


def wikiladder(startPage, endPage):
	""" This function returns a list of the wikipedia links (as page titles) 
		that one could follow to get from the startPage to the endPage. 
		The returned list includes both the start and end pages.
	"""
	placesToGo = [[startPage]]  # list of lists of the paths that we are checking
	alreadyVisited = [startPage]  # list representing places we have already gone
	secondaryGoals = get_secondary_goals(endPage)  # pages that will likely lead to
	while len(placesToGo) is not 0:
		current = placesToGo.pop(0)  # the current path we are testing
		links = get_links(current)  # get a list of all of the good links
		for link in links:
			name = link.get("href")[6:]
			if name not in alreadyVisited:  # makes sure that we don't check pages we've already visited
				alreadyVisited.append(name)
				if name == endPage:  # found the goal! add to path and return the path
					current.append(name)
					return current
				elif name in secondaryGoals:  # not the goal, but likely to be helpful, so add to front of queue
					newList = current.copy()
					newList.append(name)
					placesToGo.insert(0, newList)
				else:  # not a goal, so add to back of queue to eventually check
					newList = current.copy()
					newList.append(name)
					placesToGo.append(newList)


def linkify(name):
	#Turns the href name of the page into the full URL
	return "https://en.wikipedia.org/wiki/" + name


def get_secondary_goals(endPage):
	"""
	Gets the secondary goal links. The secondary goals are the links in the first paragraph
	on the end page, because most of those generally lead back to the end page
	"""
	# try: tried to catch connection reset error but didn't get it
	endhtml = urlopen(linkify(endPage))
	bs = BeautifulSoup(endhtml, "html.parser")
	paragraphs = bs.find("div", {"class": "mw-parser-output"}).findAll("p", recursive=False)
	links = []
	if paragraphs[0].getClass == "mw.empty.elt":
		links = paragraphs[1].findAll("a", {"href": re.compile("^\/wiki\/[^:]*$")})
	else:
		links = paragraphs[0].findAll("a", {"href": re.compile("^\/wiki\/[^:]*$")})
	secondaryGoals = []
	for link in links:
		secondaryGoals.append(link.get("href")[6:])
	return secondaryGoals
	#except ConnectionResetError:
		#print("had connection reset error, waiting and trying again")
		#time.sleep(10)  # citation: https://www.pythoncentral.io/pythons-time-sleep-pause-wait-sleep-stop-your-code/
		#return get_secondary_goals(endPage)

"""
Gets a list of links on a page based on the current list of links, the last of which
is the page that we are searching
"""
def get_links(current):
	# try: I tried to catch connection reset errors but didn't get it
	html = urlopen(linkify(current[-1]))
	bsObj = BeautifulSoup(html, "html.parser")
	# to continue to optimize, I would use regex instead of beautifulsoup, because I think it is faster
	# I tried to use regex for a little bit but none of it worked and I deleted it because I had to press undo to get back
	# to the beautifulsoup version
	links = bsObj.find("div", {"id": "bodyContent"}).findAll("a", {"href": re.compile("^\/wiki\/[^:]*$")})
	return links
	# except ConnectionResetError as e:
		# print("had connection reset error, waiting and trying again")
		# time.sleep(10)  # citation: https://www.pythoncentral.io/pythons-time-sleep-pause-wait-sleep-stop-your-code/
		# return get_links(current)


if __name__ == '__main__':
	print(wikiladder("Basketball_moves", "D._H._Hill_Library"))
	print(wikiladder("Milkshake", "Gene"))
	#print(wikiladder("Emu", "Duke_University"))