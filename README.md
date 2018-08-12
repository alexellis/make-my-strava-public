make-my-strava-public
===============================

This tool can make your Strava data public for a given period of time. There are several reasons why you may want to do this including the ability to appear on leader boards and to share data with friends. Some import services also only import your data as private. Strava has "enhanced" privacy features which you can turn on and the ability to set a privacy zone so you can have private / off-the-map areas like your home or work.

## What else could this code do?

This code could be adapted easily to do whatever you like. There are additional [Strava API endpoints](https://developers.strava.com/docs/reference/) which may be useful for coming up with ideas.

- Save a backup of your activites as JSON files
- Synchronize your activites to another service
- Import your data into a database for analytics or other analysis 
- Monitor your goals and track your progress

## Get started

### Get an OAuth token

You should set up your Strava app on your profile settings. Get your `access_token` value and save it in a JSON file like the following:

```json
{"access_token": "TOKEN_VALUE"}
```

Save the token as `./tokens/username_token.json`

You do not need to setup an endpoint or server to listen to this app, we will just use it to authenticate into our own account to edit data.

### Install Ruby

A base installation from a package manage should be fine, no additional gems are required. If on MacOS, you may want to update your Ruby version with [brew.sh](https://brew.sh/) anyway.

### Run the tool

```sh
ruby make_public.rb username "start-range" "end-range"
```

For instance:

```sh
ruby make_public.rb alexellis "2015-01-01" "2019-01-01"
```

You will now see the tool talk through your history fetching data and checking for any private activites. These will now be made public using the Strava API.

Example output:

```sh

2017-01-01 00:00:00 +0000
2018-08-30 00:00:00 +0100

Debug: /api/v3/athlete/activities https://www.strava.com/api/v3/athlete/activities?before=1535583600&after=1483228800&page=1&per_page=100

Activities found: 100
Making Morning Ride on 2018-07-19T17:10:04Z public
Put to: https://www.strava.com/api/v3/activities/xyz
Making Evening Ride on 2018-07-12T17:16:12Z public
Put to: https://www.strava.com/api/v3/activities/xyz
Making Morning Ride on 2018-07-09T08:59:20Z public
Put to: https://www.strava.com/api/v3/activities/xyz
Making Afternoon Walk on 2018-07-08T15:25:03Z public
Put to: https://www.strava.com/api/v3/activities/xyz
Making Morning Ride on 2018-07-08T09:28:08Z public
Put to: https://www.strava.com/api/v3/activities/xyz
Making Afternoon Walk on 2018-07-07T14:43:46Z public
Put to: https://www.strava.com/api/v3/activities/xyz
Making Morning Ride on 2018-07-07T08:59:29Z public
```

### Feedback & contributing

Contributions are not expected, but for feedback, questions or suggestions, please raise an Issue.

