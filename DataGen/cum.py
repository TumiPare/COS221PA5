import csv
import requests as req
import randimage
import base64
from random import random, randrange, seed
from time import time

from torch import rand

HASH_ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
# API = "https://faade.co.za/API.php"
API = "http://localhost:8080/API.php"
API_KEY = "asdf" #TODO
DEFAULT_IMG = b'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'

def csvToList(file):
    with open(file, "r") as f:
        f.readline()
        content = f.read()
        return content.split()

# Passes the provided json body onto the API, returns JSON response
def qAPI(body):
    return req.post(API, json=body)

def genPic(w, h):
    resp = req.get("https://picsum.photos/{}/{}".format(w, h))
    if resp.status_code == 200:
        return base64.b64encode(resp.content)
    return DEFAULT_IMG

def init():
    global surnames, mnames, fnames, domains, tlds, pics
    seed(time())

    # Load data
    surnames = csvToList("surnames.csv")
    mnames = csvToList("mnames.csv")
    fnames = csvToList("fnames.csv")
    domains = csvToList("domains.csv")
    tlds = csvToList("tld.csv")

    # Generate pics
    pics = []
    for i in range(1):
        pics.append(genPic(32, 32))

def randomElement(arr):
    return arr[randrange(len(arr))]

#=====PLAYERS=====
def getFullName(): # Returns [firstName, surname, gender] 1=male, 0=female (for obvious reasons)
    male = random() > 0.5
    return [randomElement(mnames if male else fnames), randomElement(surnames), male]

def getBirthdate(): # Returns [day, month, year]
    return [randrange(30)+1, randrange(12)+1, 1950 + randrange(70)]

def getImage():
    return randomElement(pics)

def getCity(): # Returns [city, country, countryCode]
    return randomElement([
            ["Pretoria", "South Africa", "za"],
            ["Cape Town", "South Africa", "za"],
            ["Kimberley", "South Africa", "za"],
            ["Johannesburg", "South Africa", "za"],
            ["New York", "United States", "us"],
            ["Washington", "United States", "us"],
            ["Kyiv", "Ukraine", "ua"],
            ["Moscow", "Russia", "ru"],
            ["Hong Kong", "China", "ch"]
        ])

def getAddress():
    city = getCity()
    return {
        "streetNo": randrange(100),
        "street": (randomElement(domains).capitalize() + " " + randomElement(["St.", "Ln.", "Ave."])),
        "city": city[0],
        "postalCode": randrange(1000, 9999),
        "country": city[1],
        "countryCode": city[2]
    }

def getPersonKey():
    return "w.polo.com-x." + str(randrange(1000, 9999));

def addPlayers(n):
    data = []

    for i in range(n):
        name = getFullName()
        data.append({
            "firstName": name[0],
            "surname": name[1],
            "personKey": getPersonKey(),
            "gender": ("female" if name[2]==0 else "male"),
            "DOB": "/".join(getBirthdate),
            "pic": getImage(),
            "birthAddr": getAddress(),
            "residenceAddr": getAddress()
        })

    json = {
        "apiKey": API_KEY,
        "type": "player",
        "operation": "add",
        "data": data
    }
    qAPI(json)

#=====USERS=====
def getEmail():
    name = getFullName()
    return name[0].lower() + (("."+name[1].lower()) if random() > 0.5 else "") + "@" + randomElement(domains) + randomElement(tlds)
    return randomElement(surnames)

def getRandomHash(n): #n = hash length
    s = ""
    for i in range(n):
        s += randomElement(HASH_ALPHABET)
    return s

def addUsers():
    json = {
        "apiKey": API_KEY,
        "type": "user",
        "add": {
            "email": getEmail(),
            "password": getRandomHash()
        }
    }
    qAPI(json)
    return

#=====TEAMS=====

def addTeams(): #TODO
    return

init()

for i in range(2):
    print(getImage())
    print()