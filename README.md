# Visable Challenge

## Running the Project

In order to run the project, clone the repo and run the following command from the terminal:

`make run`

Afterwards open your browser and go to:

`localhost:3000`

## How to use the api

### Authentication

An authentication system using json web tokens was added, by which you need to first
request a token to the following endpoint:

`POST localhost:3000/auth_user`

```
{
  "user": {
    "email": test@test.com,
    "password": '123'
  }
}
```

The endpoint returns a token to be added in the header:

`Authorization: Bearer token`

### Fetch account with latest transactions

`GET localhost:3000/accounts/1`

### Transfer funds

`POST localhost:3000/accounts/1/transfer`

```
{
  "amount": 20,
  "recipient_account_id": 2
}
```
