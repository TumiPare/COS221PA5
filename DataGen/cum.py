import csv
import requests as req
import base64
import json as JSON
from random import random, randrange, seed
from time import time

#=====CONFIG=====
# API = "http://api.faade.co.za/API.php"
# API = "https://faade.co.za/API.php"
API = "http://localhost:8080/API.php"
HASH_ALPHABET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
API_KEY = "zPQYE07BefuxO8CS7Z9mPgLeHojxVXuD"
DEFAULT_IMG = "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"
NUM_IMAGES = 25

def csvToList(file):
    with open(file, "r") as f:
        f.readline()
        content = f.read()
        return content.split()

# Passes the provided json body onto the API, returns JSON response
def qAPI(body):
    res = req.post(API, json=body)
    print("API RESPONSE:\n" + res.content.decode('utf-8'))
    return JSON.loads(res.content.decode('utf-8'))

def genPic(isMale):
    resp = req.get("https://randomuser.me/api/portraits/thumb/{}/{}.jpg".format(("men" if isMale else "women"), randrange(100)))
    if resp.status_code == 200:
        return base64.b64encode(resp.content).decode('utf-8')
    return DEFAULT_IMG

def genLogo(w, h):
    resp = req.get("https://picsum.photos/{}/{}".format(w, h))
    if resp.status_code == 200:
        return base64.b64encode(resp.content).decode('utf-8')
    return DEFAULT_IMG

def init():
    global surnames, mnames, fnames, domains, tlds, picsM, picsF, logos, adjs, nouns, teamnouns
    seed(time())

    # Load data
    surnames = csvToList("surnames.csv")
    mnames = csvToList("mnames.csv")
    fnames = csvToList("fnames.csv")
    domains = csvToList("domains.csv")
    tlds = csvToList("tld.csv")
    adjs = csvToList("adjectives.csv")
    nouns = csvToList("nouns.csv")
    teamnouns = csvToList("teamnouns.csv")
    print("> Loaded CSVs")

    # Generate pics
    picsM = []
    picsF = []
    logos = []
    for i in range(NUM_IMAGES):
        picsM.append(genPic(True))
        picsF.append(genPic(False))
        logos.append(genLogo(48, 48))
    print("> Loaded Pics")

def randomElement(arr):
    return arr[randrange(len(arr))]

#=====PLAYERS=====
def getFullName(): # Returns [firstName, surname, gender] 1=male, 0=female (for obvious reasons)
    male = random() > 0.5
    return [randomElement(mnames if male else fnames), randomElement(surnames), male]

def getBirthdate(): # Returns [day, month, year]
    return [randrange(30)+1, randrange(12)+1, 1950 + randrange(60)]

def getPic(intGender):
    return randomElement(picsF) if intGender==0 else randomElement(picsM)

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
            "lastName": name[1],
            "personKey": getPersonKey(),
            "gender": ("female" if name[2]==0 else "male"),
            "DOB": "/".join(map(str, getBirthdate())),
            "image": getPic(name[2]),
            "birthAddr": getAddress(),
            "residenceAddr": getAddress()
        })

    json = {
        "apiKey": API_KEY,
        "type": "player",
        "operation": "add",
        "data": data
    }
    # print(JSON.dumps(json))
    return qAPI(json)

#=====SEASONS=====
def addSeasons():
    return

#=====STATS=====
def addStats(playerID, matchID):
    json = {
    "apiKey": API_KEY,
    "type": "stats",
    "operation": "add",
    "data": [
        {
            "playerID": playerID,
            "matchID": matchID,
            "stats": {
                "offensive": {
                    "assists": randrange(20),
                    "successfulPasses": randrange(40),
                    "unsuccessfulPasses": randrange(30),
                    "sprintsWon": randrange(20),
                    "sprintsLost": randrange(15),
                    "goals": randrange(10),
                    "misses": randrange(15),
                },
                "defensive": {
                    "steals": randrange(20),
                    "saves": randrange(3),
                    "failedBlocks": randrange(4),
                    "successfulBlocks": randrange(20)
                },
                "fouls": {
                    "turnovers": randrange(10),
                    "exclusions": randrange(10),
                    "minorFouls": randrange(4),
                    "majorFouls" : randrange(3),
                    "penaltyShotsTaken": randrange(5),
                    "penaltyShotsGiven": randrange(5)
                }
            }
        }
    ]
}

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

def getUsername():
    return randomElement(adjs) + randomElement(nouns) + str(randrange(10, 99))

def addUsers(n):
    data = []
    for i in range(n):
        data.append({
            "username": getUsername(),
            "email": getEmail(),
            "password": getRandomHash(24)
        })

    json = {
        "type": "user",
        "operation": "add",
        "data": data
    }

    # print(JSON.dumps(json))
    # qAPI(json)

#=====TEAMS=====
def getTeamName():
    return randomElement(["The ", ""]) + randomElement(adjs) + " " + randomElement(teamnouns)

def getLogo():
    return randomElement(logos)

def addTeams(n):
    data = []
    for i in range(n):
        data.append({
            "teamName": getTeamName(),
            "teamLogo": getLogo(),
            "homeSite": getAddress()
        })
    
    json = {
        "apiKey": API_KEY,
        "type": "team",
        "operation": "add",
        "data": data
    }
    # print(JSON.dumps(json))
    return qAPI(json)

#=====TOURNAMENTS=====
def getTournamentName():
    suffixes = ["Championship", "Sub-season", "League", "Cup", "Tournaments", "Finals"]
    return randomElement(["The ", ""]) + randomElement(teamnouns) + " " + randomElement(suffixes)

def getTournamentMatches(tournamentID):
    json = {
        "apiKey": API_KEY,
        "type": "tournament",
        "operation": "getMatches",
        "data": [
            {
                "tournamentID": tournamentID
            }
        ]
    }
    res = qAPI(json)
    # print("HERE")
    # print(res["data"])
    return res["data"]

def addPlayersToMatch(n, matchID, teamID):
    players = addPlayers(n)["data"]

    data = []
    for p in players:
        data.append({
            "playerID": p,
            "teamID": teamID,
            "matchID": matchID
        })

    json = {
        "apiKey": API_KEY,
        "type": "match",
        "operation": "addPlayer",
        "data": data
    }

    return qAPI(json)

def addTournaments(n):
    data = []

    for tour in range(n):
        teams = addTeams(16)["data"]

        lineups = []
        for lu in range(0, 16, 2):
            lineups.append({
                "teamA": teams[lu]["teamID"],
                "teamB": teams[lu+1]["teamID"]
            })
        # print(JSON.dumps(lineups))

        data.append({
            "seasonID" : randrange(10),
            "tournamentName": getTournamentName(),
            "lineups": lineups
        })

    json = {
        "type": "tournament",
        "operation": "add",
        "data": data
    }

    tournamentID = qAPI(json)["data"]["tournamentID"]

    matches = getTournamentMatches(tournamentID)
    print("TESTESTES")
    for m in matches:
        if m is not None:
            print(addPlayersToMatch(7, m["eventID"], m["teamID"]))


init()

# addPlayers(1)
# addTeams(1)
addTournaments(5)
# addUsers(100)