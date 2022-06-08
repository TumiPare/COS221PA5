******************************************************************
Read me for faade.co.za website of group church of the blue arrow
******************************************************************
        Contributors:
u21729752 - Mr. Francois Combrinck 
u21495361 - Miss. Arabella Balidis 
u04868286 - Mr. Armand Krynauw 
u21435872 - Mr. Gustav Radloff 
u21630276 - Mr. Dino Gironi 
u21451088 - Mr. Thuthuka Khumalo 
u21452832 - Mr. Tumishang Pare 

*****************************************************************
                  Get access to main page:
To access the website, navigate to https://faade.co.za/. You will
be presented with the login page. The login page is where any 
users of the application must login.

If the user does not have an account yet, the user can navigate 
to the register page with the navbar on the top left. The user
simply needs to click on the Register link in the navbar.

                        Register:

If the user were to do this, they will be redirected to the 
register page. The register page consists of 3 fields: Email,
Username and Password. If the user is uncertain about what format
the password must be in, the user can click on the Question mark
icon in the center of the page.

The username need not be unique nor in a special format.
Email has to be in the regular email format used in standard 
practice and must be unique. (One email per account)

If a user registers an account with an email that already exists,
an error will be returned and the register will fail. Once all values
are valid and correct, the user will be registered on clicking the 
register button with a notifcation and sent to the login page.

                         Login:

The user can login provided that they already have an account. The
user must simply enter their email and password. The password and email
must be valid, and if the email does not exist in the system, then an
error will also be displayed. 

Again the user can refer to the help icon at the center of the page if 
the user is uncertain about what format is required. Once all details
are correct and valid the user will be able to login with the Login
button. 

Once the login button is clicked with correct details, the user will be
sent to the main page which displays the current leagues stored on the
system. 

The user also however has the option to edit their own account by clicking
on the navbar link Account. The user will be redirected to the account page
where they can change the details of their account. If the user changes their
email to an email that already exists, then the user will receive an error
and the change in account details will fail.

Furthermore if the values of email and Password are changed, validation rules
stil apply and the data must be valid. Upon entering correct details, and 
provided the details are not the exact same, then the user's account will be
updated.

The user can also delete the current account by clicking on the trash icon
and confirming that they want to delete the current account. The account
will then be permanently removed from the system. The user will then be
redirected to the login page to login into a new account/register new 
account.

**********************************************************************
                          Usage of core website:

With the user in the leagues page, they simply need to select a league
from the list of given leagues on the page to view all the tournaments
of a league.

                           Tournaments page

Once the user clicks on the desired league, they will be redirected to
the tournaments page, where the user must specify the season they wish
to view. Once the user has specified the season, the page will display
all tournaments related to the selected season.

The user can also add a new player to the current league by clicking on the
Add Player button in the top right and then simply add the necessary details
in the provided fields and click on add. The player id must be unique.

For each of these tournaments the user can either get more details on
the tournament itself by clicking the header of a tournament (events page),
or they can obtain info on the teams participating in the tournament
by clicking on the card of a team (Team page).

The user will be redirected to the respective page:

                            Team page

The Team page displays information on the selected team, such as its
current players,Team logo etc.. . For more information on the respective
players, simply click on one of the players cards to navigate to their
player page.

                            Player page:

The user will be presented with a stats page for the selected player.
These stats can be edited by simply clicking on the edit icon presented                ////////
on the page.

Note: The navbar in the top left is always present and allows the user to
navigate back to other pages on the website.

                            Events page:

The events page displays all the events/matches of the current tournament
page in the system. Each tournament consists of 16 matches/events. Each
match displays the score of the match and which teams played in.

The user can get more information on each match by simpling clicking on it. 
The user can edit each match in similar fashion by simply clicking on the 
edit icon.

*****************************************************************************
                          Access the database:


To load dump.sql `sdb` database into your MariaDB installation,
execute the following commands on the command line:

# On Windows (CMD or WSL, mysql.exe must be available in %PATH%):

mysql.exe -u root -p -e "create database sdb"
mysql.exe -u root -p sdb < C:\path\to\dump.sql

# On Linux:

mysql -u root -p -e "create database sdb"
mysql -u root -p sdb < /path/to/dump.sql







                            



