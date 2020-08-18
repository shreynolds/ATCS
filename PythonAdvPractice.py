""" This module is python practice exercises to cover more advanced topics.
	Many of the exercises can be found at: 
        http://www.practicepython.org/exercises/
		https://www.hackerrank.com/domains/python/py-introduction
        (hackerrank will ask you to sign up, but you can just close the popup)
	You may submit them there to get feedback on your solutions, and for a
        discussion of how to do each exercise.
	Put the code for your solutions to each exercise in the appropriate function.
	DON'T change the names of the functions!
	You may change the names of the input parameters.
	Put your code that tests your functions in the if __name__ == "__main__": section
	Don't forget to regularly commit and push to github.
    Please include an __author__ comment so I can tell whose code this is.
"""

# Practice Python Exercise
# found at http://www.practicepython.org/exercises/

__author__ = "Sophie Reynolds"

import re
import email.utils
import math

# 7: List Comprehensions
def even_list_elements(input_list):
    """ Use a list comprehension/generator to return a new list that has 
        only the even elements of input_list in it.
    """
    return [x for x in input_list if x % 2 == 0]



# 10: List Overlap Comprehensions
def list_overlap_comp(list1, list2):
    """ Use a list comprehension/generator to return a list that contains 
        only the elements that are in common between list1 and list2.
    """
    return [x for x in list1 if x in list2]


# More List Comprehension Practice!
# Implement the following function:

def cube_triples(input_list):
    """ Use a list comprehension/generator to return a list with the cubes
        of the numbers divisible by three in the input_list.
    """
    return [x**3 for x in input_list if x%3 == 0]


# More practice with Dictionaries, Files, and Text!
# Implement the following functions:

def longest_sentence(text_file_name):
    """ Read from the text file, split the data into sentences,
        and return the longest sentence in the file.
    """
    with open(text_file_name) as f:
        x = f.read()
        x = x.replace("?", ".")
        x = x.replace("!",".")
        x = x.replace(";", ".")

        x = x.replace(". . .", "ellip")  # replace ellipses -- need to figure out what to do
        sentence_list = x.split(".")  # splits on the periods

        longest_len = len(sentence_list[0])
        longest = sentence_list[0]

        for sent in sentence_list:
            if len(sent) > longest_len:
                longest = sent
                longest_len = len(sent)

        longest = longest.replace("ellip", ". . .")  # put the ellipses back if they're in the longest one

        return longest


def longest_word(text_file_name):
    """ Read from the text file, split the data into words,
        and return the longest word in the file.
    """
    with open(text_file_name) as f:
        word_list = split_into_words(f)

        longest_len = len(word_list[0])
        longest = word_list[0]

        for word in word_list:
            if len(word) > longest_len:
                longest = word
                longest_len = len(word)

        return longest


def split_into_words(f):
    x = f.read()
    x = x.lower()  # turns words to lowercase so that there is no difference between There and there, for example
    x = x.replace(".", "")
    x = x.replace("!", "")
    x = x.replace("?", "")
    x = x.replace(",", "")
    x = x.replace("\n", " ")
    x = x.replace(";", "")
    x = x.replace("—", "")
    x = x.replace("\"", "")
    x = x.replace("(", "")
    x = x.replace(")", "")
    word_list = x.split(" ")
    return word_list


def num_unique_words(text_file_name):
    """ Read from the text file, split the data into words,
        and return the number of unique words in the file.
        HINT: Use a set!
    """
    with open(text_file_name) as f:
        word_list = split_into_words(f);
        word_set = set(word_list)
        return len(word_set)


def most_frequent_word(text_file_name):
    """ Read from the text file, split the data into words,
        and return a tuple with the most frequently occuring word 
        in the file and the count of the number of times it appeared.
    """
    with open(text_file_name) as f:
        word_list = split_into_words(f)
        word_counter = dict()
        for word in word_list :
            if word in word_counter :
                word_counter[word] += 1
            else :
                word_counter[word]=1

        most_used = ""
        times_used = 0

        for key,value in word_counter.items():
            if value > times_used :
                times_used = value
                most_used = key
        return [most_used, times_used]

# Hackerrank Class Exercises
# found at https://www.hackerrank.com/domains/python/py-classes
#
# Class 2 - Find the Torsional Angle


class Points(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    def __sub__(self, no):
        # operator overloading (subtracts them) (there's also add, mul, truediv)
        # redefine the behavior of all the standard operators for the objects __something__ -- special reserved words
        return Points(self.x-no.x, self.y-no.y, self.z-no.z)

    def dot(self, no):
        return self.x*no.x + self.y*no.y + self.z*no.z

    def cross(self, no):
        return Points(self.y * no.z - self.z*no.y, self.z*no.x - self.x*no.z, self.x*no.y-self.y*no.x)

    def absolute(self):
        return pow((self.x ** 2 + self.y ** 2 + self.z ** 2), 0.5)


# Classes: Dealing with Complex Numbers
class Complex(object):
    def __init__(self, real, imaginary):
        self.real = real
        self.imaginary = imaginary

    def __add__(self, no):
        return Complex(self.real + no.real, self.imaginary+no.imaginary)

    def __sub__(self, no):
        return Complex(self.real-no.real, self.imaginary-no.imaginary)

    def __mul__(self, no):
        return Complex(self.real*no.real - self.imaginary*no.imaginary, self.real*no.imaginary + self.imaginary*no.real)

    def __truediv__(self, no):
        numerator = Complex(self.real, self.imaginary).__mul__(Complex(no.real, -1*no.imaginary))
        denominator = Complex(no.real, no.imaginary).__mul__(Complex(no.real, -1*no.imaginary))
        return Complex(numerator.real / denominator.real, numerator.imaginary/denominator.real)

    def mod(self):
        return Complex(math.sqrt(self.real*self.real + self.imaginary*self.imaginary), 0)

    def __str__(self):
        if self.imaginary == 0:
            result = "%.2f+0.00i" % (self.real)
        elif self.real == 0:
            if self.imaginary >= 0:
                result = "0.00+%.2fi" % (self.imaginary)
            else:
                result = "0.00-%.2fi" % (abs(self.imaginary))
        elif self.imaginary > 0:
            result = "%.2f+%.2fi" % (self.real, self.imaginary)
        else:
            result = "%.2f-%.2fi" % (self.real, abs(self.imaginary))
        return result


# Hackerrank RegEx Exercises
# found at https://www.hackerrank.com/domains/python/py-regex
# If you are unfamiliar with RegEx, look here:
# A gentle introduction about what RegEx is: 
#   https://docs.python.org/3/howto/regex.html#regex-howto
# The library reference for regex in python3: 
#    https://docs.python.org/3/library/re.html

# Validating and Parsing Email Addresses
def validate_email_addresses(address_list):
    """ Take a list of names and email addresses and return a list with
        only the valid ones. See the webpage for validity requirements.
    """
    valid_emails = []
    for add in address_list:
        pair = email.utils.parseaddr(add)
        x = re.compile('[A-z][\w \- _ \.]+@[a-z A-Z]+\.[a-z A-Z]{1,3}$')
        m = x.match(pair[1])

        if m is not None:
            valid_emails.append(email.utils.formataddr(pair))

    return valid_emails


# Regex Substitution
def sub_and_or(string_list):
    """ Take a list of strings and return a list of strings with:
            ' && ' replaced by ' and '
            ' || ' replaced by ' or '

        The first line contains the integer, n.
        The next n lines each contain a line of the text.
    """
    final_list = []
    for string in string_list:
        string = re.sub("( && )", " and ", string)
        string = re.sub("( \|\| )", " or ", string)
        final_list.append(string)

    return final_list


# Validating Credit Card Numbers
def validate_cc_numbers(ccnumber_list):
    """ Take a list of strings and return a list with 'Valid' or 'Invalid'
        strings in the appropriate place in the list. See the webpage for 
        validity requirements.
    """
    valid_list = []
    for number in ccnumber_list:
        x = re.compile('([4-6]{1}[0-9]{3}[-]?[0-9]{4}[-]?[0-9]{4}[-]?[0-9]{4})$')
        m = x.match(number)

        if m is None: # not valid sequence of numbers
            valid_list.append("Invalid")
        else:  # now need to check for repeating things
            number = number.replace("-", "") #get rid of dashes to check
            print(number)
            x2 = re.compile('[0]{4,}|[1]{4,}|[2]{4,}|[3]{4,}|[4]{4,}|[5]{4,}|[6]{4,}|[7]{4,}|[8]{4,}|[9]{4,}')
            m2 = x2.search(number)
            if m2 is None:  # there are no 4+ in a row
                valid_list.append("Valid")
            else:  # there are 4 in a row
                valid_list.append("Invalid")

    return valid_list


# Validating Postal Codes
def validate_postal_code(zipcode_list):
    """ Take a list of strings and return a list of 'True' or 'False' strings
        in the appropriate place in the list. See the webpage for validity
        requirements.
    """
    valid_list = []
    for zip in zipcode_list:
        int_in_range = re.compile('[1-9][0-9]{5}$')
        repetitive_digit = re.compile('([1][0-9][1])|([2][0-9][2])|'
                                      '([3][0-9][3])|([4][0-9][4])|'
                                      '([5][0-9][5])|([6][0-9][6])|'
                                      '([7][0-9][7])|([8][0-9][8])|'
                                      '([9][0-9][9])|([0][0-9][0])')

        if bool(re.match(int_in_range, zip)) and len(re.findall(repetitive_digit, zip)) is 0:
            valid_list.append("True")
        else:
            valid_list.append("False")

    return valid_list


if __name__ == "__main__":
    test = [5, 7, 8, 10, 4]
    test2 = [5, 6, 4, 3]
    #  print (list_overlap_comp(test, test2))
    #  print(cube_triples(test2))
    #print("Longest sentence: " + longest_sentence("permutation.txt"))
    #  print("Longest word: " + longest_word("permutation.txt"))
    #  print("Number of unique words: " + (str)(num_unique_words("permutation.txt")))
    #  print("most frequent word: " + (str)(most_frequent_word("permutation.txt")))
    #print(validate_email_addresses(['Sophie <sophie.reynolds@menloschool.org>', 'Susan <shreynolds101@gmail.com>', 'Robin <reynolds_robin@yahoo.com>',
     #                               'Name <yahoo>', 'SR <s-r@gmail.com>', 'Sophie <sophie@gmail.ed>', 'Sophie <sophie@gmail.commm>']))
    # print (validate_email_addresses(['1','Sophie <sophie.reynolds@menloschool.org']))
    # print (sub_and_or(['3', 'a && b', 'l || o', ' p | q']))
    print(validate_cc_numbers(['4123456789123456', '5123-4567-8912-3456', '61234-567-8912-3456', '4123356789123456', '5133-3367-8912-3456', '5123 - 3567 - 8912 - 3456',
                               '0525362587961578', '12345678123456789'
    ]))
    #print(validate_postal_code(['123456', '000001', '999999', '552523', '523563', '110000', '121426', '1234567']))

    # c1 = Complex(1, 2)
    # c2 = Complex(3, 4)
    # print(c1)
    # print(c2)
    # print(c1.__add__(c2))
    # print(c1.__sub__(c2))
    # print(c1.__mul__(c2))
    # print(c1.__truediv__(c2))
    # print(c2.mod())


