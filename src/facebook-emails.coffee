#!/usr/bin/env coffee

request = require 'request'
  
d = console.log

usage = '''

usage: facebook-emails [user id] [access token]

Outputs a list of all your Facebook friend's email addresses in the form [username]@facebook.com, one per line. You can then copy and paste the list into the Bcc field of an email, and each of your friends will receive an individual Facebook message with the contents of the email.

= Access Token

Get an access token by visiting
  
https://developers.facebook.com/tools/explorer

and clicking the "Get Access Token" button. No permissions need to be selected.

= User ID

Can either be your username, which is found at the end of your profile URL, for example "loren.sandsramshaw" in:

https://www.facebook.com/loren.sandsramshaw

or your numerical ID.

= Send Email

Gmail has a daily limit of 500 recipients, so the list must be split up if you have more than 500 Facebook friends:

$ facebook-emails user token > friends
$ split -l 499 friends gmail

This will result in files 'gmailaa', 'gmailab', etc. Once a day (on a Mac):

$ cat gmailaa | pbcopy

In Gmail, using the account to which your Facebook account is tied, compose a message to yourself and paste into the Bcc field.

= Import to Google Contacts

$ facebook-emails user token > friends
$ echo 'E-mail 1 - Value' > contacts.csv && cat friends >> contacts.csv

In Google Contacts, select More -> Import and choose contacts.csv
  
'''

[_,_,user,token] = process.argv
unless user and token
  d usage
  process.exit(1)

URL = "https://graph.facebook.com/#{user}/friends?fields=username&access_token=#{token}"

request URL, (e,r,b) ->
  d e if e
  friends = JSON.parse b
  d friends
  for f in friends.data
    d f.username + '@facebook.com' if f.username
