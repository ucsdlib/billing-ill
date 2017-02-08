# ILL Billing System
[![Coverage Status](https://coveralls.io/repos/github/ucsdlib/billing-ill/badge.svg?t=iGS59G)](https://coveralls.io/github/ucsdlib/billing-ill)

ILL Billing System is a Ruby on Rails web application which is created for processing and invoicing the Receivables, UCSD Recharges, UC Recharges, and Payables from the Interlibrary Loan Services in [UC San Diego Library](http://libraries.ucsd.edu/ "UC San Diego Library")

## Requirements

* Ruby 2.2.3+
* git

## Installation

```
$ git@github.com:ucsdlib/billing-ill.git
```

## Usage

1.Open project.

```
$ cd billing-ill
```

2.Checkout develop branch.

```
$ git checkout develop
```

3.Copy DB Sample.

```
$ cp config/database.yml.example config/database.yml
```

4.Copy and edit Secrets Sample.
Replace the secret_key_base hex string with a new random string (you can generate a new random key with rake secret).

```
$ cp config/secrets.yml.example config/secrets.yml
```

5.Update DB.

```
$ bundle exec rake db:migrate
```

## Running ILL Billing

* WEBrick

```
$ rails s
```

## ILL Billing will be available at 

```
http://localhost:3000
```

## Running the Test Suites

```
$ bundle exec rake
$ rubocop
```


