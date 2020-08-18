from urllib.request import urlopen
from bs4 import BeautifulSoup
import re



if __name__ == "__main__":
    html = urlopen("https://www.ptable.com/")
    bsObj = BeautifulSoup(html, "html.parser")

    tdList = bsObj.findAll("td", {"class": "Element"})

    totalMolarMass = 0.0
    for element in tdList:
        text = element.i.getText()
        if text[0] == "(":
            totalMolarMass += float(text[1: len(text) - 1])
        else:
            totalMolarMass += float(text)

    print("Total Molar Mass Of All Elements: " + str(totalMolarMass))

    lanthList = bsObj.findAll("td", {"class": re.compile("Element Lanthanoid [fd]")})

    totalLanthMass = 0.0
    num = 0
    for element in lanthList:
        num += 1
        text = element.i.getText()
        if text[0] == "(":
            totalLanthMass += float(text[1: len(text) - 1])
        else:
            totalLanthMass += float(text)

    average = (totalLanthMass / num)
    print("The Average Mass of the Lanthanoid Elements: " + str(average))

    protonList = bsObj.findAll("td", {"class": "Element"})

    biggestNum = 0
    mostProtons = ""

    for element in protonList:
        atomicMass = 0
        if element.i.getText()[0] == "(":
            atomicMass = float(element.i.getText()[1: len(element.i.getText()) - 1])
        else:
            atomicMass = float(element.i.getText())
        atomicNumber = float(element.big.strong.getText())
        numProtons = atomicMass - atomicNumber
        if numProtons > biggestNum:
            biggestNum = numProtons
            mostProtons = element.em.getText()
        elif numProtons == biggestNum:
            mostProtons += (" and " + element.em.getText())

    print("The element(s) with most protons are " + mostProtons + " with " + str(biggestNum) + " protons.")


